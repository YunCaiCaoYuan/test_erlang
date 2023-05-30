-module(test_fsm).

-export([start_link/0,stand/2,move/2,dead/2,stop/0]).
-export([handle_stand/0,handle_move/0]).

-behaviour(gen_fsm).

%%	有限状态机可以用下面这个公式来表达
%%	State(S) x Event(E) -> Actions(A), State(S')
%%	表示的就是在S状态时如果有事件E发生，那么执行动作A后把状态调整到S’。

%%
-export([init/1,handle_info/3,handle_event/3,handle_sync_event/4,code_change/4,terminate/3]).

%%
start_link() ->
	gen_fsm:start_link({local,?MODULE},?MODULE,[],[]).

%%

init([])->
	io:format("init....~n",[]),
	{ok,stand,stand}.

handle_info(_Info,_StateName,_State) ->
	{next_state,_StateName,_State}.

handle_event(_Event,StateName,State) ->
	{next_State,StateName,State};
handle_event(stop,_StateName,State) ->
	{stop,normal,State}.

handle_sync_event(_Event,_From,StateName,State) ->
	Reply = ok,
	{reply,Reply,StateName,State}.

code_change(_OldVsn,StateName,State,_Extra) ->
	{ok,StateName,State}.

terminate(_Reason,_StateName,_State) ->
	io:format("terminate......~n",[]),
	ok.

stand(stand,State) ->
	io:format("stand....~n",[]),
	{next_state,move,State}.
move(move,State) ->
	io:format("move......~n",[]),
	{next_state,dead,State,5000}. %%五秒后将执行死亡

dead(timeout,State) ->
	io:format("dead.........~n",[]),
	proc_lib:hibernate(gen_fsm, enter_loop, [?MODULE, [], stand,State]). %%清空stack，重新进入stand
%%{next_state,stand,State}.

%%==============外部接口函数==============
handle_stand() ->
	gen_fsm:send_event(?MODULE,stand).

handle_move() ->
	gen_fsm:send_event(?MODULE,move).

%%======================stop===
stop() ->
	gen_fsm:send_all_state_event(?MODULE,stop).