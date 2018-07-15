---
title: MySQL_基础 (5)
date: 2018-07-13
tags: MySQL
toc: true
---

### 慢查询日志
    某些sql语句执行完毕所花费的时间特别长,我们将这种响应比较慢的语句记录在慢查询日志中,不要被"慢查询日志"的名字误导,错误的以为慢查询日志只会记录执行比较慢的SELECT语句,其实不然,INSERT、DELETE、UPDATE、CALL等DML操作,只要是超过了指定的时间,都可以称之为"慢查询",
    默认情况下,慢查询日志是不被开启的,如果需要,可以手动开启,
    开启慢查询日志之后,默认设置下,执行超过10秒的语句才会被记录到慢查询日志中,
    慢查询秒数可以自己设定

<!-- more -->

#### 慢查询相关参数
- log_slow_queries
    * 表示是否开启慢查询日志
    * 5.6之前用的这个参数.5.6之后用的是slow_query_log
- slow_query_log
    * 作用同上,跟MySQL版本相关
- log_output
    * 表示慢查询日志开启后,以何种形式存放
    * FILE 存放在指定文件中
    * TABLE 存放在MySQL.slow_log表中
    * FILE,TABLE 将慢查询日志同时存放在文件和数据库表中
    * NONE 不记录慢查询日志
- slow_query_log_file
    * 当log_output为FILE或者FILE,TABLE时,慢查询日志存放的位置
- long_query_time
    * 表示多长时间的查询定义为慢查询,默认为10s
- log_queries_not_using_indexes
    * 如果运行的sql没有使用索引,是否当做慢查询放在慢查询日志中,off表示不记录,on表示记录
- log_throttle_queries_not_using_indexes
    * 5.6.5版本新引入的参数,当log_queries_not_using_inde设置为ON时,没有使用索引的查询语句也会被当做慢查询语句记录到慢查询日志中,使用log_throttle_queries_not_using_indexes可以限制这种语句每分钟记录到慢查询日志中的次数

#### MySQL中使用慢查询日志
- 查看当前MySQL是否开启慢查询日志
    ```sql
        mysql> show variables where variable_name like "%slow_query%" or variable_name = "log_output";
        +---------------------+---------------------------------------------------+
        | Variable_name       | Value                                             |
        +---------------------+---------------------------------------------------+
        | log_output          | FILE                                              |
        | slow_query_log      | OFF                                               |
        | slow_query_log_file | /var/lib/mysql/llllljian-virtual-machine-slow.log |
        +---------------------+---------------------------------------------------+
        3 rows in set (0.26 sec)
    ```
- 设置慢查询日志相关参数
    ```sql
        mysql> set global slow_query_log=ON;
        Query OK, 0 rows affected (0.22 sec)

        mysql> show variables where variable_name like "%slow_query%" or variable_name = "log_output";
        +---------------------+---------------------------------------------------+
        | Variable_name       | Value                                             |
        +---------------------+---------------------------------------------------+
        | log_output          | FILE                                              |
        | slow_query_log      | ON                                                |
        | slow_query_log_file | /var/lib/mysql/llllljian-virtual-machine-slow.log |
        +---------------------+---------------------------------------------------+
        3 rows in set (0.02 sec)

        # 为了方便查看慢查询日志,这里设置为FILE,TABLE 一般设置为TABLE
        mysql> set global log_output='FILE,TABLE';
        Query OK, 0 rows affected (0.07 sec)

        mysql> show variables where variable_name like "%slow_query%" or variable_name = "log_output";
        +---------------------+---------------------------------------------------+
        | Variable_name       | Value                                             |
        +---------------------+---------------------------------------------------+
        | log_output          | FILE,TABLE                                        |
        | slow_query_log      | ON                                                |
        | slow_query_log_file | /var/lib/mysql/llllljian-virtual-machine-slow.log |
        +---------------------+---------------------------------------------------+
        3 rows in set (0.02 sec)

        mysql> show variables where variable_name like "long_query_time";
        +-----------------+-----------+
        | Variable_name   | Value     |
        +-----------------+-----------+
        | long_query_time | 10.000000 |
        +-----------------+-----------+
        1 row in set (0.02 sec)

        mysql> set global long_query_time=3;
        Query OK, 0 rows affected (0.04 sec)

        # 设置成功之后,发现慢查询时间没有变化,需要重新建立数据库连接
        mysql> show variables where variable_name like "long_query_time";
        +-----------------+-----------+
        | Variable_name   | Value     |
        +-----------------+-----------+
        | long_query_time | 10.000000 |
        +-----------------+-----------+
        1 row in set (0.03 sec)

        # 重新建立数据库连接
        mysql> show variables where variable_name like "long_query_time";
        +-----------------+----------+
        | Variable_name   | Value    |
        +-----------------+----------+
        | long_query_time | 3.000000 |
        +-----------------+----------+
        1 row in set (0.20 sec)

        # 不使用索引就将sql语句记录到慢查询日志中
        mysql> show variables where variable_name like "%log_queries_not_using_index%";
        +-------------------------------+-------+
        | Variable_name                 | Value |
        +-------------------------------+-------+
        | log_queries_not_using_indexes | OFF   |
        +-------------------------------+-------+
        1 row in set (0.02 sec)

        mysql> set global log_queries_not_using_indexes=1;
        Query OK, 0 rows affected (0.00 sec)

        mysql> show variables where variable_name like "%log_queries_not_using_index%";
        +-------------------------------+-------+
        | Variable_name                 | Value |
        +-------------------------------+-------+
        | log_queries_not_using_indexes | ON    |
        +-------------------------------+-------+
        1 row in set (0.03 sec)

        mysql> show variables where variable_name like "%log_throttle_queries_not_using_indexes%";
        +----------------------------------------+-------+
        | Variable_name                          | Value |
        +----------------------------------------+-------+
        | log_throttle_queries_not_using_indexes | 0     |
        +----------------------------------------+-------+
        1 row in set (0.02 sec)

        mysql> set global log_throttle_queries_not_using_indexes=2;
        Query OK, 0 rows affected (0.00 sec)

        mysql> show variables where variable_name like "%log_throttle_queries_not_using_indexes%";
        +----------------------------------------+-------+
        | Variable_name                          | Value |
        +----------------------------------------+-------+
        | log_throttle_queries_not_using_indexes | 2     |
        +----------------------------------------+-------+
        1 row in set (0.02 sec)
    ```
- 查看慢查询日志
    ```sql
        mysql> SELECT sleep(5);
        +----------+
        | sleep(5) |
        +----------+
        |        0 |
        +----------+
        1 row in set (5.08 sec)

        mysql> SELECT * FROM mysql.slow_log;
        +----------------------------+---------------------------+-----------------+-----------------+-----------+---------------+----+----------------+-----------+-----------+-----------------+-----------+
        | start_time                 | user_host                 | query_time      | lock_time       | rows_sent | rows_examined | db | last_insert_id | insert_id | server_id | sql_text        | thread_id |
        +----------------------------+---------------------------+-----------------+-----------------+-----------+---------------+----+----------------+-----------+-----------+-----------------+-----------+
        | 2018-07-13 16:07:19.497930 | root[root] @ localhost [] | 00:00:05.073333 | 00:00:00.000000 |         1 |             0 |    |              0 |         0 |         0 | SELECT sleep(5) |        47 |
        +----------------------------+---------------------------+-----------------+-----------------+-----------+---------------+----+----------------+-----------+-----------+-----------------+-----------+
        1 row in set (0.00 sec)

        # 查看本次MySQL服务启动到当前时间点慢查询次数
        mysql> show global status like "%slow_queries%";
        +---------------+-------+
        | Variable_name | Value |
        +---------------+-------+
        | Slow_queries  | 1     |
        +---------------+-------+
        1 row in set (0.01 sec)
    ```

    ```bash
        [llllljian@llllljian-virtual-machine mysql 16:07:48 #7]$ sudo -i
        root@llllljian-virtual-machine:~# tail -fn6 /var/lib/mysql/llllljian-virtual-machine-slow.log
        Time                 Id Command    Argument
        # Time: 2018-07-13T08:07:19.497930Z
        # User@Host: root[root] @ localhost []  Id:    47
        # Query_time: 5.073333  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 0
        SET timestamp=1531642039;
        SELECT sleep(5);
    ```

#### 利用mysqldumpslow查看
    只针对log_output值为FILE或者FILE,TABLE时
- 使用
    ```bash
        root@llllljian-virtual-machine:~# mysqldumpslow -s t /var/lib/mysql/llllljian-virtual-machine-slow.log

        Reading mysql slow query log from /var/lib/mysql/llllljian-virtual-machine-slow.log
        Count: 1  Time=0.00s (0s)  Lock=0.00s (0s)  Rows=0.0 (0), 0users@0hosts
        # Time: N-N-15T08:N:N.497930Z
        # User@Host: root[root] @ localhost []  Id:    N
        # Query_time: N.N  Lock_time: N.N Rows_sent: N  Rows_examined: N
        SET timestamp=N;
        SELECT sleep(N)

        Count: 1  Time=0.00s (0s)  Lock=0.00s (0s)  Rows=0.0 (0), 0users@0hosts
        Time: N-N-15T08:N:N.958617Z
        # User@Host: root[root] @ localhost []  Id:    N
        # Query_time: N.N  Lock_time: N.N Rows_sent: N  Rows_examined: N
        SET timestamp=N;
        SELECT sleep(N)
    ```
- 参数说明
    * -s 排序
        * c 执行次数
        * l 锁定时间
        * r 返回记录
        * t 执行时间
        * al 平均锁定时间
        * ar 平均返回记录数
        * at 平均执行时间
    * -t 只查看多少条统计信息
    * -g 正则匹配想查看的内容
