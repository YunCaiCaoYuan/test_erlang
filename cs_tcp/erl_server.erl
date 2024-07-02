-module(erl_server).
-export([
	start_server/0
]).

-include("proto_game.hrl").

-define(PORT, 8888).

%% 启动端口监听
-define(TCP_OPTS,
	[binary,
	{active, false},
	{reuseaddr, true},
	{delay_send, true},
	{nodelay, true},
	{keepalive, false},
	{send_timeout, 8000}
	]).

start_server()->
	{ok, ListenSocket} = gen_tcp:listen(?PORT, ?TCP_OPTS),
	spawn(fun() -> accept(ListenSocket) end),
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
	case gen_tcp:recv(Socket, 0) of
		{ok, Bin}->
			Rec = proto_game:decode_msg(Bin, 'StartGameResp'),
			io:format("received message:~p, Rec:~p~n", [Bin, Rec]),

			Bin2 = proto_game:encode_msg(#'StartGameResp'{err_code = 2}),
			gen_tcp:send(Socket, Bin2),

			loop(Socket);
		{error, Reason}->
			io:format("socket error: ~p~n", [Reason])
	end.