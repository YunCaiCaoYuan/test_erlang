%%----------------------------------------------------
%% @doc 数据库接口（不适用于原mysql驱动
%% @author cayleung@gmail.com
%% @end
%%----------------------------------------------------
-module(db).
-export(
    [
        init/2,
        execute/1
    ]
).
-include("mysql.hrl").
-define(MYSQL_POLL, mysql_poll).

%% @spec init(mysql, Options) -> {ok, Pid}
%% Options = [{Key, Val}]
%% Key = host | port | user | pass | database | charset | connection_num
%% @hidden
%% @doc 初始化mysql
%% host -> mysql服务器地址string()
%% port -> mysql服务器端口int()
%% user -> 用户string()
%% pass -> 密码string()
%% database -> 数据库名string()
%% charset -> 编码atom() 一般用utf8
%% connection_num -> 数据库连接数int()
init(mysql, Options) ->
%%    Host = proplists:get_value(host, Options),
%%    Port = proplists:get_value(port, Options),
%%    User = proplists:get_value(user, Options),
%%    Password = proplists:get_value(pass, Options),
%%    Database = proplists:get_value(database, Options),
%%    Encoding = proplists:get_value(charset, Options),

    Host="127.0.0.1",
    Port=3306,
    User="root",
    Password="sunbin",
    Database="test",
    Encoding=utf8,
    ConnectionNum=5,

    %% 与mysql数据库建立连接
    case mysql:start_link(?MYSQL_POLL, Host, Port, User, Password, Database, fun(_,_,_,_) -> ok end, Encoding) of
    {ok, Pid} ->
        [
            mysql:connect(?MYSQL_POLL, Host, Port, User, Password, Database, Encoding, true)
            || _I <- lists:seq(1, ConnectionNum)
        ],
        {ok, Pid};
    _Any ->
        exit(kill)
    end.

%% @spec execute(Sql) -> {ok, Affected} | {error, bitstring()}
%% Sql = iolist()
%% Affected = integer()
%% @doc 执行一个SQL查询,返回影响的行数
execute(Sql) ->
    case catch mysql:fetch(?MYSQL_POLL, Sql) of
        {updated, {_, _, _, R, _, _}} -> {ok, R};
        {error, {_, _, _, _, _, Reason}} -> format_error(Sql, Reason);
        {error, Reason} -> format_error(Sql, Reason);
        {'EXIT', Reason} -> format_error(Sql, Reason)
    end.

%% @doc 显示人可以看得懂的错误信息
format_error(Sql, Reason) ->
    {error, Reason}.
