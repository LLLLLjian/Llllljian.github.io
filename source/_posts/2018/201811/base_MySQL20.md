---
title: MySQL_基础 (20)
date: 2018-11-08
tags: MySQL
toc: true
---

### SQL增删改
    突然觉得应该系统地再去学一遍MySQL,从零开始.

<!-- more -->

#### 插入数据
- 为表的所有字段插入数据
    * INSERT INTO table_name (column_list) VALUES (value_list);
- 为表的指定字段插入数据
- 同时插入多条记录
    * INSERT INTO table_name (column_list) VALUES (value_list1),  (value_list2),..., (value_listn);

#### 更新数据
- 根据本表的条件更改记录
    * UPDATE table_name SET column_name1 = value1, column_name2=value2,……, column_namen=valuen WHERE (condition);
- 根据另一张表的条件更改记录
    * UPDATE table_nameA a join table_nameB b on a. column_name1=b. column_name1 SET a.column_name1 = value1, a.column_name2=value2,……, a.column_namen=valuen WHERE b. column_name2>20

#### 删除数据
- 根据本表的条件删除记录
    * DELETE FROM table_name [WHERE condition&gt;] ;
- 根据另一张表的条件删除记录
    * DELETE a FROM table_a a join table_b b on a.column1=b.column1 [WHERE condition&gt;] ;

