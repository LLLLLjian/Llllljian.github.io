---
title: Redis_基础 (6)
date: 2018-07-22
tags: 
    - Redis
    - Interview
toc: true
---

### Redis面试点
    持续更新

<!-- more -->

#### 什么是redis
    Redis是一个基于内存的高性能key-value数据库

#### 使用redis好处？
- 速度快,因为数据存在内存中,类似于HashMap,HashMap的优势就是查找和操作的时间复杂度都是O(1)
- 支持丰富数据类型,支持string,list,set,sorted set,hash
- 支持事务,操作都是原子性,所谓的原子性就是对数据的更改要么全部执行,要么全部不执行
- 丰富的特性：可用于缓存,消息,按key设置过期时间,过期后将会自动删除

#### redis与memcached比较
- memcached所有的值均是简单的字符串,redis作为其替代者,支持更为丰富的数据类型
- redis的速度比memcached快很多
- redis可以持久化其数据
- redis最大可以达到1GB,而memcache只有1MB

#### redis常见性能问题和解决方案：
- Master最好不要做任何持久化工作,如RDB内存快照和AOF日志文件
- 如果数据比较重要,某个Slave开启AOF备份数据,策略设置为每秒同步一次
- 为了主从复制的速度和连接的稳定性,Master和Slave最好在同一个局域网内
- 尽量避免在压力很大的主库上增加从库
- 主从复制不要用图状结构,用单向链表结构更为稳定,即：Master <- Slave1 <- Slave2 <- Slave3...这样的结构方便解决单点故障问题,实现Slave对Master的替换.如果Master挂了,可以立刻启用Slave1做Master,其他不变.

#### 保证redis中的数据都是热点数据
- 数据淘汰策略
    * 惰性删除策略
    * 定期删除策略
    * LRU
    * TTL

#### redis持久化
- AOF
- RDB

#### redis最适合的场景
- 会话缓存（Session Cache）
- 全页缓存（FPC）
- 队列
- 排行榜/计数器
- 发布/订阅
