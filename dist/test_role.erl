%%%-------------------------------------------------------------------
%%% @author sunb
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 4月 2023 15:12
%%%-------------------------------------------------------------------
-module(test_role).
-author("sunb").

-export([get_friend/0]).

get_friend() ->
%%  FIXME 按玩家idhash到不同的center worker
  gen_server:call(test_center_worker, get_friend, 5000).