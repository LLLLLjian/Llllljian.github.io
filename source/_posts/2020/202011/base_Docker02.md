---
title: Docker_基础 (02)
date: 2020-11-06
tags: Docker
toc: true
---

### 快来跟我一起学Docker
    快来学Docker容器！！！

<!-- more -->

#### 学习笔记
1. Docker 以 ubuntu15.10 镜像创建一个新容器,然后在容器里执行 bin/echo "Hello world",然后输出结果
    ```bash
        docker run ubuntu:15.10 /bin/echo "Hello world"
    ```
2. 创建交互式的容器
    ```bash
                         镜像名称:tag号
        docker run -i -t ubuntu:15.10 /bin/bash
    ```
3. 创建后台运行的容器
    ```bash
        docker run -itd -p 8080:8080 --name bce_test_brain_`date +%Y_%m_%d_%H_%M_%S` -m 10g --cpus=5 --net=host xxx:1.8.3 /bin/bash
    ```
    * 参数说明
        * -P 是容器内部端口随机映射到主机的高端口 宿主机:容器内端口
        * -name 容器名
        * -m 服务器内存
        * --cpu CPU
        * --net 不用配置网桥
        * xxx 要创建容器的镜像
        * 1.8.3 镜像标签
        * /bin/bash 
4. 查看容器
    ```bash
        # 查看运行中的docker
        docker ps
        # 查看所有的docker
        docker ps -a
    ```
5. 进入已启动的容器
    ```bash
        docker exec -it 容器id /bin/bash
    ```
6. 停止容器
    ```bash
        docker stop 容器id
    ```
7. 启动容器
    ```bash
        docker start 容器id
    ```





