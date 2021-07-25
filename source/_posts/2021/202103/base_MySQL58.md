---
title: MySQL_基础 (58)
date: 2021-03-09
tags: MySQL
toc: true
---

### 更好的理解MySQL
    mysql错误总结

<!-- more -->

#### 故事背景
> 好不容易把这些都搞好了 记录一下中间遇到的mysql异常吧

#### 错误1
> impossible to write to binary log since BINLOG_FORMAT = STATEMENT
- 知识点引入
    * MySQL的binlog有有几种录入格式？分别有什么区别？
        * 有三种格式,statement,row和mixed.
        1. statement模式下,每一条会修改数据的sql都会记录在binlog中.不需要记录每一行的变化,减少了binlog日志量,节约了IO,提高性能.由于sql的执行是有上下文的,因此在保存的时候需要保存相关的信息,同时还有一些使用了函数之类的语句无法被记录复制.
        2. row级别下,不记录sql语句上下文相关信息,仅保存哪条记录被修改.记录单元为每一行的改动,基本是可以全部记下来但是由于很多操作,会导致大量行的改动(比如alter table),因此这种模式的文件保存的信息太多,日志量太大.
        3. mixed,一种折中的方案,普通操作使用statement记录,当无法使用statement的时候使用row.
- 问题解决
    * 修改my.ini
    * binlog_format=ROW

#### 错误2
> MySQL server has gone away
- 问题解读
    * client和MySQL server之间的链接断开了
- 原因
    1. MySQL服务宕了
        * 检查方法: 查看mysql运行时间
        * show global status like 'uptime';
        * 如果uptime数值很大,表明mysql服务运行了很久了.说明最近服务没有重启过
    2. mysql连接超时(很有可能是因为这个)
        * 即某个mysql长连接很久没有新的请求发起,达到了server端的timeout,被server强行关闭.此后再通过这个connection发起查询的时候,就会报错server has gone away
        * show global variables like '%timeout';
    3. mysql请求链接进程被主动kill
        * 与原因2最大的不同是 原因3是mysql自己的动作
    4. 程序中获取数据库连接时采用了Singleton的做法,虽然多次连接数据库,但其实使用的都是同一个连接,而且程序中某两次操作数据库的间隔时间超过了wait_timeout
        * 时不时顺手mysql_ping()一下,这样MySQL就知道它不是一个人在战斗

#### 错误3
> Django执行定时调度任务出现MySQL server has gone away报错
1. 背景及问题
    * django后台周期性任务(一天执行一次), 在间隔24小时之后,执行定时调度的后台线程进行数据库查询时,出现(2006, 'MySQL server has gone away')的报错
2. 问题排查过程
    * 先排查自己的日志, 从捕获的异常中看到了MySQL server has gone away
    * 出现异常的前后5分钟的周期性任务是正常执行的, 排除mysql自己挂掉
    * 从命令行模式进行计算,可以正常入库,排除因为插入数据量大导致mysql挂掉
    * 翻看mysql query log发现连周期性任务操作之前的查询语句都没有, 说明是在查询之前就发现mysql挂掉了
    * 查了很多之后发现 是因为django会自动保持连接,不会主动关闭mysql连接, 任务是24小时执行一次,第一次执行的时候django和mysql建立了一个链接A, 假设10分钟可以执行完任务,任务执行完之后,链接A没有关闭而是继续存在,这样,23小时50分钟之后,django的orm又使用链接A进行查询,但是A已经挂掉了,因为mysql设置的超时时间是8小时,所以返回了一个gone away(再来一张图片说明)
    * ![django-mysql gone away](/img/20210309_1.png)
3. 解决方法
    * fun1
        ```python
            # 主要思想 周期性任务执行之前先ping一下mysql看看是否正常,正常的话就该干什么干什么,不正常的话就关一下数据库,然后再该干什么干什么
            from django.db import connection

            def is_connection_usable():
                try:
                    connection.connection.ping()
                except:
                    return False
                else:
                    return True

            def do_work():
                while(True): # Endless loop that keeps the worker going (simplified)
                    if not is_connection_usable():
                        connection.close()
                    try:
                        do_a_bit_of_work()
                    except:
                        logger.exception("Something bad happened, trying again")
                        sleep(1)
        ```
    * fun2
        ```python
            # 方法1的局限在于 close的是default,如果是数据库是主从模式的话 还是很烦, 所以有了第二种,关闭所有的数据库
            from django.db import connections

            def close_old_connections():
                for conn in connections.all():
                    conn.close_if_unusable_or_obsolete()
        ```
4. 其它
    * django.db中connection和connections的区别
        * connection对应的是默认数据库的连接, 用代码表示就是connections\[DEFAULT_DB_ALIAS]
        * connections对应的是setting.DATABASES中所有数据库的connection




