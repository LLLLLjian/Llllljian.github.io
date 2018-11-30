---
title: MySQL_基础 (16)
date: 2018-11-02
tags: MySQL
toc: true
---

### MySQL数据库简介
    突然觉得应该系统地再去学一遍MySQL,从零开始.

<!-- more -->

#### MySQL简介
    关系型数据库
- 特性
    * 使用C和C++编写,并使用了多种编译器进行测试,保证源代码的可移植性 　　
    * 支持AIX、FreeBSD、HP-UX、Linux、Mac OS、Novell Netware、OpenBSD、OS/2 Wrap、Solaris、Windows等多种操作系统
    * 为多种编程语言提供了API.编程语言包括C、C++、Python、Java、Perl、PHP、Eiffel、Ruby和Tcl等. 　　
    * 支持多线程,充分利用CPU资源 　　
    * 优化的SQL查询算法,有效地提高查询速度 　　
    * 既能够作为一个单独的应用程序应用在客户端服务器网络环境中,也能够作为一个库而嵌入到其他的软件中提供多语言支持,常见的编码如中文的GB 2312、BIG5,日文的Shift_JIS等都可以用作数据表名和数据列名 　　
    * 提供TCP/IP、ODBC和JDBC等多种数据库连接途径 　　
    * 提供用于管理、检查、优化数据库操作的管理工具 　　
    * 可以处理拥有上千万条记录的大型数据库


#### MySQL存储引擎
    说两个常见的
- MyISAM
    * MyISAM是MySQL的默认存储引擎
    * MyISAM不支持事务、也不支持外键,但其访问速度快,对事务完整性没有要求
    * 查询效率高
    * 表级锁
    * 备份和恢复方便(拷贝覆盖MYD数据文件和MYI索引文件即可)
- InnoDB
    * InnoDB存储引擎提供了具有提交、回滚和崩溃恢复能力的事务安全
    * 但是比起MyISAM存储引擎,InnoDB写的处理效率差一些并且会占用更多的磁盘空间以保留数据和索引
    * MySQL支持外键存储引擎只有InnoDB,在创建外键的时候,要求附表必须有对应的索引,子表在创建外键的时候也会自动创建对应的索引

#### MySQL数据库安装
- 管理密码修改
    ```sql
        SET PASSWORD FOR 'root'@'localhost'=PASSWORD('123456');
    ```
- 设置开机启动MySQL
    ```bash
        chkconfig mysql on
        chkconfig --list | grep mysql
    ```
- MySQL默认安装目录说明
    * /var/lib/mysql/ #数据库目录
    * /usr/share/mysql #配置文件目录
    * /usr/bin #相关命令目录
    * /etc/init.d/mysql #启动脚本
- 授权root用户远程登录连接
    ```sql
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
    ```