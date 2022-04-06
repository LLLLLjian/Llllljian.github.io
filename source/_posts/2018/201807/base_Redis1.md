---
title: Redis_基础 (1)
date: 2018-07-17
tags: Redis
toc: true
---

### Redis基础
    Redis设计与实现学习笔记

<!-- more -->

#### Redis定义
- Redis是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、高性能的Key-Value数据库,并提供多种语言的API

#### Redis优势
- 性能极高 – Redis能读的速度是110000次/s,写的速度是81000次/s .
- 丰富的数据类型 – Redis支持二进制案例的 Strings, Lists, Hashes, Sets 及 Ordered Sets 数据类型操作.
- 原子 – Redis的所有操作都是原子性的,同时Redis还支持对几个操作全并后的原子性执行.
- 丰富的特性 – Redis还支持 publish/subscribe, 通知, key 过期等等特性

#### 和其它key-value储存区别
- 和Memcached类似,它支持存储的value类型相对更多,包括string(字符串)、list(链表)、set(集合)、zset(sorted set --有序集合)和hash(哈希类型)
- 与memcached一样,为了保证效率,数据都是缓存在内存中.区别的是redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件,并且在此基础上实现了master-slave(主从)同步.
- 这些数据类型都支持push/pop、add/remove及取交集并集和差集及更丰富的操作,而且这些操作都是原子性的.在此基础上,redis支持各种不同方式的排序

#### Redis服务相关
- 开启Redis服务
    * redis-server [配置文件路径 eg:/etc/redis/redis.conf]
    * redis-server [--port 指定开启端口, 默认是6379]
- 开启Redis终端
    * redis-cli [-h 127.0.0.1] [-p 6379]
- 关闭
    * redis-cli -h 127.0.0.1 -p 6379 shutdown
    * pkill redis-server
    * kill -p 进程号
- Redis配置
    * /etc/redis/redis.conf文件的内容
    * Redis终端下config get *获取所有配置
- Redis配置详解
    * daemonize no
        * Redis默认不是以守护进程的方式运行,可以通过该配置项修改,使用yes启用守护进程
    * pidfile /var/run/redis.pid
        * 当Redis以守护进程方式运行时,Redis默认会把pid写入/var/run/redis.pid文件,可以通过pidfile指定
    * port 6379
        * 指定Redis监听端口,默认端口为6379,作者在自己的一篇博文中解释了为什么选用6379作为默认端口,因为6379在手机按键上MERZ对应的号码,而MERZ取自意大利歌女Alessia Merz的名字
    * bind 127.0.0.1
        * 绑定的主机地址
    * timeout 300
        * 当客户端闲置多长时间后关闭连接,如果指定为0,表示关闭该功能
    * loglevel verbose
        * 指定日志记录级别,Redis总共支持四个级别: debug、verbose、notice、warning,默认为verbose
    * logfile stdout
        * 日志记录方式,默认为标准输出,如果配置Redis为守护进程方式运行,而这里又配置为日志记录方式为标准输出,则日志将会发送给/dev/null
    * databases 16
        * 设置数据库的数量,默认数据库为0,可以使用SELECT <dbid>命令在连接上指定数据库id
    * save <seconds> <changes>
        * 指定在多长时间内,有多少次更新操作,就将数据同步到数据文件,可以多个条件配合
        * Redis默认配置文件中提供了三个条件: 
        * save 900 1 表示900秒(15分钟)内有1个更改
        * save 300 10 表示300秒(5分钟)内有10个更改
        * save 60 10000 表示60秒内有10000个更改
    * rdbcompression yes
        * 指定存储至本地数据库时是否压缩数据,默认为yes,Redis采用LZF压缩,如果为了节省CPU时间,可以关闭该选项,但会导致数据库文件变的巨大
    * dbfilename dump.rdb
        * 指定本地数据库文件名,默认值为dump.rdb
    * dir ./
        * 指定本地数据库存放目录
    * slaveof <masterip> <masterport>
        * 设置当本机为slav服务时,设置master服务的IP地址及端口,在Redis启动时,它会自动从master进行数据同步
    * masterauth <master-password>
        * 当master服务设置了密码保护时,slav服务连接master的密码
    * requirepass foobared
        * 设置Redis连接密码,如果配置了连接密码,客户端在连接Redis时需要通过AUTH <password>命令提供密码,默认关闭
    * maxclients 128
        * 设置同一时间最大客户端连接数,默认无限制,Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数,如果设置 maxclients 0,表示不作限制.当客户端连接数到达限制时,Redis会关闭新的连接并向客户端返回max number of clients reached错误信息
    * maxmemory <bytes>
        * 指定Redis最大内存限制,Redis在启动时会把数据加载到内存中,达到最大内存后,Redis会先尝试清除已到期或即将到期的Key,当此方法处理 后,仍然到达最大内存设置,将无法再进行写入操作,但仍然可以进行读取操作.Redis新的vm机制,会把Key存放内存,Value会存放在swap区
    * appendonly no
        * 指定是否在每次更新操作后进行日志记录,Redis在默认情况下是异步的把数据写入磁盘,如果不开启,可能会在断电时导致一段时间内的数据丢失.因为 redis本身同步数据文件是按上面save条件来同步的,所以有的数据会在一段时间内只存在于内存中.默认为no
    * appendfilename appendonly.aof
        * 指定更新日志文件名,默认为appendonly.aof
    * appendfsync everysec
        * 指定更新日志条件,共有3个可选值:  
        * no: 表示等操作系统进行数据缓存同步到磁盘(快) 
        * always: 表示每次更新操作后手动调用fsync()将数据写到磁盘(慢,安全) 
        * everysec: 表示每秒同步一次(折衷,默认值)
    * vm-enabled no
        * 指定是否启用虚拟内存机制,默认值为no,简单的介绍一下,VM机制将数据分页存放,由Redis将访问量较少的页即冷数据swap到磁盘上,访问多的页面由磁盘自动换出到内存中(在后面的文章我会仔细分析Redis的VM机制)
    * vm-swap-file /tmp/redis.swap
        * 虚拟内存文件路径,默认值为/tmp/redis.swap,不可多个Redis实例共享
    * vm-max-memory 0
        * 将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有索引数据都是内存存储的(Redis的索引数据 就是keys),也就是说,当vm-max-memory设置为0的时候,其实是所有value都存在于磁盘.默认值为0
    * vm-page-size 32
        * Redis swap文件分成了很多的page,一个对象可以保存在多个page上面,但一个page上不能被多个对象共享,vm-page-size是要根据存储的 数据大小来设定的,作者建议如果存储很多小对象,page大小最好设置为32或者64bytes；如果存储很大大对象,则可以使用更大的page,如果不 确定,就使用默认值
    * vm-pages 134217728
        * 设置swap文件中的page数量,由于页表(一种表示页面空闲或使用的bitmap)是在放在内存中的,,在磁盘上每8个pages将消耗1byte的内存.
    * vm-max-threads 4
        * 设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的,可能会造成比较长时间的延迟.默认值为4
    * glueoutputbuf yes
        * 设置在向客户端应答时,是否把较小的包合并为一个包发送,默认为开启
    * hash-max-zipmap-entries 64
        * 指定在超过一定的数量或者最大的元素超过某一临界值时,采用一种特殊的哈希算法
    * hash-max-zipmap-value 512
        * 指定在超过一定的数量或者最大的元素超过某一临界值时,采用一种特殊的哈希算法
    * activerehashing yes
        * 指定是否激活重置哈希,默认为开启
    * include /path/to/local.conf
        * 指定包含其它的配置文件,可以在同一主机上多个Redis实例之间使用同一份配置文件,而同时各个实例又拥有自己的特定配置文件

### 关系型数据库
    关系型数据库是指采用了关系模型来组织数据的数据库.简单来说,关系模式就是二维表格模型.
    SQL标准(增删改查)、ACID属性(原子性(Atomicity)、一致性(Consistency)、隔离性(Isolation)、持久性(Durability)
- 代表
    * Oracle
    * DB2
    * Microsoft SQL Server
    * Microsoft Access
    * MySQL
- 优势
    * 容易理解,二维表的结构非常贴近现实世界,二维表格,容易理解.
    * 使用方便,通用的sql语句使得操作关系型数据库非常方便.
    * 易于维护,数据库的ACID属性,大大降低了数据冗余和数据不一致的概率.
- 劣势
    * 海量数据的读写效率.
        * 对于网站的并发量高,往往达到每秒上万次的请求,对于传统关系型数据库来说,硬盘I/o是一个很大的挑战.
    * 高扩展性和可用性.
        * 在基于web的结构中,数据库是最难以横向拓展的,当一个应用系统的用户量和访问量与日俱增的时候,数据库没有办法像web Server那样简单的通过添加更多的硬件和服务节点来拓展性能和负载能力
- 选择
    * 适合存储结构化数据
    * 这些数据通常需要做结构化查询,比如说Join,这个时候,关系型数据库就要胜出一筹.
    * 这些数据的规模、增长的速度通常是可以预期的.
    * 事务性、一致性,适合存储比较复杂的数据.

### 非关系型数据库
    NoSQL(Not Only SQL )
    要指那些非关系型的、分布式的,且一般不保证ACID的数据存储系统
    以键值来存储,且结构不稳定,每一个元组都可以有不一样的字段,这种就不会局限于固定的结构,可以减少一些时间和空间的开销
- 代表
    * Column-Oriented
        * 面向可拓展的分布式数据库
        * 解决传统数据库的扩展性上的缺陷
    * Key-Value
        * 面向高性能并发读写的key-value数据库
        * 具有极高的并发读写性能 
        * 典型代表 Redis
    * Document-Oriented
        * 面向海量数据访问的面向文档数据库
        * 可以在海量的数据库快速的查询数据
        * 典型代表 MongoDB
- 优势
    * 处理超大量的数据
    * 运行在便宜的PC服务器集群上
    * 击碎了性能瓶颈
- 劣势
    * 不能够像sql那样提供where字段属性的查询.因此适合存储较为简单的数据.有一些不能够持久化数据
- 适用场景
    * 对数据高并发读写
    * 对海量数据的高效率存储和访问
    * 对数据的高可扩展性和高可用性
- 选择
    * 适合存储非结构化数据
    * 这些数据通常用于模糊处理,例如全文搜索、机器学习,适合存储较为简单的数据
    * 这些数据是海量的,并且增长的速度是难以预期的
    * 按照key获取数据效率很高,但是对于join或其他结构化查询的支持就比较差

### 守护进程
    守护进程(Daemon Process),也就是通常说的 Daemon 进程(精灵进程),是 Linux 中的后台服务进程.它是一个生存期较长的进程,通常独立于控制终端并且周期性地执行某种任务或等待处理某些发生的事件.
    守护进程是个特殊的孤儿进程,这种进程脱离终端,为什么要脱离终端呢？之所以脱离于终端是为了避免进程被任何终端所产生的信息所打断,其在执行过程中的信息也不在任何终端上显示.由于在 linux 中,每一个系统与用户进行交流的界面称为终端,每一个从此终端开始运行的进程都会依附于这个终端,这个终端就称为这些进程的控制终端,当控制终端被关闭时,相应的进程都会自动关闭