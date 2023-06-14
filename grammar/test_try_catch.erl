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
%%-export([test/1]).
-export([test2/1]).

%%test_try_catch.erl:20: variable 'A1' unsafe in 'try' (line 16)
%%test_try_catch.erl:20: variable 'A2' unsafe in 'try' (line 16)
%%test(A) ->
%%	try
%%		[A1,A2|_] = A
%%	catch
%%		_:_ ->
%%		io:format("error, A1:~p, A2:~p~n",[A1,A2])
%%	end,
%%	ok.

test2(A) ->
	try
		[_A1,_A2|_] = A,
		error({assert, con})
	catch
		_T:{assert, _}=_R ->
			io:format("assert error, A:~p~n",[A]);
		T:R ->
			io:format("error, T:~p, R:~p~n",[T,R])
	end.
