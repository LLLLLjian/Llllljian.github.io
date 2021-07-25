---
title: 读书笔记 (05)
date: 2021-06-22
tags: Book
toc: true
---

### 还是要多读书鸭
    Docker容器与容器云读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### Docker架构概览
> Docker使用了传统的client-server架构模式.用户通过Docker client与Docker daemon建立通信, 并将请求发送给后者.而Docker的后端是松耦合结构, 不同模块各司其职, 有机组合, 完成用户的请求

![Docker架构总览](/img/20210622_1.png)

- volumedriver
    * 是volume数据卷存储操作的最终执行者, 负责volume的增删改查.屏蔽不同驱动实现的区别, 为上层调用者提供统一接口.docker中默认实现的volumedriver是local.默认将文件存储于docker根目录下的volume文件夹里.其他的volumedriver均是通过外部插件实现的, 是docker官方编写的libcontainer库
- Docker daemon
    * docker daemom 是docker最核心的后台进程, 他负责相应来自docker client 的请求, 然后将这些请求翻译成系统调用完成容器的操作, 该进程会在后台启动一个API server, 负责接收docker client发送的请求；接收到的请求将通过docker daemom分发调度, 再由具体函数来执行
    * execderiver
        * 是对Linux操作系统的namespace cgroups apparmor selinux 等容器运行所需的系统操作进行的一层二次封装, 其本质作用类似于LXC, 但是功能要更全面, 这也就是为什么LXC会作为execdriver 的一种实现而存在, 当然execdriver主要的实现, 也是现在的默认实现
    * network
        * docker 1.9版本以前, 网络通过networkdriver模块以及libcontainer库完成的.现在这部分功能已经分离成一个libnetwork库独立维护了.libnetwork抽象出一个容器模型, 并给调用者提供了一个统一抽象接口, 其目标不仅限于docker容器CNM模型对真实的容器网络抽象出了沙盒、端点、网络这3中对象, 具体网络驱动(包括内置的bridge、host、None和overlay驱动以及通过插件配置的外部驱动 )操作对象, 并通过网络控制器提供一个统一接口供调用者管理网络.网络驱动负责实现具体操作, 包括创建容器通信所需的网络.为容器提供一个network namespace, 这个网络所需的虚拟网卡, 分配通信所需的IP, 服务访问的端口和容器与宿主机之间的端口映射, 设置hosts, resolve.com、iptables等
    * graphdriver
        * 是所有与容器镜像相关操作的最终执行者.graphdriver会在docker工作目录下维护一组与镜像层对应的目录, 并记录下镜像层之间的关系以及与具体的graphdriver实现相关的元数据.这样, 用户对镜像的操作最终会被映射成对这些目录的文件及元数据的增删改查, 从而屏蔽掉不同文件存储实现对上层调用者的影响.在Linux环境下, 目前docker已经支持graphdriver包括aufs、btrfs、zfs、devicemapper、overlay和vfs
- image management
    * distribution
        * 负责把docker registry交互, 上传下载镜像以及存储于v2 registry有关的元数据
    * registry
        * 负责与docker registry有关身份验证、镜像查找、镜像验证以及管理registry mirror等交互操作
    * image
        * 负责与镜像元数据有关的存储, 查找, 镜像层的索引, 查找以及镜像tar包有关的导入、导出等操作
    * reference
        * 负责存储本地所有镜像的registry和tar名, 并维护与镜像ID之间的映射关系
    * layer
        * 负责与镜像层与容器层元数据有关的增删改查, 并负责将镜像层的增删改查操作映射到实际存储镜像层文件系统的graphdriver

