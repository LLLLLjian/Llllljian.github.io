---
title: Interview_总结 (86)
date: 2020-03-31
tags: 
    - PHP
    - Interview
toc: true
---

### 面试题
    今日被问傻系列-我真的不了解CGI、FastCGI和PHP-FPM

<!-- more -->

#### 动态PHPWeb访问流程
> 当Web Server收到 index.php 这个请求后,会启动对应的 CGI 程序,这里就是PHP的解析器.接下来PHP解析器会解析php.ini文件,初始化执行环境,然后处理请求,再以规定CGI规定的格式返回处理后的结果,退出进程,Web server再把结果返回给浏览器
1. 用户将http请求发送给nginx服务器
2. nginx会根据用户访问的URI和后缀对请求进行判断
    ```bash
        server {
            root /data/web/blog/;
            index index.html index.htm;
            server_name www.fwait.com;
            location / {
                try_files $uri $uri/ /index.html;
            }
            location ~ \.php$ {
                include /etc/nginx/fastcgi_params;  # 表示nginx会调用fastcgi这个接口
                fastcgi_intercept_errors on; # 表示开启fastcgi的中断和错误信息记录
                fastcgi_pass 127.0.0.1:9000; # 表示nginx通过fastcgi_pass将用户请求的资源发给127.0.0.1:9000进行解析
            }
        }
    ```
3. nginx会将请求交给fastcgi客户端,通过fastcgi_pass将用户的请求发送给php-fpm
4. fastcgi_pass将动态资源交给php-fpm后,php-fpm会将资源转给php脚本解析服务器的wrapper
5. wrapper收到php-fpm转过来的请求后,wrapper会生成一个新的线程调用php动态程序解析服务器
6. php会将查询到的结果返回给nginx
7. nginx构造一个响应报文将结果返回给用户

- CGI
    * 是 Web Server 与 Web Application 之间数据交换的一种协议.
- FastCGI
    * 同 CGI,是一种通信协议,但比 CGI 在效率上做了一些优化.同样,SCGI 协议与 FastCGI 类似.
- PHP-CGI
    * 是PHP对 Web Server 提供的 CGI 协议的接口程序.
- PHP-FPM
    * 是PHP对 Web Server 提供的 FastCGI 协议的接口程序,额外还提供了相对智能一些任务管理.
- CGI工作原理
    * web服务器收到用户请求,就会把请求提交给cgi程序(如php-cgi),cgi程序根据请求提交的参数作应处理(解析php),然后输出标准的html语句,返回给web服服务器,WEB服务器再返回给客户端,这就是普通cgi的工作原理
- CGI缺点
    * 每一次web请求都会有启动和退出过程



