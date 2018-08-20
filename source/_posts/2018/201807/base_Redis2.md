---
title: Redis_基础 (2)
date: 2018-07-18
tags: Redis
toc: true
---

### Redis数据类型
    redis是一种高级的key:value存储系统,了解一下数据类型

<!-- more -->

#### 综述
- 应用场景总结
    <table><thead><tr><th>类型</th><th>简介</th><th>特性</th><th>场景</th><tbody><tr><td>String(字符串)<td>二进制安全<td>可以包含任何数据,比如jpg图片或者序列化的对象,一个键最大能存储512M<td>---<tr><td>Hash(字典)<td>键值对集合,即编程语言中的Map类型<td>适合存储对象,并且可以像数据库中update一个属性一样只修改某一项属性值(Memcached中需要取出整个字符串反序列化成对象修改完再序列化存回去)<td>存储、读取、修改用户属性<tr><td>List(列表)<td>链表(双向链表)<td>增删快,提供了操作某一段元素的API<td>1,最新消息排行等功能(比如朋友圈的时间线) 2,消息队列<tr><td>Set(集合)<td>哈希表实现,元素不重复<td>1,添加、删除,查找的复杂度都是O(1) 2,为集合提供了求交集、并集、差集等操作<td>1,共同好友 2,利用唯一性,统计访问网站的所有独立ip 3,好用推荐时,根据tag求交集,大于某个阈值就可以推荐<tr><td>Sorted Set(有序集合)<td>将Set中的元素增加一个权重参数score,元素按score有序排列<td>数据插入集合时,已经进行天然排序<td>1,排行榜 2,带权重的消息队列</table>

#### 字符串
- String
    * Redis string是redis最基本的类型,可以理解成与Memcached一模一样的类型,一个key对应一个value
    * Redis string类型是二进制安全的.意思是redis的string可以包含任何数据.比如jpg图片或者序列化的对象
    * Redis string类型是Redis最基本的数据类型,一个键最大能存储512MB
- 使用
    * 实现业务上的统计计数需求
    * 使用INCR命令族(INCR, DECR, INCRBY),将字符串作为原子计数器[同上]
    * 使用APPEND命令追加字符串
    * 使用GETRANGE和SETRANGE命令,使字符串作为随机访问向量
    * 编码大量数据到一个很小的空间,或使用GETBIT和SETBIT命令,创建一个基于Redis的布隆过滤器
- 语法
    * 127.0.0.1:6379> COMMAND KEY_NAME
- 命令
    * SET key value 
        * 设置指定key的值
    * GET key 
        * 获取指定key的值.
    * GETRANGE key start end 
        * 返回key中字符串值的子字符,字符串的截取范围由start和end两个偏移量决定(包括start和end在内)
    * GETSET key value
        * 将给定key的值设为value,并返回key的旧值(old value).当key不存在时,返回 nil.当key存在但不是字符串类型时,返回一个错误
    * GETBIT key offset
        * 对key所储存的字符串值,获取指定偏移量上的位(bit).
    * MGET key1 [key2..]
        * 获取所有(一个或多个)给定key的值.
    * SETBIT key offset value
        * 对key所储存的字符串值,设置或清除指定偏移量上的位(bit).
    * SETEX key seconds value
        * 将值value关联到key,并将 key 的过期时间设为seconds(以秒为单位).
    * SETNX key value
        * 只有在key不存在时设置key的值.
    * SETRANGE key offset value
        * 用value参数覆写给定key所储存的字符串值,从偏移量offset开始.
    * STRLEN key
        * 返回key所储存的字符串值的长度.
    * MSET key value [key value ...]
        * 同时设置一个或多个key-value 对.
    * MSETNX key value [key value ...] 
        * 同时设置一个或多个key-value对,当且仅当所有给定key都不存在.
    * PSETEX key milliseconds value
        * 这个命令和SETEX命令相似,但它以毫秒为单位设置key的生存时间,而不是像SETEX命令那样,以秒为单位
    * INCR key
        * 将key中储存的数字值增一.
    * INCRBY key increment
        * 将key所储存的值加上给定的增量值(increment） .
    * INCRBYFLOAT key increment
        * 将key所储存的值加上给定的浮点增量值(increment） .
    * DECR key
        * 将key中储存的数字值减一.
    * DECRBY key decrement
        * key所储存的值减去给定的减量值(decrement） .
    * APPEND key value
        * 如果key已经存在并且是一个字符串,APPEND命令将指定的value追加到该key原来值(value)的末尾
- eg
    ```bash
        [llllljian@llllljian-virtual-machine src 10:21:42 #24]$ ./redis-cli
        127.0.0.1:6379> SET test_key tetst_value
        OK

        127.0.0.1:6379> GET test_key
        "tetst_value"

        127.0.0.1:6379> DEL test_key
        (integer) 1

        127.0.0.1:6379> GET test_key
        (nil)

        # GETRANGE start
                                       012345678
        127.0.0.1:6379> SET test_key1 "1 2 3 4 5"
        OK

        127.0.0.1:6379> GET test_key1
        "1 2 3 4 5"

        127.0.0.1:6379> GETRANGE test_key1 1 3
        " 2 "

        127.0.0.1:6379> GETRANGE test_key1 2 3
        "2 "
        
        127.0.0.1:6379> GETRANGE test_key1 0 -1
        "1 2 3 4 5"

        # GETRANGE end

        # GETSET start

        127.0.0.1:6379> GETSET db mongodb
        (nil)

        127.0.0.1:6379> GET db
        "mongodb"

        127.0.0.1:6379> GETSET db redis
        "mongodb"
        
        127.0.0.1:6379> GET db
        "redis"

        # GETSET end
    ```

#### 哈希
- Hash
    * Redis hash是一个键值(key=>value)对集合
    * Redis hash是一个string类型的field和value的映射表,hash特别适合用于存储对象
    * Redis中每个hash可以存储2^32 - 1键值对(40多亿）
- 使用
    * 用户要存储其全名、姓氏、年龄
- 命令
    * HDEL key field1 [field2]
        * 删除一个或多个哈希表字段
    * HEXISTS key field 
        * 查看哈希表key中,指定的字段是否存在
    * HGET key field
        * 获取存储在哈希表中指定字段的值
    * HGETALL key 
	    * 获取在哈希表中指定key的所有字段和值
	* HINCRBY key field increment 
	    * 为哈希表key中的指定字段的整数值加上增量increment .
	* HINCRBYFLOAT key field increment 
	    * 为哈希表key中的指定字段的浮点数值加上增量increment .
	* HKEYS key 
	    * 获取所有哈希表中的字段
	* HLEN key 
	    * 获取哈希表中字段的数量
	* HMGET key field1 [field2] 
	    * 获取所有给定字段的值
	* HMSET key field1 value1 [field2 value2 ] 
	    * 同时将多个field-value(域-值)对设置到哈希表key中.
	* HSET key field value 
	    * 将哈希表key中的字段field的值设为value .
	* HSETNX key field value 
	    * 只有在字段field不存在时,设置哈希表字段的值.
	* HVALS key 
	    * 获取哈希表中所有值
	* HSCAN key cursor [MATCH pattern] [COUNT count] 
	    * 迭代哈希表中的键值对
- eg
    ```bash
        127.0.0.1:6379> HMSET runoobkey name "redis tutorial" description "redis basic commands for caching" likes 20 visitors 23000
        OK

        127.0.0.1:6379> HGETALL runoobkey
        1) "name"
        2) "redis tutorial"
        3) "description"
        4) "redis basic commands for caching"
        5) "likes"
        6) "20"
        7) "visitors"
        8) "23000"

        127.0.0.1:6379> HEXISTS runoobkey likes
        (integer) 1

        127.0.0.1:6379> HEXISTS runoobkey likes2
        (integer) 0

        127.0.0.1:6379> HGET runoobkey visitors
        "23000"

        127.0.0.1:6379> HGET runoobkey visitors2
        (nil)
    ```

#### 列表
- List
    * Redis list是简单的字符串列表,按照插入顺序排序.你可以添加一个元素到列表的头部(左边）或者尾部(右边）
    * 一个list最多可以包含2^32 - 1个元素 (4294967295, 每个列表超过40亿个元素)
- 使用
    * 实现一个消息队列
    * 实现分页
    * 每篇博客评论都可以放在一个单独的list中
    * 为社交网络时间轴建模,用LPUSH往用户时间轴插入元素,使用LRANGE获取最近事项
    * 使用LPUSH和LTRIM命令创建一个不会超过给定数量元素的列表,只储存最近的N个元素
- 命令
    * BLPOP key1 [key2 ] timeout 
	    * 移出并获取列表的第一个元素,如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止.
	* BRPOP key1 [key2 ] timeout 
	    * 移出并获取列表的最后一个元素, 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止.
	* BRPOPLPUSH source destination timeout 
	    * 从列表中弹出一个值,将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止.
	* LINDEX key index 
	    * 通过索引获取列表中的元素
	* LINSERT key BEFORE|AFTER pivot value 
	    * 在列表的元素前或者后插入元素
	* LLEN key 
	    * 获取列表长度
	* LPOP key 
	    * 移出并获取列表的第一个元素
	* LPUSH key value1 [value2] 
	    * 将一个或多个值插入到列表头部
	* LPUSHX key value 
	    * 将一个值插入到已存在的列表头部
	* LRANGE key start stop 
	    * 获取列表指定范围内的元素
	* LREM key count value 
	    * 移除列表元素
	* LSET key index value 
	    * 通过索引设置列表元素的值
	* LTRIM key start stop 
	    * 对一个列表进行修剪(trim),就是说,让列表只保留指定区间内的元素,不在指定区间之内的元素都将被删除.
	* RPOP key 
	    * 移除并获取列表最后一个元素
	* RPOPLPUSH source destination 
	    * 移除列表的最后一个元素,并将该元素添加到另一个列表并返回
	* RPUSH key value1 [value2] 
	    * 在列表中添加一个或多个值
	* RPUSHX key value 
	    * 为已存在的列表添加值
- eg
    ```bash
        127.0.0.1:6379> LPUSH runoobkey redis
        (integer) 1

        127.0.0.1:6379> LPUSH runoobkey redis1
        (integer) 2

        127.0.0.1:6379> LPUSH runoobkey redis2
        (integer) 3

        127.0.0.1:6379> LPUSH runoobkey redis3
        (integer) 4
        
        127.0.0.1:6379> LPUSH runoobkey redis4
        (integer) 5

        127.0.0.1:6379> LRANGE runoobkey 0 10
        1) "redis4"
        2) "redis3"
        3) "redis2"
        4) "redis1"
        5) "redis"

        127.0.0.1:6379> LRANGE runoobkey 0 2
        1) "redis4"
        2) "redis3"
        3) "redis2"

        127.0.0.1:6379> LINDEX runoobkey 0 
        "redis4"

        127.0.0.1:6379> LINDEX runoobkey 2
        "redis2"

        127.0.0.1:6379> LINDEX runoobkey 1
        "redis3"

        127.0.0.1:6379> LLEN runoobkey
        (integer) 5
    ```

#### 集合
- Set
    * Redis 的 Set 是 String 类型的无序集合.集合成员是唯一的,这就意味着集合中不能出现重复的数据.
    * Redis 中集合是通过哈希表实现的,所以添加,删除,查找的复杂度都是 O(1).
    * 集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员).
- 使用
    * 把每一个用户的标签都存储在一个集合之中
    * 取交集并集
    * 用Redis集合取唯一性.
    * 用SPOP或SRANDMEMBER命令从集合中随机抽取元素
- 命令
    * SADD key member1 [member2] 
	    * 向集合添加一个或多个成员
	* SCARD key 
	    * 获取集合的成员数
	* SDIFF key1 [key2] 
	    * 返回给定所有集合的差集
	* SDIFFSTORE destination key1 [key2] 
	    * 返回给定所有集合的差集并存储在destination中
	* SINTER key1 [key2] 
	    * 返回给定所有集合的交集
	* SINTERSTORE destination key1 [key2] 
	    * 返回给定所有集合的交集并存储在destination中
	* SISMEMBER key member 
	    * 判断member元素是否是集合key的成员
	* SMEMBERS key 
	    * 返回集合中的所有成员
	* SMOVE source destination member 
	    * 将member元素从source集合移动到destination集合
	* SPOP key 
	    * 移除并返回集合中的一个随机元素
	* SRANDMEMBER key [count] 
	    * 返回集合中一个或多个随机数
	* SREM key member1 [member2] 
	    * 移除集合中一个或多个成员
	* SUNION key1 [key2] 
	    * 返回所有给定集合的并集
	* SUNIONSTORE destination key1 [key2] 
	    * 所有给定集合的并集存储在destination集合中
	* SSCAN key cursor [MATCH pattern] [COUNT count] 
	    * 迭代集合中的元素
- eg
    ```bash
        127.0.0.1:6379> SADD runoobkey1 redis
        (integer) 1

        127.0.0.1:6379> SADD runoobkey1 mongodb
        (integer) 1

        127.0.0.1:6379> SADD runoobkey1 mysql
        (integer) 1

        127.0.0.1:6379> SADD runoobkey1 mysql
        (integer) 0

        127.0.0.1:6379> SMEMBERS runoobkey1
        1) "redis"
        2) "mysql"
        3) "mongodb"

        127.0.0.1:6379> SADD runoobkey2 mysql
        (integer) 1

        127.0.0.1:6379> SMEMBERS runoobkey2
        1) "mysql"

        127.0.0.1:6379> SDIFF runoobkey1 runoobkey2 
        1) "redis"
        2) "mongodb"

        127.0.0.1:6379> SINTER runoobkey1 runoobkey2
        1) "mysql"
    ```

#### 有序集合
- zset[sorted set]
    * Redis 有序集合和集合一样也是string类型元素的集合,且不允许重复的成员.
    * 不同的是每个元素都会关联一个double类型的分数.redis正是通过分数来为集合中的成员进行从小到大的排序.
    * 有序集合的成员是唯一的,但分数(score)却可以重复.
    * 集合中最大的成员数为 232 - 1 (4294967295, 每个集合可存储40多亿个成员)
- 使用
    * 对排行榜进行操作.ZADD进行更新,ZRANGE取前几名,ZRANK通过给定用户名返回其排行.ZRANk和ZRAGE展示给定用户相似的用户及分数
    * 将用户年龄作为元素的分数,用户的id作为元素值,可以用ZRANGEBYSCORE命令取出年龄区间内的用户
- 命令
	* ZADD key score1 member1 [score2 member2] 
	    * 向有序集合添加一个或多个成员,或者更新已存在成员的分数
	* ZCARD key 
	    * 获取有序集合的成员数
	* ZCOUNT key min max 
	    * 计算在有序集合中指定区间分数的成员数
	* ZINCRBY key increment member 
	    * 有序集合中对指定成员的分数加上增量increment
	* ZINTERSTORE destination numkeys key [key ...] 
	    * 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合key中
	* ZLEXCOUNT key min max 
	    * 在有序集合中计算指定字典区间内成员数量
	* ZRANGE key start stop [WITHSCORES] 
	    * 通过索引区间返回有序集合成指定区间内的成员
	* ZRANGEBYLEX key min max [LIMIT offset count] 
	    * 通过字典区间返回有序集合的成员
	* ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT] 
	    * 通过分数返回有序集合指定区间内的成员
	* ZRANK key member 
	    * 返回有序集合中指定成员的索引
	* ZREM key member [member ...] 
	    * 移除有序集合中的一个或多个成员
	* ZREMRANGEBYLEX key min max 
	    * 移除有序集合中给定的字典区间的所有成员
	* ZREMRANGEBYRANK key start stop 
	    * 移除有序集合中给定的排名区间的所有成员
	* ZREMRANGEBYSCORE key min max 
	    * 移除有序集合中给定的分数区间的所有成员
	* ZREVRANGE key start stop [WITHSCORES] 
	    * 返回有序集中指定区间内的成员,通过索引,分数从高到底
	* ZREVRANGEBYSCORE key max min [WITHSCORES] 
	    * 返回有序集中指定分数区间内的成员,分数从高到低排序
	* ZREVRANK key member 
	    * 返回有序集合中指定成员的排名,有序集成员按分数值递减(从大到小)排序
	* ZSCORE key member 
	    * 返回有序集中,成员的分数值
	* ZUNIONSTORE destination numkeys key [key ...] 
	    * 计算给定的一个或多个有序集的并集,并存储在新的 key 中
	* ZSCAN key cursor [MATCH pattern] [COUNT count] 
	    * 迭代有序集合中的元素(包括元素成员和元素分值)
- eg
    ```bash
        127.0.0.1:6379>  ZADD runoobkey3 1 redis
        (integer) 1

        127.0.0.1:6379>  ZADD runoobkey3 3 redis
        (integer) 0

        127.0.0.1:6379>  ZADD runoobkey3 3 redis3
        (integer) 1

        127.0.0.1:6379>  ZADD runoobkey3 5 redis5
        (integer) 1

        127.0.0.1:6379>  ZADD runoobkey3 2 redis2
        (integer) 1

        127.0.0.1:6379>  ZADD runoobkey3 4 redis4
        (integer) 1

        127.0.0.1:6379>  ZADD runoobkey3 6 redis4
        (integer) 0

        127.0.0.1:6379>  ZADD runoobkey3 7 redis4
        (integer) 0

        127.0.0.1:6379> ZRANGE runoobkey3 0 10 WITHSCORES
        1) "redis2"
        2) "2"
        3) "redis"
        4) "3"
        5) "redis3"
        6) "3"
        7) "redis5"
        8) "5"
        9) "redis4"
        10) "7"
    ```
