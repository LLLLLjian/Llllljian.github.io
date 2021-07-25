---
title: MySQL_基础 (75)
date: 2021-05-17
tags: MySQL
toc: true
---

### 更好的理解MySQL
    MySQL实战45讲

<!-- more -->

#### 故事背景
> 今天在b站学习mysql的时候 突然觉得b站的学习氛围不是很好了呀, 都是随便讲的, 都是想吃互联网第二波饭的人, 两个小时的视频里有一个多小时是在卖课,  在给人洗脑, 然后我就找呀找, 最后找到了【MySQL实战45讲】, 看过的人都说好, 我也来看看吧, 学一学

#### 22MySQL有哪些“饮鸩止渴”提高性能的方法？

##### 短连接风暴

正常的短连接模式就是连接到数据库后, 执行很少的SQL语句就断开, 下次需要的时候再重连.如果使用的是短连接, 在业务高峰期时, 就可能出现连接数突然暴涨的情况.

max_connections 参数, 用来控制一个MySQL实例同时存在的连接数上限, 超过这个值系统会拒绝接下来的连接请求, 并报错提示“Too many connections”.

碰到超过连接池上限的情况, 调高 max_connections 参数并不太可取.因为max_connections 值太大, 就会有更多的连接进来, 系统的负载可能会进一步加大, 大量的资源耗费在权限验证等逻辑上, 已经连接的线程拿不到CPU资源去执行业务的SQL请求.下面有两种有损的方案推荐给你.


###### 第一种方法：先处理掉那些占着连接但是不工作的线程.

通过 kill connection + id 主动剔除线程空闲的连接.这个行为跟事先设置 wait_timeout 的效果是一样的.wait_timeout参数表示线程空闲 wait_timeout 多秒之后, 就会被MySQL直接断开连接.

如果连接数过多, 你可以优先断开事务外空闲太久的连接；如果这样还不够, 再考虑断开事务内空闲太久的连接.因为如果断开事务内的连接, 就会造成MySQL事务回滚, 对业务是有影响的.

我们可以通过 show processlist 查看那些线程处于 sleep(空闲) 状态, 然后通过查 information_schema 库的 innodb_trx表, 找出trx_mysql_thread_id的值, 表示值为该id的线程是处于事务内的.

    mysql> show processlist;
    
    mysql> select * from information_schema.innodb_trx\G;


从数据库端主动断开连接可能是有损的, 尤其是有点应用端收到错误后, 不重新连接, 而是直接使用这个已经不能用的句柄重试查询.这会导致应用端看上去, “MySQL一直没恢复”.

###### 第二种方法：减少连接过程的消耗

让数据库跳过权限验证阶段.跳过权限验证的方法是：重启数据库, 并使用 skip-grant-tables 参数启动.这样, 整个MySQL会跳过所有的权限验证阶段, 包括连接过程和语句执行过程.

但这样做的风险极高, 不建议使用该方案.特别是数据库可以外网访问的话.


##### 慢查询性能问题

在mysql中, 会引发性能问题的慢查询, 大体有以下三种可能：

1. 索引没有设计好；
2. SQL语句没写好；
3. mysql 选错了索引.

###### 第一种可能：索引没有设计好

这种场景一般就是通过紧急创建索引来解决.最高效的做法就是直接执行 alter table 语句.

比较理想的是能够在备库先执行.假设现在的服务是一主一备, 主库A, 备库B, 这个方案的执行流程是：

1. 在备库B上执行 set sql_log_bin=off, 也就是不写binlog, 然后执行 alter table 语句加上索引；
2. 执行主备切换；
3. 这时主库是B, 备库是A.然后在A上执行1的操作.

在紧急处理时, 上述方案的效率是最高的.但是在平时考虑使用 gh-ost 方案可能更稳妥.

###### 第二种可能：语句没写好

由于sql语句书写不当, 导致语句没有使用上索引.这时我们可以通过改写SQL语句来处理.MySql5.7 提供了 query_rewrite 功能, 可以把输入的语句改写成另一种模式.

    mysql> insert into query_rewrite.rewrite_rules(pattern, replacement, pattern_database) values ("select * from t where id + 1 = ?", "select * from t where id = ? - 1", "db1");
    
    call query_rewrite.flush_rewrite_rules();



###### 第三种可能：MySql选错了索引

这时的应急方案就是给这个语句加上 force index.同样的也可以使用查询重写功能, 给原来的语句加上 force index.

在现实系统中, 出现最多的是前两种情况, 即：索引没设计好和语句没写好.而这两种情况可以在系统上线前避免的.

1. 测试环境, 打开慢查询日志, 并且设置 long_query_time = 0;
2. 在测试表里插入模拟线上的数据, 做一遍回归测试；
3. 观察慢查询日志里面的每类语句的输出, 特别留意 Rows_examined 字段是否与预期一致.

也可以使用开源工具 pt-query-digest 来分析.

##### QPS突增问题

有时候由于业务突然出现高峰, 或者应用程序bug, 导致某个语句的QPS突然暴涨, 也可能导致MySql压力过大, 影响服务.

如果是因功能引起的, 最理想的情况是让业务把新功能下掉.

#### 23MySQL是怎么保证数据不丢的？

只要 redo log 和 binlog 保证持久化到磁盘, 就能确保MySQL异常重启后, 数据可以恢复.

binlog的写入机制

binlog的写入逻辑：事务执行过程中, 先把日志写到 binlog cache, 事务提交的时候, 再把 binlog cache 写到 binlog 文件中.

![binlog的写入逻辑](/img/20210517_1.png)

每个线程都有自己的 binlog cache, 但是共用一份 binlog 文件.

- 图中write, 指的是把日志写入到文件系统的 page cache, 由于是写入内存, 并没有把数据持久化到磁盘, 因此速度比较快
- 图中的fsync, 才是将数据持久化到磁盘的操作.一般情况下, 我们认为 fsync 才占磁盘的 IOPS.


write 和 fsync 的时机, 是由参数 sync_binlog 控制的：

1. 当 sync_binlog=0时, 表示每次提交事务都只write, 不fsync；
2. 当 sync_binlog=1时, 表示每次提交事务都会执行 fsync；
3. 当 sync_binlog=N(N>1)时, 表示每次提交事务都write, 但累积N个事物后才fsync.

因此在出现IO瓶颈的场景中, 将 sync_binlog 设置成一个比较大的值, 可以提升性能.考虑到丢失日志量的可控性, 比较常见的是将其设置为 100~1000 中的某个值.

将 sync_binlog 设置为N, 对应的风险是：如果主机发生异常重启, 会丢失最近N个事务的binlog日志.

##### redo log 的写入机制

事务在执行过程中, 生成的redo log 是要先写到 redo log buffer, 并不是每次写入redo log buffer都要直接持久化到磁盘.在事务还没提交的时候, redo log buffer 中的部分日志有可能被持久化到磁盘.

redo log可能存在的三种状态：
![redo log存在的三种状态](/img/20210517_2.png)

1、存在redo log buffer中, 物理上是在MySQL进程内存中, 也就是图中的红色部分；
2、写到磁盘(write), 但是没有持久化(fsync), 物理上是在文件系统的page cache 里面, 也就是图中黄色部分；
3、持久化到磁盘, 对应的是 hard disk, 也就是图中绿色部分.

日志写到redo log buffer是很快的, write到 page cache 也很快, 但是持久化到磁盘就慢很多了.

InnoDB提供了 innodb_flush_log_at_trx_commit 参数来控制 redo log的写入策略, 它有三种可能的取值：

1. 设置为0时, 表示每次事物提交时都只是把redo log留在 redo log buffer 中；
2. 设置为1时, 表示每次事务提交时都将 redo log 直接持久化到磁盘；
3. 设置为2时, 表示每次事物提交时都只是把redo log 写到 page cache.

InnoDB有一个后台线程, 每隔1秒, 就会把 redo log buffer中的日志, 调用write 写到文件系统的 page cache, 然后调用 fsync 持久化到磁盘.

**注意**, 事务在执行过程中的 redo log 也是会直接写入 redo log buffer中的, 这些 redo log 也会被后台线程一起持久化到磁盘.也就是说, 一个还没提交的事物的 redo log, 也是可能被持久化到磁盘的.

除了后台线程每秒一次的轮询操作外, 还有两种场景会把一个没提交事物的 redo log 写入到磁盘中.

1. redo log buffer 占用的空间即将达到 innodb_log_buffer_size 一半的时候, 后台线程会主动写盘.由于这个事物并没有提交, 所以只调用 write,  而没有调用 fsync.redo log留在了 page cache.
2. 并行事务提交时, 顺带将这个事务的 redo log buffer 持久化到磁盘.事务A执行到一半, 事务B提交, 如果 innodb_flush_log_at_trx_commit 参数设置为1, 那么事务B要不 redo log buffer 里的日志持久化到磁盘.这时就会带上 事务A 在 redo log buffer中的日志一起持久化到磁盘.

两阶段提交：redo log 先 prepare, 再写 binlog,  最后再把 redo log commit.

双1配置指的是将 sync_binlog 和 innodb_flush_log_at_trx_commit 都设置成1.也就是说, 一个事务完整提交前, 需要等待两次刷盘, 一次是 redo log(prepare阶段), 一次是binlog.

日志逻辑序列号(log sequence number)LSN是单调递增的, 用来对应 redo log 的一个个写入点.每写入length长度的redo log,  LSN的值就会增加 length.

如果你的MySQL出现性能瓶颈, 而且瓶颈在IO上, 那么可以通过下面三种方法提升性能：

1. 设置binlog_group_commit_sync_delay 和 binlog_group_commit_sync_no_delay_count参数, 减少binlog的写盘次数.这个方法是基于“额外的故意等待”来实现的, 因此可能会增加语句的响应时间, 但没有丢失数据的风险.
2. 将 sync_binlog 设置为大于1的值(比较常见的是 100 ~ 1000).这样做的风险是, 主机掉电时会丢binlog日志.
3. 将 innodb_flush_log_at_trx_commit 设置为2, 这样做的风险是, 主机掉电的时候会丢失数据.

