% MASTERMIND
% Jakub Kudela, I33, Summer, 2010/2011
% Non-procedural programming, PRG005

% pattern/code ~ [Color].
% guess ~ guess(Pattern, PositionFeedback,ColorFeedback).
% turn current state ~ [Guess].

% Predicates that can be useful to all strategies:
% code(-Pattern), generates pattern based on settings.
code(P):-
	code_length(CL),
	code(P, CL).

% code(?Pattern, ?Length)
code([], 0):-
	!.

code([CH|CT], N):-
	color(CH),
	N1 is N - 1,
	code(CT, N1).

% potential(+Pattern, +TurnState), says wheather pattern can be code
% within a turn represented by TurnState.
potential(_, []).

potential(P, [guess(PG, B, W)|GT]):-
	feedback(PG, P, B1, W1),
	B == B1,
	W == W1,
	potential(P, GT).

% potential_code(+TurnState, -Pattern), returns pattern that still can
% be a code in actual turn represented by TurnState.
potential_code(TS, C):-
	code(C),
	potential(C, TS).

% read_code(-Code), return first valid code from standard input.
read_code(C):-
	read(C),
	code(C),
	!.

read_code(C):-
	write('Tip must be valid, try again please: '),
	read_code(C),
	!.

% Strategy definition must be declared in a predicate forms as follows:
% strategy(Name), where name is a unique name of the strategy.
% strategy(Name, +TurnState, -Pattern), where name of the strategy,
% TurnState is current turn representation. Predicate must return
% Pattern as strategy's next choise. This decision should be one and
% only (cut).

% Database of defined strategies:
strategy(0).
strategy(1).
strategy(2).

% Definition of defined strategies:
% strategy "0" takes a tip from a standard input (user).
strategy(0, _, P):-
	writef('Next tip?: '),
	read_code(P),
	!.

% strategy "1" goes by permutations of pattern, takes first potential.
strategy(1, TS, P):-
	potential_code(TS, P),
	!.

% strategy "2" takes random potential pattern, that can be code.
strategy(2, TS, P):-
	setof(X, potential_code(TS, X), LP),
	length(LP, L),
	PI is random(L),
	element(PI, LP, P).

% Predicate gathering list of all defined strategies:
strategies(S):-
	setof(X, strategy(X), S).
