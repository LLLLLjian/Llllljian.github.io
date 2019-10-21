---
title: Interview_总结 (17)
date: 2019-02-27
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * PHP获取客户端IP和服务器IP
- A
    ```php
        // 获取服务器端IP
        $_SERVER['SERVER_ADDR'] 
        // 客户端IP
        $_SERVER['REMOTE_ADDR'] 
    ```

#### 问题2
- Q
    * PHP打印上一个月第一天和最后一天
- A
    ```php
        echo date('Y-m-01', strtotime('-1 month'));
        echo date('Y-m-t', strtotime('-1 month'));
    ```

#### Redis和memcache、MongoDB的区别
- memcache
    * 优点
        * Memcached可以利用多核优势,单实例吞吐量极高,可以达到几十万QPS(取决于key、value的字节大小以及服务器硬件性能,日常环境中QPS高峰大约在4-6w左右).适用于最大程度扛量.
        * 支持直接配置为session handle.
    * 局限性
        * 只支持简单的key/value数据结构,不像Redis可以支持丰富的数据类型.
        * 无法进行持久化,数据不能备份,只能用于缓存使用,且重启后数据全部丢失.
        * 无法进行数据同步,不能将MC中的数据迁移到其他MC实例中.
        * Memcached内存分配采用Slab Allocation机制管理内存,value大小分布差异较大时会造成内存利用率降低,并引发低利用率时依然出现踢出等问题.需要用户注重value设计
- Redis
    * 优点
        * 支持多种数据结构,如string(字符串) list(双向链表) dict(hash表) set(集合) zset(排序set) hyperloglog(基数估算)
        * 支持持久化操作,可以进行aof及rdb数据持久化到磁盘,从而进行数据备份或数据恢复等操作,较好的防止数据丢失的手段.
        * 支持通过Replication进行数据复制,通过master-slave机制,可以实时进行数据的同步复制,支持多级复制和增量复制,master-slave机制是Redis进行HA的重要手段.
        * 单线程请求,所有命令串行执行,并发情况下不需要考虑数据一致性问题.
        * 支持pub/sub消息订阅机制,可以用来进行消息订阅与通知.
        * 支持简单的事务需求,但业界使用场景很少,并不成熟
    * 局限性
        * Redis只能使用单线程,性能受限于CPU性能,故单实例CPU最高才可能达到5-6wQPS每秒(取决于数据结构,数据大小以及服务器硬件性能,日常环境中QPS高峰大约在1-2w左右).
        * 支持简单的事务需求,但业界使用场景很少,并不成熟,既是优点也是缺点.
        * Redis在string类型上会消耗较多内存,可以使用dict(hash表)压缩存储以降低内存耗用
- MongoDB
    * 非关系型数据库,随时应对动态增加的数据项
- 区别
    * 性能
        * redis和memcache差不多,要大于mongodb
    * 操作的便利性
        * memcache数据结构单一
        * redis丰富一些,数据操作方面,redis更好一些,较少的网络IO次数
        * mongodb支持丰富的数据表达,索引,最类似关系型数据库,支持的查询语言非常丰富
    * 可靠性(持久化)
        * redis支持(快照、AOF)：依赖快照进行持久化,aof增强了可靠性的同时,对性能有所影响
        * memcache不支持,通常用在做缓存,提升性能；
        * MongoDB从1.8版本开始采用binlog方式支持持久化的可靠性
    * 数据一致性(事务支持)
        * Memcache 在并发场景下,用cas保证一致性
        * redis事务支持比较弱,只能保证事务中的每个操作连续执行
        * mongoDB不支持事务
    * 数据分析
        * mongoDB内置了数据分析的功能(mapreduce),其他不支持
    * 应用场景
        * redis：数据量较小的更性能操作和运算上
        * memcache：用于在动态系统中减少数据库负载,提升性能;做缓存,提高性能(适合读多写少,对于数据量比较大,可以采用sharding)
        * MongoDB:主要解决海量数据的访问效率问题

#### 问题3
- Q
    * $str = "hello 中国你好"; echo strlen($str);
- A
    ```php
        // UTF-8编码下 汉字长度为3
        $str = "hello 中国你好";
        // 17
        echo strlen($str);

        // GBK编码下 汉字长度为2
        $str = "hello 中国你好";
        // 14
        echo strlen($str);
    ```

#### 问题4
- Q
    * 合并两个数组有几种方式 有什么不同
- A
    ```php
        $array1 = array(2,4,"color" => "red");
        $array2 = array("a", "b", "color" => "green", "shape" => "trapezoid", 4);
        $result = array_merge($array1, $array2);
        echo "----------------array_merge---------------".PHP_EOL;
        print_r($result);
        echo "----------------+++++++++++---------------".PHP_EOL;
        print_r($array1+$array2);
        echo "----------------array_merge_recursive---------------".PHP_EOL;
        print_r(array_merge_recursive($array1,$array2));

        ----------------array_merge--------------- 
        array(7) { 
            [0]=> int(2) 
            [1]=> int(4) 
            ["color"]=> string(5) "green" 
            [2]=> string(1) "a" 
            [3]=> string(1) "b" 
            ["shape"]=> string(9) "trapezoid" 
            [4]=> int(4) } 
        ----------------+++++++++++--------------- 
        array(5) { 
            [0]=> int(2) 
            [1]=> int(4) 
            ["color"]=> string(3) "red"
            ["shape"]=> string(9) "trapezoid" 
            [2]=> int(4) } 
        ----------------array_merge_recursive--------------- 
        array(7) { 
            [0]=> int(2) 
            [1]=> int(4) 
            ["color"]=> array(2) { 
                [0]=> string(3) "red" 
                [1]=> string(5) "green" } 
            [2]=> string(1) "a" 
            [3]=> string(1) "b" 
            ["shape"]=> string(9) "trapezoid" 
            [4]=> int(4) } 
    ```
- 解释
    * 对于相同的字符串索引,
        * array_merge则会用后面的值覆盖前面出现的值;
        * +会用前面出现过的值覆盖后面相同的key;
        * array_merge_recursive则会把相同的索引放到一个数组里面,增加数组的维度;
    * 对于相同的数字索引,
        * array_merge则会给重复的值重建索引(索引值从0开始);
        * +仍然是用前面出现过的值覆盖后面的值;
        * array_merge_recursive和array_merge的处理方法一样.
