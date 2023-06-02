%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 6月 2023 10:50
%%%-------------------------------------------------------------------
-module(test_try_catch).
-author("sunbin").

%% API
-export([test/1]).

%%test_try_catch.erl:20: variable 'A1' unsafe in 'try' (line 16)
%%test_try_catch.erl:20: variable 'A2' unsafe in 'try' (line 16)
test(A) ->
	try
		[A1,A2|_] = A
	catch
		_:_ ->
		io:format("error, A1:~p, A2:~p~n",[A1,A2])
	end,
	ok.
