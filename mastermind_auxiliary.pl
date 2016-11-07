% MASTERMIND
% Jakub Kudela, I33, Summer, 2010/2011
% Non-procedural programming, PRG005

% Auxiliary predicates:
% element(+N, +List, -Element), returns N-th element from list.
element(0, [H|_], H):-
	!.

element(N, [_|T], E):-
	N1 is N - 1,
	element(N1, T, E),
	!.

% delete(+Element, +List, -Result), deletes first appropriate element.
% Fails if element is not in list.
delete(_, [], _):-
	fail.

delete(E, [E|T], T).

delete(E, [H|T], [H|R]):-
	E \= H,
	delete(E, T, R),
	!.

% sum(+List, -Result), sum through a list of numbers.
sum([], 0).

sum([H|T], R):-
	sum(T, R1),
	R is H + R1.
