%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%		dict vs maps
%%% @end
%%% Created : 26. 4月 2023 10:59
%%%-------------------------------------------------------------------
-module(test_dict).
-author("sunbin").

%% API
-export([test/1]).

%% maps
maps_put(N) ->
	Maps = maps:new(),
	lists:foldl(fun(Nth, MapsAcc) ->
		maps:put(Nth, Nth, MapsAcc)
				end, Maps, lists:seq(1,N)).

maps_get(Maps, N) ->
	for(N, fun(Nth) -> maps:get(Nth, Maps) end).

%% dict
dict_put(N) ->
	Dict = dict:new(),
	lists:foldl(fun(Nth, DictAcc) ->
		dict:store(Nth, Nth, DictAcc)
				end, Dict, lists:seq(1,N)).

dict_get(Dict, N) ->
	for(N, fun(Nth) -> dict:fetch(Nth, Dict) end).

%% ets
ets_put(N) ->
	ets:new(ets, [named_table, set, public]),
	for(N, fun(Nth) -> ets:insert(ets, {Nth,Nth}) end).

ets_get(N) ->
	for(N, fun(Nth) -> ets:lookup(ets, Nth) end).


test(Num) ->
	{T, V} = timer:tc(fun maps_put/1, [Num]),
	io:format("maps put T:~p microsecond~n", [T]),
	{DT, DV} = timer:tc(fun dict_put/1, [Num]),
	io:format("dict put T:~p microsecond~n", [DT]),
	catch ets:delete(ets),
	{ET, _EV} = timer:tc(fun ets_put/1, [Num]),
	io:format("ets  put T:~p microsecond~n", [ET]),

	io:format("~n", []),

	{T2, _} = timer:tc(fun maps_get/2, [V, Num]),
	io:format("maps get T:~p microsecond~n", [T2]),
	{DT2, _} = timer:tc(fun dict_get/2, [DV, Num]),
	io:format("dict get T:~p microsecond~n", [DT2]),
	{ET2, _} = timer:tc(fun ets_get/1, [Num]),
	io:format("ets  get T:~p microsecond~n", [ET2]),
	ok.

%%30> test_dict:test(1000000).
%%maps put T:537453 microsecond
%%dict put T:13339667 microsecond
%%ets  put T:425254 microsecond
%%
%%maps get T:184364 microsecond
%%dict get T:419705 microsecond
%%ets  get T:199237 microsecond

%% 结论：
%% put: ets > maps > dict
%% get: maps > ets > dict

%% local function
for(N, Fun) ->
	[Fun(E) || E <- lists:seq(1,N)].
