-module(tt13).
%%-version("1.1").
-version("2.0").
-behavior(gen_server).

%% API
-export([test/0]).
-export([start_link/0, stop/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%-record(state, {cnt}).
-record(state, {testcheck, cnt}).

-define(SERVER, ?MODULE).

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], [{debug, [trace]}]).

test() ->
  gen_server:call(?SERVER, test).

stop() ->
  gen_server:cast(?SERVER, stop).

%%init(_) -> {ok, #state{cnt=1}}.
init(_) -> {ok, #state{testcheck = 'chk', cnt=1}}.

handle_call(test, _From, #state{cnt=Cnt} = State) ->
%%  {reply, {ok, Cnt}, State#state{cnt=Cnt+1}};
  {reply, {ok, Cnt}, State#state{cnt=Cnt*2}};


handle_call(stop, _From, State) ->
  {stop, normal, ok, State};

handle_call(_Unrec, _From, State) ->
  {reply, {error, invalid_call}, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  io:format("hello gen server:terminating~n").

code_change("1.1", {state, Cnt}, _Extra) ->
  {ok, {state, chk, Cnt}};

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.