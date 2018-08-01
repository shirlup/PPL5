[expand/4, sub_helper/3, combine/3, sub/2, split/2].

expand(X,_,[],X).
expand(X,N,[A|B],Agg):- append([[N|A]],Agg,Agg2),expand(X,N,B,Agg2).
combine(X,N,L):- expand(Y,N,L,[]),append(Y,L,X).
sub_helper(X,[],H):- split(X,H).
sub_helper(X,[Y|B],H):- combine(H2,Y,H),sub_helper(X,B,H2).
sub(X,L):- sub_helper(X,L,[[]]).
split(X,[X|_]).
split(X,[_|B]):- split(X,B).

