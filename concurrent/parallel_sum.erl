-module(parallel_sum).

%% API
-export([start/1]).

-define(Schedulers, 4).

start(Numbers) ->
  ResultRef = make_ref(),
  MasterPid = self(),
  SpawnCount = length(Numbers),
  Result = [],
  ChunkSize = SpawnCount div ?Schedulers,

  lists:foreach(
    fun(Index) ->
      case Index of
        ?Schedulers-1 -> Chunk = lists:sublist(Numbers, 1+Index*ChunkSize, SpawnCount-Index*ChunkSize);
        _ -> Chunk = lists:sublist(Numbers, 1+Index*ChunkSize, ChunkSize)
      end,
      spawn_link(fun() -> worker(MasterPid,Chunk,ResultRef) end)
      end,
    lists:seq(0, ?Schedulers-1)
  ),

  loop(Result, ResultRef).

loop(Result, ResultRef) ->
  case length(Result) of
    ?Schedulers ->
      FinalResult = lists:sum(Result),
      io:format("Result: ~p~n", [FinalResult]);
    _ ->
      receive
        {result, ResultRef, PartialResult} ->
          NewResult = [PartialResult|Result],
          loop(NewResult, ResultRef)
      end
  end.

worker(MasterPid, Numbers, ResultRef) ->
  PartialResult = calculate_partial_sum(Numbers),
  MasterPid ! {result, ResultRef, PartialResult}.

calculate_partial_sum(Numbers) ->
  lists:sum([X*X || X <- Numbers]).
