---
title: MySQL_基础 (63)
date: 2021-04-27
tags: MySQL
toc: true
---

### 更好的理解MySQL
    explain理解1.0

<!-- more -->

#### 故事背景
> 联合索引中判断所有的索引字段是否都被查询用到, 之前一直有点猜的意思, 今天学到了

#### key_len
- eg
    ```sql
        mysql> show create table test_key_len_user;
        +-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | Table             | Create Table                                                                                                                                                                                                                                                                                                                                                                           |
        +-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | test_key_len_user | CREATE TABLE `test_key_len_user` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `name` varchar(10) DEFAULT NULL,
        `age` tinyint(2) DEFAULT NULL,
        `sex` char(1) DEFAULT NULL,
        `create_time` datetime DEFAULT NULL,
        PRIMARY KEY (`id`) USING BTREE,
        KEY `idx_name` (`name`),
        KEY `idx_age` (`age`),
        KEY `idx_sex` (`sex`)
        ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 |
        +-------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        1 row in set (0.00 sec)

        mysql> INSERT INTO `test_key_len_user` (`id`, `name`, `age`, `sex`, `create_time`) VALUES (1, 'llllljian', '26', '1', NULL);
        Query OK, 1 row affected (0.01 sec)

        mysql> EXPLAIN select * FROM user WHERE id = 1; # id字段类型为int, 长度为4, id为主键, 不允许Null , key_len = 4
        +----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
        | id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
        +----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
        |  1 | SIMPLE      | user  | NULL       | const | PRIMARY       | PRIMARY | 4       | const |    1 |   100.00 | NULL  |
        +----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
        1 row in set, 1 warning (0.00 sec)

        EXPLAIN select * FROM test_key_len_user WHERE name = 'llllljian'; 

        mysql> EXPLAIN select * FROM test_key_len_user WHERE name = 'llllljian'; # name的字段类型是varchar(10), 允许Null, 字符编码是utf8, 一个字符占用3个字节, varchar为动态类型, key长度加2, key_len = 10 * 3 + 2 + 1 = 33
        +----+-------------+-------------------+------------+------+---------------+----------+---------+-------+------+----------+-------+
        | id | select_type | table             | partitions | type | possible_keys | key      | key_len | ref   | rows | filtered | Extra |
        +----+-------------+-------------------+------------+------+---------------+----------+---------+-------+------+----------+-------+
        |  1 | SIMPLE      | test_key_len_user | NULL       | ref  | idx_name      | idx_name | 33      | const |    1 |   100.00 | NULL  |
        +----+-------------+-------------------+------------+------+---------------+----------+---------+-------+------+----------+-------+
        1 row in set, 1 warning (0.00 sec)

        mysql> EXPLAIN select * FROM test_key_len_user WHERE age = 26; # age的字段类型是tinyint, 允许NULL, key_len = 1 + 1 = 2
        +----+-------------+-------------------+------------+------+---------------+---------+---------+-------+------+----------+-------+
        | id | select_type | table             | partitions | type | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
        +----+-------------+-------------------+------------+------+---------------+---------+---------+-------+------+----------+-------+
        |  1 | SIMPLE      | test_key_len_user | NULL       | ref  | idx_age       | idx_age | 2       | const |    1 |   100.00 | NULL  |
        +----+-------------+-------------------+------------+------+---------------+---------+---------+-------+------+----------+-------+
        1 row in set, 1 warning (0.00 sec)

        mysql> EXPLAIN select * FROM test_key_len_user WHERE sex = '1'; # sex的字段类型是char(1), 允许NULL, 字符编码是utf8, 一个字符占用3个字节, key_len = 3 + 1 = 4
        +----+-------------+-------------------+------------+------+---------------+---------+---------+-------+------+----------+-------+
        | id | select_type | table             | partitions | type | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
        +----+-------------+-------------------+------------+------+---------------+---------+---------+-------+------+----------+-------+
        |  1 | SIMPLE      | test_key_len_user | NULL       | ref  | idx_sex       | idx_sex | 4       | const |    1 |   100.00 | NULL  |
        +----+-------------+-------------------+------------+------+---------------+---------+---------+-------+------+----------+-------+
        1 row in set, 1 warning (0.00 sec)

        mysql> ALTER TABLE test_key_len_user DROP INDEX `idx_name`, DROP INDEX `idx_age`, DROP INDEX `idx_sex`;
        Query OK, 0 rows affected (0.05 sec)
        Records: 0  Duplicates: 0  Warnings: 0

        mysql> ALTER TABLE test_key_len_user ADD INDEX `idx_name_age`(`name`, `age`);
        Query OK, 0 rows affected (0.06 sec)
        Records: 0  Duplicates: 0  Warnings: 0

        mysql> EXPLAIN select * FROM test_key_len_user WHERE name = 'llllljian'; # 只用到了联合索引中的name key_len = 10 * 3 + 2 + 1 = 33
        +----+-------------+-------------------+------------+------+---------------+--------------+---------+-------+------+----------+-------+
        | id | select_type | table             | partitions | type | possible_keys | key          | key_len | ref   | rows | filtered | Extra |
        +----+-------------+-------------------+------------+------+---------------+--------------+---------+-------+------+----------+-------+
        |  1 | SIMPLE      | test_key_len_user | NULL       | ref  | idx_name_age  | idx_name_age | 33      | const |    1 |   100.00 | NULL  |
        +----+-------------+-------------------+------------+------+---------------+--------------+---------+-------+------+----------+-------+
        1 row in set, 1 warning (0.02 sec)

        mysql> EXPLAIN select * FROM test_key_len_user WHERE name = 'llllljian' and age = 26; # 都用到了, name + age = key_len = (33) + (2) = 35
        +----+-------------+-------------------+------------+------+---------------+--------------+---------+-------------+------+----------+-------+
        | id | select_type | table             | partitions | type | possible_keys | key          | key_len | ref         | rows | filtered | Extra |
        +----+-------------+-------------------+------------+------+---------------+--------------+---------+-------------+------+----------+-------+
        |  1 | SIMPLE      | test_key_len_user | NULL       | ref  | idx_name_age  | idx_name_age | 35      | const,const |    1 |   100.00 | NULL  |
        +----+-------------+-------------------+------------+------+---------------+--------------+---------+-------------+------+----------+-------+
        1 row in set, 1 warning (0.01 sec)
    ```
- 结论
    * key_len表示使用的索引长度, key_len可以衡量索引的好坏, key_len越小 索引效果越好
    * char和varchar是日常使用最多的字符类型.char(N)用于保存固定长度的字符串, 长度最大为255, 比指定长度大的值将被截短, 而比指定长度小的值将会用空格进行填补.
    * varchar(N)用于保存可以变长的字符串, 长度最大为65535, 只存储字符串实际实际需要的长度(它会增加一个额外字节来存储字符串本身的长度), varchar使用额外的1~2字节来存储值的的长度, 如果列的最大长度小于或者等于255, 则用1字节, 否则用2字节.
    * char和varchar跟字符编码也有密切的联系, latin1占用1个字节, gbk占用2个字节, utf8占用3个字节.(不同字符编码占用的存储空间不同
    * 常见的列类型长度计算
        * <table border="1" cellpadding="1" cellspacing="1"><tbody><tr><th>列类型</th><th>是否为空</th><th>长度</th><th>key_len</th><th>备注</th></tr><tr><td>tinyint</td><td>允许Null</td><td>1</td><td>key_len = 1+1</td><td>允许NULL, key_len长度加1</td></tr><tr><td>tinyint</td><td>不允许Null</td><td>1</td><td>key_len = 1</td><td>不允许NULL</td></tr><tr><td>int</td><td>允许Null</td><td>4</td><td>key_len = 4+1</td><td>允许NULL, key_len长度加1</td></tr><tr><td>int not null</td><td>不允许Null</td><td>4</td><td>key_len = 4</td><td>不允许NULL</td></tr><tr><td>bigint</td><td>允许Null</td><td>8</td><td>key_len = 8+1</td><td>允许NULL, key_len长度加1</td></tr><tr><td>bigint not null</td><td>不允许Null</td><td>8</td><td>key_len = 8</td><td>不允许NULL</td></tr><tr><td>char(1)</td><td>允许Null</td><td>utf8mb4=4,utf8=3,gbk=2</td><td>key_len = 1*3 + 1</td><td>允许NULL, 字符集utf8, key_len长度加1</td></tr><tr><td>char(1) not null</td><td>不允许Null</td><td>utf8mb4=4,utf8=3,gbk=2</td><td>key_len = 1*3</td><td>不允许NULL, 字符集utf8</td></tr><tr><td>varchar(10)&nbsp;</td><td>允许Null</td><td>utf8mb4=4,utf8=3,gbk=2</td><td>key_len = 10*3 + 2 + 1</td><td>动态列类型, key_len长度加2, 允许NULL, key_len长度加1</td></tr><tr><td>varchar(10) not null</td><td>不允许Null</td><td>utf8mb4=4,utf8=3,gbk=2</td><td>key_len = 10*3+ 2</td><td>动态列类型, key_len长度加2</td></tr></tbody></table>


