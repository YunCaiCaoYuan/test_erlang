%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 10月 2023 10:37
%%%-------------------------------------------------------------------
-module(test_file).
-author("sunbin").

%% API
-export([
	unconsult/2,

	write_term_file/2, read_term_file/1]).

unconsult(File, L) ->
	{ok, S} = file:open(File, write),
	lists:foreach(fun(X) -> io:format(S, "~p~n", [X]) end, L),
	file:close(S).


%% @doc 写入term文件
write_term_file(File, Term) ->
	Bin = erlang:term_to_binary(Term),
	ok = file:write_file(File, Bin).

%% @doc 读取term文件
read_term_file(File) ->
	{ok, Bin} = file:read_file(File),
	erlang:binary_to_term(Bin).