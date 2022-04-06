---
title: MySQL_基础 (73)
date: 2021-05-13
tags: MySQL
toc: true
---

### 更好的理解MySQL
    MySQL实战45讲

<!-- more -->

#### 故事背景
> 今天在b站学习mysql的时候 突然觉得b站的学习氛围不是很好了呀, 都是随便讲的, 都是想吃互联网第二波饭的人, 两个小时的视频里有一个多小时是在卖课,  在给人洗脑, 然后我就找呀找, 最后找到了【MySQL实战45讲】, 看过的人都说好, 我也来看看吧, 学一学

#### 18为什么这些SQL语句逻辑相同, 性能却差异巨大？

##### 条件字段函数操作

如果对字段做了函数计算, 就用不上索引了.原因: 对索引字段做函数操作, 可能会破坏索引值的有序性, 因此优化器就决定放弃走树搜索功能. 优化器会选择遍历索引(主键索引或字段索引, 取决于索引大小).

要想使用到索引的快速定位能力, 就要把字段的函数操作改为范围查询.比如下面两个: 

- eg1
    ```sql
        SELECT count(*) FROM log WHERE month(update_date) = 7;

        SELECT count(*) FROM log WHERE (update_date >= "2021-7-1" AND update_date < "2021-8-1") OR (update_date >= "2020-7-1" AND update_date < "2020-8-1")
    ```
- eg2
    ```sql
        SELECT * FROM log WHERE id + 1 = 10000

        SELECT * FROM log WHERE id = 9999
    ```


##### 隐式类型转换

在mysql查询语句中, 如果作为条件的值类型与字段类型不一样时, 可能会存在类型转换, 比如vachar类型和整数.在mysql中, 字符串和数字比较的话, 是将字符串转换成数字.如果varchar类型的字段转换成数字的话, 将会用到函数, 从而就用不上索引, 将全表扫描.


##### 隐式字符编码转换

当两个表的字符集不同时(例如utf8、utf8mb4), 做表关联查询的时候用不上关联字段的索引.原因: 当两个字符集不同时, MySQL就会先做类型转换, 再进行比较.转换规则是“按数据长度增加的方向”进行转换, 类似于程序设计语言中的自动类型转换.如果是被驱动表里的字段做转换, 就会用到函数操作, 因此该字段的索引将无法使用, 优化器会放弃走树搜索功能.由此可以得出导致被驱动表做全表扫描的直接原因是: **连接过程中要求在被驱动表的索引字段上加函数操作.**

优化方案: 

1. 改变表的编码, 两个表统一编码, 就不会存在字符编码转换了.这需要DDL操作, 如果数据量大或业务上暂时不允许则要改变SQL语句了
2. 改变SQL语句, 主动把驱动表的关联字段改变编码和被驱动表一样.


例如: 

    alter table trade_detail modify tradeid varchar(32) CHARACTER SET utf8mb4 default null;

    select d.* from tradelog l, trade_detail d where d.tradeid=CONVERT(l.tradeid USING utf8) and l.id=2;


##### 总结: 

对索引字段做函数操作, 可能会破坏索引值的有序性, 因此优化器就决定放弃走树搜索功能.

#### 19为什么我只查一行的语句, 也执行这么慢？

##### 第一类: 查询长时间不返回

碰到这种情况大概率表被锁住了.可以使用 show processlist 命令, 查看当前语句处于什么状态, 然后根据不同的状态, 用不同的方法处理.

##### 等MDL锁

如果语句对应的状态是 Waiting for table metadata lock, 那么表示的是, 现在有一个线程正在表t上请求或者持有MDL写锁, 把select语句堵住了.

![show processlist](/img/20210513_1.png)

这类问题的处理方式, 就是kill掉持有MDL写锁的线程.


##### 等 flush

![show processlist](/img/20210513_2.png)

当状态是 waiting for table flush 时, 表示一个线程正要对表t做flush操作, flush操作通常很快.而这个flush table命令被别的语句堵住了, flush命令又堵住了select语句.


##### 等行锁

通过下面语句查询阻塞线程, 然后通过kill线程号, 杀死线程.

    mysql> select * from t sys.innodb_lock_waits where locked_table=`'test'.'t'`\G



### 第二类 慢查询

session B 更新完100万次, 会生成100万个回滚日志(undo log). session A 第一个select是一致性读, 会依次执行 undo log, 执行了100万次以后, 才将1结果返回. session A第二个select查询是当前读, 因此会直接得出1000001 结果.


