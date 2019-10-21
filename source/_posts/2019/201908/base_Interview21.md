---
title: Interview_总结 (21)
date: 2019-08-30
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * MySQL的索引机制,复合索引的使用原则
- A
    * 一般都会用书本中的目录来介绍索引机制,包括有些书本会有专门的快速检索附录,就很类似于数据库的索引.MySQL的索引包括4类：主键索引(primary key)、唯一索引(unique)、常规索引(index)、全文索引(fullindex).Show index from table_name; –查看表中的索引.Show status like ‘Handler_read%’ –查看索引的使用情况复合索引,一般遵循最左前缀原则,如table_a 的 a b c 三列建复合索引.create index ind_table_a on table_a(a,b,c);那么,只有在条件中用到a,或者a、b,或者a、b、c这样的情况下,才会用到刚建的复合索引.
    
#### 问题2
- Q
    * MySQL的表类型及MyISAM与InnoDB的区别
- A
    * MySQL常见的表类型(即存储引擎)
    show engines查看支持表类型配置.常见包括:MyISAM/Innodb/Memory/Merge/NDB
    其中,MyISAM和Innodb是最常用的两个表类型,各有优势,我们可以根据需求情况选择适合自己的表类型.
    * \[MyISAM]
    1)每个数据库存储包括3个文件：.frm(表定义)、MYD(数据文件)、MYI(索引文件)
    2)数据文件或索引文件可以指向多个磁盘
    3)Linux的默认引擎,win默认InnoDB
    4)面向非事务类型,避免事务型额外的开销
    5)适用于select、insert密集的表
    6)MyISAM默认锁的调度机制是写优先,可以通过LOW_PRIORITY_UPDATES设置
    7)MyISAM类型的数据文件可以在不同操作系统中COPY,这点很重要,布署的时候方便点.
    * \[Innodb]
    1)用于事务应用程序
    2)适用于update、delete密集的操作.执行select count(*) from table时,InnoDB要扫描一遍整个表来计算有多少行,但是MyISAM只要简单的读出保存好的行数即可.注意的是,当count(*)语句包含 where条件时,两种表的操作是一样的.DELETE FROM table时,InnoDB不会重新建立表,而是一行一行的删除.
    3)引入行级锁和外键的约束
    4)InnoDB不支持FULLTEXT类型的索引


#### 问题3
- Q
    * 简单说下快速排序算法
- A
    * 基本思想：通过一趟排序将待排序列分割成两部分,其中一部分比另一部分记录小,再分别对这两部分继续快速排序,以达到有序.
    * 算法实现：设有两个指针low和high,初值为low=1,high=n,设基准值为key(通常选第一个),则首先从high位置开始向前搜索,找到第一个比key小的记录与key交换,然后从low位置向后搜索,找到第一个比key大的记录与基准值交换,重复直至low=high为止.
    第一趟排序结果,key之前的记录值比key之后的记录值小.
    11 25 9 3 16 2 //选择11为key
    2 25 9 3 16 11
    2 11 9 3 16 25
    2 3 9 11 16 25

#### 问题4
- Q
    * awk、sed、sort的基本使用
- A
    * eg
        ```bash
            [例]：有如下文件test,请统计每个网址出现次数,用一句shell实现.
            a        www.baidu.com        20:00
            b        www.qq.com        19:30
            c        www.baidu.com        14:00
            d        www.baidu.com        23:00
            e        www.qq.com        20:30
            f        www.360.com        20:30
            【答案】cat test| awk -F’ ‘ ‘{print $2}’ |sort | uniq -c | sort -rn
        ```

#### 问题5
- Q
    * Memcached、redis的使用和理解
- A
    * Memcached和redis 都是一个key-value的内存式存储系统,通过hash表来存储检索结果,做到强大的缓存机制.像新浪的微博、淘宝等大流量站点都必须的使用了这些东东.
    * Memcache是一个高性能的分布式的内存对象缓存系统,通过在内存里维护一个统一的巨大的hash表,它能够用来存储各种格式的数据,包括图像、视频、文件以及数据库检索的结果等.简单的说就是将数据调用到内存中,然后从内存中读取,从而大大提高读取速度.
    * redis是一个key-value存储系统.和Memcached类似,它支持存储的value类型相对更多,包括string(字符串)、list(链表)、set(集合)和zset(有序集合).

