-module(my_supervisor).
-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  ServerSpec = {
    my_server,
    {my_server, start_link, []},
    permanent,
    5000,
    worker,
    [my_server]
  },
  {ok, {{one_for_one, 5, 10}, [ServerSpec]}}.


