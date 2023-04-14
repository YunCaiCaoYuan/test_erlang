%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 4月 2023 16:53
%%%-------------------------------------------------------------------
-module(test_grammar).
-author("sunbin").

%% API
-export([test_semicolon/1, test_case/1]).

test_semicolon(Val) ->
	if
		Val == 1; Val == 2 ->
			io:format("1 or 2~n");
		Val == 3; Val == 4 ->
			io:format("3 or 4~n");
		true ->
			io:format("other~n")
	end.

test_case(Val) ->
	case Val of
		1 ->
			io:format("1~n");
		_ when Val == 2; Val == 3 ->
			io:format("2 or 3~n");
		4 ->
			io:format("4~n");
		_ ->
			io:format("other~n")
	end.
