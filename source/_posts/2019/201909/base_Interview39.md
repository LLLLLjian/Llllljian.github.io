---
title: Interview_总结 (39)
date: 2019-09-27
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 哨兵机制
- 是什么
    * 是一个分布式系统,你可以在一个架构中运行多个哨兵(sentinel) 进程,这些进程使用流言协议(gossipprotocols)来接收关于Master是否下线的信息,并使用投票协议(agreement protocols)来决定是否执行自动故障迁移,以及选择哪个Slave作为新的Master
- 做什么
    * 监控(Monitoring)
        * 哨兵(sentinel)会不断地检查你的Master和Slave是否运作正常.
    * 提醒(Notification)
        * 当被监控的某个 Redis出现问题时, 哨兵(sentinel) 可以通过 API 向管理员或者其他应用程序发送通知.
    * 自动故障迁移(Automatic failover)
        * 当一个Master不能正常工作时,哨兵(sentinel) 会开始一次自动故障迁移操作,它会将失效Master的其中一个Slave升级为新的Master, 并让失效Master的其他Slave改为复制新的Master; 当客户端试图连接失效的Master时,集群也会向客户端返回新Master的地址,使得集群可以使用Master代替失效Master
- 作用
    * Master 状态监测
    * 如果Master异常,则会进行Master-slave 转换,将其中一个Slave作为Master,将之前的Master作为Slave 
    * Master-Slave切换后,master_redis.conf、slave_redis.conf和sentinel.conf的内容都会发生改变,即master_redis.conf中会多一行slaveof的配置,sentinel.conf的监控目标会随之调换
- 工作方式
    * 每个Sentinel以每秒钟一次的频率向它所知的Master,Slave以及其他 Sentinel 实例发送一个 PING 命令.
    * 如果一个实例(instance)距离最后一次有效回复 PING 命令的时间超过 down-after-milliseconds 选项所指定的值, 则这个实例会被 Sentinel 标记为主观下线. 
    * 如果一个Master被标记为主观下线,则正在监视这个Master的所有 Sentinel 要以每秒一次的频率确认Master的确进入了主观下线状态. 
    * 当有足够数量的 Sentinel(大于等于配置文件指定的值)在指定的时间范围内确认Master的确进入了主观下线状态, 则Master会被标记为客观下线 .
    * 在一般情况下, 每个 Sentinel 会以每 10 秒一次的频率向它已知的所有Master,Slave发送 INFO 命令 .
    * 当Master被 Sentinel 标记为客观下线时,Sentinel 向下线的 Master 的所有 Slave 发送 INFO 命令的频率会从 10 秒一次改为每秒一次 .
    * 若没有足够数量的 Sentinel 同意 Master 已经下线, Master 的客观下线状态就会被移除
    * 若 Master 重新向 Sentinel 的 PING 命令返回有效回复, Master 的主观下线状态就会被移除

#### 心跳机制
- 是什么
    * 在命令传播阶段,从服务器默认以每秒一次的频率,向主服务器发送命令
- 做什么
    * 检测主服务器的网络连接状态
        * 通过向主服务器发送INFO replication命令,可以列出从服务器列表,可以看出从最后一次向主发送命令距离现在过了多少秒
    * 辅助实现min-slaves选项
        * 通过配置防止主服务器在不安全的情况下执行写命令
    * 检测命令丢失
        * 如果因为网络故障,主服务器传播给从服务器的写命令在半路丢失,那么当从服务器向主服务器发送REPLCONF ACK命令时,主服务器将发觉从服务器当前的复制偏移量少于自己的复制偏移量,然后主服务器就会根据从服务器提交的复制偏移量,在复制积压缓冲区里面找到从服务器缺少的数据,并将这些数据重新发送给从服务器


