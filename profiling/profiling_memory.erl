%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 2月 2023 16:23
%%%-------------------------------------------------------------------
-module(profiling_memory).
-author("sunbin").

%% API
-export([memory/0]).

%% 查看内存占用前几的进程
memory() ->
  memory(10).
memory(N) ->
  [erlang:process_info(P)||{P, _}<-lists:sublist(lists:sort(fun({_, {_, A}}, {_, {_, B}}) -> A > B end, [{P,erlang:process_info(P,memory)} || P <- erlang:processes()]), N)].