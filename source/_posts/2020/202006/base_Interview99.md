---
title: Interview_总结 (99)
date: 2020-06-01
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### 一次⻚面请求的过程
1. 首先, 在浏览器输入网址(www.xxx.com) 
2. 浏览器首先去找本地的hosts文件,检查在该文件中是否有相应的域名、IP对应关系,如果有,则向其IP地址发送请求,如果没有就会将domain(域)发送给 dns(域名服务器)进行解析,将域名解析成对应的服务器IP地址,发回给浏览器
    * 浏览器客户端向本地DNS服务器发送一个含有域名www.cnblogs.com的DNS查询报文.
    * 本地DNS服务器把查询报文转发到根DNS服务器,根DNS服务器注意到其com后缀,于是向本地DNS服务器返回comDNS服务器的IP地址.
    * 本地DNS服务器再次向comDNS服务器发送查询请求,comDNS服务器注意到其www.cnblogs.com后缀并用负责该域名的权威DNS服务器的IP地址作为回应.
    * 本地DNS服务器将含有www.cnblogs.com的IP地址的响应报文发送给客户端
3. 浏览器发起到xxx.xx.xx.xxx端口80的连接
4. 浏览器给Web服务器发送一个HTTP请求
5. 服务器接收请求
6. 务器"处理"请求
7. 服务器返回一个HTML响应
8. 浏览器开始显示HTML

#### LNMP请求的过程
1. www.example.com
2. Nginx
3. 路由到www.example.com/index.php
4. 加载nginx的fast-cgi模块
5. fast-cgi监听127.0.0.1:9000地址
6. www.example.com/index.php请求到达127.0.0.1:9000
7. php-fpm 监听127.0.0.1:9000
8. php-fpm 接收到请求,启用worker进程处理请求
9. php-fpm 处理完请求,返回给nginx
10. nginx将结果通过http返回给浏览器







