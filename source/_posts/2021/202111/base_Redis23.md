---
title: Redis_基础 (23)
date: 2021-11-02
tags: Redis
toc: true
---

### 复习之redis
    从头再看一遍redis

<!-- more -->

#### Redis基数统计
> HyperLogLog
- 基数统计
    * 统计一个集合中不重复元素的个数, 常见于计算独立用户数(UV). 
- 为什么不用set
    * 实现基数统计最直接的方法, 就是采用集合(Set)这种数据结构, 当一个元素从未出现过时, 便在集合中增加一个元素；如果出现过, 那么集合仍保持不变. 当页面访问量巨大, 就需要一个超大的 Set 集合来统计, 将会浪费大量空间. 另外, 这样的数据也不需要很精确, 到底有没有更好的方案呢
- 网站的UV
    * 通过 Set 实现
        ```bash
            > SADD uv 89757
            (integer) 1
            > SADD uv 89757
            (integer) 0
            > SADD uv 89756
            (integer) 1
            > SCARD uv
            2
        ```
    * 通过 Hash 实现
        ```bash
            > HSET uv1 userId:89757 1
            1
            > HSET uv1 userId:89757 1
            0
            > HLEN uv1
            1
        ```
    * 通过 HyperLogLog 实现
        ```bash
            > PFADD uv3 a
            (integer) true
            > PFADD uv3 b
            (integer) true
            > PFADD uv3 c
            (integer) true
            > PFADD uv3 d
            (integer) true
            > PFCOUNT uv3
            (integer) 4
        ```
    * 聚合两个页面的uv
        ```bash
            > PFADD uv4 a
            (integer) true
            > PFADD uv4 b
            (integer) true
            > PFADD uv4 z
            (integer) true
            > PFADD uv4 x
            (integer) true
            > PFADD uv4 c
            (integer) true
            > PFMERGE uv34 uv3 uv4
            (integer) 1
            > PFCOUNT uv34
            (integer) 7
        ```

#### Redis排序统计
- List
    * 按照元素插入 List 的顺序排序, 使用场景通常可以作为 消息队列、最新列表、排行榜；
- Sorted Set
    * 根据元素的 score 权重排序, 我们可以自己决定每个元素的权重值. 使用场景(排行榜, 比如按照播放量、点赞数). 
- 评论列表分页
    ```bash
        > LPUSH list1 1 2 3 4 5 6
        (integer) 6
        > LRANGE list1 0 4
        1) "6"
        2) "5"
        3) "4"
        4) "3"
        5) "2"
        > LPUSH list1 7
        (integer) 7
        > LRANGE list1 0 4
        1) "7"
        2) "6"
        3) "5"
        4) "4"
        5) "3"
    ```
- 小结
    * 只有不需要分页(比如每次都只取列表的前 5 个元素)或者更新频率低(比如每天凌晨统计更新一次)的列表才适合用 List 类型实现. 
    * 对于需要分页并且会频繁更新的列表, 需用使用有序集合 Sorted Set 类型实现. 
    * 另外, 需要通过时间范围查找的最新列表, List 类型也实现不了, 需要通过有序集合 Sorted Set 类型实现, 如以成交时间范围作为条件来查询的订单列表. 

#### Redis排行榜
- 一周音乐榜单, 需要实时更新播放量, 并且需要分页展示
    ```bash
        > ZADD musicTop 100000000 青花瓷 8999999 花田错
        (integer) 2
        > ZINCRBY musicTop 1 青花瓷
        100000001.0
        > ZINCRBY musicTop 1 青花瓷
        100000002.0
        > ZINCRBY musicTop 1 青花瓷
        100000003.0
        > ZINCRBY musicTop 1 青花瓷
        100000004.0
        > ZREVRANGE musicTop 0 0 WITHSCORES
        1) "青花瓷"
        2) 100000004.0
        > ZRANGEBYSCORE musicTop 1 100000004 WITHSCORES
        1) "花田错"
        2) 8999999.0
        3) "青花瓷"
        4) 100000004.0
    ```

#### Redis聚合统计
- 交集-共同好友
    ```bash
        > SADD user:码哥字节 R大 Linux大神 PHP之父
        (integer) 3
        > SADD user:大佬 Linux大神 Python大神 C++菜鸡
        (integer) 3
        > SINTERSTORE user:共同好友 user:码哥字节 user:大佬
        1
        > SMEMBERS user:共同好友
        1) "Linux大神"
    ```
- 差集-每日新增好友数
    ```bash
        > SADD user:20211101 1 2 3
        (integer) 3
        > SADD user:20211102 3 4 5
        (integer) 3
        > SDIFFSTORE user:new user:20211101 user:20211102
        2
        > SMEMBERS user:new
        1) "4"
        2) "5"
    ```
- 并集-总共新增好友
    ```bash
        > SUNIONSTORE userid:new user:20211101 user:20211102
        5
        > SMEMBERS userid:new
        1) "1"
        2) "2"
        3) "3"
        4) "4"
        5) "5"
    ```






