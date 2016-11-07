% MASTERMIND
% Jakub Kudela, I33, Summer, 2010/2011
% Non-procedural programming, PRG005

:-
	compile('mastermind_auxiliary.pl'),
	compile('mastermind_settings.pl'),
	compile('mastermind_strategies.pl'),
	compile('mastermind_engine.pl'),
	writef('\n\nMASTERMIND (Jakub Kúdela, 2011)\n\n'),
	list_settings,
	writef('\nType: "mastermind_help." for help.\n\n').

% Predicate showing main predicates in game (commented):
mastermind_help:-
	writef('HELP:\n\n'),
	writeln('Type "match([X1, X2, ...]).", to run a match between X1, X2, ... defined strategies'),
	writeln('Type "list_settings.", to see all game settings.'),
	writeln('Type "set_round_count(X).", to change the round count to X.'),
	writeln('Type "set_guess_limit(X).", to change the quess limit to X.'),
	writeln('Type "set_code_length(X).", to change the length of code to X.'),
	writeln('Type "add_color(X).", to add a new color X.'),
	writeln('Type "remove_color(X).", to remove a color X from game.'),
	writeln('Type "set_code_visibility(X).", where X=true to show codes, X=false to hide codes.'),
	writeln('For adding/removing/renaming strategies edit "mastermind_strategies.pl".').
