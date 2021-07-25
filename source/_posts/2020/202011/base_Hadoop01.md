---
title: Hadoop_基础 (01)
date: 2020-11-20
tags: Hadoop
toc: true
---

### 快来跟我一起学HDFS
    还需要学一下大数据
    先看看Hadoop

<!-- more -->

#### Hadoop
> Apache™Hadoop®项目开发了用于可靠,可扩展的分布式计算的开源软件.
Apache Hadoop软件库是一个框架,该框架允许使用简单的编程模型跨计算机集群对大型数据集进行分布式处理.它旨在从单个服务器扩展到数千台机器,每台机器都提供本地计算和存储.库本身不依赖于硬件来提供高可用性,而是被设计用来检测和处理应用程序层的故障,因此可以在计算机集群的顶部提供高可用性服务,而每台计算机都容易出现故障
- 官网
    * http://hadoop.apache.org/
- 模块
    * Hadoop Common：支持其他Hadoop模块的通用实用程序.
    * Hadoop分布式文件系统(HDFS™)：一种分布式文件系统,可提供对应用程序数据的高吞吐量访问.
    * Hadoop YARN：用于作业调度和集群资源管理的框架.
    * Hadoop MapReduce：基于YARN的系统,用于并行处理大数据集.
    * Hadoop Ozone： Hadoop的对象存储.
- 插入一个相关项目(接下来要学的点)
    * Spark: 一种用于Hadoop数据的快速通用计算引擎.Spark提供了一个简单而富于表现力的编程模型,该模型支持广泛的应用程序,包括ETL,机器学习,流处理和图形计算.

#### 分布式文件系统架构
- FS
    * File System
    * 文件系统是基于硬盘之上的一个文件管理的工具
    * 用户操作文件系统可以和硬盘进行解耦
- DFS
    * Distributed File System
    * 分布式文件系统
    * 将数据存放在多台电脑上存储
    * 分布式文件系统有很多
    * HDFS是MapReduce计算的基础

##### 概念
- 文件存放在一个磁盘上效率肯定是低的
    * 读取效率低
    * 如果文件特别大会超出单机的存储范围
- 字节数组
    * 文件在磁盘真实存储文件的抽象概念
- 切分数据
    * 对字节数据进行切分
- 拼接数据
    * 按照数组的偏移量将数据连接到一起
- 偏移量
    * 当前数据在数组中的相对位置
    * 数组都有对应的索引(下标), 可以快速的定位数据
- 数据存储的原理
    * 不管文件的大小, 所有的文件都是由字节数组成的
    * 如果我们要切分文件, 就是将一个字节数组分成多份
    * 我们将切分后的数据拼接到一起, 数据可以继续使用
    * 我们需要根据数据的偏移量将他们重新拼接到一起

##### Block拆分标准
- 拆分的数据块需要等大
    * 数据计算的时候简化问题复杂度
    * 数据拉取的时间相对一致
    * 通过偏移量就知道这个块的位置
    * 进行分布式算法设计的时候,数据不统一算法很难设计
- 数据块Block
    * 在Hadoop1默认大小为64M, 在Hadoop2及以后默认大小为128M
    * 同一个文件中,每个子数据块大小要一致, 除了最后一个节点
    * 不同文件中,块的大小可以不一致
    * 数据被切分后的一个整体
    * 真实情况下, 会根据文件大小和集群节点的数量综合考虑快块的大小
    * 数据块的个数 = ceil(文件大小/每个块的大小)
- 注意事项
    * HDFS中一旦文件被存储, 数据不允许被修改
        * 修改会影响偏移量
        * 修改会导致数据倾斜
        * 修改数据会导致蝴蝶效应
    * 可以被追加, 但是不推荐
    * 一般HDFS存储的都是历史数据

##### Block数据安全
- 肯定要对存储数据做备份
- 备份的数据肯定不能存放在一个节点上
    * 使用数据的时候可以就近获取数据
- 所以备份的数量要小于等于节点的数量
- 每个数据块都会有三个副本, 相同副本是不会存放在同一个节点上
- 副本的数量可以变更, 但是Block的大小是不能改变的

##### Block的管理效率
- 需要专门给节点进行分工
    * 存储 DataNode
    * 记录 NameNode

##### 伪分布式搭建
- demo
    ```bash
        [ubuntu@llllljian-cloud-tencent ~ 00:35:07 #5]$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
        Generating public/private rsa key pair.
        Your identification has been saved in /home/ubuntu/.ssh/id_rsa.
        Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub.
        The key fingerprint is:
        SHA256:XOHj5TWLUYX3p6jbGdcKdQbaBjiuwuSM1MeNXb6xTho ubuntu@llllljian-cloud-tencent
        ....
        # ssh-copy-id ubuntu@132.232.60.97 ~/.ssh/id_rsa.pub
        [ubuntu@llllljian-cloud-tencent ~ 00:40:23 #8]$ ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@132.232.60.97
        /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/ubuntu/.ssh/id_rsa.pub"
        The authenticity of host '132.232.60.97 (132.232.60.97)' can't be established.
        ECDSA key fingerprint is SHA256:NziKdGoPabABJQEaFKxVwz07AiIOBFOnT9yccML1jfM.
        Are you sure you want to continue connecting (yes/no)? yes
        /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
        /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
        ubuntu@132.232.60.97's password: 

        Number of key(s) added: 1

        Now try logging into the machine, with:   "ssh 'ubuntu@132.232.60.97'"
        and check to make sure that only the key(s) you wanted were added.

        [ubuntu@llllljian-cloud-tencent ~ 00:41:29 #9]$ ssh ubuntu@132.232.60.97
        Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-130-generic x86_64)

        * Documentation:  https://help.ubuntu.com
        * Management:     https://landscape.canonical.com
        * Support:        https://ubuntu.com/advantage

        Last login: Mon Nov 23 00:32:25 2020 from 111.194.49.36
        # 这两步操作主要是为了去除之后ssh免密钥登陆的时候还要输入yes
        [ubuntu@llllljian-cloud-tencent ~ 00:42:04 #1]$ ssh ubuntu@localhost
        [ubuntu@llllljian-cloud-tencent ~ 00:43:26 #1]$ ssh ubuntu@127.0.0.1
        [ubuntu@llllljian-cloud-tencent ~ 01:12:30 #3]$ wget https://archive.apache.org/dist/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz
        [ubuntu@llllljian-cloud-tencent ~ 01:13:42 #5]$ tar -zxvf hadoop-2.6.5.tar.gz
        [ubuntu@llllljian-cloud-tencent ~ 01:14:22 #7]$ cd hadoop-2.6.5/etc/hadoop/
    ```
    * 修改hadoop-env.sh
        ```bash
            export JAVA_HOME=/home/ubuntu/jdk1.8.0_271
        ```
    * 修改core-site.xml
        ```bash
            <configuration>
                <property>
                    <name>fs.defaultFS</name>
                    <value>hdfs://llllljian-cloud-tencent:9001</value>
                </property>
                <property>
                    <name>hadoop.tmp.dir</name>
                    <value>/home/ubuntu/hadoop/local</value>
                </property>
            </configuration>
        ```
    * 修改hdfs-site.xml
        ```bash
            <configuration>
                <!-- 设置secondarynamenode的http通讯地址 -->
                <property>
                        <name>dfs.namenode.secondary.http-address</name>
                        <value>llllljian-cloud-tencent:50090</value>
                </property>
            
                <!-- 设置hdfs副本数量 -->
                <property>
                        <name>dfs.replication</name>
                        <value>1</value>
                </property>
            </configuration>
        ```
    * 修改mapred-site.xml
        ```bash
            <configuration>
                <property>
                    <name>mapreduce.framework.name</name>
                    <value>yarn</value>
                </property>
            </configuration>
        ```
    * 修改yarn-site.xml
        ```bash
            <configuration>
                <property>
                    <name>yarn.nodemanager.aux-services</name>
                    <value>mapreduce_shuffle</value>
                </property>
            </configuration>
        ```
    * 修改slave
        ```bash
            lcoalhost
        ```
    * 继续执行命令
        ```bash
            hdfs namenode -format

            start-dfs.sh

            [ubuntu@llllljian-cloud-tencent hadoop 21:35:31 #13]$ jps
            2160 DataNode
            2032 NameNode
            16697 Jps
            2363 SecondaryNameNode
        ```





