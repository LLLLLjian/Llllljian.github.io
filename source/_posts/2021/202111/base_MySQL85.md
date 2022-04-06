---
title: MySQL_基础 (85)
date: 2021-11-15
tags: MySQL
toc: true
---

### 更好的理解MySQL
    Mysql解决问题记录

<!-- more -->

#### 主从同步问题
- 现象
    ```sql
        # MySQL在从服务器执行start slave命令,启动主从复制功能时报错
        [ERROR] Slave I/O for channel '': Master command COM_REGISTER_SLAVE failed: Access denied for user 'repl'@'%' (using password: YES) (Errno: 1045), Error_code: 1597
        [ERROR] Slave I/O thread couldn't register on master
    ```
- 解决办法
    ```sql
        # 登陆主服务器,查询复制用户的权限
        mysql> show grants for 'repl'@'%';
        mysql> GRANT REPLICATION SLAVE ON *.* TO  'repl'@'%' identified by '自己用户的密码';
        mysql> show grants for 'repl'@'%';
        # 当权限显示为REPLICATION是方才正确
    ```

#### mysql文件太大
- 现象
    * mysql文件夹特别大,看了一下发现有个log就几十个g,如果它没用的话就把它删除并且关了
- 解决方法
    * error日志只记录数据库层的报错
    * binlog只记录增/删/改的记录,但是没记录谁执行,只记录执行用户名
    * slowlog虽然详细,但是只记录超过设定值的慢查询sql信息.
    * general-log才是记录所有的操作日志,不过他会耗费数据库5%-10%的性能,所以一般没什么特别需要,大多数情况是不开的,例如一些sql审计和不知名的排错等,那就是打开来使用了
    * 关闭方法
        ```sql
            #先查看当前状态
            mysql> show variables like 'general%';
            +------------------+--------------------------------+
            | Variable_name    | Value                          |
            +------------------+--------------------------------+
            | general_log      | OFF                            |
            | general_log_file | /data/mysql/data/localhost.log |
            +------------------+--------------------------------+
            2 rows in set (0.00 sec)
            #可以在my.cnf里添加,1开启(0关闭),当然了,这样要重启才能生效,有点多余了
            general-log = 1
            log = /log/mysql_query.log路径
            #也可以设置变量那样更改,1开启(0关闭),即时生效,不用重启,首选当然是这样的了
            set global general_log=1
            #这个日志对于操作频繁的库,产生的数据量会很快增长,出于对硬盘的保护,可以设置其他存放路径
            set global general_log_file=/tmp/general_log.log
        ```



