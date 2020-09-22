-module(test_websocket_client).
-author("孙斌").

%% API
-export([start/0]).


start() ->
    inets:start(),

    URL = "http://127.0.0.1:88",
    Headers = [
        {"Origin", URL},
        {"Connection", "Upgrade"},
        {"Upgrade", "websocket"},
        {"Sec-WebSocket-Version", "13"},
        {"Sec-WebSocket-Key", "w4v7O6xFTi36lq3RNcgctw=="}
    ],
    {ok, Ret} = httpc:request(get, {URL, Headers}, [], []),
    io:format("Ret=~p", [Ret]),

    ok.
