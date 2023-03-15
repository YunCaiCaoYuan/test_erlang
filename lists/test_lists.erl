%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 3月 2023 14:39
%%%-------------------------------------------------------------------
-module(test_lists).
-author("sunbin").

%% API
-export([test_update_or_add/3]).

test_update_or_add(List, Key, Add) ->
  case lists:keyfind(Key, 1, List) of
    {_, OldNum} ->
      lists:keyreplace(Key, 1, List, {Key, OldNum + Add});
    _ ->
      [{Key, Add} | List]
  end.
