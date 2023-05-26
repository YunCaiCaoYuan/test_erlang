-module(tcp_test).
-export([
	start_server/0,
	start_client_unpack/0, start_client_packed/0
]).

%%下面我们以 {packet, 2} 做讨论。
%%gen_tcp 通信传输的数据将包含两部分：包头+数据。gen_tcp:send/2发送数据时，erlang会计算要发送数据的大小，把大小信息存放到包头中，然后封包发送出去。
%%所以在接收数据时，要根据包头信息，判断接收数据大小。使用gen_tcp:recv/2,3接收数据时，erlang会自动处理包头，获取封包数据。

-define(PORT, 8888).
-define(PORT2, 8889).

start_server()->
	{ok, ListenSocket} = gen_tcp:listen(?PORT, [binary,{active,false}]),
	{ok, ListenSocket2} = gen_tcp:listen(?PORT2, [binary,{active,false},{packet,2}]),
	spawn(fun() -> accept(ListenSocket) end),
	spawn(fun() -> accept(ListenSocket2) end),
	receive
		_ -> ok
	end.

accept(ListenSocket)->
	case gen_tcp:accept(ListenSocket) of
		{ok, Socket} ->
			spawn(fun() -> accept(ListenSocket) end),
			loop(Socket);
		_ ->
			ok
	end.

loop(Socket)->
	case gen_tcp:recv(Socket,0) of
		{ok, Data}->
			io:format("received message ~p~n", [Data]),
			gen_tcp:send(Socket, "receive successful"),
			loop(Socket);
		{error, Reason}->
			io:format("socket error: ~p~n", [Reason])
	end.

start_client_unpack()->
	{ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT,[binary,{active,false}]),
	gen_tcp:send(Socket, "1"),
	gen_tcp:send(Socket, "2"),
	gen_tcp:send(Socket, "3"),
	gen_tcp:send(Socket, "4"),
	gen_tcp:send(Socket, "5"),
	sleep(1000).

start_client_packed()->
	{ok,Socket} = gen_tcp:connect({127,0,0,1},?PORT2,[binary,{active,false},{packet,2}]),
	gen_tcp:send(Socket, "1"),
	gen_tcp:send(Socket, "2"),
	gen_tcp:send(Socket, "3"),
	gen_tcp:send(Socket, "4"),
	gen_tcp:send(Socket, "5"),
	sleep(1000).

sleep(Count) ->
	receive
	after Count ->
		ok
	end.