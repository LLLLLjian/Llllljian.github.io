---
title: Docker_基础 (05)
date: 2021-11-24
tags: Docker
toc: true
---

### 快来跟我一起学Docker
    之前学的太浅了 现在看的深一点

<!-- more -->

#### Dockerfile指令详解
- COPY复制文件
    * 格式
        ```bash
            COPY [--chown=<user>:<group>] <源路径>... <目标路径>
            COPY [--chown=<user>:<group>] ["<源路径1>",... "<目标路径>"]
        ```
    * eg
        ```bash
            COPY package.json /usr/src/app/

            COPY hom* /mydir/
            COPY hom?.txt /mydir/

            COPY --chown=55:mygroup files* /mydir/
            COPY --chown=bin files* /mydir/
            COPY --chown=1 files* /mydir/
            COPY --chown=10:11 files* /mydir/
        ```
- ADD更高级的复制文件
    * 与COPY命令基本一致, 但如果 <源路径> 为一个 tar 压缩文件的话,压缩格式为 gzip, bzip2 以及 xz 的情况下,ADD 指令将会自动解压缩这个压缩文件到 <目标路径> 去
- CMD容器启动命令
    * CMD 指令就是用于指定默认的容器主进程的启动命令的
    * 格式
        ```bash
            shell 格式: CMD <命令>
            exec 格式: CMD ["可执行文件", "参数1", "参数2"...]
            参数列表格式: CMD ["参数1", "参数2"...]. 在指定了 ENTRYPOINT 指令后,用 CMD 指定具体的参数. 
        ```
    * eg
        ```bash
            CMD echo $HOME # 实际执行中会转化为 CMD [ "sh", "-c", "echo $HOME" ]

            # nginx 后台运行
            CMD ["nginx", "-g", "daemon off;"]
        ```
- ENTRYPOINT入口点
    * ENTRYPOINT 的格式和 RUN 指令格式一样,分为 exec 格式和 shell 格式. ENTRYPOINT 的目的和 CMD 一样,都是在指定容器启动程序及参数. ENTRYPOINT 在运行时也可以替代,不过比 CMD 要略显繁琐,需要通过 docker run 的参数 --entrypoint 来指定. 当指定了 ENTRYPOINT 后,CMD 的含义就发生了改变,不再是直接的运行其命令,而是将 CMD 的内容作为参数传给 ENTRYPOINT 指令
    * eg
        ```bash
            <ENTRYPOINT> "<CMD>"
        ```
    * demo1
        ```bash
            $ cat Dockerfile
            FROM ubuntu:18.04
            RUN apt-get update \
                && apt-get install -y curl \
                && rm -rf /var/lib/apt/lists/*
            CMD [ "curl", "-s", "http://myip.ipip.net" ]

            $ docker build -t myip .

            $ docker run myip
            当前 IP xx.xx.xx.xx 来自: xx xx

            # 想看HTTP头信息 需要加参数 -i
            $ docker run myip -i
            docker: Error response from daemon: invalid header field value "oci runtime error: container_linux.go:247: starting container process caused \"exec: \\\"-i\\\": executable file not found in $PATH\"\n".

            $ docker run myip curl -s http://myip.ipip.net -i

            $ cat Dockerfile
            FROM ubuntu:18.04
            RUN apt-get update \
                && apt-get install -y curl \
                && rm -rf /var/lib/apt/lists/*
            ENTRYPOINT [ "curl", "-s", "http://myip.ipip.net" ]

            $ docker build -t myip .

            $ docker run myip
            当前 IP xx.xx.xx.xx 来自: xx xx

            $ docker run myip -i
            HTTP/1.1 200 OK
            Server: nginx/1.8.0
            Date: Tue, 22 Nov 2021 05:12:40 GMT
            Content-Type: text/html; charset=UTF-8
            Vary: Accept-Encoding
            X-Powered-By: PHP/5.6.24-1~dotdeb+7.1
            X-Cache: MISS from cache-2
            X-Cache-Lookup: MISS from cache-2:80
            X-Cache: MISS from proxy-2_6
            Transfer-Encoding: chunked
            Via: 1.1 cache-2:80, 1.1 proxy-2_6:8006
            Connection: keep-alive

            当前 IP xx.xx.xx.xx 来自: xx xx
        ```
    * demo2
        ```bash
            # 用root用户做一些前置准备工作 但是真正启动服务的是另一个用户
            $ cat Dockerfile
            FROM alpine:3.4
            ...
            RUN addgroup -S redis && adduser -S -G redis redis
            ...
            ENTRYPOINT ["docker-entrypoint.sh"]

            EXPOSE 6379
            CMD [ "redis-server" ]

            $ cat docker-entrypoint.sh
            # !/bin/sh
            # 根据 CMD 的内容来判断,如果是 redis-server 的话,则切换到 redis 用户身份启动服务器,否则依旧使用 root 身份执行
            ...
            # allow the container to be started with `--user`
            if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
                find . \! -user redis -exec chown redis '{}' +
                exec gosu redis "$0" "$@"
            fi

            exec "$@"
        ```
- ENV设置环境变量
    * 格式
        ```bash
            ENV <key> <value>
            ENV <key1>=<value1> <key2>=<value2>...
        ```
    * eg
        ```bash
            $ cat Dockerfile
            ENV NODE_VERSION 7.2.0

            RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
            && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
            && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
            && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
            && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
            && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
            && ln -s /usr/local/bin/node /usr/local/bin/nodejs
        ```
- ARG构建参数
    * 构建参数和 ENV 的效果一样,都是设置环境变量. 所不同的是,ARG 所设置的构建环境的环境变量,在将来容器运行时是不会存在这些环境变量的
    * 格式
        ```bash
            ARG <参数名>[=<默认值>]
        ```
    * eg
        ```bash
            # Dockerfile 中的 ARG 指令是定义参数名称,以及定义其默认值. 该默认值可以在构建命令 docker build 中用 --build-arg <参数名>=<值> 来覆盖
            ARG DOCKER_USERNAME=library

            FROM ${DOCKER_USERNAME}/alpine

            # 在FROM 之后使用变量,必须在每个阶段分别指定
            ARG DOCKER_USERNAME=library

            RUN set -x ; echo ${DOCKER_USERNAME}

            FROM ${DOCKER_USERNAME}/alpine

            # 在FROM 之后使用变量,必须在每个阶段分别指定
            ARG DOCKER_USERNAME=library

            RUN set -x ; echo ${DOCKER_USERNAME}
        ```
- VOLUME定义匿名卷
    * 格式
        ```bash
            VOLUME ["<路径1>", "<路径2>"...]
            VOLUME <路径>
        ```
- EXPOSE暴露端口
    * EXPOSE 指令是声明容器运行时提供服务的端口,这只是一个声明,在容器运行时并不会因为这个声明应用就会开启这个端口的服务. 在 Dockerfile 中写入这样的声明有两个好处,一个是帮助镜像使用者理解这个镜像服务的守护端口,以方便配置映射；另一个用处则是在运行时使用随机端口映射时,也就是 docker run -P 时,会自动随机映射 EXPOSE 的端口. 
    * 要将 EXPOSE 和在运行时使用 -p <宿主端口>:<容器端口> 区分开来. -p,是映射宿主端口和容器端口,换句话说,就是将容器的对应端口服务公开给外界访问,而 EXPOSE 仅仅是声明容器打算使用什么端口而已,并不会自动在宿主进行端口映射
    * 格式
        ```bash
            EXPOSE <端口1> [<端口2>...]. 
        ```
- EORKDIR指定工作目录
    * 使用 WORKDIR 指令可以来指定工作目录(或者称为当前目录),以后各层的当前目录就被改为指定的目录,如该目录不存在,WORKDIR 会帮你建立目录
    * 格式
        ```bash
            WORKDIR <工作目录路径>
        ```
- USER指定当前用户
    * USER 指令和 WORKDIR 相似,都是改变环境状态并影响以后的层. WORKDIR 是改变工作目录,USER 则是改变之后层的执行 RUN, CMD 以及 ENTRYPOINT 这类命令的身份. 
    * 注意,USER 只是帮助你切换到指定用户而已,这个用户必须是事先建立好的,否则无法切换
    * 格式
        ```bash
            USER <用户名>[:<用户组>]
        ```
    * demo1
        ```bash
            # 创建redis用户并切换到redis用户启动redis-server
            RUN groupadd -r redis && useradd -r -g redis redis
            USER redis
            RUN [ "redis-server" ]
        ```
    * demo2
        ```bash
            # 不要使用 su 或者 sudo
            # 建立 redis 用户,并使用 gosu 换另一个用户执行命令
            RUN groupadd -r redis && useradd -r -g redis redis
            # 下载 gosu
            RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64" \
                && chmod +x /usr/local/bin/gosu \
                && gosu nobody true
            # 设置 CMD,并以另外的用户执行
            CMD [ "exec", "gosu", "redis", "redis-server" ]
        ```









