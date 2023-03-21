%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 3月 2023 11:00
%%%-------------------------------------------------------------------
-module(test_eunit).
-author("sunbin").

%% API
-export([]).

-export([fib/1]).
-include_lib("eunit/include/eunit.hrl").

fib(0) -> 1;
fib(1) -> 1;
fib(N) when N > 1 -> fib(N-1) + fib(N-2).

fib_test_() ->
	?debugMsg("123~n"),	% 调试宏
	[?_assert(fib(0) =:= 1),
		?_assert(fib(1) =:= 1),
		?_assert(fib(2) =:= 2),
		?_assert(fib(3) =:= 3),
		?_assert(fib(4) =:= 5),
		?_assert(fib(5) =:= 8),
		?_assertException(error, function_clause, fib(-1)),
		?_assert(fib(31) =:= 2178309)
	].

