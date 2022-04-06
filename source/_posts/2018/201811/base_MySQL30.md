---
title: MySQL_基础 (30)
date: 2018-11-28
tags: MySQL
toc: true
---

### EXPLAIN执行计划
    今天关联表查询的时候想检查一下SQL性能,于是先用了EXPLAIN,返回的结果Extra中为Impossible WHERE noticed after reading const tables

<!-- more -->

#### 解释
    字面上的意思是: 读取const tables表之后, 没有发现匹配的行

#### 情景再现
- 创建表
    ```sql
        CREATE TABLE `class` (
        `id` int(11) NOT NULL,
        `name` varchar(100) DEFAULT NULL,
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

        INSERT INTO `class` VALUES ('1', '计算机1班');
        INSERT INTO `class` VALUES ('2', '计算机2班');
        INSERT INTO `class` VALUES ('3', '计算机3班');

        CREATE TABLE `student` (
        `id` int(11) NOT NULL,
        `name` varchar(100) DEFAULT NULL,
        `class_id` int(11) DEFAULT NULL,
        PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

        INSERT INTO `student` VALUES ('1', '张三', '1');
        INSERT INTO `student` VALUES ('2', '李四', '2');
        INSERT INTO `student` VALUES ('3', '王五', '3');
    ```
- 执行语句
    ```sql
        EXPLAIN
        SELECT a.*, b.*
        FROM class a, student b
        WHERE b.id=99 AND a.id = b.class_id

        id	select_type	table	partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
        1	SIMPLE										                                                no matching row in const table
    ```


