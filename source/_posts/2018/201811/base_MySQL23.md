---
title: MySQL_基础 (23)
date: 2018-11-13
tags: MySQL
toc: true
---

### 视图
    突然觉得应该系统地再去学一遍MySQL,从零开始.

<!-- more -->

#### 视图简介
- 简介
    * 视图是由SELECT查询语句所定义的一个虚拟表,是查看数据的一种非常有效的方式.视图包含一系列带有名称的数据列和数据行,但视图中的数据并不真实存在于数据库中,视图返回的是结果集
- 目的
    * 实现安全.视图可设置用户对视图的访问权限
    * 隐藏数据复杂性
- 优点
    * 视图能简化用户操作
    * 视图使用户能以多种角度看待同一数据
    * 视图对重构数据库提供了一定程度的逻辑独立性
    * 视图能够对机密数据提供安全保护
    * 适当的利用视图可以更清晰地表达查询

#### 创建视图
    ```sql
        CREATE VIEW viewname(列1,列2...)
        AS SELECT (列1,列2...)
        FROM ...;

        // 创建学生信息的视图
        create view studentview
        as select studentID, sname, sex from TStudent;
    ```

#### 操作视图
- 视图的使用
    ```sql
        // 和普通表是一样的
        select * from studentview;
    ```
- 删除视图
    ```sql
        drop view studentview
    ```
- 通过视图修改数据
    * 通过视图插入数据到表
        ```sql
            // 要求视图中的没有的列允许为空
            insert into studentview(studentID, sname, sex)VALUES('01001', '孙悟空', '男');
        ```
    * 通过视图删除表中记录
        ```sql
            // 视图的基表只能有一张表,如果有多张表,将不知道从哪一张表删除
            delete from studentview where studentid='01001';
        ```
    * 通过视图修改表中记录
        ```sql
            // 只能修改视图中有的列.
            update studentview set sname='孙悟空' where studentid='00001';
        ```
- 查看视图的信息
    * 查看视图的信息
        ```sql
            describe viewname;
            desc scoreview;
        ```
    * 查看所有的表和视图
        ```sql
            show tables;
        ```
    * 查看视图的信息
        ```sql
            show fields from scoreview;
        ```
- 修改视图
    ```sql
        CREATE OR REPLACE VIEW viewname AS SELECT [...] FROM [...];

        alter view studentview 
        as select studentID as 学号, sname as 姓名, sex as 性别 from TStudent;
    ```


