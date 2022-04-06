---
title: Nginx_基础 (2)
date: 2018-06-26
tags: Nginx
toc: true
---

### Nginx基础使用
    本文的前提是Nginx已经安装成功
    主要记录一下Nginx的启动重启和停止以及配置文件的基本结构

<!-- more -->

#### Nginx服务的启停控制
- Nginx 服务的信号控制
    * 获取PID
        * 从文件中直接获取
            ```bash
                [llllljian@llllljian-virtual-machine ~]# cat /usr/local/nginx-1.6.0/logs/nginx.pid
                17773
            ```
        * 直接获取进程PID
            ```bash
                [llllljian@llllljian-virtual-machine ~]# ps aux | grep nginx | grep master
                root     17773  0.0  0.0  64264  3056 ?        Ss   Apr11   0:00 nginx: master process /usr/local/nginx-1.6.0/sbin/nginx
            ```
    * 信号列表
        <table><thead><tr><th>信号</th><th>作用</th></tr></thead><tbody><tr><td>TERM 或 INT</td><td>快速停止 Nginx 服务</td></tr><tr><td>QUIT</td><td>平滑停止 Nginx 服务</td></tr><tr><td>HUP</td><td>平滑重启(使用新的配置文件启动进程,之后平缓停止原有进程)</td></tr><tr><td>USR1</td><td>重新打开日志文件,常用于日志切割</td></tr><tr><td>USR2</td><td>平滑升级(使用新版本的 Nginx 文件启动服务,之后平缓停止原有 Nginx 进程)</td></tr><tr><td>WINCH</td><td>平缓停止 worker process ,用于 Nginx 服务器平滑升级</td></tr></tbody></table>
- Nginx 服务的启动
    * 使用默认的配置文件启动 Nginx 服务:
        ```bash
            nginx 或 /usr/local/nginx-1.6.0/sbin/nginx   或   ./sbin/nginx

            [llllljian@llllljian-virtual-machine conf]# nginx -h
            nginx version: openresty/1.11.2.1
            Usage: nginx [-?hvVtTq] [-s signal] [-c filename] [-p prefix] [-g directives]

            Options:
            -?,-h         : 显示帮助
            -v            : 显示版本,退出
            -V            : 显示版本和配置信息,退出
            -t            : 测试配置正确性,退出
            -T            : 测试配置正确性,删除,退出
            -q            : 测试配置时,只显示错误信息
            -s signal     : 发送信号到主进程: stop, quit, reopen, reload
            -p prefix     : 指定 Nginx 服务器路径前缀 (默认: /usr/local/openresty/nginx/)
            -c filename   : 指定配置文件 (默认: conf/nginx.conf)
            -g directives : 从配置文件中设置全局指令
        ```
- Nginx 服务的停止
    * 发送信号
        ```bash
            TERM 和 INT 信号用于快速停止,QUIT 用于平缓停止

            ./sbin/nginx -g TERM
            ./sbin/nginx -g INT
            ./sbin/nginx -g QUIT
        ```
    * 用 kill 命令发送信号
        ```bash
            kill TERM `/usr/local/openresty/nginx/logs/nginx.pid`
            kill INT `/usr/local/openresty/nginx/logs/nginx.pid`
            kill QUIT `/usr/local/openresty/nginx/logs/nginx.pid`

            kill -9 `/usr/local/openresty/nginx/logs/nginx.pid`
            kill SIGKILL `/usr/local/openresty/nginx/logs/nginx.pid`
        ```
- Nginx 服务的重启
    * 平滑重启
        * Nginx 服务进程接收到信号后,首先读取新的 Nginx 配置文件,
        * 如果,配置语法正确,则启动新的 Nginx 服务,然后,平缓关闭旧的服务进程；
        * 如果,新的配置文件有问题,将显示错误,仍使用旧的 Nginx 提供服务.
        ```bash
            ./sbin/nginx -g HUP [-c newConfFile]
            /usr/local/openresty/nginx -g HUP [-c newConfFile]
        ```

#### 配置文件组成[nginx.conf]
- 全局块
    * 默认配置文件从开始到events块之间的一部分内容,主要设置一些影响Nginx服务器整体运行的配置指令
    * 包括
        * 配置运行Nginx服务器的用户(组)
        * 允许生成的worker process数
        * Nginx进程PID存放路径
        * 日志的存放路径和类型
        * 配置文件引入
- events块
    * 影响Nginx服务器与用户的网络连接
    * 包括
        * 是否开启对多worker process下的网络连接进行序列化
        * 是否允许同时接收多个网络连接
        * 选取哪种事件驱动模型处理连接请求
        * 每个worker process可以同时支持的最大连接数
- http块
    * Nginx服务器配置中的重要部分
    * 包括
        * 文件引入
        * MIME-Type定义
        * 日志自定义
        * 是否使用sendfile传输文件
        * 连接超时时间
        * 单连接请求数上限
- server块
    * 每一个http块都可以包含多个server块,而每个server块就相当于一台虚拟主机,它内部可有多台主机联合提供服务,一起对外提供在逻辑上关系密切的一组服务
    * 包括
        * 本虚拟主机的监听配置
        * 本虚拟主机的名称或IP配置
- location块
    * 每个server块中可以包含多个location块
    * 包括
        * 地址定向
        * 数据缓存
        * 应答控制
        * 第三方模块配置

#### 配置文件详解[nginx.conf]
- user
    * 说明
        * 用于配置运行Nginx服务器的用户(组)
    * 语法
        * user user [group];
    * 默认
        * user nobody nobody;
    * 位置
        * 全局块
    * 允许所有用户都可以启动Nginx
        ```bash
            1.将此命令注释掉
            # user user [group];

            2.将用户和用户组都设置为nobody
            user nobody nobody;
        ```
- worker_processes
    * 说明
        * 定义工作进程的数量,配置允许生成的worker process数
    * 语法
        * worker_processes number | auto;
    * 默认
        * worker_processes 1;
    * 位置
        * 全局块
    * 一般设置为可用的CPU核数
    * eg
        ```bash
            vim /usr/local/nginx-1.6.0/conf/nginx.conf
            
            ...
            # 对应开启的worker进程数
            worker_processes  8;
            ...

            [llllljian@llllljian-virtual-machine ~]# ps aux | grep nginx
            root      1499  0.0  0.0 103344   832 pts/0    S+   11:30   0:00 grep nginx
            www       3098  0.0  0.1  69600  9100 ?        S    Jun23   1:18 nginx: worker process            
            www       3099  0.0  0.1  69820  9356 ?        S    Jun23   1:18 nginx: worker process            
            www       3100  0.0  0.1  69704  9256 ?        S    Jun23   1:17 nginx: worker process            
            www       3101  0.0  0.1  69512  9152 ?        S    Jun23   1:24 nginx: worker process            
            www       3102  0.0  0.1  69236  8740 ?        S    Jun23   1:18 nginx: worker process            
            www       3103  0.0  0.1  69412  8948 ?        S    Jun23   1:20 nginx: worker process            
            www       3104  0.0  0.1  69248  8748 ?        S    Jun23   1:23 nginx: worker process            
            www       3105  0.0  0.1  69276  8844 ?        S    Jun23   1:17 nginx: worker process            
            root     17773  0.0  0.0  64264  3020 ?        Ss   Apr11   0:00 nginx: master process /usr/local/nginx-1.6.0/sbin/nginx

            Master进程: 读取及评估配置和维持
            Worker进程: 处理请求
        ```
- error_log
    * 说明
        * 配置错误日志的存放位置
    * 语法
        * error_log file | stderr [debug | info | notice | warn | error | crit | alert | emerg];
    * 默认值
        * error_log logs/error.log error;
    * 位置
        * 全局块, http块, server块, location块
    * 第一个参数定义了存放日志的文件. 如果设置为特殊值stderr,nginx会将日志输出到标准错误输出
    * 第二个参数定义日志级别. 日志级别在上面已经按严重性由轻到重的顺序列出. 设置为某个日志级别将会使指定级别和更高级别的日志都被记录下来. 比如,默认级别error会使nginx记录所有error、crit、alert和emerg级别的消息. 如果省略这个参数,nginx会使用error.
    * 为了使debug日志工作,需要添加--with-debug编译选项.
- pid
    * 说明
        * 定义存储nginx主进程ID的file,配置Nginx进程PID存放路径
    * 语法
        * pid file;
    * 默认值
        * pid nginx.pid;
    * 位置
        * 全局块
- include
    * 说明
        * 配置文件的引入
    * 语法
        * include file | mask;
    * 可以放在配置文件的任何地方
- accept_mutex
    * 说明
        * 设置网络连接的序列化
    * 语法
        * accept_mutex on | off;
    * 默认值	
        * accept_mutex on;
    * 位置
        * events块
    * on : 会对多个Nginx进程接收连接进行序列化,防止多个进程对连接的争抢
    * off : 新连接将通报给所有工作进程,而且如果新连接数量较少,某些工作进程可能只是在浪费系统资源
- multi_accept
    * 说明
        * 设置是否允许同时接收多个网络连接
    * 语法
        * multi_accept on | off;
    * 默认值
        * multi_accept off;
    * 位置
        * events块
    * on : 工作进程一次会将所有新连接全部接入
    * off : 每个worker process一次只能接收一个新到达的网络连接
