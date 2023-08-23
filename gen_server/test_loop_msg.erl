%%%-------------------------------------------------------------------
%%% @author sunb
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%		如果死循环式的发消息，时间片会非常大，处理不过来，消息邮箱会大于>0
%%% @end
%%% Created : 05. 4月 2023 15:12
%%%-------------------------------------------------------------------
-module(test_loop_msg).
-author("sunb").
-behaviour(gen_server).

%% API
-export([]).


-export([
	start_link/0,
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).


start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	io:format("init~n"),
	erlang:send(self(), do_loop),
	{ok, []}.

handle_call(hi, _From, State) ->
	io:format("hi~n"),
	{reply, hi, State}.

handle_cast(_, State) ->
	{noreply, State}.

handle_info(do_loop, State) ->
	erlang:send(self(), do_loop),
	{noreply, State};
handle_info(_Info, State) ->
	{noreply, State}.

terminate(Reason, State) ->
	io:format("terminate~n"),
	ok.

code_change(OldVsn, State, Extra) ->
	{ok, State}.

%% 了解邮箱情况，除了message_queue_len，20版本可以查看messages

%% 查看当前收到的所有消息
%% 启动跟踪器:
%%d bg:tracer().
%% 跟踪进程(在本例中为 self())接收到的所有消息 (r):
%% dbg:p(self(), r).


%%erlang:process_info(pid(0,85,0)).
%%[{registered_name,test_loop_msg},
%%{current_function,{gen_server,loop,7}},
%%{initial_call,{proc_lib,init_p,5}},
%%{status,running},
%%{message_queue_len,0},
%%{links,[<0.78.0>]},
%%{dictionary,[{'$initial_call',{test_loop_msg,init,1}},
%%{'$ancestors',[<0.78.0>]}]},
%%{trap_exit,false},
%%{error_handler,error_handler},
%%{priority,normal},
%%{group_leader,<0.64.0>},
%%{total_heap_size,609},
%%{heap_size,233},
%%{stack_size,11},
%%{reductions,388846625023}, %% 时间片非常大
%%{garbage_collection,[{max_heap_size,#{error_logger => true,kill => true,size => 0}},
%%{min_bin_vheap_size,46422},
%%{min_heap_size,233},
%%{fullsweep_after,65535},
%%{minor_gcs,51836}]},
%%{suspending,[]}]

%%========================================================================================
%%nonode@nohost                                                             11:08:48
%%Load:  cpu         6               Memory:  total       20489    binary         42
%%procs      44                        processes    5252    code         6899
%%runq        0                        atom          372    ets           502
%%
%%Pid            Name or Initial Func    Time    Reds  Memory    MsgQ Current Function
%%----------------------------------------------------------------------------------------
%%<0.85.0>       test_loop_msg            '-'********    5764       0 gen_server:loop/7
%%<0.64.0>       group:server/3           '-'   20901   63068       0 group:more_data/6
%%<0.108.0>      etop_txt:init/1          '-'   10781  142748       0 etop:update/1
%%<0.62.0>       user_drv                 '-'   10513    8868       0 user_drv:server_loop
%%<0.78.0>       erlang:apply/2           '-'    5228   69024       0 shell:eval_loop/3
%%<0.76.0>       erlang:apply/2           '-'     394  177100       0 shell:get_command1/5
%%<0.918.0>      erlang:apply/2           '-'      16    2728       0 io:execute_request/2
%%<0.46.0>       application_master:i     '-'       2    5816       0 application_master:m
%%<0.61.0>       supervisor_bridge:us     '-'       2    2800       0 gen_server:loop/7
%%<0.65.0>       kernel_config:init/1     '-'       2    2756       0 gen_server:loop/7
%%<0.0.0>        init                     '-'       1    8780       0 init:loop/1
%%<0.1.0>        erts_code_purger         '-'       1    2688       0 erts_code_purger:wai
%%<0.2.0>        erts_literal_area_co     '-'       1    2624       0 erts_literal_area_co
%%<0.3.0>        erts_dirty_process_s     '-'       1    2624       0 erts_dirty_process_s
%%<0.4.0>        erts_dirty_process_s     '-'       1    2624       0 erts_dirty_process_s
%%<0.5.0>        erts_dirty_process_s     '-'       1    2624       0 erts_dirty_process_s
%%<0.6.0>        prim_file:start/0        '-'       1    2624       0 prim_file:helper_loo
%%<0.7.0>        socket_registry          '-'       1    2624       0 socket_registry:loop
%%<0.10.0>       erl_prim_loader          '-'       1  263884       0 erl_prim_loader:loop
%%<0.42.0>       logger                   '-'       1    6988       0 gen_server:loop/7
%%========================================================================================