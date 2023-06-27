-module(tcp_test2).

%% API
-export([server/0, client/0]).

-define(PORT, 9999).

server() ->
  {ok, Socket} = gen_tcp:listen(?PORT, [binary, {active, false}]),
  {ok, ClientSocket} = gen_tcp:accept(Socket),
  gen_tcp:send(ClientSocket, "Hello, client!"),
  {ok, Data} = gen_tcp:recv(ClientSocket, 0),
  io:format("Received data: ~w~n", [Data]),
  gen_tcp:close(ClientSocket),
  gen_tcp:close(Socket).

client()->
  {ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT,[binary,{active,false}]),
  {ok, Data} = gen_tcp:recv(Socket, 0),
  io:format("Received data: ~s~n", [Data]),
  gen_tcp:send(Socket, "12345").

