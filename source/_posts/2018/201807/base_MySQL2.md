---
title: MySQL_基础 (2)
date: 2018-07-10
tags: MySQL
toc: true
---
    
### MySQL数据类型
    高性能MySQL学习笔记
    MySQL版本 5538

<!-- more -->

#### 整数类型
- TINYINT
    * 说明
        * 很小的整数
    * 储存需求
        * 1个字节
    * 有符号
        * -128 ~ 127
        * -2^7 ~ 2^7 - 1
    * 无符号
        * 0 ~ 255
        * 0 ~ 2^8 - 1
- SMALLINT
    * 说明
        * 小的整数
    * 储存需求
        * 2个字节
    * 有符号
        * -32768 ~ 32767
        * -2^15 ~ 2^15 - 1
    * 无符号
        * 0 ~ 65535
        * 0 ~ 2^16 - 1
- MEDIUMINT
    * 说明
        * 中等大小的整数
    * 储存需求
        * 3个字节
    * 有符号
        * -8388608 ~ 8388607
        * -2^23 ~ 2^23  -1 
    * 无符号
        * 0 ~ 16777215
        * 0 ~ 2^24 - 1
- INT
    * 说明
        * 普通大小的整数
    * 储存需求
        * 4个字节
    * 有符号
        * -2147483648 ~ 2147483647
        * -2^31 ~ 2^31 - 1
    * 无符号
        * 0 ~ 4294967295
        * 0 ~ 2^32 - 1
- BIGINT
    * 说明
        * 小的整数
    * 储存需求
        * 8个字节
    * 有符号
        * -2^63 ~ 2^63 - 1
    * 无符号
        * 0 ~ 2^64 - 1
- 注意
    ```sql
        mysql> CREATE TABLE aaa(id INT(10) PRIMARY KEY,age INT(6)); 
        Query OK, 0 rows affected (0.06 sec)

        mysql> show tables;
        +----------------+
        | Tables_in_test |
        +----------------+
        | aaa            |
        | test           |
        +----------------+
        2 rows in set (0.00 sec)

        mysql> INSERT INTO aaa VALUES (1, 5555),(2, 66666666);
        Query OK, 2 rows affected (0.05 sec)
        Records: 2  Duplicates: 0  Warnings: 0

        mysql> SELECT * 
            -> FROM aaa;
        +----+----------+
        | id | age      |
        +----+----------+
        |  1 |     5555 |
        |  2 | 66666666 |
        +----+----------+
        2 rows in set (0.00 sec)

        INT(10)、INT(6) 括号中的数字表示的是该数据类型指定的显示宽度,指定能够显示的数值中数字的个数
        显示宽度和数据类型的取值范围是无关的,显示宽度只是指明MySQL最大可能显示的数字个数
    ```

#### 浮点数类型
- FLOAT(M, D)
    * 说明
        * 单精度浮点数
    * 存储需求
        * 4个字节
- DOUBLE(M, D)
    * 说明
        * 双精度浮点数
    * 存储需求
        * 8个字节

#### 定点小数
- DECIMAL(M, D)
    * 说明
        * 压缩的“严格”定点数
    * 存储需求
        * M + 2个字节
    * M : 数值的总位数
    * D : 小数点后保留几位

#### 关于浮点数和定点数的使用
- eg
    ```sql
        mysql> CREATE TABLE tmp(
            -> x FLOAT(3,1),
            -> y DOUBLE(5,3),
            -> z DECIMAL(5,4)
            -> );
        Query OK, 0 rows affected (0.07 sec)

        mysql> INSERT INTO
            -> tmp VALUES
            -> (5.69, 1.2345, 1.1),
            -> (56.78, 1.1, 1.2345),
            -> (5.438, 1.6789, 1.56789),
            -> (1, 1, 1),
            -> (1234, 1234, 1234);
        Query OK, 3 rows affected, 1 warning (0.06 sec)
        Records: 3  Duplicates: 0  Warnings: 1

        mysql> SELECT *
            -> FROM tmp;
        +------+--------+--------+
        | x    | y      | z      |
        +------+--------+--------+
        |  5.7 |  1.234 | 1.1000 |
        | 56.8 |  1.100 | 1.2345 |
        |  5.4 |  1.679 | 1.5679 |
        |  1.0 |  1.000 | 1.0000 |
        | 99.9 | 99.999 | 9.9999 |
        +------+--------+--------+
        3 rows in set (0.00 sec)

        x的M为3,D为1,小数点上必须是占了一位数字,就算没有值,也会用0来填充,超过就四舍五入

        y字段上的值,整数部分最多是2位,小数点后的位数最多是3位,不够补0,超过四舍五入

        z字段上的值,整数部分最多只能是一位,小数点后的位数最多是4位,不够补0,超过四舍五入
    ```
- 三者区别
    * DECIMAL使用的时候要指定精度
        * FLOAT和DOUBLE在不指定精度时,也就是不用(M,D),默认会按照实际的精度,也就是你写多少就是多少,而DECIMAL如不指定精度默认为(10,0)
    * 在长度一定的情况下,浮点数能够表示更大的数据范围,但是缺点是会引起精度问题.
    * 一般货币、科学数据使用DECIMAL

#### 日期/时间类型
- YEAR
    * 日期格式
        * YYYY
    * 日期范围
        * 1901 ~ 2155
    * 存储需求
        * 1字节
    * eg
        ```sql
            mysql> CREATE TABLE tmp(
                -> y YEAR
                -> );
            Query OK, 0 rows affected (0.06 sec)

            mysql> INSERT INTO 
                -> tmp VALUES
                -> (2018),
                -> ('2018'),
                -> ("2018");
            Query OK, 3 rows affected (0.05 sec)
            Records: 3  Duplicates: 0  Warnings: 0

            mysql> SELECT * 
                -> FROM tmp;
            +------+
            | y    |
            +------+
            | 2018 |
            | 2018 |
            | 2018 |
            +------+
            3 rows in set (0.00 sec)

            mysql> INSERT INTO 
                -> tmp VALUES
                -> (1800),
                -> (2800);
            Query OK, 2 rows affected, 2 warnings (0.05 sec)
            Records: 2  Duplicates: 0  Warnings: 2

            mysql> SELECT *  FROM tmp;
            +------+
            | y    |
            +------+
            | 2018 |
            | 2018 |
            | 2018 |
            | 0000 |
            | 0000 |
            +------+
            5 rows in set (0.00 sec)

            mysql> INSERT INTO tmp VALUES('0'),('00'),('77'),('10');
            Query OK, 4 rows affected (0.05 sec)
            Records: 4  Duplicates: 0  Warnings: 0

            mysql> INSERT INTO tmp VALUES(0),(00),(77),(11);
            Query OK, 4 rows affected (0.06 sec)
            Records: 4  Duplicates: 0  Warnings: 0

            mysql> SELECT *  FROM tmp;
            +------+
            | y    |
            +------+
            | 2000 |
            | 2000 |
            | 1977 |
            | 2010 |
            | 0000 |
            | 0000 |
            | 1977 |
            | 2011 |
            +------+
            8 rows in set (0.00 sec)

            如果是字符0或字符00,则在数据库中会生成2000,如果是数字0或00,则会生成0000. 
            
            在不超过70,也就是小于70,度会生成2000年以上,也就是如果是69,则生成2069.如果是70以上包含70,就会变成1970以上

            不在1901 2155这个范围内 插入会有一个警告错误,插入结果为0000
        ```
- TIME
    * 日期格式
        * HH:MM:SS
        * HH表示小时 、MM表示分钟、SS表示秒
    * 日期范围
        * -838:59:59 ~ 838:59:59
    * 存储需求
        * 3字节
    * eg
        ```sql
            mysql> CREATE TABLE tmp(
                -> t TIME
                -> );
            Query OK, 0 rows affected (0.06 sec)

            mysql> INSERT INTO 
                -> tmp VALUES
                -> ("10:05:05"),
                -> ("23:23"),
                -> ("2 10:10"),
                -> ("3 02"),
                -> ("10"),
                -> ("101112"),
                -> (CURRENT_TIME),
                -> (NOW());
            Query OK, 8 rows affected (0.05 sec)
            Records: 8  Duplicates: 0  Warnings: 0

            mysql> SELECT * 
                -> FROM tmp;
            +----------+
            | t        |
            +----------+
            | 10:05:05 |
            | 23:23:00 |
            | 58:10:00 |
            | 74:00:00 |
            | 00:00:10 |
            | 10:11:12 |
            | 13:55:35 |
            | 13:55:35 |
            +----------+
            8 rows in set (0.00 sec)
        ```
- DATE
    * 日期格式
        * YYYY-MM-DD
    * 日期范围
        * 1000-01-01 ~ 9999-12-3
    * 存储需求
        * 3字节
    * eg
        ```sql
            mysql> CREATE TABLE tmp(
                -> d DATE
                -> );
            Query OK, 0 rows affected (0.06 sec)

            mysql> INSERT INTO 
                -> tmp VALUES
                -> ("1998-08-08"),
                -> ("98.11.23"),
                -> (19980808),
                -> (100511),
                -> (CURRENT_DATE),
                -> (NOW());
            Query OK, 6 rows affected, 1 warning (0.05 sec)
            Records: 6  Duplicates: 0  Warnings: 1

            mysql> SELECT * 
                -> FROM tmp;
            +------------+
            | d          |
            +------------+
            | 1998-08-08 |
            | 1998-11-23 |
            | 1998-08-08 |
            | 2010-05-11 |
            | 2018-07-10 |
            | 2018-07-10 |
            +------------+
            6 rows in set (0.00 sec)

            任何标点符号度可以当用日期部分之间的间隔符
        ```
- DATETIME
    * 日期格式
        * YYYY-MM-DD HH:MM:SS
    * 日期范围
        * 1000-01-01 00:00:00 ~ 9999-12-31 23:59:59
    * 存储需求
        * 8字节
    * eg
        ```sql
            mysql> CREATE TABLE tmp(
                -> dt DATETIME
                -> );
            Query OK, 0 rows affected (0.05 sec)

            mysql> INSERT INTO 
                -> tmp VALUES
                -> ("1998-08-08 08-08-08"),
                -> (980808080808),
                -> (CURRENT_DATE()),
                -> (NOW());
            Query OK, 4 rows affected (0.05 sec)
            Records: 4  Duplicates: 0  Warnings: 0

            mysql> SELECT * 
                -> FROM tmp;
            +---------------------+
            | dt                  |
            +---------------------+
            | 1998-08-08 08:08:08 |
            | 1998-08-08 08:08:08 |
            | 2018-07-12 00:00:00 |
            | 2018-07-12 14:01:05 |
            +---------------------+
            4 rows in set (0.00 sec)
        ```
- TIMESTAMP
    * 日期格式
        * YYYY-MM-DD HH:MM:SS
    * 日期范围
        * 1970-01-01 00:00:01 UTC ~ 2038-01-19 03:14:07 UTC
    * 存储需求
        * 4字节
    * 与DATETIME区别
        * 会根据当前时区的不同,显示的时间值不同

#### 字符串类型
- CHAR(M)
    * 说明
        * 固定长度非二进制字符串
    * 固定长度的意思就是M的值为多少,那么该M的值就是其实际存储空间的值,就算插入的数据少于M位,其存储空间还是那么大,多余的用空格补齐.在输出时,空格将被删除不输出.M最大为255
    * M为多大,就最多能插入多少字符,超过了M,就会报错
- VARCHAR(M)
    * 说明
        * 变长非二进制字符串
    * 根据实际的大小值来确定存储空间的大小
    * M为多大,就最多能插入多少字符,超过了M,就会报错
- TEXT
    * 说明
        * 小的非二进制字符串
        * 最多为65535字符
- ENUM
    * 说明
        * 枚举类型,只能有一个枚举字符串值
    * 最多为65535
    * 使用索引值,也可以选择枚举中得值,从1开始
- SET
    * 说明
        * 一个设置,字符串对象可以有零个或多个set成员
    * 插入SET字段中的值如果有重复,则会自动删除重复的值
    * 插入SET字段中的值会按顺序排列,排列规则就是按照SET中的值的排列优先顺序
    * 如果插入了不属于SET中的值,就会报错

#### 二进制类型
- BIT
    * 说明 : 位字段类型
- BINARY
    * 说明 : 固定长度二进制字符串
- VARBINARY
    * 说明 : 可变长度二进制字符串
- BLOB
    * 说明 : 二进制大对象,一般存图像、音频文件