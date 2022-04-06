---
title: Interview_总结 (73)
date: 2020-03-12
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-nginx+php-fpm运行原理

<!-- more -->

#### 代理与反向代理
> 现实生活中的例子
1. 正向代理: 访问google.com
    * google.com -> vpn -> google.com
    * 对于人来说可以感知到,但服务器感知不到的服务器,我们叫他正向代理服务器
2. 反向代理: 通过反向代理实现负载均衡
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




