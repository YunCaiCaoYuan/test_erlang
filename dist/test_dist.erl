%%%-------------------------------------------------------------------
%%% @author sunb
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 4月 2023 20:29
%%%-------------------------------------------------------------------
-module(test_dist).
-author("sunb").

%% API
-export([start/0]).

start() ->
  test_center_worker:start_link(),
  test_game:start_link(),
  ok.