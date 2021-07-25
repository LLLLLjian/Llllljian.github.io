---
title: Docker_基础 (01)
date: 2020-11-04
tags: Docker
toc: true
---

### 快来跟我一起学Docker
    快来学Docker容器！！！

<!-- more -->

#### 学之前的思考
1. Docker是什么
2. Docker能干什么
3. 跟Docker类似的有什么 为什么不学它
4. 我从今天的学习里知道了什么

#### Docker是什么
> Docker是一个开源的应用容器引擎,基于 Go 语言 并遵从 Apache2.0 协议开源
Docker 可以让开发者打包他们的应用以及依赖包到一个轻量级、可移植的容器中,然后发布到任何流行的 Linux 机器上,也可以实现虚拟化.
容器是完全使用沙箱机制,相互之间不会有任何接口(类似 iPhone 的 app),更重要的是容器性能开销极低

#### Docker的应用场景
1. Web 应用的自动化打包和发布
2. 自动化测试和持续集成、发布
3. 在服务型环境中部署和调整数据库或其他的后台应用
4. 从头编译或者扩展现有的 OpenShift 或 Cloud Foundry 平台来搭建自己的 PaaS 环境

#### 使用Docker之前, 大家在用什么
> 虚拟机(VM)
- 百度百科介绍虚拟机
    * 指通过软件模拟的具有完整硬件系统功能的、运行在一个完全隔离环境中的完整计算机系统.在实体计算机中能够完成的工作在虚拟机中都能够实现.在计算机中创建虚拟机时,需要将实体机的部分硬盘和内存容量作为虚拟机的硬盘和内存容量.每个虚拟机都有独立的CMOS、硬盘和操作系统,可以像使用实体机一样对虚拟机进行操作
- 优点
    * 隔离所有依赖项,并避免影响任何现有的应用程序及其依赖项
- 缺点
    * 每当有所改变时, 必须做新的快照, 以某种方式组织这些虚拟机快照的所有不同版本, 需要将代码中的更改以及任何依赖部署到其他环境中

#### Docker战胜VM的原因
> 从宿主机分配单独的资源, 不需要另一个操作系统来运行软件, 方便移植

#### Docker的进阶
> 使用Kubernetes部署和扩展
当需要在很多服务器上支持流量负载时,需要在所有服务器上运行先前的命令, 如果由于某个原因容器死亡, 必须去该服务器运行命令以重新启动, 跟虚拟机没什么区别
Kubernetes是一个开源系统,用于自动化容器化应用程序的部署、扩展和管理
Kubernetes将帮助你在任何地方以相同的方式部署应用程序.你只需要用声明性语言说出你想如何运行容器即可.你将拥有一个负载均衡器,运行最少量的容器,并且只有在需要时才可以向上扩展或向下缩小.你将规模运行所需的一切,并且你将在同一个地方拥有这一切

#### MacOS Docker安装
> Docker for Mac

#### Docker Hello World
> 输出Hello World
- eg
    ```bash
         $ docker run ubuntu:15.10 /bin/echo "Hello world"
         Hello world
    ```
- 参数解析
    * docker: Docker 的二进制执行文件
    * run: 与前面的 docker 组合来运行一个容器
    * ubuntu:15.10 指定要运行的镜像,Docker 首先从本地主机上查找镜像是否存在,如果不存在,Docker 就会从镜像仓库 Docker Hub 下载公共镜像.
    * /bin/echo "Hello world": 在启动的容器里执行的命令
- 运行交互式的容器
    * eg
        ```bash
            $ docker run -i -t ubuntu:15.10 /bin/bash
            root@0123ce188bd8:/#
        ```
    * 参数解析
        * -t: 在新容器内指定一个伪终端或终端
        * -i: 允许你对容器内的标准输入 (STDIN) 进行交互
        * 注意第二行 root@0123ce188bd8:/#,此时我们已进入一个 ubuntu15.10 系统的容器
- 启动容器(后台模式)
    * eg
        ```bash
            $ docker run -d ubuntu:15.10 /bin/sh -c "while true; do echo hello world; sleep 1; done"
            2b1b7a428627c51ab8810d541d759f072b4fc75487eed05812646b8534a2fe63
        ```
- 查看容器状态
    ```bash
        docker ps
        CONTAINER ID        IMAGE                  COMMAND              ...  
        5917eac21c36        ubuntu:15.10           "/bin/sh -c 'while t…"    ...
    ```
    * 输出详情
        * CONTAINER ID: 容器 ID
        * IMAGE: 使用的镜像
        * COMMAND: 启动容器时运行的命令
        * CREATED: 容器的创建时间
        * STATUS: 容器状态
            * created(已创建)
            * restarting(重启中)
            * running 或 Up(运行中)
            * removing(迁移中)
            * paused(暂停)
            * exited(停止)
            * dead(死亡)
        * PORTS: 容器的端口信息和使用的连接类型(tcp\udp)
        * NAMES: 自动分配的容器名称

