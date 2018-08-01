#lang racket
(require racket/sandbox)
(require racket/exn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 1: The lazy lists interface ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define cons-lzl cons)

(define empty-lzl empty)

(define empty-lzl? empty?)

(define head car)

(define tail
  (lambda (lz-lst)
    ((cdr lz-lst))))

(define take
  (lambda (lz-lst n)
    (if (or (= n 0) (null? lz-lst))
      '()
      (cons (car lz-lst)
            (take (tail lz-lst) (- n 1))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 2: Auxiliary functions for testing ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Signature: check-inf-loop(mission)
; Purpose: check if the result is infinite loop,
;          if so, return 'infinite
;          otherwise the actual result
; Type: [[Empty -> T1] -> Union(T1, Symbol)]
(define check-inf-loop
  (lambda (mission)
    (with-handlers ([exn:fail:resource?
                     (lambda (e)
                       (if (equal? (exn->string e)
                                   "with-limit: out of time\n")
                           'infinite
                           'error))])
      (call-with-limits 1 #f mission))))

; A function that creates an infinite loop
(define (inf x) (inf x))

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 3: The assignment ;
;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (distrib Lz E)
    (if (null? Lz)
     '()
    (cons (cons E (car Lz))(lambda() (distrib (tail Lz) E)))
    )
)

    

(define lzl-append
  (lambda (lz1 lz2)
    (if (null? lz1)
        lz2
        (cons (car lz1)
                  (lambda () (lzl-append (tail lz1) lz2))))))
              
(define (extend L E)
    (lzl-append  (distrib L E) L))

(define lstToLazy
    (lambda(lst)
        (if(null? lst)
        '()
        (cons (car lst) (lambda() (lstToLazy (cdr lst)))))))


; Signature: all-subs(long)
; Type: [List(T) -> LZL(List(T))]
; Purpose: compute all lists that can be obtained 
; from long by removing items from it.
; Pre-conditions: -
; Tests:
; (take (all-subs '(1 2 3)) 8) ->
; '(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
(define all-subs
  (lambda (long)
    (if (null? long)
            (cons '() (lambda () '()))
            (extend (all-subs (cdr long))(car long))
        ) 
    ))


;;;;;;;;;;;;;;;;;;;;;
; Part 4: The tests ;
;;;;;;;;;;;;;;;;;;;;;

;; Make sure to add take or another utility to test here
;; If the results are obained in a different order, change the test accordingly.
(check-inf-loop (lambda () (take (all-subs '(1 2 3)) 8)))
;; Write more tests - at least 5 tests.
(check-inf-loop (lambda () (take (all-subs '(1 2 3 4 5)) 30)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 5: The tests expected results;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|
> (check-inf-loop (lambda () (take (all-subs '(1 2 3)) 8))
'(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))
|#