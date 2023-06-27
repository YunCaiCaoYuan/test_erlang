-module(test_udp).

%% API
-export([server/0, client/0]).

-define(PORT, 9999).

%% UDP server示例：
server() ->
  {ok, Socket} = gen_udp:open(?PORT, [binary]),
  io:format("udp_demo_server starting...~n"),
  loop(Socket).

loop(Socket) ->
  receive
    {udp, Socket, Host, Port, Bin} ->
      io:format("server recv from ~p:~p ~p~n", [Host, Port, Bin]),
      BinReply = "ok",
      gen_udp:send(Socket, Host, Port, BinReply),
      loop(Socket)
  end.


%% opt默认{active,false},报文发给了宿主进程
%%23> flush().
%%Shell got {udp,#Port<0.15>,{127,0,0,1},9999,<<"ok">>}

%%flush/0函数只是一种输出所收到的消息的快捷方法
%%使用receive表达式来接收消息。receive的语法和case...of非常相似。事实上，它们的模式匹配部分的工作原理完全一样，只是receive模式中变量会绑定到收到的消息，而不是case和of之间的表达式。

client() ->
  {ok, Socket} = gen_udp:open(0, [binary, {active, false}]),
  gen_udp:send(Socket, {127, 0, 0, 1}, ?PORT, "Hello, server!"),
  {ok, {_,_,Data}} = gen_udp:recv(Socket, 0),
  io:format("Received data: ~p~n", [Data]),
  gen_udp:close(Socket).

