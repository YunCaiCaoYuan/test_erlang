%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%		maps
%%% @end
%%% Created : 26. 4月 2023 10:29
%%%-------------------------------------------------------------------
-module(test_maps).
-author("sunbin").

%% API
-export([test/0]).

test() ->
	Maps = maps:new(),
	io:format("Maps:~p~n", [Maps]),

	NewMaps = maps:put(a, 1, Maps),
	NewMaps2 = maps:put(b, 2, NewMaps),
	NewMaps3 = maps:put(c, 3, NewMaps2),
	io:format("NewMaps:~p~n", [NewMaps3]),

	catch maps:get(d, Maps), % 查不到d这个key的值，会报异常提示
	Ret2 = maps:get(a, NewMaps3),
	io:format("Ret2:~p~n", [Ret2]),

	io:format("NewMap keys:~p~n", [maps:keys(NewMaps3)]),

	io:format("NewMap is_key:~p~n", [maps:is_key(a, NewMaps3)]),
	io:format("NewMap is_key:~p~n", [maps:is_key(d, NewMaps3)]),

	io:format("NewMap values:~p~n", [maps:values(NewMaps3)]),

	io:format("NewMap size:~p~n", [maps:size(NewMaps3)]),

	NewMaps4 = maps:put(c, 33, NewMaps3),
	io:format("NewMap:~p~n", [NewMaps4]),

	NewMaps5 = maps:remove(c, NewMaps3),
	io:format("NewMap:~p~n", [NewMaps5]),

	RetTake = maps:take(c, NewMaps3), % {3,#{a => 1,b => 2}}
	io:format("RetTake:~p~n", [RetTake]),
	RetTake2 = maps:take(cc, NewMaps3), % error
	io:format("RetTake2:~p~n", [RetTake2]),

	RetFind = maps:find(c, NewMaps3), % {ok,3}
	io:format("RetFind:~p~n", [RetFind]),
	RetFind2 = maps:find(cc, NewMaps3), % error
	io:format("RetFind2:~p~n", [RetFind2]),

	io:format("NewMap to_list:~p~n", [maps:to_list(NewMaps5)]),

	RoleMap = maps:from_list([{11111, 10}, {22222, 20}]),
	io:format("RoleMap:~p~n", [RoleMap]),
	ok.
