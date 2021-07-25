---
title: Python_基础 (73)
date: 2020-12-29
tags: Python
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    uwsgi服务器配置及管理

<!-- more -->

#### 先说说我想做的事
> invalid request block size: 4557 (max 4096)...skip
这是我的报错, 可能是因为我请求数据有点大了, 所以修改一下请求大小, 修改完还不算, 还得看看uwsgi服务器配置

#### uwsgi.ini注解
- uwsgi.ini
    ```bash
        [uwsgi]
        # 配置uwsgi监听的socket(ip+端口)
        http-socket=:55555
        # uwsgi调用的python应用实例名称,Flask里默认是app,根据具体项目代码实例命名来设置
        callable=app
        # 调用的主程序文件,绝对路径或相对于该ini文件位置的相对路径均可
        wsgi-file=server.py
        # 以独立守护进程运行
        master=true
        # 配置进程数量
        processes=8
        # 配置线程数量
        threads=4
        # 允许在请求中开启新线程
        enable-threads=true
        # 返回一个json串,显示各进程和worker的状态
        stats=127.0.0.1:9191
        # 存放uwsgi进程的pid,便于重启和关闭操作
        pidfile=uwsgi.pid
        # 监听队列长度,默认100,设置大于100的值时,需要先调整系统参数
        listen=1024
        # 指定项目目录为主目录
        chdir = /project
        # 以守护进程运行,日志文件路径
        daemonize=uwsgi.daemonize.log
        # 启用内存报告,报告占用的内存
        memory-report=true
        # 设置请求的最大大小 (排除request-body),这一般映射到请求头的大小.默认情况下,它是4k,大cookies的情况下需要加大该配置
        buffer-size=65535
    ```
- eg2
    ```bash
        # uwsgi使用配置文件启动,配置如下
        [uwsgi]
        #项目目录
        chdir=./

        #指定项目application
        module=test.wsgi

        #监控python模块mtime来触发重载
        py-autoreload=1

        #指定sock的文件路径(nginx使用)
        socket=./uwsgi/uwsgi.sock

        # 进程个数(processess一样效果)
        workers=2
        #指定启动时的pid文件路径
        pidfile=./uwsgi/uwsgi.pid

        #指定ip及端口(配置nginx就不需要,单独启动uwsgi需要填写)
        #http=172.16.0.4:8001
        #指定静态文件(配置nginx不需要,单独启动uwsgi加载静态文件)
        #static-map=/static=/var/www/orange_web/static
        #启动uwsgi的用户名和用户组
        uid=root
        gid=root

        #启用主进程
        master=true

        # 启用线程
        enable-threads=true

        #自动移除unix Socket和pid文件当服务停止的时候
        vacuum=true

        #设置日志目录
        daemonize=./logs/uwsgi.log

        #不记录信息日志,只记录错误以及uwsgi内部消息
        disable-logging=true

        # 序列化接受的内容,如果可能的话
        thunder-lock=true

        # 设置请求的最大大小 (排除request-body),这一般映射到请求头的大小.默认情况下,它是4k,大cookies的情况下需要加大该配置
        buffer-size = 65536
    ```

#### uwsgi管理
1. 启动uwsgi
    ```bash
        # 从配置文件启动,将命令参数统一写进ini文件
        uwsgi --ini uwsgi.ini
    ```
2. 重启uwsgi
    * uwsgi命令重启
        ```bash
            # uwsgi.pid文件路径在ini文件中配置,uwsgi启动后所开启进程的pid号会自动写入该文件
            uwsgi --reload uwsgi.pid
        ```
    * 系统命令重启
        ```bash
            # 友好重启,不会丢失会话,pid为master进程的pid
            kill -HUP pid
            # 强制重启,可能丢失会话,pid为master进程的pid
            kill -TERM pid
        ```
3. 查看uwsgi运行状态
    ```bash
        # 返回json,显示进程和worker的详细状态
        uwsgi --connect-and-read uwsgi.status或127.0.0.1：9191
    ```
4. 关闭uwsgi
    * uwsgi命令关闭
        ```bash
            wsgi --stop uwsgi.pid
        ```
    * 系统命令关闭
        ```bash
            # pid为master进程的pid
            kill -INT pid
        ```


