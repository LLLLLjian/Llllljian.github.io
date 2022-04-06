---
title: Docker_基础 (9)
date: 2022-01-11
tags: Docker
toc: true
---

### 修改运行中的DOCKER容器的端口映射

<!-- more -->

#### 前提
> 在docker run创建并运行容器的时候, 可以通过-p指定端口映射规则.但是, 我们经常会遇到刚开始忘记设置端口映射或者设置错了需要修改.当docker start运行容器后并没有提供一个-p选项或设置

##### 方法1: 删除原有容器, 重新建新容器
> 这个解决方案最为简单, 把原来的容器删掉, 重新建一个.当然这次不要忘记加上端口映射.
优点是简单快捷, 在测试环境使用较多.
缺点是如果是数据库镜像, 那重新建一个又要重新配置一次, 就比较麻烦了.

##### 方法2: 修改容器配置文件, 重启DOCKER服务
> 这个方法的优点是没有副作用, 操作简单.缺点是需要重启整个docker服务, 如果在同一个宿主机上运行着多个容器服务的话, 就会影响其他容器服务.
1. 先查看docker的root path
    ```bash
        # 如果没有修改过的话 默认就是 /var/lib/docker
        docker info | grep "Docker Root Dir"
    ```
2. 停止容器, 关闭docker服务
    ```bash
        # 如果不做的话 修改配置文件后会自动还原
        docker stop [hash_of_the_container]
        systemctl stop docker
    ```
2. 修改容器的配置文件
    ```bash
        vim /var/lib/docker/containers/[hash_of_the_container]/hostconfig.json

        "PortBindings":
        {
            # 80/tcp对应的是容器内部的8080端口
            "80/tcp":[
                # HostPort对应的是映射到宿主机的端口8080
                {"HostIp":"","HostPort":"8080"}
            ]
        }
    ```
3. 重启docker服务, 开启容器
    ```bash
        systemctl start docker
        docker start [hash_of_the_container]
    ```

##### 方法3: 利用DOCKER COMMIT新构镜像
> 这种方式的优点是不会影响统一宿主机上的其他容器, 缺点是管理起来显得比较乱, 没有第二种方法那么直观
- bash
    ```bash
        # 1. 停止docker容器
        docker stop container_id
        # 2. commit该docker容器
        docker commit container_id new_image:tag
        # 3. 用前一步生成的镜像重新起一个容器
        docker run --name container02 -p 3306:3306 new_image:tag
    ```





