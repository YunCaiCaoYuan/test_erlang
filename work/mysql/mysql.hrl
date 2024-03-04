%% MySQL result record:
%% 改造事项：这里根据emysql加入insertid属性
-record(mysql_result,{
    fieldinfo=[],
	rows=[],
    affectedrows=0,
    insertid=0,
    error=""}
).
