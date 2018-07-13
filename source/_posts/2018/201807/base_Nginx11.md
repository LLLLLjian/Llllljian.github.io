---
title: Nginx_基础 (11)
date: 2018-07-07
tags: Nginx
toc: true
---

### 面试中Nginx相关问题
    临时抱佛脚

<!-- more -->

#### Nginx是什么
    Nginx是一个web服务器和方向代理服务器,用于HTTP、HTTPS、SMTP、POP3和IMAP协议.

#### Nginx能干什么
    邮件代理 反向代理 负载均衡 web缓存
    作为http server(代替apache,对PHP需要FastCGI处理器支持)
    反向代理服务器
    实现负载均衡
    虚拟主机
    FastCGI：Nginx本身不支持PHP等语言,但是它可以通过FastCGI来将请求扔给某些语言或框架处理

#### Nginx和Apache的异同
    轻量级,同样起web 服务,比apache 占用更少的内存及资源 
    抗并发,nginx 处理请求是异步非阻塞的,而apache 则是阻塞型的,在高并发下nginx 能保持低资源低消耗高性能
    高度模块化的设计,编写模块相对简单 
    最核心的区别在于apache是同步多进程模型,一个连接对应一个进程；nginx是异步的,多个连接（万级别）可以对应一个进程 

#### Nginx如何处理HTTP请求
    Nginx使用反应器模式.主事件循环等待操作系统发出准备事件的信号,这样数据就可以从套接字读取,在该实例中读取到缓冲区并进行处理.单个线程可以提供数万个并发连接

#### 反向代理服务器的优点
    反向代理服务器可以隐藏源服务器的存在和特征.它充当互联网云和web服务器之间的中间层,比较安全

#### Master进程和Worker进程
    一个master进程,生成一个或者多个worker进程
    Master进程：读取及评估配置和维持
    Worker进程：处理请求

#### nginx常用命令
    启动nginx  ./sbin/nginx
    停止nginx ./sbin/nginx -s stop    ./sbin/nginx -s quit
    重载配置  ./sbin/nginx -s reload(平滑重启)  service nginx reload 
    重载指定配置文件 ./sbin/nginx -c /usr/local/nginx/conf/nginx.conf
    查看nginx版本 ./sbin/nginx -v
    检查配置文件是否正确 ./sbin/nginx -t
    显示帮助信息 ./sbin/nginx -h

#### 为什么要做动、静分离
- 什么是动静分离
    * 将网站静态资源（HTML,JavaScript,CSS,img等文件）与后台应用分开部署,提高用户访问静态代码的速度,降低对后台应用访问
- eg
    ```bash
        server {
            listen       80;
            server_name  dongjingfenli.web;

            location ~ .*\.(html|htm|gif|jpg|jpeg|bmp|png|ico|js|css)$ {
                root /usr/share/nginx/html;
                #cache
                # 拦截指定的后缀的文件,并且会在客户端进行缓存.缓存的时间是三天
                expires 3d;
            }
        }
    ```

