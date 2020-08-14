---
title: Interview_总结 (109)
date: 2020-07-07
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### 问题1
- 问题描述
    * phpfpm杀掉master进程, php还能正常工作吗
- 问题结论
    * 不能, master进程被杀掉之后, worker进程也随之消失, 再访问php文件返回502
- 问题扩展
    * Fpm的master进程
        > 作为一种多进程的模型, Fpm由一个master进程加多个worker进程组成.当master进程启动时, 会创建一个socket, 但是他本身并不接收/处理请求.他会fork出子进程来完成请求的接收和处理.所以, master的主要职责是管理worker进程, 比如fork出worker进程, 或者kill掉worker进程.master进程通过共享内存的方式来读取worker进程的状态信息, 包括：worker进程当前状态, worker进程已经处理的请求数量等等.master进程会通过发送信号的方式来kill掉worker进程.
    * Fpm的worker进程
        > Fpm中的worker进程的主要工作是处理请求.每个worker进程会竞争Accept请求, 接收成功的那一个来处理本次请求.请求处理完毕后又重新进入等待状态.此处需要注意的是：一个worker进程在同一时刻只能处理一个请求.这与Nginx的事件驱动模型有很大的区别.Nginx的子进程使用epoll来管理socket, 当一个请求的数据还未发送完成的话他就会处理下一个请求, 即同一时刻, 一个子进程会连接多个请求.而Fpm的这种子进程处理方式则大大简化了PHP的资源管理, 使得在Fpm模式下我们不需要考虑并发导致的资源冲突.
    * PHP-FPM的三种模式
        * pm=static : 始终保持固定数量的worker进程数, 由pm.max_children决定
        * pm=dynamic 
            1. php-fpm启动时, 会初始启动一些worker, 初始启动worker数决定于pm.max_children的值.在运行过程中动态调整worker数量, worker的数量受限于pm.max_children配置, 同时受限全局配置process.max.
            2. 1秒定时器作用, 检查空闲worker数量, 按照一定策略动态调整worker数量, 增加或减少.增加时, worker最大数量<=max_children· <=全局process.max；减少时, 只有idle >pm.max_spare_servers时才会关闭一个空闲worker.
            3. 优缺点
                * 优点：动态扩容, 不浪费系统资源
                * 缺点：如果所有worker都在工作, 新的请求到来只能等待master在1秒定时器内再新建一个worker, 这时可能最长等待1s
        * pm=ondemand
            * php-fpm启动的时候, 不会启动任何一个worker, 而是按需启动, 只有当连接过来的时候才会启动.
            * 启动的最大worker数决定于pm.max_children的值, 同时受限全局配置process.max.
            * 1秒定时器作用, 如果空闲worker时间超过pm.process_idle_timeout的值(默认值为10s), 则关闭该worker.这个机制可能会关闭所有的worker
            * 优缺点
                * 优点：按流量需求创建, 不浪费系统资源
                * 缺点：由于php-fpm是短连接的, 所以每次请求都会先建立连接, 频繁的创建worker会浪费系统开销.所以, 在大流量的系统上, master进程会变得繁忙, 占用系统cpu资源, 不适合大流量环境的部署.

#### Nginx日志分析及性能排查
- 获取访问的PV数量
    ```bash
        cat /data/wwwlogs/www.itbiancheng.com.log | wc -l
    ```
- 获取IP数量
    ```bash
        cat /data/wwwlogs/www.itbiancheng.com.log | awk '{print $1}' | sort -k1 -r | uniq | wc -l
    ```
- 获取访问最多的前10个IP
    ```bash
        cat /data/wwwlogs/www.itbiancheng.com.log | awk '{print $1}' | sort | uniq -c|sort -nr|head -10
    ```
- 获得访问最多的前10个url
    ```bash
        cat /data/wwwlogs/www.itbiancheng.com.log | awk '{print $7}' | sort | uniq -c | sort -nr | head -10
    ```
- 获取每分钟的请求数量, 输出成csv文件
    ```bash
        cat /data/wwwlogs/www.itbiancheng.com.log | awk '{print substr($4,14,5)}' | uniq -c | awk '{print $2","$1}'
    ```

#### 代理与反向代理
> 现实生活中的例子
1. 正向代理：访问google.com
    * google.com -> vpn -> google.com
    * 对于人来说可以感知到,但服务器感知不到的服务器,我们叫他正向代理服务器
2. 反向代理：通过反向代理实现负载均衡
    * baidu.com -> 反向代理服务器 -> 不同的服务器上
    * 对于人来说不可感知,但对于服务器来说是可以感知的,我们叫他反向代理服务器

#### 初识Nginx与php-fpm
- Nginx是什么
    * 是一个高性能的HTTP和反向代理服务器,也是一个IMAP/POP3/SMTP服务器
- cgi是什么
    *  早期的webserver只处理html等静态文件,但是随着技术的发展,出现了像php等动态语言.webserver处理不了了,怎么办呢？那就交给php解释器来处理吧！交给php解释器处理很好,但是,php解释器如何与webserver进行通信呢？为了解决不同的语言解释器(如php、python解释器)与webserver的通信,于是出现了cgi协议.只要你按照cgi协议去编写程序,就能实现语言解释器与webwerver的通信
- fastcgi是什么
    * fast-cgi每次处理完请求后,不会kill掉这个进程,而是保留这个进程,使这个进程可以一次处理多个请求.这样每次就不用重新fork一个进程了,大大提高了效率
- php-fpm是什么
    * php-fpm即php-Fastcgi Process Manager.php-fpm是 FastCGI 的实现,并提供了进程管理的功能

#### 运行流程
1. www.example.com
2. Nginx
3. 路由到www.example.com/index.php
4. 加载nginx的fast-cgi模块
5. fast-cgi监听127.0.0.1:9000地址
6. www.example.com/index.php请求到达127.0.0.1:9000
7. php-fpm 监听127.0.0.1:9000
8. php-fpm 接收到请求,启用worker进程处理请求
9. php-fpm 处理完请求,返回给nginx
10. nginx将结果通过http返回给浏览器复制代码

#### 查看指定端口
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 17:27:32 #3]$ sudo netstat -anp | grep 3306
        tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      20241/mysqld 
    ```


