-module(test_websocket_client).
-author("孙斌").

%% API
-export([start/0]).


start() ->
    URL = "http://127.0.0.1:88",
    Headers = [{"Connection", "Upgrade"}],
    httpc:request({URL, Headers}),
    ok.
