---
title: MySQL_基础 (48)
date: 2020-07-29
tags: 
    - MySQL 
    - Interview
toc: true
---

### 更好的理解MySQL
    MySQL数据库基础考察点

<!-- more -->

#### MySQL数据类型
- char和varchar
    * VARCHAR 比 CHAR 更节约空间
    * CHAR 比 VARCHAR 存储效率更好
    * VARCHAR 与 CHAR 的长度,如果存储内容超出指定长度,会被截断
    * 存储经常改变的数据,CHAR 不容易产生碎片
- 货币存储字段
    * 一般货币、科学数据使用DECIMAL,使用浮点数(f loat单精度 double双精度)会影响精度

#### MySQL存储引擎
- `InnoDB`和`MyISAM`区别
    * InnoDB支持事务,而MyISAM不支持事务
    * InnoDB支持行级锁,而MyISAM支持表级锁
    * InnoDB支持MVCC(多版本并发控制), 而MyISAM不支持
    * InnoDB支持外键,而MyISAM不支持
    * InnoDB不支持全文索引,而MyISAM支持.(X)
    * InnoDB: 如果要提供提交、回滚、崩溃恢复能力的事务安全(ACID兼容)能力,并要求实现并发控制,InnoDB是一个好的选择
    * MyISAM: 如果数据表主要用来插入和查询记录,则MyISAM(但是不支持事务)引擎能提供较高的处理效率

#### MySQL锁机制
- 读锁
    * 共享的 不堵塞 多个用户可以同时读一个资源, 互不干扰
- 写锁
    * 排他的, 一个写锁会阻塞其他的写锁和读锁,这样可以值允许一个人进行写入,防止其他用户读取正在写入的资源
- 行锁
    * Innodb使用行锁,最大程度地支持并发处理,但也带来了最大的锁开销
- 表锁
    * myisam使用表锁,系统性能开销最小,会锁定整张表

#### MySQL存储过程、触发器
- 存储过程
    * 使用场景: 通过把处理封装在容易使用的单元中, 简化复杂的操作
- 触发器
    * 提供给程序员和数据分析员来保证数据完整性的一种方法,他是与表事件相关的特殊的存储过程


