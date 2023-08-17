%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 8月 2023 11:34
%%%-------------------------------------------------------------------
-module(test_loop_exec).
-author("sunbin").

%% API
-export([test/2]).

test(N, MilliSec) ->
%%	io:format("start..."),
	[begin
		 timer:sleep(MilliSec),
		 ok
	 end || _E <- lists:seq(1, N)],
%%	io:format("end..."),
	ok.

%% 花了十秒
%%3> timer:tc(test_loop_exec, test, [10,1000]).
%%{10009263,ok}
