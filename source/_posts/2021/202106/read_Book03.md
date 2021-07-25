---
title: 读书笔记 (03)
date: 2021-06-18
tags: Book
toc: true
---

### 还是要多读书鸭
    Docker容器与容器云读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### Docker核心原理解读
> Docker通过namespace实现了资源隔离, 通过cgroups实现了资源限制, 通过写时复制(copy-on-write)实现了高效的文件操作

- 实现一个资源隔离的容器需要从哪些方面下手
    * 文件系统隔离: 使用后根目录的挂载点发生切换
    * 网络隔离: 容器必须有独立的IP、端口、路由等
    * 网络独立: 需要独立的主机名在网络中标示自己
    * 进程间通信隔离: 有了网络自然离不开通信, 信号量、消息队列和共享内存
    * 用户权限隔离: 权限问题, 需要对用户和用户组进行隔离
    * 进程号隔离: 在容器中运行的应用需要有进程号(PID), 自然也需要与宿主机中的PID进行隔离
- namespace资源隔离
    * ![namespace资源隔离](/img/20210618_1.png)
    * UTS namespace:主机名与域名
        * UNIX Time-sharing System namespace提供了主机名和域名的隔离, 这样每个Docker容器就可以拥有独立的主机名和域名, 在网络上可以被视为一个对立的节点, 而非宿主机上的一个进程.Docker中, 每个镜像基本都以自身所提供的服务名称来命名镜像的hostname, 且不会对宿主机产生任何影响, 其原理就是利用了UTS namespace
    * IPC namespace:信号量、消息队列和内存共享
        * Inter-Process Communication namespace涉及的IPC资源包括常见的信号量、消息队列和内存共享.申请IPC资源就申请了一个全局唯一的32位ID, 所以IPC namespace中实际上包含了系统IPC标识符以及实现POSIX消息队列的文件系统.在同一个IPC namespace下的进程彼此可见, 不同IPC namespace下的进程则互相不可见
    * PID namespace:进程编号
        * PID namespace对进程PID重新标号, 即两个不同namespace下的进程可以有相同PID.每个PID namespace都有自己的计数程序
    * Network namespace:网络设备、网络栈、端口等
        * network namespace主要提供了关于网络资源的隔离, 包括网络设备、IPv4和IPv6协议栈、IP路由表、防火墙、/proc/net目录、/sys/class/net目录、套接字等.一个物理的网络设备最多存在于一个network namespace中, 可以通过创建veth pair在不同的network namespace间创建管道, 以达成通信目的
    * Mount namespace:挂载点(文件系统)
        * mount namespace通过隔离文件系统挂载点对隔离文件系统提供支持, 隔离后, 不同mount namespace中的文件结构发生变化也不会互相影响.进程在创建mount namespace时, 会把当前的文件结构复制给新的namespace.新namespace中的所有mount操作都只会影响自身的文件系统, 但是**父子节点的namespace不能同时挂载一个文件夹**
    * User namespace:用户和用户组
        * user namespace主要隔离了安全相关的标识符(identifier)和属性(attribute), 包括用户ID、用户组ID、root目录、key(指密钥)以及特殊权限.通俗地讲, 一个普通用户的进程通过clone()创建的新进程在新user namespace中可以拥有不同的用户和用户组.这意味着一个进程在容器外属于一个没有特权的普通用户, 但他创建的容器进程却属于拥有所有权限的超级用户, 这个技术为容器提供了极大的自由


