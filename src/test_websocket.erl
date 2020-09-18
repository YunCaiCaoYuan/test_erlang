-module(test_websocket).

-export([start/0]).

-define(PORT, 88).
-define(TCP_OPTS, [
                   binary
                  ,{packet, 0}
                  ,{active, false}
                  ,{reuseaddr, true}
                  ,{exit_on_close, false}
                  ]).

start() ->
    {ok, LSock} = gen_tcp:listen(?PORT, ?TCP_OPTS),

    {ok, Socket} = gen_tcp:accept(LSock),

    loop(Socket),

    gen_tcp:close(Socket).

loop(Socket) ->
    Ret = gen_tcp:recv(Socket, 0, 5*1000),
    io:format("Ret=~w", [Ret]).