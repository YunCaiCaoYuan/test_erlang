-module(tcp_test3).

%% API
-export([server/0, client/0]).

-define(PORT, 9999).

server() ->
  {ok, Listen} = gen_tcp:listen(?PORT, [binary, {packet, raw}, {active, false}]),
  spawn(fun() -> accept(Listen) end).

accept(Listen) ->
  {ok, Socket} = gen_tcp:accept(Listen),
  spawn(fun() -> handle(Socket) end),
  accept(Listen).

handle(Socket) ->
  {ok, Data} = gen_tcp:recv(Socket, 0),
  io:format("Received data: ~s~n", [Data]),
  gen_tcp:send(Socket, "Hello, client!"),
  gen_tcp:close(Socket).

client()->
  {ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT,[binary,{active,false}]),
  gen_tcp:send(Socket, "12345"),
  {ok, Data} = gen_tcp:recv(Socket, 0),
  io:format("Received data: ~s~n", [Data]).

