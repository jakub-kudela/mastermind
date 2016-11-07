% MASTERMIND
% Jakub Kudela, I33, Summer, 2010/2011
% Non-procedural programming, PRG005

% Dynamics for settings:
:-
	dynamic(round_count/1),
	retractall(round_count(_)),
	dynamic(guess_limit/1),
	retractall(guess_limit(_)),
	dynamic(code_length/1),
	retractall(code_length(_)),
	dynamic(color/1),
	retractall(color(_)),
	dynamic(code_visibility/1),
	retractall(code_visibility(_)).

% The default amount of turns within a match:
round_count(5).

% The default amount of guesses within a turn:
guess_limit(10).

% The default number of pegs in a code in the game:
code_length(4).

% The default colors for pegs available in the game:
color(a).
color(b).
color(c).
color(d).
color(e).
color(f).

% The default visibility of generated code <0>Hidden <1>Visible:
code_visibility(true).

% Predicate for showing game settings:
list_settings:-
	round_count(RC),
	writef('Round count: %q.\n', [RC]),
	guess_limit(GL),
	writef('Guess limit: %q.\n', [GL]),
	code_length(CL),
	writef('Code length: %q.\n', [CL]),
	colors(LC),
	writef('Peg colors: %q.\n', [LC]),
	code_visibility(CV),
	writef('Code visibility: %q.\n', [CV]),
	strategies(LS),
	writef('Strategies defined: %q.\n', [LS]),
	!.

% Predicates for changing settings within the game:
% set_round_count(+RoundCount)
set_round_count(RC):-
	number(RC),
	RC > 0,
	retractall(round_count(_)),
	assert(round_count(RC)),
	writef('Round count set to: %q.\n', [RC]),
	!.

% set_guess_limit(+GuessLimit)
set_guess_limit(GL):-
	number(GL),
	GL > 0,
	retractall(guess_limit(_)),
	assert(guess_limit(GL)),
	writef('Guess limit set to: %q.\n', [GL]),
	!.

% set_code_length(+CodeLength)
set_code_length(CL):-
	number(CL),
	CL > 0,
	retractall(code_length(_)),
	assert(code_length(CL)),
	writef('Code length set to: %q.\n', [CL]),
	!.

% add_color(+Color)
add_color(C):-
	not(color(C)),
	assert(color(C)),
	writef('Peg color added: %q.\n', [C]),
	!.

add_color(C):-
	color(C),
	writef('Peg color alredy defined: %q.\n', [C]),
	!,
	fail.

% remove_color(+Color):
remove_color(C):-
	retract(color(C)),
	writef('Peg color removed: %q.\n', [C]),
	!.

% Predicate returning colors in a list:
% colors(-ListOfColors)
colors(LC):-
	setof(C, color(C), LC),
	!.

% Predicate for changing code visibility:
set_code_visibility(true):-
	writeln('Codes are set to be visible.'),
	retractall(code_visibility(_)),
	assert(code_visibility(true)),
	!.
set_code_visibility(false):-
	writeln('Codes are set to be hidden.'),
	retractall(code_visibility(_)),
	assert(code_visibility(false)),
	!.
