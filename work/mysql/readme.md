## 编译
erlc

## 启动
application:start(mysql_app).

```
    先启动mysql_dispatcher，也有一条连接（每条连接都要鉴权）；
    启动连接池，分别被mysql_dispatcher监控。
    
    交互流程:
    比如查询请求，先把消息发给mysql_dispatcher，dispatcher选择一条可用的连接
```

## 监控树结构 mysql_app
```
          -- <87>--<88>
          -- <89>--<90>   
<79>--<80>-- <91>--<92>
          -- <93>--<94>
          -- <95>--<96>
          -- mysql_dispatcher

<88>是mysql连接进程；
mysql_dispatcher还监控了<82>--<83>（不清楚为啥没显示在observer）
```

## 测试执行语句
mysql:fetch(mysql_poll, "select * from stu").

{data,{mysql_result,[{<<"stu">>,<<"id">>,11,'LONG'},
{<<"stu">>,<<"age">>,4,'TINY'}],
[[1,18]],
0,0,[]}}




