---
title: Python_基础 (129)
date: 2021-12-31
tags: Python
toc: true
---

### python相关
    重新看一下WSGI, uWSGI, uwsgi, Nginx

<!-- more -->

#### WSGI
> WSGI的全称是Web Server Gateway Interface(Web服务器网关接口), 它不是服务器、python模块、框架、API或者任何软件, 只是一种描述web服务器(如nginx, uWSGI等服务器)如何与web应用程序(如用Django、Flask框架写的程序)通信的规范.
server和application的规范在PEP3333中有具体描述, 要实现WSGI协议, 必须同时实现web server和web application, 当前运行在WSGI协议之上的web框架有Bottle, Flask, Django.

#### uWSGI
> uWSGI是一个全功能的HTTP服务器, 实现了WSGI协议、uwsgi协议、http协议等.它要做的就是把HTTP协议转化成语言支持的网络协议.比如把HTTP协议转化成WSGI协议, 让Python可以直接使用.

#### uwsgi
> 与WSGI一样, 是uWSGI服务器的独占通信协议, 用于定义传输信息的类型(type of information).每一个uwsgi packet前4byte为传输信息类型的描述, 与WSGI协议是两种东西, 据说该协议是fcgi协议的10倍快.

#### Nginx
> Nginx是一个Web服务器其中的HTTP服务器功能和uWSGI功能很类似, 但是Nginx还可以用作更多用途, 比如最常用的反向代理功能.

#### Django
> Django是一个Web框架, 框架的作用在于处理request和 reponse, 其他的不是框架所关心的内容.所以如何部署Django不是Django所需要关心的.
Django所提供的是一个开发服务器, 这个开发服务器, 没有经过安全测试, 而且使用的是Python自带的simple HTTPServer 创建的, 在安全性和效率上都是不行的.





