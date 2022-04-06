---
title: MySQL_基础 (34)
date: 2020-01-09
tags: MySQL
toc: true
---

### 书写高质量SQL的30条建议
    优化SQL系列

<!-- more -->

#### 优化建议-SELECT
> 查询SQL尽量不要使用select *, 而是select具体字段.
- 反例
    ```sql 
        select * from employee;
    ```
- 正例
    ```sql
        select id, name from employee;
    ```
- 理由
    * 只取需要的字段, 节省资源、减少网络开销.select * 进行查询时, 很可能就不会使用到覆盖索引了, 就会造成回表查询.

#### 优化建议-SELECT
> 如果知道查询结果只有一条或者只要最大/最小一条记录, 建议用limit 1
- 反例
    ```sql
        select id, name from employee  where name = 'jay'
    ```
- 正例
    ```sql
        select id, name from employee  where name = 'jay' limit 1
    ```
- 理由: 
    * 加上limit 1后,只要找到了对应的一条记录,就不会继续向下扫描了,效率将会大大提高

#### 优化建议-SELECT
> 应尽量避免在where子句中使用or来连接条件
- 反例
    ```sql
        select * from user where userid = 1 or age = 18
    ```
- 正例
    ```sql
        select * from user where userid = 1 
        UNION ALL
        select * from user where age = 18

        select * from user where userid = 1
        select * from user where age = 18
    ```
- 理由
    * 使用or可能会使索引失效, 从而全表扫描.对于or+没有索引的age这种情况, 假设它走了userId的索引, 但是走到age查询条件时, 它还得全表扫描, 也就是需要三步过程: 全表扫描+索引扫描+合并

#### 优化建议-SELECT
> 优化limit分页
- 反例
    ```sql
        select id, name, age from employee limit 10000, 10
    ```
- 正例
    ```sql
        //方案一 : 返回上次查询的最大记录(偏移量)
        select id, name from employee where id > 10000 limit 10.

        //方案二: order by + 索引
        select id, name from employee order by id  limit 10000, 10
        //方案三: 在业务允许的情况下限制页数: 
    ```
- 理由
    * 当偏移量最大的时候, 查询效率就会越低, 因为Mysql并非是跳过偏移量直接去取后面的数据, 而是先把偏移量+要取的条数, 然后再把前面偏移量这一段的数据抛弃掉再返回的.
    * 如果使用优化方案一, 返回上次最大查询记录(偏移量), 这样可以跳过偏移量, 效率提升不少.
    * 方案二使用order by+索引, 也是可以提高查询效率的.
    * 方案三的话, 建议跟业务讨论, 有没有必要查这么后的分页啦.因为绝大多数用户都不会往后翻太多页.

#### 优化建议-SELECT
> 优化你的like语句
- 反例
    ```sql
        select userId, name from user where userId like '%123';
    ```
- 正例
    ```sql
        select userId, name from user where userId like '123%';
    ```
- 理由
    * 把%放前面, 并不走索引

#### 优化建议-SELECT
> 使用where条件限定要查询的数据, 避免返回多余的行
- 业务要求
    * 查询某个用户是否是会员
- 反例
    ```sql
        select userId from user where isVip=1
    ```
- 正例
    ```sql
        select userId from user where userId='userId' and isVip='1'
    ```
- 理由
    * 需要什么数据, 就去查什么数据, 避免返回不必要的数据, 节省开销.

#### 优化建议-SELECT
> 尽量避免在索引列上使用mysql的内置函数
- 业务需求
    * 查询最近七天内登陆过的用户(假设loginTime加了索引)
- 反例
    ```sql
        select userId,loginTime from loginuser where Date_ADD(loginTime,Interval 7 DAY) >=now();
    ```
- 正例
    ```sql
        select userId,loginTime from loginuser where  loginTime >= Date_ADD(NOW(),INTERVAL - 7 DAY);
    ```
- 理由
    * 索引列上使用mysql的内置函数, 索引失效

#### 优化建议-SELECT
> 应尽量避免在where子句中对字段进行表达式操作, 这将导致系统放弃使用索引而进行全表扫
- 反例
    ```sql
        select * from user where age-1 =10；
    ```
- 正例
    ```sql
        select * from user where age =11；
    ```
- 理由
    * 虽然age加了索引, 但是因为对它进行运算, 索引失效

#### 优化建议-SELECT
> Inner join 、left join、right join, 优先使用Inner join, 如果是left join, 左边表结果尽量小
- 原理
    * Inner join 内连接, 在两张表进行连接查询时, 只保留两张表中完全匹配的结果集
    * left join 在两张表进行连接查询时, 会返回左表所有的行, 即使在右表中没有匹配的记录.
    * right join 在两张表进行连接查询时, 会返回右表所有的行, 即使在左表中没有匹配的记录.
- 理由
    * 如果inner join是等值连接, 或许返回的行数比较少, 所以性能相对会好一点.
    * 使用了左连接, 左边表数据结果尽量小, 条件尽量放到左边处理, 意味着返回的行数可能比较少

#### 优化建议-SELECT
> 应尽量避免在where子句中使用!=或<>操作符, 否则将引擎放弃使用索引而进行全表扫描

#### 优化建议-SELECT
> 对查询进行优化, 应考虑在where及order by涉及的列上建立索引, 尽量避免全表扫描

#### 优化建议-SELECT
> 使用联合索引时, 注意索引列的顺序, 一般遵循最左匹配原则
- 理由
    * 当我们创建一个联合索引的时候, 如(k1,k2,k3), 相当于创建了(k1)、(k1,k2)和(k1,k2,k3)三个索引, 这就是最左匹配原则.

#### 优化建议-SELECT
> 慎用distinct关键字
- 理由
    * 带distinct的语句cpu时间和占用时间都高于不带distinct的语句.因为当查询很多字段时, 如果使用distinct, 数据库引擎就会对数据进行比较, 过滤掉重复数据, 然而这个比较、过滤的过程会占用系统资源, cpu时间.

#### 优化建议-SELECT
> 如果字段类型是字符串, where的时候一定用引号括起来, 否则索引失效
- 理由
    * 因为不加单引号时, 是字符串跟数字的比较, 它们类型不匹配, MySQL会做隐式的类型转换, 把它们转换为浮点数再做比较

#### 优化建议-INDEX
> 删除冗余和重复索引
- 理由
    * 重复的索引需要维护, 并且优化器在优化查询的时候也需要逐个地进行考虑, 这会影响性能的

#### 优化建议-INSERT
> 如果插入数据过多, 考虑批量插入

#### 优化建议-CREATE
> 尽量使用数字型字段, 若只含数值信息的字段尽量不要设计为字符型




