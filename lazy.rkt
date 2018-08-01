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
                     (λ (e)
                       (if (equal? (exn->string e)
                                   "with-limit: out of time\n")
                           'infinite
                           'error))])
      (call-with-limits 1 #f mission))))

; A function that creates an infinite loop
(define (inf x) (inf x))

; A function that creates collatz sequence lazy list
; Stops when the next element is 0
(define lzl-collatz
  (lambda (n)
    (if (< n 2)
        (cons-lzl n (lambda () empty-lzl))
        (cons-lzl n (lambda () (if (= (modulo n 2) 0)
                                   (lzl-collatz (/ n 2))
                                   (lzl-collatz (+ (* 3 n) 1))))))))

; A function that creates collatz sequence lazy list
; Never stops
(define collatz
  (lambda (n)
    (cons-lzl n (lambda () (if (= (modulo n 2) 0)
                               (collatz (/ n 2))
                               (collatz (+ (* 3 n) 1)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 3: The assignment ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(define take1 (lambda (x y)
   (if (or (empty-lzl? x) (not (y (head x))))
      empty-lzl
      (cons (head x)
            (take1 (tail x) y)))))

;;;;;;;;;;;;;;;;;;;;;
; Part 4: The tests ;
;;;;;;;;;;;;;;;;;;;;;

(check-inf-loop (lambda () (inf 5)))
(check-inf-loop (lambda () (take1 (lzl-collatz 563) identity)))
(check-inf-loop (lambda () (take1 (lzl-collatz 563) (lambda (x) (> x 1)))))
(check-inf-loop (lambda () (take1 (lzl-collatz 563) (lambda (x) (not (= x 1))))))
(check-inf-loop (lambda () (take1 (collatz 563) identity)))
(check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (= x 1)))))
(check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (not (= x 1))))))
(check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (> x 1)))))
(check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (> x 100)))))
(check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (< x 1)))))
(check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (> x 0)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Part 5: The tests expected results;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#|
> (check-inf-loop (lambda () (inf 5)))
'infinite
> (check-inf-loop (lambda () (take1 (lzl-collatz 563) identity)))
'(563 1690 845 2536 1268 634 317 952 476 238 119 358 179 538 269 808 404 202 101 304 152 76 38 19 58 29 88 44 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1)
> (check-inf-loop (lambda () (take1 (lzl-collatz 563) (lambda (x) (> x 1)))))
'(563 1690 845 2536 1268 634 317 952 476 238 119 358 179 538 269 808 404 202 101 304 152 76 38 19 58 29 88 44 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2)
> (check-inf-loop (lambda () (take1 (lzl-collatz 563) (lambda (x) (not (= x 1))))))
'(563 1690 845 2536 1268 634 317 952 476 238 119 358 179 538 269 808 404 202 101 304 152 76 38 19 58 29 88 44 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2)
> (check-inf-loop (lambda () (take1 (collatz 563) identity)))
'infinite
> (check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (= x 1)))))
'()
> (check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (not (= x 1))))))
'(563 1690 845 2536 1268 634 317 952 476 238 119 358 179 538 269 808 404 202 101 304 152 76 38 19 58 29 88 44 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2)
> (check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (> x 1)))))
'(563 1690 845 2536 1268 634 317 952 476 238 119 358 179 538 269 808 404 202 101 304 152 76 38 19 58 29 88 44 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2)
> (check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (> x 100)))))
'(563 1690 845 2536 1268 634 317 952 476 238 119 358 179 538 269 808 404 202 101 304 152)
> (check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (< x 1)))))
'()
> (check-inf-loop (lambda () (take1 (collatz 563) (lambda (x) (> x 0)))))
'infinite
|#
