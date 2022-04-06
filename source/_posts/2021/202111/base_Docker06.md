---
title: Docker_基础 (06)
date: 2021-11-25
tags: Docker
toc: true
---

### 快来跟我一起学Docker
    之前学的太浅了 现在看的深一点

<!-- more -->

#### 操作容器
- 启动
    * 主要命令是docker run
        ```bash
            # 输出一个 “Hello World”,之后终止容器
            # 跟在本地直接执行 /bin/echo 'hello world' 几乎感觉不出任何区别
            $ docker run ubuntu:18.04 /bin/echo 'Hello world'
            Hello world

            # 启动一个 bash 终端,允许用户进行交互
            # -t 选项让Docker分配一个伪终端(pseudo-tty)并绑定到容器的标准输入上, -i 则让容器的标准输入保持打开
            $ docker run -t -i ubuntu:18.04 /bin/bash
            root@af8bae53bdd3:/#
        ```
    * 当利用 docker run 来创建容器时,Docker 在后台运行的标准操作包括
        * 检查本地是否存在指定的镜像,不存在就从 registry 下载
        * 利用镜像创建并启动一个容器
        * 分配一个文件系统,并在只读的镜像层外面挂载一层可读写层
        * 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
        * 从地址池配置一个 ip 地址给容器
        * 执行用户指定的应用程序
        * 执行完毕后容器被终止
- 守护态运行
    * 更多的时候,需要让 Docker 在后台运行而不是直接把执行命令的结果输出在当前宿主机下. 此时,可以通过添加 -d 参数来实现
        ```bash
            $ docker run ubuntu:18.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
            hello world
            hello world
            hello world
            hello world

            $ docker run -d ubuntu:18.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
            77b2dc01fe0f3f1265df143181e7b9af5e05279a884f4776ee75350ea9d8017a

            $ docker container logs 77b2dc01fe
            hello world
            hello world
            hello world
            hello world
        ```

#### docker其它命令
- info
    * 显示Docker系统信息,包括镜像和容器数
    * 要关注的一个信息: **Docker Root Dir**, 这个地址是容器/镜像原始文件存放的位置,一旦磁盘不足会导致创建容器或者拉取镜像失败
        ```bash
            # 修改Docker Root Dir方式 记得换个大点的地方
            # 1 关闭docker服务
            $ systemstl stop docker.service
            # 2 修改配置(新增文件/修改文件)
            $ vim /etc/docker/daemon.json
            {
                "data-root": "/opt/docker/data"
            }
        ```
- inspect
    * 获取容器/镜像的元数据(启动命令,创建时间,磁盘挂载等...)



