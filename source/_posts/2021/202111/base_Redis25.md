---
title: Redis_基础 (25)
date: 2021-11-09
tags: Redis
toc: true
---

### 实用之redis
    redis info

<!-- more -->

#### 前提提要
> 我的系统开始用redis了, 同事过来问我, redis我主要用来干什么, 会不会存特别大的东西, 导致redis性能下降, 我说 我就存点字符串, 还用了个list, 别的也不会干什么, 他说 那你还是info查一下吧,  我说好. 抓紧时间看看info是干什么的

#### 性能相关的数据指标
- code
    ```bash
        127.0.0.1:6379> info
        # Server
        redis_version:6.2.6
        redis_git_sha1:00000000
        redis_git_dirty:0
        redis_build_id:e72639486d2ec1a2
        redis_mode:standalone
        os:Linux 5.4.0-1030-aws x86_64
        arch_bits:64
        multiplexing_api:epoll
        gcc_version:9.3.0
        process_id:3307900
        run_id:6c93018a2a9facdb95803b70c7508e5fc63a5a97
        tcp_port:6379
        uptime_in_seconds:6049113
        uptime_in_days:70
        hz:10
        lru_clock:12005941

        # Clients
        connected_clients:3
        blocked_clients:0

        # Memory
        used_memory:199966480
        used_memory_human:190.70M
        used_memory_rss:225165312
        used_memory_peak:201190824
        used_memory_peak_human:191.87M
        used_memory_lua:37888
        mem_fragmentation_ratio:1.13
        mem_allocator:jemalloc-5.1.0

        # Persistence
        loading:0
        rdb_changes_since_last_save:24481813
        rdb_bgsave_in_progress:0
        rdb_last_save_time:1633346780
        rdb_last_bgsave_status:ok
        rdb_last_bgsave_time_sec:-1
        rdb_current_bgsave_time_sec:-1
        aof_enabled:0
        aof_rewrite_in_progress:0
        aof_rewrite_scheduled:0
        aof_last_rewrite_time_sec:-1
        aof_current_rewrite_time_sec:-1
        aof_last_bgrewrite_status:ok

        # Stats
        total_connections_received:384503
        total_commands_processed:57443989
        instantaneous_ops_per_sec:27
        rejected_connections:0
        sync_full:0
        sync_partial_ok:0
        sync_partial_err:0
        expired_keys:158744
        evicted_keys:4157212
        keyspace_hits:13057847
        keyspace_misses:5667787
        pubsub_channels:0
        pubsub_patterns:0
        latest_fork_usec:0
        migrate_cached_sockets:0

        # Replication
        role:master
        connected_slaves:0
        master_repl_offset:0
        repl_backlog_active:0
        repl_backlog_size:1048576
        repl_backlog_first_byte_offset:0
        repl_backlog_histlen:0

        # CPU
        used_cpu_sys:5639.737000
        used_cpu_user:48638.730365
        used_cpu_sys_children:0.000000
        used_cpu_user_children:0.000000

        # Cluster
        cluster_enabled:0

        # Keyspace
        db0:keys=986991,expires=1196,avg_ttl=31274435276138

        # 主要有以下几个
        # server
        # clients
        # memory
        # persistence
        # stats
        # replication
        # cpu
        # commandstats
        # cluster
        # keyspace

        # 只查看内存相关信息
        127.0.0.1:6379> info memory
        # Memory
        used_memory:199970672
        used_memory_human:190.71M
        used_memory_rss:225099776
        used_memory_peak:201190824
        used_memory_peak_human:191.87M
        used_memory_lua:37888
        mem_fragmentation_ratio:1.13
        mem_allocator:jemalloc-5.1.0
    ```

#### 内存使用率used_memory
- 参数详解
    * used_memory: 由Redis分配器分配的内存总量, 以字节(byte)为单位
    * used_memory_human: 和used_memory是一样的值, 它以M为单位显示, 仅为了方便阅读
    * used_memory_rss: 从操作系统上显示已经分配的内存总量. 
    * mem_fragmentation_ratio: 内存碎片率. 
    * used_memory_lua: Lua脚本引擎所使用的内存大小. 
    * mem_allocator: 在编译时指定的Redis使用的内存分配器, 可以是libc、jemalloc、tcmalloc. 
- 重点关注字段
    * used_memory
    * 如果used_memory>可用最大内存, 意味着redis将会把内存中旧的数据或者不再使用的内容写到硬盘上, 效率相较于内存操作会低很多, 影响性能
- 避免方法
    * 假如缓存数据小于4GB, 就使用32位的Redis实例
    * 尽可能的使用Hash数据结构
    * 设置key的过期时间
    * 回收key

#### 命令处理数total_commands_processed
> 在info信息里的total_commands_processed字段显示了Redis服务处理命令的总数, 其命令都是从一个或多个Redis客户端请求过来的. Redis每时每刻都在处理从客户端请求过来的命令, 它可以是Redis提供的140种命令的任意一个.  total_commands_processed字段的值是递增的, 比如Redis服务分别处理了client_x请求过来的2个命令和client_y请求过来的3个命令, 那么命令处理总数(total_commands_processed)就会加上5. 
- 解决响应延迟的问题
    * 使用多参数命令: 若是客户端在很短的时间内发送大量的命令过来, 会发现响应时间明显变慢, 这由于后面命令一直在等待队列中前面大量命令执行完毕. 有个方法可以改善延迟问题, 就是通过单命令多参数的形式取代多命令单参数的形式. 
    ![使用多参数命令](/img/20211109_1.png)
    * 管道命令: 另一个减少多命令的方法是使用管道(pipeline), 把几个命令合并一起执行, 从而减少因网络开销引起的延迟问题. 因为10个命令单独发送到服务端会引起10次网络延迟开销, 使用管道会一次性把执行结果返回, 仅需要一次网络延迟开销
    * 避免操作大集合的慢命令: 如果命令处理频率过低导致延迟时间增加, 这可能是因为使用了高时间复杂度的命令操作导致, 这意味着每个命令从集合中获取数据的时间增大.  所以减少使用高时间复杂的命令, 能显著的提高的Redis的性能
    ![避免操作大集合的慢命令](/img/20211109_2.png)





