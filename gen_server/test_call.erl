%%%-------------------------------------------------------------------
%%% @author sunb
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 4月 2023 15:12
%%%-------------------------------------------------------------------
-module(test_call).
-author("sunb").
-behaviour(gen_server).

%% API
-export([call_self/0]).


-export([
    start_link/0,
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

%% call自己会超时，和处理时长没关系
%% 死锁导致超时
call_self() ->
    gen_server:call(self(), hi).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    io:format("init~n"),
    erlang:send_after(1000, self(), do_loop),
    {ok, []}.

handle_call(hi, From, State) ->
%%    timer:sleep(3*1000),
    io:format("hi~n"),
    {reply, hi, State};
handle_call({add, A, B}, From, State) ->
    io:format("add~n"),
    {reply, A + B, State};
handle_call({sub, A, B}, From, State) ->
    io:format("sub~n"),
    {reply, A - B, State}.

handle_cast({add, A, B}, State) ->
    io:format("add~n"),
    {noreply, State};

handle_cast({sub, A, B}, State) ->
    io:format("sub~n"),
    {noreply, State}.

handle_info(do_loop, State) ->
%%    io:format("do_loop~n"),
    erlang:send_after(1000, self(), do_loop),
    {noreply, State};
handle_info(Info, State) ->
    io:format("info~n"),
    {noreply, State}.

terminate(Reason, State) ->
    io:format("terminate~n"),
    ok.

code_change(OldVsn, State, Extra) ->
    {ok, State}.