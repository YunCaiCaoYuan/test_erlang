-module(my_app).
-behaviour(application).

%% API
-export([start/2, stop/1]).

start(_Type, _Args) ->
  my_supervisor:start_link().

stop(_State) ->
  ok.