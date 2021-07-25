---
title: 读书笔记 (02)
date: 2021-06-17
tags: Book
toc: true
---

### 还是要多读书鸭
    Docker容器与容器云读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### Docker基础
1. sudo docker
    * 因为Docker的命令行工具docker和Docker daemon是同一个二进制文件, 而Docker daemon负责接收并执行来自docker的命令, 它的运行需要root权限.同时, 从Docker 0.5.2版本开始, Docker daemon默认绑定一个Unix Socket来代替原有的TCP端口, 该Unix Socket默认是属于root用户的, 因此在执行docker命令时, 需要使用sudo来获取root权限
2. docker命令结构图
    * ![docker命令结构图](/img/20210617_1.png)
3. docker子命令分类
    * ![docker子命令分类](/img/20210617_2.png)
4. code_demo
    ```bash
        # 从官方hub拉取ubuntu:latest镜像
        sudo docker pull ubuntu
        # 从官方hub拉取 12.04tag的镜像
        sudo docker pull ubuntu:ubuntu12.04
        # 从特定的仓库拉取ubuntu镜像
        sudo docker pull SEL/ubuntu
        # 从其他服务器拉取镜像
        sudo docker pull 1.1.11:5000/sshd
        # 使用标签为latest的镜像ubuntu创建一个名为mytest的容器, 并为它分配一个伪终端执行/bin/bash命令
        sudo docker run -it --name mytest ubuntu:latest /bin/bash
    ```



