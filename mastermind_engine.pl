% MASTERMIND
% Jakub Kudela, I33, Summer, 2010/2011
% Non-procedural programming, PRG005

% Dynamics for results (gather information throughout the match)
% result_wins(Strategy)
% result_guesses(Strategy, NumberOfGuesses)
:-
	dynamic(result_win/1),
	dynamic(result_guesses/2).

% A "match" runs "round_count"-times "rounds", where "round" means a
% "turn" for each strategy in a "match" for a generated "code". A "turn"
% means sequence of "guess"-es, which ends by guess of a perfect match
% to a round "code" - that's a "win". It can also end by "loss", that
% means the "strategy" runs out of "guess"-es in "guess_limit".

% pattern/code representation ~ [Color].
% guess ~ guess(Pattern, PositionFeedback, ColorFeedback).
% turn current state ~ [Guess].

% match(+ListOfStrategies), runs match between strategies.
match(LS):-
	round_count(RC),
	guess_limit(GL),
	colors(C),
	code_length(CL),
	code_visibility(CV),
	writef('Starting match: strategies=%q, rounds=%q, guess limit=%q,\npeg colors=%q, code length=%q, code visibility=%q.\n\n', [LS, RC, GL, C, CL, CV]),
	retractall(result_win(_)),
	retractall(result_guesses(_, _)),
	match(LS, 0),
	writeln('Results:'),
	write_results(LS),
	writef('Match ended.'),
	!.

% match(+ListOfStrategies, +RoundNumber), auxiliary.
match(_, RN):-
	round_count(RN),
	!.

match(LS, RN):-
	generate_code(C),
	public_code(C, PC),
	writef('[round=%q, code=%q]\n', [RN, PC]),
	round(LS, C),
	RN1 is RN + 1,
	match(LS, RN1).

% round(+ListOfStrategies, +Code), runs a round between strategies.
round([], _):-
	writef('\n').

round([SH|ST], C):-
	writef('"%q"\'s turn:\n', [SH]),
	turn(SH, C),
	round(ST, C).

% turn(+Strategy, +Code), runs a turn for a strategy.
turn(S, _):-
	not(strategy(S)),
	write('\tFailed!\n'),
	!.

turn(S, C):-
	turn(S, [], C).

% turn(+Strategy, +TurnState, +Code), auxiliary.
turn(S, TS, _):-
	guess_limit(GL),
	length(TS, L),
	GL == L,
	writef('\tLoss.\n'),
	assert(result_win(S, loss)),
	!.

turn(S, TS, C):-
	strategy(S, TS, P),
	feedback(P, C, B, W),
	writef('\t%q, B=%q, W=%q\n', [P, B, W]),
	guess_check(S, TS, C, guess(P, B, W)).

% guess_check(+Strategy, +TurnState, +Code, +NewGuess),
% checks wheather NewGuess is a perfect match.
guess_check(S, TS, _, guess(_, B, _)):-
	code_length(CL),
	B == CL,
	length(TS, L),
	L1 is L + 1,
	writef('\tWin in: %q.\n', [L1]),
	assert(result_win(S)),
	assert(result_guesses(S, L1)),
	!.

guess_check(S, TS, C, NG):-
	turn(S, [NG|TS], C).

% Code generating predicate:
% generate_code(-Code), generates according to mastermind settings.
generate_code(C):-
	colors(LC),
	length(LC, L),
	code_length(CL),
	generate_code(L, LC, CL, C).

% generate_code(+NumberOfColors, +Colors, +Length, -Code), auxiliary.
generate_code(_, _, 0, []).
generate_code(N, LC, L, [CH|CT]):-
	R is random(N),
	element(R, LC, CH),
	L1 is L - 1,
	generate_code(N, LC, L1, CT),
	!.

% Predicate providing feedback for a guess:
% feedback(+Pattern, +Code, -Positions, -ExtraColors),
% provides position and extra color matches ratings.
feedback(P, C, B, EW):-
	feedback_positions(P, C, B),
	feedback_colors(P, C, W),
	EW is W - B.

% feedback_positions(+Pattern, +Code, -Positions),
% provides position matches rating.
feedback_positions([], [], 0).
feedback_positions([PH|PT], [PH|CT], P):-
	feedback_positions(PT, CT, P1),
	P is P1 + 1,
	!.

feedback_positions([PH|PT], [CH|CT], P):-
	PH \= CH,
	feedback_positions(PT, CT, P).

% feedback_colors(+Pattern, +Code, -Colors),
% provides color matches rating.
feedback_colors([], _, 0).
feedback_colors([PH|PT], CR, C):-
	delete(PH, CR, CR1),
	feedback_colors(PT, CR1, C1),
	C is C1 + 1,
	!.

feedback_colors([_|PRT], CR, C):-
	feedback_colors(PRT, CR, C).

% Predicate hiding code if codes are set to be hidden:
% public_code(+Code, -PublicCode)
public_code(C, C):-
	code_visibility(true).

public_code(_, 'hidden'):-
	code_visibility(false).

% Predicate writing results calculated from gathered information
% throughout the match:
% write_results(+ListOfStrategies), writes results for each strategy.
write_results([]):-
	writef('\n').

write_results([SH|ST]):-
	write_result(SH),
	write_results(ST).

% write_result(+Strategy), writes result for a given strategy.
write_result(S):-
	bagof(_, result_win(S), LW),
	length(LW, W),
	round_count(RC),
	L is RC - W,
	bagof(X, result_guesses(S, X), LG),
	sum(LG, GS),
	length(LG, GL),
	GA is GS / GL,
	writef('"%q": W=%q, L=%q, Avg(Wins)=%q.\n', [S, W, L, GA]),
	!.
