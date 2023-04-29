%%%-------------------------------------------------------------------
%%% @author sunb
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(test_center_worker).

-behaviour(gen_server).

%% 跳板，不做具体逻辑

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(test_center_worker_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #test_center_worker_state{}}.

handle_call(get_friend, From, State) ->
  io:format("到中心服worker了"),
  Reply = gen_server:call(test_game, get_friend, 5000),
  {reply, Reply, State};
handle_call(_Request, _From, State = #test_center_worker_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #test_center_worker_state{}) ->
  {noreply, State}.

handle_info(_Info, State = #test_center_worker_state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #test_center_worker_state{}) ->
  ok.

code_change(_OldVsn, State = #test_center_worker_state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
