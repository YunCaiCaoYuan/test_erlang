%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 2月 2023 22:10
%%%-------------------------------------------------------------------
-module(test_race_condition).
-author("sunbin").

%% API
-export([test_keep_alive/0]).
-export([test_keep_alive2/0]).

keep_alive(Name, Fun) ->
  register(Name, Pid = spawn(Fun)),
  on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).

on_exit(Pid, Fun) ->
  io:format("on_exit...～n"),
  ok.

%% 已经注册了，再次注册会失败
test_keep_alive() ->
  spawn(fun() ->
    keep_alive(sunbin, fun() -> ok end)
        end),
  spawn(fun() ->
    keep_alive(sunbin, fun() -> ok end)
        end),
  ok.
%%=ERROR REPORT==== 3-Feb-2023::22:20:58.707760 ===
%%Error in process <0.113.0> with exit value:
%%{badarg,[{erlang,register,
%%[sunbin,<0.115.0>],
%%[{error_info,#{cause => none,module => erl_erts_errors}}]},
%%{test_race_condition,keep_alive,2,
%%[{file,"test_race_condition.erl"},{line,16}]}]}



%% 这样写的话，不是在调用者的上下文中崩溃
start() ->
  _ = spawn_link(fun() -> some_helper() end),
  main_loop().

some_helper() ->
  true = register(helper, self()),
  io:format("123~n"),
  helper_loop().

main_loop() ->
  ok.

helper_loop() ->
  ok.

test_keep_alive2() ->
  spawn(fun() -> start() end),
  spawn(fun() -> start() end),
  ok.
%%=ERROR REPORT==== 3-Feb-2023::22:51:31.617869 ===
%%Error in process <0.109.0> with exit value:
%%{badarg,[{erlang,register,
%%[helper,<0.109.0>],
%%[{error_info,#{cause => none,module => erl_erts_errors}}]},
%%{test_race_condition,some_helper,0,
%%[{file,"test_race_condition.erl"},{line,46}]}]}




