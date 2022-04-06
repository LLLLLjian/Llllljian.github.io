---
title: Docker_基础 (04)
date: 2021-11-23
tags: Docker
toc: true
---

### 快来跟我一起学Docker
    之前学的太浅了 现在看的深一点

<!-- more -->

#### docker的基本概念
- 镜像
    * Image
    * 是一个特殊的文件系统,除了提供容器运行时所需的程序、库、资源、配置等文件外,还包含了一些为运行时准备的一些配置参数(如匿名卷、环境变量、用户等). 镜像 不包含 任何动态数据,其内容在构建之后也不会被改变. 
    * 分层存储
        * 因为镜像包含操作系统完整的 root 文件系统,其体积往往是庞大的,因此在 Docker 设计时,就充分利用 Union FS 的技术,将其设计为分层存储的架构. 所以严格来说,镜像并非是像一个 ISO 那样的打包文件,镜像只是一个虚拟的概念,其实际体现并非由一个文件组成,而是由一组文件系统组成,或者说,由多层文件系统联合组成. 镜像构建时,会一层层构建,前一层是后一层的基础. 每一层构建完就不会再发生改变,后一层上的任何改变只发生在自己这一层. 比如,删除前一层文件的操作,实际不是真的删除前一层的文件,而是仅在当前层标记为该文件已删除. 在最终容器运行的时候,虽然不会看到这个文件,但是实际上该文件会一直跟随镜像. 因此,在构建镜像的时候,需要额外小心,每一层尽量只包含该层需要添加的东西,任何额外的东西应该在该层构建结束前清理掉. 分层存储的特征还使得镜像的复用、定制变的更为容易. 甚至可以用之前构建好的镜像作为基础层,然后进一步添加新的层,以定制自己所需的内容,构建新的镜像. 
- 容器
    * Container
    * 镜像(Image)和容器(Container)的关系,就像是面向对象程序设计中的 类 和 实例 一样,镜像是静态的定义,容器是镜像运行时的实体. 容器可以被创建、启动、停止、删除、暂停等. 容器的实质是进程,但与直接在宿主执行的进程不同,容器进程运行于属于自己的独立的 命名空间. 因此容器可以拥有自己的 root 文件系统、自己的网络配置、自己的进程空间,甚至自己的用户 ID 空间. 容器内的进程是运行在一个隔离的环境里,使用起来,就好像是在一个独立于宿主的系统下操作一样
- 仓库
    * Repository
    * 存放镜像的地方

#### 制作镜像
- commit
    * 语法格式
        ```
            docker commit [选项] <容器ID或容器名> [<仓库名>[:<标签>]]
        ```
    * eg
        ```
            $ docker commit \
                --author "Tao Wang <twang2218@gmail.com>" \
                --message "修改了默认网页" \
                webserver \
                nginx:v2
            sha256:07e33465974800ce65751acc279adc6ed2dc5ed4e0838f8b86f0c87aa1795214
        ```
    * 作用
        * 能将容器保存为镜像
    * 慎用commit
        * 通过观察docker diff的结果发现,除了真正想修改的文件之外,由于命令的执行,很多的文件被改动或添加了,这个会导致整个镜像变得特别臃肿
        * 此外,使用docker commit意味着对镜像的所有操作都是黑箱操作,生成的镜像也被称为黑箱镜像. 换句话说,就是除了制作镜像的人知道执行过什么命令、怎么生成的镜像,别人根本无从得知. 而且,即使是这个制作镜像的人,过一段时间后也无法记清具体的操作. 这种黑箱镜像的维护工作是非常痛苦的. 而且,回顾之前提及的镜像所使用的分层存储的概念,除当前层外,之前的每一层都是不会发生改变的,换句话说,任何修改的结果仅仅是在当前层进行标记、添加、修改,而不会改动上一层. 如果使用 docker commit 制作镜像,以及后期修改的话,每一次修改都会让镜像更加臃肿一次,所删除的上一层的东西并不会丢失,会一直如影随形的跟着这个镜像,即使根本无法访问到. 这会让镜像更加臃肿. 
- Dockerfile
    * Dockerfile 是一个文本文件,其内包含了一条条的 指令(Instruction),每一条指令构建一层,因此每一条指令的内容,就是描述该层应当如何构建
    * eg
        ```bash
            cat Dockerfile
            # 指定基础镜像
            FROM nginx
            # shell 格式: RUN <命令>,就像直接在命令行中输入的命令一样. 刚才写的 Dockerfile 中的 RUN 指令就是这种格式. 
            RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
        ```
    * 误区
        ```bash
            cat Dockerfile
            FROM debian:stretch

            RUN apt-get update
            RUN apt-get install -y gcc libc6-dev make wget
            RUN wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz"
            RUN mkdir -p /usr/src/redis
            RUN tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1
            RUN make -C /usr/src/redis
            RUN make -C /usr/src/redis install
        ```
    * 误区说明
        * Dockerfile 中每一个指令都会建立一层,RUN 也不例外. 每一个 RUN 的行为,就和刚才我们手工建立镜像的过程一样: 新建立一层,在其上执行这些命令,执行结束后,commit 这一层的修改,构成新的镜像. 而上面的这种写法,创建了 7 层镜像. 这是完全没有意义的,而且很多运行时不需要的东西,都被装进了镜像里,比如编译环境、更新的软件包等等. 结果就是产生非常臃肿、非常多层的镜像,不仅仅增加了构建部署的时间,也很容易出错
    * 正确写法
        ```bash
            cat Dockerfile
            FROM debian:stretch

            RUN set -x; buildDeps='gcc libc6-dev make wget' \
                && apt-get update \
                && apt-get install -y $buildDeps \
                && wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
                && mkdir -p /usr/src/redis \
                && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
                && make -C /usr/src/redis \
                && make -C /usr/src/redis install \
                && rm -rf /var/lib/apt/lists/* \
                && rm redis.tar.gz \
                && rm -r /usr/src/redis \
                && apt-get purge -y --auto-remove $buildDeps
        ```
    * 构建镜像
        ```bash
            $ mkdir mynginx
            $ cd mynginx
            $ touch Dockerfile 
            $ cat Dockerfile
            FROM nginx
            RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
            $ docker build -t nginx:v3 .
            Sending build context to Docker daemon 2.048 kB
            Step 1 : FROM nginx
            ---> e43d811ce2f4
            Step 2 : RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
            ---> Running in 9cdc27646c7b
            ---> 44aa4490ce2c
            Removing intermediate container 9cdc27646c7b
            Successfully built 44aa4490ce2c
        ```
    * 镜像构建上下文
        * docker build 命令最后有一个 .. . 在指定上下文路径
        * Docker 在运行时分为 Docker 引擎(也就是服务端守护进程)和客户端工具. Docker 的引擎提供了一组 REST API,被称为 Docker Remote API,而如 docker 命令这样的客户端工具,则是通过这组 API 与 Docker 引擎交互,从而完成各种功能. 因此,虽然表面上我们好像是在本机执行各种 docker 功能,但实际上,一切都是使用的远程调用形式在服务端(Docker 引擎)完成. 也因为这种 C/S 设计,让我们操作远程服务器的 Docker 引擎变得轻而易举. 当我们进行镜像构建的时候,并非所有定制都会通过 RUN 指令完成,经常会需要将一些本地文件复制进镜像,比如通过 COPY 指令、ADD 指令等. 而 docker build 命令构建镜像,其实并非在本地构建,而是在服务端,也就是 Docker 引擎中构建的. 那么在这种客户端/服务端的架构中,如何才能让服务端获得本地文件呢？这就引入了上下文的概念. 当构建的时候,用户会指定构建镜像上下文的路径,docker build 命令得知这个路径后,会将路径下的所有内容打包,然后上传给 Docker 引擎. 这样 Docker 引擎收到这个上下文包后,展开就会获得构建镜像所需的一切文件





