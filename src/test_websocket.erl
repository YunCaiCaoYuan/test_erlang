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

-define(trim_def, [32, 9, 10, 13, 0, 11]).

start() ->
    {ok, LSock} = gen_tcp:listen(?PORT, ?TCP_OPTS),

    io:format("server start...\n"),
    {ok, Socket} = gen_tcp:accept(LSock),

    handshake(Socket),

%%    gen_tcp:close(Socket).

    loop(Socket),
    io:format("server stop...\n"),
    ok.

handshake(Socket) ->
    {ok, Bin} = gen_tcp:recv(Socket, 0, 5*1000),
    io:format("Bin=~p\n", [Bin]),

    BinList = binary:split(Bin, [<<"\r\n">>], [global]),
    HeadList = [erlang:list_to_tuple([trim(Ele, ?trim_def) || Ele <- string:tokens(erlang:binary_to_list(Elem), ":")]) || Elem <- BinList, Elem =/= <<>>],
    io:format("HeadList=~p\n", [HeadList]),

    ClientKey = proplists:get_value("sec-websocket-key", HeadList),
    io:format("ClientKey=~p\n", [ClientKey]),

    AcceptKey = base64:encode(crypto:hash(sha, erlang:list_to_binary([ClientKey, ?WS_MAGIC_KEY]))),
    ok = gen_tcp:send(Socket, erlang:list_to_binary(?WS_REP(AcceptKey))),

    ok.

loop(Socket) ->
    %% ...
    loop(Socket).

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
