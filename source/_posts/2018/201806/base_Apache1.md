---
title: Apache_基础 (1)
date: 2018-06-19
tags: Apache
toc: true
---

### Apache基础
    Apache是目前世界上使用最为广泛的一种Web Server,它以跨平台、高效和稳定而闻名
    缺点是消耗资源大

<!-- more -->

#### Apache组件
- APR
    * Apache可移植运行库
    * 是一个对操作系统调用的抽象库,用来实现Apache内部组件对操作系统的使用,提高系统的可移植性
- Module
- MPM
    * Apache通过MPM来使用操作系统的资源,对进程和线程池进行管理

#### MPM
- 查看当前Apache工作模式
    ```bash
        [llllljian@llllljian-virtual-machine conf 21:16:03 #38]$ /usr/local/apache2.2.17/bin/httpd -l
        Compiled in modules:
            core.c
            prefork.c
            http_core.c
            mod_so.c
    ```
- Prefork
    * 工作原理
        * Prefork是非线程、预生成进程型MPM,会预先启动一些子进程,每个子进程一个时间只能处理一个请求,并且会根据并发请求数量动态生成更多子进程
    * 配置参数
        ```bash
            vim /usr/local/apache2.2.17/conf/extra/http-mpm.conf

            <IfModule mpm_prefork_module>
                # 服务器启动默认启动的子进程
                StartServers          5

                # 最小空闲进程数量
                MinSpareServers       5

                # 最大空闲进程数量
                MaxSpareServers      10

                # 最高的并发量
                MaxClients          150

                # 最大限制的并发量
                # ServerLimit

                # 每个子进程默认最多处理多少个请求
                # 当达到设定值时,这个进程就会被kill掉,重新生成一个新的进程(避免内存泄露等安全性问题,运行太久怕出一些bug,可能出现假死,或者占用太多内存等
                MaxRequestsPerChild   0
            </IfModule>
        ```
- worker
    * 工作原理
        * Workder是线程化、多进程的MPM,每个进程可以生成多个线程,每个线程处理一个请求
        * 不需要启用太多的子进程,每个进程能够拥有的线程数量是固定的
        * 服务器会根据负载情况增加或减少进程数量
        * 一个单独的控制进程(父进程)负责子进程的建立
        * 每个子进程能够建立ThreadsPerChild数量的服务线程和一个监听线程,该监听线程监听接入请求并将其传递给服务线程处理和应答
    * 配置参数
        ```bash
            vim /usr/local/apache2.2.17/conf/extra/http-mpm.conf

            <IfModule mpm_worker_module>
                # 服务器启动时建立的子进程数,默认值是"3".
                StartServers          2

                # 允许同时服务的最大接入请求数量(最大线程数量).任何超过MaxClients限制的请求都将进入等候队列,默认值是"400"
                MaxClients          150

                # 最小空闲线程数,默认值是"75"
                MinSpareThreads      25

                # 设置最大空闲线程数.默认值是"250"
                MaxSpareThreads      75

                # 每个子进程建立的常驻的执行线程数.默认值是25
                ThreadsPerChild      25

                # 设置每个子进程在其生存期内允许处理的最大请求数量
                MaxRequestsPerChild   0
            </IfModule>
        ```
- Prefork和Worker的比较
    * prefork方式速度要稍高于worker,然而它需要的cpu和memory资源也稍多于woker.
    * prefork的无线程设计在某些情况下将比worker更有优势:它可以使用那些没有处理好线程安全的第三方模块,并且对于那些线程调试困难的平台而言,它也更容易调试一些.
    * 在一个高流量的HTTP服务器上,Worker MPM是个比较好的选择,因为Worker MPM的内存使用比Prefork MPM要低得多.

#### Apache启动阶段
- 手动安装php需要配置Apache的地方
    ```
        vim /usr/local/apache2.2.17/conf/httpd.conf

        ...
        LoadModule php5_module        modules/libphp5.5.24.so
        AddType application/x-httpd-php .php
        ...
    ```
- 启动过程
    * 开始
    * 解析配置文件
        * 解析主配置文件http.conf中的配置信息.像LoadModule AddType等指令被加载至内存
    * 加载静态/动态模板
        * 依据AddModule LoadModule等指令加载Apache模块,像mod_php5.so被加载至内存,映射到Apache的地址空间
    * 系统资源初始化
        * 日志文件、共享内存段、数据库连接等进行初始化
    * 结束

#### Apache运行阶段
- 概述
    * 在运行阶段,Apache主要工作是处理用户的服务请求
    * 为了安全考虑,防止由于代码的缺陷引起的安全漏洞,Apache使用普通权限
- 流程
    * Post-Read-Reques阶段 
        * 在正常请求处理流程中,这是模块可以插入钩子的第一个阶段
    * URI Translation阶段
        * Apache在本阶段的主要工作:将请求的URL映射到本地文件系统
    * Header Parsing阶段
        * Apache在本阶段的主要工作:检查请求的头部.
    * Access Control阶段
        * Apache在本阶段的主要工作:根据配置文件检查是否允许访问请求的资源
    * Authentication阶段
        * Apache在本阶段的主要工作:按照配置文件设定的策略对用户进行认证,并设定用户名区域
    * Authorization阶段
        * Apache在本阶段的主要工作:根据配置文件检查是否允许认证过的用户执行请求的操作.
    * MIME Type Checking阶段
        * Apache在本阶段的主要工作:根据请求资源的MIME类型的相关规则,判定将要使用的内容处理函数
    * FixUp阶段
        * 这是一个通用的阶段,允许模块在内容生成器之前,运行任何必要的处理流程
    * Response阶段
        * Apache在本阶段的主要工作:生成返回客户端的内容,负责给客户端发送一个恰当的回复
    * Logging阶段
        * Apache在本阶段的主要工作:在回复已经发送给客户端之后记录事务.
    * CleanUp阶段
        * Apache在本阶段的主要工作:清理本次请求事务处理完成之后遗留的环境,比如文件、目录的处理或者Socket的关闭等等
