-module(tcp_test3).

%%% 服务器不处理，客户端一直发消息
%%% 1、客户端会卡住，后面消息发送不出去（用send）563415 byte
%%% 2、客户端可以一直发?（用port_command）貌似占用了Erlang VM的内存
%% PID    COMMAND      %CPU  TIME     #TH    #WQ  #PORTS MEM    PURG   CMPRS  PGRP  PPID  STATE    BOOSTS           %CPU_ME %CPU_OTHRS UID  FAULTS
%% 60918  beam.smp     95.0  27:57.45 32/1   0    51     2048M+ 0B     1790M+ 60918 86465 running  *0[1]            0.00000 0.00000    501  4699010+


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
%%  {ok, Data} = gen_tcp:recv(Socket, 0),
%%  io:format("Received data: ~s~n", [Data]),
  gen_tcp:send(Socket, "Hello, client!").
%%  gen_tcp:close(Socket).

client()->
  {ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT,[binary,{active,false}]),
  [begin
%%     gen_tcp:send(Socket, "1"),
     erlang:port_command(Socket, "1", [force]),
     io:format("~w~n", [Index])
   end||Index<-lists:seq(1,10000*10000)].
%%  gen_tcp:send(Socket, "12345"),
%%  {ok, Data} = gen_tcp:recv(Socket, 0),
%%  io:format("Received data: ~s~n", [Data]).

