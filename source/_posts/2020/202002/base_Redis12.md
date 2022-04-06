---
title: Redis_基础 (12)
date: 2020-02-20
tags: 
    - Redis
    - Interview
toc: true
---

### Redis面试须知
    记录一下面试中遇到的Redis相关问题

<!-- more -->

#### Redis对象
- 是什么
    * Redis 并没有直接使用简单动态字符串、双端链表、字典、压缩列表、整数集合这些数据结构来实现键值对的数据库, 而是在这些数据结构之上又包装了一层 RedisObject(对象)
    * RedisObject 有五种对象: 字符串对象、列表对象、哈希对象、集合对象和有序集合对象.
- 使用RedisObject好处
    * 通过不同类型的对象, Redis 可以在执行命令之前, 根据对象的类型来判断一个对象是否可以执行给定的命令.
    * 可以针对不同的使用场景, 为对象设置不同的实现, 从而优化内存或查询速度
- 源码
    ```bash
        typedef struct redisObject {

            // 类型
            unsigned type:4;

            // 编码
            unsigned encoding:4;

            // 对象最后一次被访问的时间
            unsigned lru:REDIS_LRU_BITS; /* lru time (relative to server.lruclock) */

            // 引用计数
            int refcount;

            // 指向实际值的指针
            void *ptr;

        } robj;
    ```
- type
    * type 记录了对象的类型
    * 取值
        * REDIS_STRING字符串对象
        * REDIS_LIST列表对象
        * REDIS_HASH哈希对象
        * REDIS_SET集合对象
        * REDIS_ZSET有序集合对象
- ptr
    * 指向对象的底层实现数据结构
- encoding
    * 表示 ptr 指向的具体数据结构, 即这个对象使用了什么数据结构作为底层实现
    * 取值
        * REDIS_ENCODING_INT long类型的整数
        * REDIS_ENCODING_EMBSTR embstr编码的简单动态字符串
        * REDIS_ENCODING_RAW 简单动态字符串
        * REDIS_ENCODING_HT 字典
        * REDIS_ENCODING_LINKEDLIST 双端链表
        * REDIS_ENCODING_ZIPLIST 压缩列表
        * REDIS_ENCODING_INSERT 整数集合
        * REDIS_ENCODING_SKIPLIST 跳跃表和字典
- refcount
    * 表示引用计数, 由于 C 语言并不具备内存回收功能, 所以 Redis 在自己的对象系统中添加了这个属性, 当一个对象的引用计数为0时, 则表示该对象已经不被任何对象引用, 则可以进行垃圾回收了.
- lru
    * 表示对象最后一次被命令程序访问的时间





