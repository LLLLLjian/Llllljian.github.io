---
title: MySQL_基础 (77)
date: 2021-05-19
tags: MySQL
toc: true
---

### 更好的理解MySQL
    MySQL实战45讲

<!-- more -->

#### 故事背景
> 今天在b站学习mysql的时候 突然觉得b站的学习氛围不是很好了呀, 都是随便讲的, 都是想吃互联网第二波饭的人, 两个小时的视频里有一个多小时是在卖课,  在给人洗脑, 然后我就找呀找, 最后找到了【MySQL实战45讲】, 看过的人都说好, 我也来看看吧, 学一学

#### 26备库为什么会延迟好几个小时？

![](/img/20210519_1.png)

第一个黑色箭头表示客户端写入主库, 第二个黑色箭头表示备库上 sql_thread 执行中转日志(relay log).如果客户端写入主库的并发度远大于备库执行中转日志的并发度, 那么将会造成严重地主备延迟.

![](/img/20210519_2.png)

coordinator 就是原来的 sql_thread, 不过现在它不再是直接更新数据了, 只负责读取中转日志和分发事务.真正的日志更新变成了worker线程.worker线程的个数是由参数 slave_parallel_workers 决定的.根据经验, 值设置为 8~16 之间最好(32核物理机).

coordinator在分发的时候, 需要满足以下两个基本要求：

1. 不能造成更新覆盖.这就要求更新同一行的两个事务, 必须被分发到同一个worker中.
2. 同一个事务不能被拆开, 必须放到同一个worker中.

##### MySQL 5.5 版本的并行复制策略

MySQL5.5版本是不支持并行复制的, 备库只能单线程复制. 林实现了两种并行策略：按表分发策略和按行分发策略.


###### 按表分发策略

按表分发事务的基本思路是, 如果两个事务更新不同的表, 它们就可以并行.因为数据是存储在两个不同的表里, 所以按表分发, 可以保证两个 worker 不会更新同一行.如果有跨表的事务, 还是要放在一起考虑的.

![](/img/20210519_3.png)

##### MySQL 5.6 版本的并行复制策略

官方5.6版本支持了并行复制, 只是支持的粒度是按库并行.

##### MariaDB 的并行复制策略

MariaDB 策略, 目标是“模拟主库的并行模式”.但它并没有实现“真正的模拟主库并发度”这个目标.

MariaDB 的并行复制策略利用了 redo log 组提交优化的特性：

1. 能够在同一组里提交的事务, 一定不会修改同一行；
2. 主库上可以并行执行的事务, 备库上也一定可以并行执行.

具体实现： 

1. 在一组里面一起提交的事务, 有一个相同的commit_id, 下一组就是 commit_id + 1;
2. commit_id 直接写到 binlog 里面；
3. 传到备库应用的时候, 相同 commit_id 的事务分发到多个 worker 执行；
4. 这一组全部执行完成后, coordinator 再去取下一批.

![](/img/20210519_4.png)

可以看到, 在主库执行的时候, 多组事务是并行执行的, 但在从库上同时只能一组事务执行, 这样系统的吞吐量就不够.这个方案很容易被大事务拖后腿, 如果 trx2 是一个超大事务, 那么在 trx1 和 trx3执行完后, 就只有一个worker线程在工作了, 是对资源的浪费.


##### MySQL 5.7 的并行复制策略

参数 slave-parallel-type 来控制并行复制策略：

1. 配置为 DATABASE, 表示使用 MySQL 5.6 版本的库并行策略；
2. 配置为 LOGICAL_CLOCK, 表示使用优化过的类似 MariaDB 的策略.


MySQL 5.7 并行复制策略的思想是：

1. 同时处于 prepare 状态的事务, 在备库执行时是可以并行的；
2. 处于 prepare 状态的事务, 与处于 commit 状态的事务之间, 在备库执行时也是可以并行的.

用于控制binlog 从 write 到 fsync 时间的参数, 既可以减少 binlog 的写盘次数, 也可以制造更多的“同时处于 prepare 阶段的事务”, 从而提升备库复制并发度的目的.


##### MySQL 5.7.22 的并行复制策略

新增了一个新的并行复制策略, 基于 WRITESET 的并行复制.由参数 binlog-transaction-dependency-tracking, 用来控制是否启用这个新策略.可取值：

1. COMMIT_ORDER, 表示就是前面介绍的, 根据同时进入 prepare 和 commit 来判断是否可以并行的策略；
2. WRITESET, 表示的是对于事务涉及更新的每一行, 计算出这一行的hash值, 组成 writeset 集合.如果两个事务没有操作相同的行, 也就是 writeset 没有交集, 就可以并行；
3. WRITESET_SESSION, 在 WRITESET 的基础上多了一个约束, 在主库上同一个线程先后执行的事务, 在备库也要保证相同的执行顺序.

#### 27主库出问题了, 从库怎么办？

一主多从结构：

![](/img/20210519_5.png)


图中虚线箭头表示的是主备关系, 也就是 A 和 A' 互为主备关系.从库 B、C、D 指向的是主库A.一主多从的设置, 一般用于读写分离, 主库负责所有的写和一部分读, 其他的读请求由从库分担.

在一主多从架构下, 主备切换问题：

![](/img/20210519_6.png)

相比于一主一备的切换流程, 一主多从在切换完成后, A'会成为新的主库, 从库 B、C、D 也要改连接到 A'.从而主备切换的复杂性也相应增加了.


##### 基于位点的主备切换

我们把节点B设置成A'的从库的时候, 需要执行一条 change master 命令：

    
    CHANGE MASTER TO
    MASTER_HOST=$host_name
    MASTER_PORT=$port
    MASTER_USER=$user_name
    MASTER_PASSWORD=$password
    MASTER_LOG_FILE=$master_log_name
    MASTER_LOG_POS=$master_log_pos  

前四个参数分别是主库的 IP、端口、用户名和密码.最后两个参数是要从主库的 master_log_name 文件的 master_log_pos 这个位置的日志继续同步.这个位置就是我们所说的同步位点.

同步位点的获取是不精确的, 考虑到切换过程中不能丢失数据, 所以找位点的时候, 总是要找一个“稍微往前”的, 再通过判断跳过哪些在从库B上已经执行的事务.

一种取同步位点的方法：

1. 等待新主库 A' 把中转日志(relay log)全部同步完成；
2. 在 A' 上执行 show master status 命令, 得到当前 A' 上最新的 File 和 Position；
3. 取原主库 A 故障的时刻 T；
4. 用 mysqlbinlog 工具解析 A' 的 file, 得到 T时刻的位点.

    mysqlbinlog File --stop-datetime=T --start-datetime=T

通常情况下, 在切换任务的时候, 要先主动跳过这些错误, 有两种常用的方法：

1、主动跳过一个事务.每次碰到错误时, 就执行一次跳过命令.


    set global sql_slave_skip_counter=1;
    start slave;

2、通过设置 slave_skip_errors 参数, 直接设置跳过指定的错误.这种设置是在主备切换时, 当切换完成, 稳定执行一定时间后, 还需把这个参数设置为空.

例如设置 slave_skip_errors 为 “1032,1062”.

##### GTID

通过上述方式来实现主备切换, 操作都很复杂, 而且容易出错.MySQL5.6版本引入了GTID, 彻底解决了这个困难.

Global Transaction identifier, 也就是全局事务 ID, 是一个事务在提交时生成的.格式： GTID=server_uuid:gno, server_uuid 是一个实例第一次启动时生成的, 是一个全局唯一的值；gno 是一个整数, 初始值为1, 每次提交事务的时候分配给这个事务, 并加1.

官方文档给的定义是： GTID=source_id:transaction_id

在启动MySQL实例时, 通过加上参数 gtid_mode=on 和 enforce_gtid_consistency=on 就可以启动GTID模式了.在GTID模式下, 每一个事务都与一个GTID一一对应.GTID的两种生成方式, 由session变量gtid_next的值决定：

1. 如果 gtid_next=automatic, 代表使用默认值.这时, MySQL就会把 server_uuid:gno 分配给这个事务
	1. 记录binlog的时候, 先记录一行 SET @@SESSION.GTID_NEXT='server_uuid:gno';
	2. 把这个GTID加入到本实例的 GTID 集合.
2. 如果 gtid_next 是一个指定的 GTID 值, 那么就有两种可能：
	1. 如果指定值已经在 GTID 集合中, 接下来执行的这个事务直接被系统忽略, 不执行该事务；
	2. 如果指定值没有在 GTID 集合中, 就将该值分配给这个事务.系统不需要给这个事务生成新的 GTID,  因此gno 也不用加1.

这样, 每个 MySQL 实例都维护了一个GTID 集合, 用来对应“这个实例执行过的所有事务”.


##### 基于 GTID 的主备切换

在 GTID 模式下, 备库 B 要设置为新主库 A' 的从库的语法如下：

    
    CHANGE MASTER TO
    MASTER_HOST=$host_name
    MASTER_PORT=$port
    MASTER_USER=$user_name
    MASTER_PASSWORD=$password
    master_auto_position=1

master_auto_position=1 表示这个主备关系使用的是 GTID 协议.

在主备切换时, 从库会把自己的 GTID 集合发送个 新主库 A' , A' 会用自己的 GTID 集合与从库比较, 算出差集.如果 A' 不包含差集中的所需要的 binlog 事务, 那么直接返回错误；如果包含, 则找出差集只中的第一个事务发给从库, 之后就从这个事务开始, 往后读文件, 顺序取 binlog 发送给从库.

#### 28读写分离有哪些坑？

![](/img/20210519_7.png)

读写分离的主要目标就是分摊主库的压力.图1 中的结构是客户端(client)主动做负载均衡, 这种模式下一般会把数据库的连接信息放在客户端的连接层.由客户端来选择数据库进行查询.

还有一种架构是, 在MySQL和客户端之间有一个中间代理层 proxy, 客户端只连接 Proxy, 由Proxy根据请求类型和上下文决定请求的分发路由.

![](/img/20210519_8.png)


两种架构的特点：

1. 客户端直连, 因为少了一层Proxy转发, 索引查询性能稍微好一点, 并且整体架构简单, 排查问题更方便.但是这种方案需要了解后端部署细节, 所以在出现主备切换、库迁移等操作的时候, 客户端会感知到, 并且要调整数据库连接信息.为了更方便的管理, 一般会使用管理后端的组件, 例如zookeeper.
2. 待Proxy 的架构, 对客户端比较友好.客户端不需要关注后端细节, 连接维护、后端信息维护等工作, 都是由Proxy完成.使用这种架构会增加系统的复杂度, 因此对团队的要求会更高.

无论使用哪种架构, 都会碰到由于主从可能存在延迟, 客户端执行完一个更新事务后马上发起查询, 如果查询选择的是从库的话, 就有可能读到刚刚的事务更新之前的状态.

这种“在从库上会读到系统的一个过期状态”的现象, 我们暂且称之为“过期读”.

处理方案：

- 强制走主库方案；
- sleep 方案；
- 判断主备无延迟方案；
- 配合 semi-sync 方案；
- 等主库位点方案；
- 等 GTID 方案.

##### 强制走主库方案

强制走主库方案就是, 将查询请求做分类：

1. 对于必须要拿到最新结果的请求, 强制将其发到主库上.
2. 对于可以读到旧数据的请求, 才将其发到从库上.

##### Sleep 方案

主库更新后, 读从库之前先 sleep 一下.

这种方式看起来不靠谱, 存在的问题：

1. 如果这个查询请求本来 0.5 秒就可以在从库上拿到正确结果, 也会等 n 秒.
2. 如果延迟超过 n 秒, 还是会出现过期读.


##### 判断主备无延迟方案

在确保主备无延迟的情况下, 才进行从库请求.

**第一种**确保主备无延迟的方法是, 每次从库执行查询请求前, 先判断 seconds_behind_master 是否已经等于0(表示主备无延迟).直到参数等于 0  时才能执行查询请求.

**第二种**方法, 对比位点确保主备无延迟：

- Master_Log_File 和 Read_Master_Log_Pos, 表示的是读到的主库的最新位点；
- Relay_Masert_Log_File 和 Exec_Master_Log_Pos, 表示的是备库执行的最新位点.


如果两组值对应相等, 就表示接收到的日志已经同步完成.

第三种方法, 对比 GTID 集合确保主备无延迟：

- Auto_Position=1, 表示这对主备关系使用了 GTID 协议.
- Retrieved_Gtid_Set, 是备库收到的所有日志的 GTID 集合；
- Executed_Gtid_set, 是备库所有已执行完成的 GTID 集合.


当两个集合相同时, 表示备库接收到的日志都已同步完成.

可见对比位点和对比 GTID 方法, 都要比判断 second_behind_master 是否为 0 更准确.

但是还没有达到精确的程度, 因为发往备库的 binlog 是始终少于等于主库 binlog 内容的, 即使从库 binlog 都执行完成, 与主库的状态还是可能不同步的, 就会出现过期读.


##### 配合 semi-sync

半同步复制：semi-sync replication

1. 事务提交的时候, 主库把 binlog 发给从库；
2. 从库收到 binlog 后, 发回给主库一个 ack, 表示收到了；
3. 主库收到这个 ack 后, 才能给客户端返回 “事务完成”的确认.

semi-sycn 配合判断主备无延迟的方案, 存在两个问题：

1. 一主多从的时候, 在某些从库执行查询请求会存在过期读的现象；
2. 在持续延迟的情况下, 可能出现过度等待的问题.

##### 等主库位点方案

执行逻辑：

1. trx1 事务更新完成后, 马上执行 show master status 得到当前主库执行到的 File 和Position；
2. 选定一个从库执行查询语句；
3. 在从库上执行 select master_pos_wait(File, Position, 1);
4. 如果返回值是 >= 0 的正整数, 则在这个从库执行查询语句；
5. 否则, 到主库执行查询语句.

    select master_pos_wait(file, pos[, timeout]);

表示从命令开始执行, 到应用完 file 和 pos 表示的 binlog 位置, 执行了多少事务.

对于不予许过期读的要求, 只有两个选择, 一种是超时放弃, 一种是转到主库查询.需要注意的是考虑到主库的压力, 做好限流策略.


##### GTID 方案

    select wait_for_executed_gtid_set(gtid_set, 1);

命令的逻辑是：

1. 等待, 直到这个库执行的事务中包含传入的 gtid_set,  返回0；
2. 超时返回 1.

等 GTID 的执行逻辑：

1. trx1 事务更新完成后, 从返回包直接获取这个事务的 GTID,  记为 gtid1；
2. 选定一个从库执行查询语句；
3. 在从库上执行  select wait_for_executed_gtid_set(gtid_set, 1);
4. 如果返回值是 0, 则在这个从库执行查询语句；
5. 否则, 到主库执行查询语句.

通过设置参数 session_track_gtids = OWN_GTID , 让 MySQL 在执行事务后, 返回包中带上 GTID.然后通过 API 接口 mysql_session_track_get_first 从返回包中解析 GTID 的值.