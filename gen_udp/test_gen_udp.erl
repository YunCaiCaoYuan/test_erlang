%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 3月 2023 12:38
%%%-------------------------------------------------------------------
-module(test_gen_udp).
-author("sunbin").

%% API
-export([udp_demo_server/1, udp_demo_client/2]).

%% UDP server示例：
udp_demo_server(Port) ->
	{ok, Socket} = gen_udp:open(Port, [binary]),
	io:format("udp_demo_server starting...~n"),
	loop(Socket).

loop(Socket) ->
	receive
		{udp, Socket, Host, Port, Bin} ->
			io:format("server recv from ~p:~p ~p~n", [Host, Port, Bin]),
			BinReply = <<"ok">>,
			gen_udp:send(Socket, Host, Port, BinReply),
			loop(Socket)
	end.

%% UDP client示例：
udp_demo_client(Port, Request) ->
	%% open 0 猜测表明随机端口
	{ok, Socket} = gen_udp:open(0, [binary]),
	ok = gen_udp:send(Socket, "localhost", Port, Request),
	Value = receive
				{udp, Socket, SrcHost, SrcPort, Bin} ->
					io:format("client recv from ~p:~p ~p~n", [SrcHost, SrcPort, Bin]),
					{ok, Bin}
			after 2000 ->
				error
			end,
	gen_udp:close(Socket),
	Value.