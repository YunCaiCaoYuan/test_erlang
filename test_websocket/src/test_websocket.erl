-module(test_websocket).

-export([start/0]).

-define(PORT, 8800).
-define(TCP_OPTS, [
	binary
	, {packet, 0}
	, {active, false}
	, {reuseaddr, true}
	, {nodelay, true}
	, {delay_send, true}
	, {high_watermark, 65536}
	, {exit_on_close, true}
	, {send_timeout, 5000}
	, {send_timeout_close, true}
	, {keepalive, true}
]).

-define(WS_MAGIC_KEY, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11").
-define(REP,
	"HTTP/1.1 101 Switching Protocols\r\n"
	"Upgrade: websocket\r\n"
	"Connection: Upgrade\r\n"
	"Sec-WebSocket-Accept: ~s\r\n\r\n"
).
-define(WS_REP(AcceptKey), io_lib:format(?REP, [AcceptKey])).
-define(SecWebKey, "Sec-WebSocket-Key").

-define(RECV_TIMEOUT, 1200 * 1000).

-record(conn, {
	status,      %% 状态
	mask,        %% 掩码标记
	length,      %% 载荷长度
	fin,         %% 0/1 是否最后一个分片
	opcode       %% 操作码
}).

-record(ws_frame, {
	fin = 0                 %% fin标识
	,opcode = 0             %% opcode标识
	,mask = 0               %% 是否使用掩码标识
	,payload_len = 0        %% 运载数据长度
	,masking_key = <<>>     %% 掩码
	,payload_data = <<>>    %% 运载数据（包括扩展数据，一般不用，可以
}).

%% Opcode定义
-define(WS_OPCODE_CONTINUATION  ,0).
-define(WS_OPCODE_TEXT          ,1).
-define(WS_OPCODE_BINARY        ,2).
-define(WS_OPCODE_RESERVED_3    ,3).
-define(WS_OPCODE_RESERVED_4    ,4).
-define(WS_OPCODE_RESERVED_5    ,5).
-define(WS_OPCODE_RESERVED_6    ,6).
-define(WS_OPCODE_RESERVED_7    ,7).
-define(WS_OPCODE_CLOSE         ,8).
-define(WS_OPCODE_PING          ,9).
-define(WS_OPCODE_PONG          ,10).
-define(WS_OPCODE_RESERVED_11   ,11).
-define(WS_OPCODE_RESERVED_12   ,12).
-define(WS_OPCODE_RESERVED_13   ,13).
-define(WS_OPCODE_RESERVED_14   ,14).
-define(WS_OPCODE_RESERVED_15   ,15).

-define(true, 1).
-define(false, 0).

-define(trim_def, [32, 9, 10, 13, 0, 11]).

-define(b2l(L), binary_to_list(L)).
-define(l2b(L), list_to_binary(L)).


start() ->
	{ok, LSock} = gen_tcp:listen(?PORT, ?TCP_OPTS),
	io:format("server start...\n"),
	accept(LSock).

accept(LSock) ->
	{ok, Socket} = gen_tcp:accept(LSock),
	spawn(fun() ->
		handshake(Socket),
		loop(Socket, #conn{status = read_head})
		  end),
	accept(LSock).

handshake(Socket) ->
	{ok, Bin} = gen_tcp:recv(Socket, 0, 5 * 1000),
	io:format("Bin=~p\n", [Bin]),

	BinList = binary:split(Bin, [<<"\r\n">>], [global]),
	HeadList = [erlang:list_to_tuple([trim(Ele, ?trim_def) || Ele <- string:tokens(erlang:binary_to_list(Elem), ":")]) || Elem <- BinList, Elem =/= <<>>],
	io:format("HeadList=~p\n", [HeadList]),

	ClientKey = proplists:get_value(?SecWebKey, HeadList),
	io:format("ClientKey=~p\n", [ClientKey]),

	AcceptKey = base64:encode(crypto:hash(sha, erlang:list_to_binary([ClientKey, ?WS_MAGIC_KEY]))),
	ok = gen_tcp:send(Socket, erlang:list_to_binary(?WS_REP(AcceptKey))),

	ok.

%% 接收数据
loop(Socket, ConnState = #conn{status = read_head}) ->
	case sync_recv(Socket, 2, ?RECV_TIMEOUT) of
		{ok, Bin} ->
			case Bin of
				<<FIN:1, _RSV:3, Opcode:4, Mask:1, PayloadLen:7>> ->
					ConnState2 = ConnState#conn{fin = FIN, opcode = Opcode, mask = Mask},
					case PayloadLen of
						0 ->
							loop(Socket, ConnState2#conn{status = read_head});
						126 ->
							loop(Socket, ConnState2#conn{status = read_payload_len});
						127 ->
							loop(Socket, ConnState2#conn{status = read_payload_len2});
						_ ->
							case Mask of
								?true ->
									loop(Socket, ConnState2#conn{status = read_payload_data, length = 4 + PayloadLen});
								?false ->
									loop(Socket, ConnState2#conn{status = read_payload_data, length = PayloadLen})
							end
					end;
				_ ->
					loop(Socket, ConnState)
			end;
		_ ->
			loop(Socket, ConnState)
	end;
loop(Socket, ConnState = #conn{status = read_payload_len, mask = Mask}) ->
	case sync_recv(Socket, 2, ?RECV_TIMEOUT) of
		{ok, Bin} ->
			<<PayloadLen:16>> = <<Bin/binary>>,
			case Mask of
				?true ->
					loop(Socket, ConnState = #conn{status = read_payload_data, mask = Mask, length = 4 + PayloadLen});
				?false ->
					loop(Socket, ConnState = #conn{status = read_payload_data, mask = Mask, length = PayloadLen})
			end;
		_ ->
			ok
	end,
	loop(Socket, ConnState);
loop(Socket, ConnState = #conn{status = read_payload_len2, mask = Mask}) ->
	case sync_recv(Socket, 8, ?RECV_TIMEOUT) of
		{ok, Bin} ->
			<<PayloadLen:64>> = <<Bin/binary>>,
			case Mask of
				?true ->
					loop(Socket,  ConnState = #conn{status = read_payload_data, mask = Mask, length = 4 + PayloadLen});
				?false ->
					loop(Socket, ConnState = #conn{status = read_payload_data, mask = Mask, length = PayloadLen})
			end;
		_ ->
			ok
	end,
	loop(Socket, ConnState);
loop(Socket, _ConnState = #conn{status = read_payload_data, length = Len, mask = ?true}) ->
    {ok, Bin} = sync_recv(Socket, Len, ?RECV_TIMEOUT),
    <<MaskingKey:4/binary, Bin2/binary>> = Bin,
	Bin3 = do_unmask(Bin2, MaskingKey),
    io:format("Bin3:~s~n", [Bin3]),
	BinR = erlang:integer_to_binary(rand:uniform(1000)),
	send_data(Socket, do_pack(#ws_frame{fin=?true, opcode=?WS_OPCODE_TEXT, payload_data=BinR})),
	loop(Socket, #conn{status = read_head});
loop(Socket, _ConnState = #conn{status = read_payload_data, length = Len}) ->
	{ok, Bin} = sync_recv(Socket, Len, ?RECV_TIMEOUT),
	io:format("Bin:~s~n", [Bin]),
	loop(Socket, #conn{status = read_head}).


sync_recv(Socket, Len, TimeOut) ->
	gen_tcp:recv(Socket, Len, TimeOut).


%% =========================== local function ===========================

do_unmask(PayloadData, MaskingKey) -> do_mask(PayloadData, MaskingKey).

do_mask(PayloadData, MaskingKey) ->
    do_mask_f1(?b2l(PayloadData), 0, MaskingKey, []).

do_mask_f1(L, _I, <<>>, _Res) -> ?l2b(L);
do_mask_f1([], _I, _MaskingKey, Res) -> ?l2b(lists:reverse(Res));
do_mask_f1([H|T], I, MaskingKey, Res) ->
    H2 = H bxor binary:at(MaskingKey, I rem 4),
    do_mask_f1(T, I + 1, MaskingKey, [H2|Res]).


do_pack(#ws_frame{payload_data=PayloadData, opcode = Opcode}) ->
	PayloadLen = byte_size(PayloadData),
	FIN = 1,
	Mask = 0,
	RSV = 0,
	Bin = <<FIN:1, RSV:3, Opcode:4>>,
	Bin2 =
		if
			PayloadLen =< 125 -> <<Bin/binary, Mask:1, PayloadLen:7>>;
			PayloadLen =< 65536 -> <<Bin/binary, Mask:1, 126:7, PayloadLen:16>>;
			true -> <<Bin/binary, Mask:1, 127:7, PayloadLen:64>>
		end,
	<<Bin2/binary, PayloadData/binary>>.

send_data(Socket, Bin) ->
	try
		prim_inet:send(Socket, Bin, [force])
%%		gen_tcp:send(Socket, Bin)
%%		erlang:port_command(Socket, Bin, [force])
	catch
	    _:_Error ->
			io:format("send_data, _Error:~p~n", [_Error])
	end.

trim(Str, Chars) ->
	rtrim(ltrim(Str, Chars), Chars).

ltrim([], _Chars) -> [];
ltrim(L = [C | T], Chars) ->
	case lists:member(C, Chars) of
		true -> ltrim(T, Chars);
		false -> L
	end.

rtrim(Str, Chars) ->
	lists:reverse(ltrim(lists:reverse(Str), Chars)).
