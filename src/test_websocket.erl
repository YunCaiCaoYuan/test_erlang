-module(test_websocket).

-export([start/0]).

-define(PORT, 88).
-define(TCP_OPTS, [
                   binary
                  ,{packet, 0}
                  ,{active, false}
                  ,{reuseaddr, true}
                  ,{nodelay, true}
                  ,{delay_send, true}
                  ,{high_watermark, 65536}
                  ,{exit_on_close, true}
                  ,{send_timeout, 5000}
                  ,{send_timeout_close, true}
                  ,{keepalive, true}
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

-define(RECV_TIMEOUT, 120*1000).

-record(conn, {
  status,      %% 状态
  mask,        %% 掩码标记
  length,      %% 载荷长度
  fin,         %% 0/1 是否最后一个分片
  opcode       %% 操作码
}).

-define(true, 1).
-define(false, 0).

-define(trim_def, [32, 9, 10, 13, 0, 11]).


start() ->
    {ok, LSock} = gen_tcp:listen(?PORT, ?TCP_OPTS),

    io:format("server start...\n"),
    {ok, Socket} = gen_tcp:accept(LSock),

    handshake(Socket),

    loop(Socket, #conn{status = read_head}),

%%    gen_tcp:close(Socket),
    io:format("server stop...\n"),
    ok.

handshake(Socket) ->
    {ok, Bin} = gen_tcp:recv(Socket, 0, 5*1000),
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
          <<FIN:1,_RSV:3,Opcode:4,Mask:1, PayloadLen:7>> ->
            case PayloadLen of
              0 ->
                loop(Socket, ConnState#conn{status = read_head});
              126 ->
                loop(Socket, ConnState = #conn{status = read_payload_len, mask = Mask});
              127 ->
                loop(Socket, ConnState = #conn{status = read_payload_len2, mask = Mask});
              _ ->
                case Mask of
                  ?true ->
                    sync_recv(Socket, 4+PayloadLen, ?RECV_TIMEOUT);
                  ?false ->
                    sync_recv(Socket, PayloadLen, ?RECV_TIMEOUT)
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
          loop(Socket, ConnState = #conn{status = read_payload_data, mask = Mask});
        ?false ->
          loop(Socket, ConnState = #conn{status = read_payload_data, mask = Mask})
      end;
    _ ->
      ok
  end,
  loop(Socket, ConnState);
loop(Socket, ConnState = #conn{status = read_payload_len2}) ->
  sync_recv(Socket, 8, ?RECV_TIMEOUT),
  loop(Socket, ConnState);
loop(Socket, ConnState = #conn{status = read_payload_data, length = Len}) ->
  sync_recv(Socket, 8, ?RECV_TIMEOUT),
  loop(Socket, ConnState).


sync_recv(Socket, Len, TimeOut) ->
  gen_tcp:recv(Socket, Len, TimeOut).


%% =========================== local function ===========================

trim(Str, Chars) ->
    rtrim(ltrim(Str, Chars), Chars).

%%ltrim(Str) ->
%%    ltrim(Str, ?trim_def).

ltrim([], _Chars) -> [];
ltrim(L = [C | T], Chars) ->
    case lists:member(C, Chars) of
        true -> ltrim(T, Chars);
        false -> L
    end.

%%rtrim(Str) ->
%%    rtrim(Str, ?trim_def).

rtrim(Str, Chars) ->
    lists:reverse(ltrim(lists:reverse(Str), Chars)).
