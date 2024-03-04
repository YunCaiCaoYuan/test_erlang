-module(mysql_app).
-behaviour(application).

%% API
-export([start/2, stop/1]).

start(_Type, _Args) ->
  db:init(mysql, []).

stop(_State) ->
  ok.