---
title: MySQL_基础 (8)
date: 2018-08-06
tags: MySQL
toc: true
---

### MySQL主从复制与读写分离
    通过主从复制(Master-Slave)的方式来同步数据
    通过读写分离(MySQL-Proxy)来提升数据库的并发负载能力

<!-- more -->

#### 主从复制
    MySQL主从复制的原理: 从服务器读取主服务器的binlog,然后根据binlog的记录来更新数据库
- MySQL支持的复制类型
    * 基于语句的复制.在服务器上执行sql语句,在从服务器上执行同样的语句,mysql默认采用基于语句的复制,执行效率高.
    * 基于行的复制.把改变的内容复制过去,而不是把命令在从服务器上执行一遍.
    * 混合类型的复制.默认采用基于语句的复制,一旦发现基于语句无法精确复制时,就会采用基于行的复制.
- 复制的工作过程
    * 在每个事务更新数据完成之前,master在二进制日志记录这些改变.写入二进制日志完成后,master通知存储引擎提交事务.
    * Slave将master的binary log复制到其中继日志.首先slave开始一个工作线程（I/O）,I/O线程在master上打开一个普通的连接,然后开始binlog dump process.binlog dump process从master的二进制日志中读取事件,如果已经跟上master,它会睡眠并等待master产生新的事件,I/O线程将这些事件写入中继日志.
    * Sql slave thread（sql从线程）处理该过程的最后一步,sql线程从中继日志读取事件,并重放其中的事件而更新slave数据,使其与master中的数据一致,只要该线程与I/O线程保持一致,中继日志通常会位于os缓存中,所以中继日志的开销很小.
- 场景描述
    * 主数据库服务器: 127.0.0.1:4095
    * 从数据库服务器: 127.0.0.1:4096
- 主服务器操作
    * 启动mysql服务
        ```bash
            /usr/local/mysql/bin/mysqld --defaults-file=/data/mysqldata/4095_mysql/my.cnf
        ```
    * 通过命令行登录管理MySQL服务器
        ```bash
            /usr/local/mysql/bin/mysql -h127.0.0.1 --port=4095 -uroot -p
        ```
    * 授权给从数据库服务器127.0.0.1:4096
        ```sql
            mysql>create user repl; //创建新用户

            mysql> GRANT REPLICATION SLAVE ON *.* to 'rep1'@'127.0.0.1:4096' identified by ‘password’;
        ```
    * 查询主数据库状态
        ```sql
            Mysql> show master status\G
            **************** 1. row *******************
                        File: binlog.000005
                    Position: 300
                Binlog_Do_DB:
            Binlog_Ignore_DB:
        ```
- 配置从服务器
    * 修改从服务器server-id,确保唯一,设置不同步的表
        ```bash
            vim /data/mysqldata/4096_mysql/my.cnf

            [mysqld]
            server-id =2

            replicate-ignore-db = mysql
            replicate-ignore-db = test
            replicate-ignore-db = infomation_schema

        ```
    * 启动mysql服务
        ```bash
            /usr/local/mysql/bin/mysqld --defaults-file=/data/mysqldata/4096_mysql/my.cnf
        ```
    * 通过命令行登录管理MySQL服务器
        ```bash
            /usr/local/mysql/bin/mysql -h127.0.0.1 --port=4096 -uroot -p
        ```
    * 执行同步SQL语句
        ```sql
            mysql> change master to master_host='127.0.0.1',
                                    master_port='4096',
                                    master_user='repl',
                                    master_password='password',
                                    master_log_file='mysql-bin.000005',
                                    master_log_pos=300;
        ```
    * 正确执行后启动Slave同步进程
        ```sql
            mysql> start slave;
        ```
    * 主从同步检查
        ```sql
            mysql> show slave status\G
            **************** 1. row *******************\
            Slave_IO_State: Waiting for maseter to send evenet
            Master_Host: 127.0.0.1
            Master_User: repl
            Master_Port: 4095
            Connect_Retry: 60
            Master_Log_File: mysql-bin.000005
            Read_Master_Log_Pos: 415
            Relay_Log_File: localhost-relay-bin.000008
            Relay_Log_Pos: 561
            Relay_Master_Log_File: mysql-bin.000005
            Slave_IO_Running: YES
            Slave_SQL_Running: YES
            Replicate_Do_DB:
            Replicate_Ignore_DB: mysql,test,information_schema
            ...
            Master_Server_Id: 1
            1 row in set (0.00 sec)
        ```

#### 读写分离
    MySQL读写分离的原理是: 让主数据库处理事务性增、改、删操作(INSERT、UPDATE、DELETE)从数据库处理SELECT查询操作
    MySQL读写分离的原因是: 防止因为数据库的写入影响了查询的效率
- 常见的Mysql读写分离
    * 基于程序代码内部实现
        * 在代码中根据select 、insert进行不同的数据库连接,
        * 优点是性能较好,因为程序在代码中实现,不需要增加额外的硬件开支
        * 缺点是需要开发人员来实现,运维人员无从下手
    * 基于中间代理层实现
        * 代理一般介于应用服务器和数据库服务器之间,代理数据库服务器接收到应用服务器的请求后根据判断后转发到,后端数据库,有以下代表性的程序
        * mysql_proxy.mysql_proxy是Mysql的一个开源项目,通过其自带的lua脚本进行sql判断

#### 二进制日志
    binlog.记录了所有修改数据库的语句,或者有可能改变数据库的语句
- 二进制日志的记录方式
    * statement
        * 基于语句的复制
        * binlog日志量少,IO压力小,性能高
        * 不能保证恢复操作与记录完全一致
    * row
        * 基于行的复制
        * 能完全还原或者复制日志被记录时的操作
        * 记录日志量大,IO压力大,性能消耗大
    * mixed
        * 混合类型的复制
        * 默认采用基于语句的复制,一旦发现基于语句无法精确复制时,就会采用基于行的复制
