-module(test_param_module, [A]).
-author("sunbin").

%% API
-export([test/0]).


%%test_param_module.erl:1: parameterized modules are no longer supported
%%test_param_module.erl:8: variable 'A' is unbound
%% 20以下支持
test() ->
  io:format("~p", A),
  ok.


