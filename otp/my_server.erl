-module(my_server).
-behaviour(gen_server).

%% API
-export([start_link/0]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
  {ok, 0}.

handle_call(increment, _From, Count) ->
  {reply, Count+1, Count+1}.

handle_cast(_Msg, Count) ->
  {noreply, Count}.

handle_info(_Info, Count) ->
  {noreply, Count}.

terminate(_Reason, _Count) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


