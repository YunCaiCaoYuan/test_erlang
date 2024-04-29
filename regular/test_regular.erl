%%%-------------------------------------------------------------------
%%% @author sunbin
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 4月 2024 16:50
%%%-------------------------------------------------------------------
-module(test_regular).
-author("sunbin").

%% API
-export([is_alpha_num/1]).

is_alpha_num(StringAlphaNum) ->
	case re:run(StringAlphaNum, "^[0-9A-Za-z_]+$") of
		{match, _} ->
			true;
		nomatch ->
			false
	end.
