---
title: Interview_总结 (80)
date: 2020-03-23
tags: 
    - MySQL 
    - Interview
toc: true
---

### 面试题
    今日被问傻系列-主从复制

<!-- more -->

#### 主从数据库区别
> 从数据库(Slave)是主数据库的备份,当主数据库(Master)变化时从数据库要更新,这些数据库软件可以设计更新周期.这是提高信息安全的手段.主从数据库服务器不在一个地理位置上,当发生意外时数据库可以保存
1. 主从分工
    * 其中Master负责写操作的负载,也就是说一切写的操作都在Master上进行,而读的操作则分摊到Slave上进行.这样一来的可以大大提高读取的效率.在一般的互联网应用中,经过一些数据调查得出结论,读/写的比例大概在 10: 1左右 ,也就是说大量的数据操作是集中在读的操作,这也就是为什么我们会有多个Slave的原因.但是为什么要分离读和写呢？熟悉DB的研发人员都知道,写操作涉及到锁的问题,不管是行锁还是表锁还是块锁,都是比较降低系统执行效率的事情.我们这样的分离是把写操作集中在一个节点上,而读操作其其他的N个节点上进行,从另一个方面有效的提高了读的效率,保证了系统的高可用性.
2. 基本过程
    * Mysql的主从同步就是当master(主库)发生数据变化的时候,会实时同步到slave(从库).
    * 主从复制可以水平扩展数据库的负载能力,容错,高可用,数据备份.
    * 不管是delete、update、insert,还是创建函数、存储过程,都是在master上,当master有操作的时候,slave会快速的接受到这些操作,从而做同步.
3. 用途和条件
    * mysql主从复制用途
        1. 实时灾备,用于故障切换
        2. 读写分离,提供查询服务
        3. 备份,避免影响业务
    * 主从部署必要条件: 
        1. 主库开启binlog日志(设置log-bin参数)
        2. 主从server-id不同
        3. 从库服务器能连通主库

#### 主从同步的粒度、原理和形式
1. 三种主要实现粒度
    * statement : 会将对数据库操作的sql语句写道binlog中
    * row : 会将每一条数据的变化写道binlog中.
    * mixed : statement与row的混合.Mysql决定何时写statement格式的binlog, 何时写row格式的binlog.
2. 主要的实现原理、具体操作、示意图
    * 在master机器上的操作: 当master上的数据发生变化时,该事件变化会按照顺序写入bin-log中.当slave链接到master的时候,master机器会为slave开启binlog dump线程.当master的binlog发生变化的时候,bin-log dump线程会通知slave,并将相应的binlog内容发送给slave.
    * 在slave机器上操作: 当主从同步开启的时候,slave上会创建两个线程: I\O线程.该线程连接到master机器,master机器上的binlog dump 线程会将binlog的内容发送给该I\O线程.该I/O线程接收到binlog内容后,再将内容写入到本地的relay log；sql线程.该线程读取到I/O线程写入的ralay log.并且根据relay log.并且根据relay log 的内容对slave数据库做相应的操作.
    * MySQL主从复制原理图如下
        * 主库会生成一个 log dump 线程,用来给从库 i/o线程传binlog；
        * 从库生成两个线程,一个I/O线程,一个SQL线程；i/o线程去请求主库 的binlog,并将得到的binlog日志写到relay log(中继日志) 文件中；SQL 线程,会读取relay log文件中的日志,并解析成具体操作,来实现主从的操作一致,而最终数据一致；
        ![MySQL主从复制原理图](/img/20200323_1.jpg)

#### 造成主从延迟的原因
1. 主库针对写操作,顺序写binlog,从库单线程去主库顺序读”写操作的binlog”,从库取到binlog在本地原样执行(随机写),来保证主从数据逻辑上一致.mysql的主从复制都是单线程的操作,主库对所有DDL和DML产生binlog,binlog是顺序写,所以效率很高,slave的Slave_IO_Running线程到主库取日志,效率比较高, 由于Slave_SQL_Running也是单线程的,所以一个DDL卡主了,需要执行10分钟,那么所有之后的DDL会等待这个DDL执行完才会继续执行,这就导致了延时
2. 当主库的TPS并发较高时,产生的DDL数量超过slave一个sql线程所能承受的范围,那么延时就产生了,当然还有就是可能与slave的大型query语句产生了锁等待









