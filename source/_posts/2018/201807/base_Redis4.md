---
title: Redis_基础 (4)
date: 2018-07-20
tags: Redis
toc: true
---

### 使用Redis作为LRU缓存
    LRU是Least Recently Used 的缩写，翻译过来就是“最近最少使用”，LRU缓存就是使用这种原理实现，简单的说就是缓存一定量的数据，当超过设定的阈值时就把一些过期的数据删除掉

<!-- more -->

#### 相关指令
- maxmemory <bytes>
    * redis-cache所能使用的最大内存(bytes),默认为0,表示"无限制"
    * 当内存满了的时候，如果还接收到set命令，redis将先尝试剔除设置过expire信息的key，而不管该key的过期时间还没有到达.
    * 在删除时，将按照过期时间进行删除，最早将要被过期的key将最先被删除.如果带有expire信息的key都删光了，内存还不够用，那么将返回错误.这样，redis将不再接收写请求，只接收get请求.maxmemory的设置比较适合于把redis 当作于类似memcached的缓存来使用.
- maxmemory-policy
    * 内存不足"时,数据清除策略,默认为"volatile-lru"
    * volatile-lru
        * 回收最近最少使用LRU的键,但只回收有设置过过期的键,为新数据腾出空间[个人理解]
        * 对"过期集合"中的数据采取LRU(近期最少使用)算法.如果对key使用"expire"指令指定了过期时间,那么此key将会被添加到"过期集合"中.将已经过期/LRU的数据优先移除.如果"过期集合"中全部移除仍不能满足内存需求,将抛出OOM异常.
    * allkeys-lru
        * 回收最近最少使用LRU的键,为新数据腾出空间
        * 对所有的数据,采用LRU算法
    * volatile-random
        * 回收随机的键,但只回收有设置过期的键,为新数据腾出空间
        * 对"过期集合"中的数据采取"随即选取"算法,并移除选中的K-V,直到"内存足够"为止. 如果如果"过期集合"中全部移除全部移除仍不能满足,将抛出OOM异常
    * allkeys-random
        * 回收随机的键,为新数据腾出空间
        * 对所有的数据,采取"随机选取"算法,并移除选中的K-V,直到"内存足够"为止
    * volatile-ttl
        * 回收有设置过期的键,尝试先回收离TTL最短时间的键,为新数据腾出空间
        * 对"过期集合"中的数据采取TTL算法(最小存活时间),移除即将过期的数据.
    * noeviction
        * 当达到内存限制时返回错误
        * 不做任何干扰操作,直接返回OOM异常
- maxmemory-samples 3
    * 清理时,每次取出来多少个数据进行比对[个人理解] 
    * 清理时会根据用户配置的maxmemory-policy来做适当的清理（一般是LRU或TTL），这里的LRU或TTL策略并不是针对redis的所有key，而是以配置文件中的maxmemory-samples个key作为样本池进行抽样清理

#### 回收过程
- 客户端执行一条新命令，导致数据库需要增加数据（比如set key value）
- Redis会检查内存使用，如果内存使用超过maxmemory，就会按照置换策略删除一些key
- 新的命令执行成功

#### 回收原理
- 概述
    * 当mem_used内存已经超过maxmemory的设定，对于所有的读写请求，都会触发redis.c/freeMemoryIfNeeded(void)函数以清理超出的内存.注意这个清理过程是阻塞的，直到清理出足够的内存空间.所以如果在达到maxmemory并且调用方还在不断写入的情况下，可能会反复触发主动清理策略，导致请求会有一定的延迟.
    * 清理时会根据用户配置的maxmemory-policy来做适当的清理（一般是LRU或TTL），这里的LRU或TTL策略并不是针对redis的所有key，而是以配置文件中的maxmemory-samples个key作为样本池进行抽样清理
- TTL数据淘汰机制
    * 从过期时间的表中随机挑选maxmemory-samples个键值对，取出其中ttl最大的键值对淘汰.
- LRU数据淘汰机制
    * 在数据集中随机挑选maxmemory-samples个键值对，取出其中lru最小的键值对淘汰
