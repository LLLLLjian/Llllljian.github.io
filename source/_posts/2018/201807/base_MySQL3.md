---
title: MySQL_基础 (3)
date: 2018-07-11
tags: MySQL
toc: true
---

### 关于索引
    高性能MySQL学习笔记
    MySQL版本 5538

<!-- more -->

#### 索引是什么
    Index
    索引的本质 : 索引是数据结构
    索引是帮助MySQL高效获取数据的数据结构
    通俗的说,数据库索引好比是一本书前面的目录,能加快数据库的查询速度

#### 优势
- 类似大学图书馆建书目索引,提高数据检索效率,降低数据库的IO成本.
- 通过索引对数据进行排序,降低数据排序的成本,降低了CPU的消耗

#### 劣势
- 实际上索引也是一张表,该表保存了主键与索引字段,并指向实体表的记录,所以索引列也是要占空间的.
- 虽然索引大大提高了查询速度,同时确会降低更新表的速度,如对表进行INSERT、UPDATE、DELETE.因为更新表时,MySQL不仅要保存数据,还要保存一下索引文件每次更新添加了索引列的字段.都会调整因为更新所带来的键值变化后的索引信息. 

#### 索引的分类
- 普通索引
    * 最基本的索引
    * eg
        ```sql
            –直接创建索引
            CREATE INDEX index_name ON table(column(length))

            –修改表结构的方式添加索引
            ALTER TABLE table_name ADD INDEX index_name ON (column(length))

            –创建表的时候同时创建索引
            CREATE TABLE `table` (
            `id` int(11) NOT NULL AUTO_INCREMENT ,
            `title` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
            `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
            `time` int(10) NULL DEFAULT NULL ,
            PRIMARY KEY (`id`),
            INDEX index_name (title(length))
            )

            –删除索引
            DROP INDEX index_name ON table
        ```
- 唯一索引
    * 索引列的值必须唯一,但允许有空值
    * eg
        ```sql
            –创建唯一索引
            CREATE UNIQUE INDEX indexName ON table(column(length))

            –修改表结构
            ALTER TABLE table_name ADD UNIQUE indexName ON (column(length))

            –创建表的时候直接指定
            CREATE TABLE `table` (
            `id` int(11) NOT NULL AUTO_INCREMENT ,
            `title` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
            `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
            `time` int(10) NULL DEFAULT NULL ,
            PRIMARY KEY (`id`),
            UNIQUE indexName (title(length))
        ```
- 全文索引
    * 全文索引[FULLTEXT]仅可用于MyISAM引擎
    * eg
        ```sql
            –创建表的适合添加全文索引
            CREATE TABLE `table` (
            `id` int(11) NOT NULL AUTO_INCREMENT ,
            `title` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
            `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
            `time` int(10) NULL DEFAULT NULL ,
            PRIMARY KEY (`id`),
            FULLTEXT (content)
            );

            –修改表结构添加全文索引
            ALTER TABLE article ADD FULLTEXT index_content(content)
            
            –直接创建索引
            CREATE FULLTEXT INDEX index_content ON article(content)
        ```
- 单列索引、多列索引
- 组合索引(最左前缀)
    * 如果左边的值未确定,那么无法使用此索引
    * eg
        ```sql
            ALTER TABLE t3 ADD INDEX MultiIdx ('id', 'age', 'name');

            语句1
            select * from zimu where a = '1'  

            select * from zimu where a = '1' and b = '2'  

            select * from zimu where a = '1' and b = '2'  and c='3'

            语句2
            select * from zimu where c = '1' 

            select * from zimu where b =‘1’ and c ='2'

            select * from zimu where a = '1' and c= ‘2’

            select * from zimu where a = '1' and b > ‘2’  and c='3' 

            会用MultiIdx索引
            mysql> EXPLAIN SELECT * FROM t3 WHERE id = 1\G
            *************************** 1. row ***************************
                    id: 1
            select_type: SIMPLE
                    table: t3
                    type: ref
            possible_keys: MultiIdx
                    key: MultiIdx
                key_len: 4
                    ref: const
                    rows: 1
                    Extra: 
            1 row in set (0.00 sec)

            mysql> EXPLAIN SELECT * FROM t3 WHERE id = 1 AND age = 2\G
            *************************** 1. row ***************************
                    id: 1
            select_type: SIMPLE
                    table: t3
                    type: ref
            possible_keys: MultiIdx
                    key: MultiIdx
                key_len: 8
                    ref: const,const
                    rows: 1
                    Extra: 
            1 row in set (0.00 sec)

            mysql> EXPLAIN SELECT * FROM t3 WHERE id = 1 AND name = 'joe'\G
            *************************** 1. row ***************************
                    id: 1
            select_type: SIMPLE
                    table: t3
                    type: ref
            possible_keys: MultiIdx
                    key: MultiIdx
                key_len: 4
                    ref: const
                    rows: 1
                    Extra: Using where
            1 row in set (0.00 sec)

            mysql> EXPLAIN SELECT * FROM t3 WHERE id = 1 AND age = 2 AND name = 'joe'\G
            *************************** 1. row ***************************
                    id: 1
            select_type: SIMPLE
                    table: t3
                    type: ref
            possible_keys: MultiIdx
                    key: MultiIdx
                key_len: 68
                    ref: const,const,const
                    rows: 1
                    Extra: Using where
            1 row in set (0.00 sec)

            不会用到索引
            mysql> EXPLAIN SELECT * FROM t3 WHERE age = 2\G
            *************************** 1. row ***************************
                    id: 1
            select_type: SIMPLE
                    table: t3
                    type: ALL
            possible_keys: NULL
                    key: NULL
                key_len: NULL
                    ref: NULL
                    rows: 2
                    Extra: Using where
            1 row in set (0.00 sec)

            mysql> EXPLAIN SELECT * FROM t3 WHERE name = 'joe'\G
            *************************** 1. row ***************************
                    id: 1
            select_type: SIMPLE
                    table: t3
                    type: ALL
            possible_keys: NULL
                    key: NULL
                key_len: NULL
                    ref: NULL
                    rows: 2
                    Extra: Using where
            1 row in set (0.00 sec)
        ```
    * 注意最左前缀,并不是是指: 一定要按照各个字段出现在where中的顺序来建立复合索引的,这是对最左前缀极大的误解
    * 复合索引,哪个字段放在最前面,需要根据哪个字段经常出现在where条件中,哪个字段的选择性最好来判断的

#### MySQL索引结构
- BTree索引
    * mysql使用最频繁的一个索引数据结构
    * 是Inodb和Myisam存储引擎模式的索引类型
    * 查找单条记录的速度比不上Hash,但更适合排序等操作
    * B+Tree所有索引数据都在叶子节点上,并且增加了顺序访问指针,每个叶子节点都有指向相邻叶子节点的指针
    * 大大减少磁盘I/O读取
- Hash索引
    * 是Memory搜索引擎的默认索引类型
    * 将数据以hash的形式组织起来,速度很快,但不支持范围查找和排序等功能
- full-text全文索引
- R-Tree索引

#### 哪些情况需要创建索引
- 主键自动建立唯一索引
- 频繁作为查询条件的字段应该创建索引
- 查询中与其他表关联的字段,外键关系建立索引
- 频繁更新的字段不适合建立索引,因为每次更新不单单是更新了记录还会更新索引
- WHERE条件里用不到的字段不创建索引
- 单键/组合索引的选择问题,who?(在高并发下倾向创建组合索引)
- 查询中排序的字段,排序的字段若通过索引去访问将大大提高排序速度
- 查询中统计或者分组字段

#### 哪些情况不要创建索引
- 表记录太少
- 经常增删改的表,提高了查询速度,同时却会降低更新表的速度,如对表进行INSERT、UPDATE、和DELETE.因为更新表时,MySQL不仅要保存数据,还要保存一下索引文件.数据重复且分布平均的表字段,因此应该只为最经常查询和最经常排序的数据建立索引.
- 注意,如果某个数据列包含许多重复的内容,为它建立索引就没有太大的实际效果.

### MySQL常见引擎

#### 查看系统中支持的存储引擎类型
- SHOW ENGINES;
- sql
    ```sql
        mysql> SHOW ENGINES;
        +--------------------+---------+------------------------------------------------------------+--------------+------+------------+
        | Engine             | Support | Comment                                                    | Transactions | XA   | Savepoints |
        +--------------------+---------+------------------------------------------------------------+--------------+------+------------+
        | MyISAM             | YES     | MyISAM storage engine                                      | NO           | NO   | NO         |
        | InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys | YES          | YES  | YES        |
        | MRG_MYISAM         | YES     | Collection of identical MyISAM tables                      | NO           | NO   | NO         |
        | PERFORMANCE_SCHEMA | YES     | Performance Schema                                         | NO           | NO   | NO         |
        | CSV                | YES     | CSV storage engine                                         | NO           | NO   | NO         |
        | MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables  | NO           | NO   | NO         |
        +--------------------+---------+------------------------------------------------------------+--------------+------+------------+
        6 rows in set (0.00 sec)
    ```

#### 查看默认储存引擎
- show variables like '%storage_engine%';
- sql
    ```sql
        mysql> show variables like '%storage_engine%';
        +------------------------+--------+
        | Variable_name          | Value  |
        +------------------------+--------+
        | default_storage_engine | InnoDB |
        | storage_engine         | InnoDB |
        +------------------------+--------+
        2 rows in set (0.00 sec)
    ```

#### 修改默认储存引擎
- linux下为/etc/my.cnf),在mysqld后面增加default-storage-engine=INNODB即可.

#### MyISAM
    支持表级锁,不支持行级锁,不支持事务,不支持外检约束,支持全文索引,表空间文件相对小.
- 不支持事务
- BLOB和TEXT列可以被索引
- 读写比InnoDB快

#### Innodb
    支持表级锁,行级锁,支持事务,支持外检,不支持全文索引,表空间文件相对较大.
- 用于事务处理应用程序
- 提供行级锁

#### 搜索引擎的选择
- 如果要提供提交、回滚、崩溃恢复能力的事物安全(ACID兼容)能力,并要求实现并发控制,InnoDB是一个好的选择
- 如果数据表主要用来插入和查询记录,则MyISAM引擎能提供较高的处理效率