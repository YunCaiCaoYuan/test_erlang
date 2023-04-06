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
-export([test_update_or_add/3, test_sort/0]).

test_update_or_add(List, Key, Add) ->
  case lists:keyfind(Key, 1, List) of
    {_, OldNum} ->
      lists:keyreplace(Key, 1, List, {Key, OldNum + Add});
    _ ->
      [{Key, Add} | List]
  end.


%%  [3,1,4,5,9] -> [9,5,4,3,1]
test_sort() ->
  List = [3,1,4,5,9],
  lists:sort(fun(A,B) -> A>B end, List).