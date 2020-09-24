-module(test_websocket_client).
-author("孙斌").

%% API
-export([start/0]).


start() ->
    inets:start(),

    URL = "http://127.0.0.1:88",
    Headers = [
        {"origin", URL},
        {"connection", "Upgrade"},
        {"upgrade", "websocket"},
        {"sec-websocket-version", "13"},
        {"sec-webSocket-key", "w4v7O6xFTi36lq3RNcgctw=="}
    ],
    io:format("client start...\n"),

    Ret = httpc:request(get, {URL, Headers}, [], []),
    io:format("Ret=~p", [Ret]),

    ok.
