%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 8月 2023 11:52
%%%-------------------------------------------------------------------
-module(test_retry).
-author("sunbin").

%% API
-export([do/3]).

-export([test/0]).

do(_PredFun, _IntervalMill, 0) ->
	io:format("fail~n"),
	ok;
do(PredFun, IntervalMill, RetryCnt) ->
	case PredFun() of
		true ->
			io:format("success~n"),
			ok;
		 _ ->
			 io:format("retry...~n"),
			 timer:sleep(IntervalMill),
			 do(PredFun, IntervalMill, RetryCnt-1)
	end.

test() ->
	do(fun exec/0, 3000, 5),
	ok.

exec() ->
	rand:seed(exs64),
	rand:uniform(10) =< 5.