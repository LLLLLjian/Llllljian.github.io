---
title: MySQL_基础 (78)
date: 2021-05-20
tags: MySQL
toc: true
---

### 更好的理解MySQL
    MySQL实战45讲

<!-- more -->

#### 故事背景
> 今天在b站学习mysql的时候 突然觉得b站的学习氛围不是很好了呀, 都是随便讲的, 都是想吃互联网第二波饭的人, 两个小时的视频里有一个多小时是在卖课,  在给人洗脑, 然后我就找呀找, 最后找到了【MySQL实战45讲】, 看过的人都说好, 我也来看看吧, 学一学

#### 29如何判断一个数据库是不是出问题了？

##### select 1 判断

select1成功返回, 只能说明这个库的进程还在, 并不能说明主库没有问题.

innodb_thread_concurrency 参数设置并发线程上限, 一旦并发线程数达到这个值,  InnoDB 在接收到新请求的时候, 就会进入等待状态, 直到有线程退出.默认值为0, 表示不限制并发线程数量.如果不限制, CPU核数有限, 线程上下文切换成本高.一般建议设置为 64-128 之间.

并发连接和并发查询是不同的概念.show processlist 的结果, 指的是并发连接, 达到几千个影响不大, 多占些内存.“当前正在执行”的语句, 才是并发查询, 其占用CPU资源.

线程在进入锁等待以后, 并发线程的计数会减一, 也就是等行锁(也包括间隙锁)的线程并不在 innodb_thread_concurrency 中.原因是, 进入锁等待的线程并不吃CPU了, 再有就是如果计数不减一, 线程等待数到达上限值, 整个系统就会堵住了.

如果线程真正地在执行查询, 比如上述的 select sleep(100) from t, 还是要算进并发线程的计数的.


##### 查表判断

可以通过在MySQL里面创建一张表, 然后定期执行查询语句.这样就可以检测出由于并发线程过多导致数据库不可用的情况.

但是, 如果遇到磁盘空间满的时候, 这种方法就变得不可用.更新事务时要写 binlog, 而一旦 binlog 所在磁盘的空间占用率达到 100%,  那么所有的更新语句和事务提交的 commit 语句就都会被堵住.但是可以进行正常的读数据.

##### 更新判断

常见的做法是放一个 timestamp 字段, 用来表示最后一次执行检测的时间.

节点可用性检测应该包含主库和备库.我们一般会把数据库 A 和 B 的主备关系设计为双 M 结构, 所以在备库 B上执行的命令也要发回给主库 A.如果主库 A 和 备库 B 都用相同的更新命令, 就可能出现行冲突, 也就是可能会导致主备同步停止.所以更新的表就要有多行数据, id 对应每个数据库的 server_id 做主键.

    mysql> CREATE TABLE `health_check` (
      `id` int(11) NOT NULL,
      `t_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB;
    
    /* 检测命令 */
    insert into mysql.health_check(id, t_modified) values (@@server_id, now()) on duplicate key update t_modified=now();

MySQL 规定了主库和备库的 server_id 必须不同, 这样就可以保证检测命令不会发生冲突.

如果检测命令的id一样, 两个语句同时执行, 那么在主库和备库上就都是“insert行为”, 写到binlog里面就都是Write rows event, 这个冲突就会导致主备同步停止.

但是依然存在一些问题, 当 IO 利用率 100%时, 表示系统的 IO 是在工作的, 每个请求都有机会获得 IO 资源, 执行任务.检测执行语句需要的资源很少, 所以可能在拿到 IO 资源的时候就可以提交成功, 并且在未到达超时时间时就返回给检测系统, 那么就会得出“系统正常”的结论.但其实业务系统上正常的 SQL语句已经执行的很慢了.

上述所说的所有方法, 都是基于外部检测的.存在两个问题：一是检测方式并不能真正完全的反应系统当前的状况, 二是定时轮询检测有时间间隔, 如不能及时发现, 可能导致切换慢的问题.


##### 内部统计

可以通过MySQL 统计的 IO 请求时间, 来判断数据库是否出问题.

可以通过下面语句, 查看各类 IO 操作统计值：


    select * from performance_schema.file_summary_by_event_name where event_name = 'wait/io/file/innodb/innodb_log_file';


从上到下分别统计的是：所有 IO 类型、读操作、写操作、其他类型数据.

performance_schema 统计是有性能损耗的, 因此只需打开需要的监控即可.例如 redo log：


    mysql> update setup_instruments set ENABLED='YES', Timed='YES' where name like '%wait/io/file/innodb/innodb_log_file%';

检测语句, 200 ms 为异常：

    mysql> select event_name,MAX_TIMER_WAIT  FROM performance_schema.file_summary_by_event_name where event_name in ('wait/io/file/innodb/innodb_log_file','wait/io/file/sql/binlog') and MAX_TIMER_WAIT>200*1000000000;

清空语句：

    mysql> truncate table performance_schema.file_summary_by_event_name;

#### 30 | 答疑文章(二)：

用动态的观点看加锁加锁规则：两个“原则”, 两个“优化”, 一个bug.

- 原则1：加锁的基本单位是 next-key lock.它是前开后闭区间.
- 原则2：查找过程中访问到的对象会加锁.
- 优化1：索引上的等值查询, 给唯一索引加锁的时候, next-key lock 退化为行锁.
- 优化2：索引上的等值查询, 向右遍历时且最后一个值不满足等值条件的时候, next-key lock 退化为间隙锁.
- 一个bug：唯一索引上的范围查询会访问到不满足条件的第一个值为止.


##### 不等号条件里的等值查询

在执行过程中, 通过树搜索的方式定位记录的时候, 用的是“等值查询”的方法.


##### 等值查询的过程


##### 怎么看死锁

出现死锁后, 执行 show engine innodb status 命令输出相关信息.LATESTDETECTED DEADLOCK 记录的是最后一次死锁信息.

1、由于锁是一个一个加的, 要避免死锁, 对同一组资源, 要按照尽量相同的顺序访问；

2、在死锁发生时刻, 资源占用越多, 回滚成本就越大.因此 InnoDB 会选择回滚成本更小的语句.


##### 怎么看锁等待

update 语句先插入再删除.

#### 31误删数据后除了跑路, 还能怎么办？

误删数据分类：
1、使用 delete 语句误删数据行；
2、使用 drop table 或者 truncate table 语句误删数据表；
3、使用 drop database 语句误删数据库；
4、使用 rm 命令误删整个 MySQL 实例.


##### 误删行

在前提是 binlog_format=row 和 binglog_row_image=NULL 的前提下, 如果使用 delete 语句误删了数据行, 可以用 Flashback 工具通过闪回把数据恢复回来.

具体恢复数据时, 对单个事务做如下处理：

1. 对于 insert 语句, 对应的 binlog event 类型是 Write_rows event, 把它改成 Delete_rows event 即可；
2. 对于 delete 语句, 将 Delete_rows event 改为 Write_rows event；
3. 对于Update_rows, binlog 里面记录了修改前和修改后的值, 对调这两行的位置即可.

对于误删数据涉及到多个事务的话, 需要将事务的顺序调过来再执行.

恢复数据比较安全的做法是, 恢复出一个备份, 或者找一个从库作为临时库, 在这个临时库上执行这些操作, 然后再将确认过的临时数据库的数据, 恢复回主库.

预防误删数据方法：

1. 把 sql_safe_updates 参数设置为 on.这样的话, 如果忘记在 delete 或者 update 语句中写 where 条件, 或者 where 条件里面没有包含索引字段的话, 这条语句执行就会报错.
2. 代码上线前, 必须经过 SQL 审计.


##### 误删库 / 表

误删了库或表, 就要求线上有定期的全量备份, 并且实时备份 binlog.

恢复数据的流程：

1. 取最近一次全量备份, 假设这个库是一天一备, 上次备份时当天 0 点；
2. 用备份恢复一个临时库；
3. 从日志备份里面, 取出凌晨 0 点之后的日志；
4. 把这些日志, 除了误删除数据的语句外, 全部应用到临时库.

![](/img/20210520_1.png)


1、为了加速数据恢复, 在使用 mysqlbillog 命令时, 加 database 参数来指定误删表所在的库.

2、在应用日志的时候, 需要跳过 12 点误操作的那个语句的 binlog：

- 如果没有使用 GTID 模式, 只能在应用到 12 点的 binlog 文件的时候, 先用 -stop-position 参数执行到误操作之前的日志, 再用 -start-position 从误操作之后的日志继续执行.
- 如果使用了 GTID 模式, 只需要把误操作的 GTID 加到临时库实例的 GTID 集合就行了.


使用 mysqlbinlog 方法恢复数据不够快的原因：

1. mysqlbinlog 并不能指定只解析一个表的日志；
2. 用 mysqlbinlog 解析出日志应用, 应用日志的过程只能是单线程.


一种加速的方法是, 将临时实例设置成线上备库的从库：

1. 在 start slave 之前, 先通过执行 change replication filter replicate_do_table  = (tbl_name) 命令, 就可以让临时库只同步误操作的表；
2. 这样也可以用上并行复制技术, 加速数据恢复过程.

![](/img/20210520_2.png)


把之前删掉的 binlog 放回备库的操作步骤：

1. 从备份系统下载 master.000005 和 master.000006 这两个文件, 放到备库的日志目录下；
2. 打开日志目录下的 master.index 文件, 在文件开头加入两行, 内容分别是 “./master.000005" 和 “./master.000006”;
3. 重启备库, 目的是让备库重新识别这两个日志文件；
4. 现在备库上就有了临时库需要的所有 binlog 了, 建立主备干洗, 就可以正常同步了.


##### 延迟复制备库

如果距离上一个全量备份时间较长, 那么恢复时间也会很长.对于非常核心的业务, 是不允许太长的恢复时间.可以考虑搭建延迟复制的备库.

延迟复制的备库是一种特殊的备库, 通过 CHANGE MASTER TO MASTER_DELAY = N 命令, 可以指定这个备库持续保持跟主库 N 秒的延迟.这样就可以在备库上先 stop slave, 再通过之前的方法跳过误操作命令, 就可以恢复出需要的数据.


##### 预防误删库 / 表的方法

1、账号分离, 不同的人有不同的权限, 避免写错命令.

2、制定操作规范.避免写错要删除的表名.比如：在删除表之前先对表做改名操作.观察一段时间如果对业务没有影响, 再通过管理系统删除有固定后缀的表.


##### rm 删除数据

尽量把备份跨机房, 或者最好是跨城市保存.

