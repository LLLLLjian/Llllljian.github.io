---
title: MySQL_基础 (84)
date: 2021-11-12
tags: MySQL
toc: true
---

### 更好的理解MySQL
    Mysql主从报错记录

<!-- more -->

#### 前情提要
> mysql主从搞好了 但是因为是代码层面实现的读写分离,主写从读,因为一部分原因导致主从同步失败了,数据不同步了,有问题就得解决呀

#### 场景1
- Q
    ```sql
        mysql> show slave status\G
        ...
        Slave_IO_Running: No
        Slave_SQL_Running: Yes
        ...
        Last_IO_Errno: 1236
        Last_IO_Error: Got fatal error 1236 from master when reading data from binary log: 'Could not open log file'
    ```
- A
    * 读不到bin log了,需要重新刷一下主从同步状态
    ```sql
        # master
        mysql> flush logs;
        Query OK, 0 rows affected (0.02 sec)

        mysql> show master status;
        # 记住file和position这两个选项

        # slave
        mysql> stop slave;
        Query OK, 0 rows affected (0.01 sec)

        mysql> change master to master_log_file ='xxxxxx',master_log_pos=xxxx;
        Query OK, 0 rows affected (0.01 sec)

        mysql> start slave;
        Query OK, 0 rows affected (0.00 sec)
    ```

#### 场景2
- Q
    * 记录删除失败: 在master上删除一条记录,而slave上找不到
    ```sql
        Last_SQL_Error: Could not execute Delete_rows event on table hcy.t1; 
        Can't find record in 't1', 
        Error_code: 1032; handler error HA_ERR_KEY_NOT_FOUND; 
        the event's master log mysql-bin.000006, end_log_pos 254
    ```
- A
    ```sql
        # master要删除一条记录,而slave上找不到报错,这种情况主都已经删除了,那么从机可以直接跳过
        stop slave;
        set global sql_slave_skip_counter=1;
        start slave;
    ```

#### 场景3
- Q
    * 主键重复: 在slave已经有该记录,又在master上插入了同一条记录
    ```sql
        Last_SQL_Error: Could not execute Write_rows event on table hcy.t1; 
        Duplicate entry '2' for key 'PRIMARY', 
        Error_code: 1062; 
        handler error HA_ERR_FOUND_DUPP_KEY; the event's master log mysql-bin.000006, end_log_pos 924
    ```
- A
    ```sql
        # 删除从库上重复的记录
        mysql> delete from t1 where id=2;
        Query OK, 1 row affected (0.00 sec)

        mysql> start slave;
        Query OK, 0 rows affected (0.00 sec)

        mysql> show slave status\G;
        ……
        Slave_IO_Running: Yes
        Slave_SQL_Running: Yes
        ……
        mysql> select * from t1 where id=2;
    ```

#### 场景4
- Q
    * 更新丢失: 在master上更新一条记录,而slave上找不到,丢失了数据
    ```sql
        Last_SQL_Error: Could not execute Update_rows event on table hcy.t1; 
        Can't find record in 't1', 
        Error_code: 1032; 
        handler error HA_ERR_KEY_NOT_FOUND; 
        the event's master log mysql-bin.000010, end_log_pos 794
    ```
- A
    ```sql
        # 找到要更新的那条数据并新增到从库
        mysqlbinlog --no-defaults -v -v --base64-output=DECODE-ROWS mysql-bin.000010 | grep -A '10' 794

        # master
        select * from table where id = 2;

        # slave
        insert into table values (2, xx, xx);
    ```

