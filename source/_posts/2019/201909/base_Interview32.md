---
title: Interview_总结 (32)
date: 2019-09-18
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * redis中有几种类型
- A
    * 字符串string
        * 字符串类型是Redis中最为基础的数据存储类型,是一个由字节组成的序列,他在Redis中是二进制安全的,这便意味着该类型可以接受任何格式的数据,如JPEG图像数据货Json对象描述信息等,是标准的key-value,一般来存字符串,整数和浮点数.Value最多可以容纳的数据长度为512MB
        * 统计网站访问数量,当前在线人数等, incr命令
        * ![字符串操作](/img/20190918_1.png)
    * 列表list
        * Redis的列表允许用户从序列的两端推入或者弹出元素,列表由多个字符串值组成的有序可重复的序列,是链表结构,所以向列表两端添加元素的时间复杂度为0(1),获取越接近两端的元素速度就越快.这意味着即使是一个有几千万个元素的列表,获取头部或尾部的10条记录也是极快的.List中可以包含的最大元素数量是4294967295.
        * 最新消息排行榜 
        * 消息队列,以完成多程序之间的消息交换.可以用push操作将任务存在list中（生产者）,然后线程在用pop操作将任务取出进行执行
        * ![列表操作](/img/20190918_2.png)
    * 哈希hash
        * 可以看成具有String key和String value的map容器,可以将多个key-value存储到一个key中.每一个Hash可以存储4294967295个键值对
        * 存储、读取、修改用户属性（name,age,pwd等）
        * ![散列操作](/img/20190918_3.png)
    * 集合set
        * Redis的集合是无序不可重复的,和列表一样,在执行插入和删除和判断是否存在某元素时,效率是很高的.集合最大的优势在于可以进行交集并集差集操作.Set可包含的最大元素数量是4294967295
        * 利用交集求共同好友.
        * 利用唯一性,可以统计访问网站的所有独立IP.
        * 好友推荐的时候根据tag求交集,大于某个threshold（临界值的）就可以推荐
        * ![集合操作](/img/20190918_4.png)
    * 有序集合sorted set
        * 和set很像,都是字符串的集合,都不允许重复的成员出现在一个set中.他们之间差别在于有序集合中每一个成员都会有一个分数(score)与之关联,Redis正是通过分数来为集合中的成员进行从小到大的排序.尽管有序集合中的成员必须是卫衣的,但是分数(score)却可以重复
        * 可以用于一个大型在线游戏的积分排行榜,每当玩家的分数发生变化时,可以执行zadd更新玩家分数(score),此后在通过zrange获取几分top ten的用户信息
        * ![有序集合操作](/img/20190918_5.png)
    * 对key的通用操作
        * ![通用操作](/img/20190918_6.png)


#### 问题2
- Q
    * redis对象底层数据结构
- A
    * REDIS_ENCODING_INT : long 类型的整数
    * REDIS_ENCODING_EMBSTR : embstr 编码的简单动态字符串
    * REDIS_ENCODING_RAW : 简单动态字符串
    * REDIS_ENCODING_HT : 字典
    * REDIS_ENCODING_LINKEDLIST : 双端链表
    * REDIS_ENCODING_ZIPLIST : 压缩列表
    * REDIS_ENCODING_INTSET : 整数集合
    * REDIS_ENCODING_SKIPLIST : 跳跃表和字典
    * 字符串对象
        * 字符串对象的编码可以是int、raw或者embstr
        * 如果一个字符串的内容可以转换为long,那么该字符串就会被转换成为long类型,对象的ptr就会指向该long,并且对象类型也用int类型表示.
        * 普通的字符串有两种,embstr和raw. 如果字符串对象的长度小于39字节,就用embstr对象.否则用传统的raw对象
        * embstr的创建只需分配一次内存,而raw为两次, 相对地,释放内存的次数也由两次变为一次
        * embstr的objet和sds放在一起,更好地利用缓存带来的优势
        * redis并未提供任何修改embstr的方式,即embstr是只读的形式.对embstr的修改实际上是先转换为raw再进行修改
    * 列表对象
        * 列表对象的编码可以是ziplist或者linkedlist
        * ziplist是一种压缩链表,它的好处是更能节省内存空间,因为它所存储的内容都是在连续的内存区域当中的.当列表对象元素不大,每个元素也不大的时候,就采用ziplist存储
        * linkedlist是一种双向链表.它的结构比较简单,节点中存放pre和next两个指针,还有节点相关的信息.当每增加一个node的时候,就需要重新malloc一块内存
    * 哈希对象
        * 哈希对象的底层实现可以是ziplist或者hashtable
    * 集合对象
        * 集合对象的编码可以是intset或者hashtable
    * 有序集合对象
        * 有序集合的编码可能两种,一种是ziplist,另一种是skiplist与dict的结合


