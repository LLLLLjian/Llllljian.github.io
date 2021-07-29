---
title: 读书笔记 (14)
date: 2021-07-05
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 白话容器基础(三):白话容器基础(三):深入理解容器镜像
> 一讲的是namespace 二讲的是cgroups 三就讲一讲rootfs
- 对Docker项目来说，它最核心的原理实际上就是为待创建的用户进程
    1. 启用 Linux Namespace 配置
    2. 设置指定的 Cgroups 参数
    3. 切换进程的根目录(Change Root)
- rootfs
    * 根文件系统，也叫做容器镜像，它只是一个操作系统的所有文件和目录，并不包含内核，最多也就几百兆。而相比之下，传统虚拟机的镜像大多是一个磁盘的“快照”，磁盘有多大，镜像就至少有多大

#### 白话容器基础(四):重新认识Docker容器
- 用Docker部署一个用Python编写的Web应用
    * app.py
        ```python
            From flask import Flask

            import socket

            app = Flask(__name__)

            @app.route('/') 
            def hello():
                html = "<h3>Hello {name}!</h3>" \ "<b>Hostname:</b> {hostname}<br/>"
                return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname())


            if __name__ == "__main__":
                app.run(host='0.0.0.0', port=80)
        ```
    * requirements.txt
        ```bash
            $ cat requirements.txt
            Flask
        ```
    * Dockerfile
        ```bash
            # 使用官方提供的 Python 开发镜像作为基础镜像
            FROM python:2.7-slim
            # 将工作目录切换为/app
            WORKDIR /app
            # 将当前目录下的所有内容复制到 /app 下
            ADD . /app
            # 使用 pip 命令安装这个应用所需要的依赖
            RUN pip install --trusted-host pypi.python.org -r requirements.txt
            # 允许外界访问容器的80端口
            EXPOSE 80
            # 设置环境变量
            ENV NAME World
            # 设置容器进程为:python app.py，即:这个 Python 应用的启动命令
            CMD ["python", "app.py"] # 等价于 "docker run python app.py"
        ```
    * Dockerfile分析
        * WORKDIR, Dockerfile 后面的操作都以这一句指定的 /app 目录作 为当前目录
        * 其实应该有个ENTRYPOINT的原语，它和 CMD 都是 Docker容器进程启动所必需的参数，完整执行格式是:“ENTRYPOINT CMD”。但是，默认情况下，Docker 会为你提供一个隐含的 ENTRYPOINT，即:/bin/sh -c。所以，在 不指定 ENTRYPOINT 时，比如在我们这个例子里，实际上运行在容器里的完整进程 是:/bin/sh -c “python app.py”，即 CMD 的内容就是 ENTRYPOINT 的参数
        * Dockerfile 里的原语并不都是指对容器内部的操作。就比如 ADD，它指的是把 当前目录(即 Dockerfile 所在的目录)里的文件，复制到指定容器内的目录当中
    * 制作镜像
        ```bash
            $ ls
            Dockerfile app.py requirements.txt

            $ docker build -t helloworld .
        ```
    * 制作镜像解析
        * docker build 会自动加载 当前目录下的 Dockerfile 文件，然后按照顺序，执行文件中的原语。而这个过程，实际上可以 等同于 Docker 使用基础镜像启动了一个容器，然后在容器中依次执行 Dockerfile 中的原语，-t 的作用是给这个镜像加一个Tag
    * 查看镜像
        ```bash
            $ docker image ls
            REPOSITORY            TAG                 IMAGE ID
            helloworld         latest              653287cdf998
        ```
    * 使用镜像
        ```bash
            # 把容器内的 80 端口映射在宿主机的 4000 端口上并执行Dockerfile中的CMD
            # 如果没有Dockerfile的话 就得执行docker run -p 4000:80 helloworld python app.py
            docker run -p 4000:80 helloworld
        ```
    * 查看容器返回结果
        ```bash
            $ curl http://localhost:4000
            <h3>Hello World!</h3><b>Hostname:</b> 4ddf4638572d<br/>
        ```



