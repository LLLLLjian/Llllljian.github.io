---
title: Linux_基础 (86)
date: 2021-04-06
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### curl
> 处理完资源接下来就是处理请求呀, 当我在服务器A上想请求服务器B接口的时候用的就是curl呀
1. 将下载的文件输出到终端
    ```bash
        curl URL
    ```
2. 避免curl命令显示进度信息
    ```bash
        curl URL --silent
    ```
3. 断点续传
    ```bash
        curl -C - URL
    ```
4. 用cURL设置参照页字符串
    ```bash
        curl --referer Referer_URL target_URL
    ```
5. 用cURL设置cookie
    ```bash
        curl http://example.com --cookie "user=slynux;pass=hack"
    ```
6. 用cURL设置用户代理字符串
    ```bash
        curl URL --user-agent "Mozilla/5.0"
    ```
7. 只打印响应头部信息(不包括数据部分)
    ```bash
        curl -I http://slynux.org
    ```
8. 发送post请求
    ```bash
        curl URL -d "postvar=postdata2&postvar2=postdata2"
    ```

#### 使用proc采集信息
> 在GNU/Linux操作系统中, /proc是一个在内存中的伪文件系统(pseudo filesystem).它的引入 是为了提供一个可以从用户空间读取系统参数的接口.我们能够从中获取到大量的信息.下面来 看看如何使用它.如果查看/proc, 你会发现有很多文件和目录.其中的一些我们在本章的其他攻略中已经讲 解过了.你可以对/proc及其子目录下的文件使用cat来获取信息.所有内容都是易读的格式化 文本.系统中每一个运行的进程在/proc中都有一个对应的目录.目录名和进程ID相同
1. 以Bash为例, 它的进程ID是4295(pgrep bash), 那么就会有一个对应的目录/proc/4295.进程对应的目录中包含了大量有关进程的信息./proc/PID中一些重要的文件如下所示.
    * environ:包含与进程相关的环境变量.使用cat /proc/4295/environ, 可以显示所 有传递给该进程的环境变量
    * cwd:是一个到进程工作目录(working directory)的符号链接
    * exe:是一个到当前进程所对应的可执行文件的符号链接
    * fd:包含了进程所使用的文件描述符


