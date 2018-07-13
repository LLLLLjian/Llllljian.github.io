---
title: Nginx_基础 (9)
date: 2018-07-05
tags: Nginx
toc: true
---

### Nginx服务器的代理服务
    主要看一下 正向代理和方向代理的基本概念
              Nginx正向代理服务的配置指令
              Nginx反向代理服务的配置指令
              Nginx反向代理服务器的应用-负载均衡

<!-- more -->

#### 正向代理
    正向代理服务器用来让局域网客户机接入外网以访问外网资源
    我们的角色是服务端,目的是要访问外网的资源
- 概念
    * 正向代理 是一个位于客户端和原始服务器(origin server)之间的服务器,为了从原始服务器取得内容,客户端向代理发送一个请求并指定目标(原始服务器),然后代理向原始服务器转交请求并将获得的内容返回给客户端.客户端必须要进行一些特别的设置才能使用正向代理
- 用途
    * 访问原来无法访问的资源,如google
    * 可以做缓存,加速访问资源
    * 对客户端访问授权,上网进行认证
    * 代理可以记录用户访问记录（上网行为管理）,对外隐藏用户信息
- 安全性
    * 允许客户端通过它访问任意网站并且隐藏客户端自身,因此你必须采取安全措施以确保仅为经过授权的客户端提供服务
- 配置指令
    * resolver
        * 说明
            * 用于指定DNS服务器的IP地址,DNS服务器的主要工作是进行域名解析,将域名映射为对应的IP地址
        * 语法
            * resolver address ... [valid=time];
        * 位置
            * http, server, location
        * address
            * DNS服务器的IP地址,如果不指定端口号,默认使用53端口
        * time
            * 设置数据包在网络中的有效时间
    * resolver_timeout
        * 说明
            * 用于设置DNS服务器域名解析超时时间
        * 语法
            * resolver_timeout time;
        * 默认值	
            * resolver_timeout 30s;
        * 位置
            * http, server, location
    * proxy_pass
        * 说明
            * 用于设置代理服务器的协议和地址,还可以设置可选的URL以定义本地路径和后端服务器的映射关系
        * 语法
            * proxy_pass URL;
            * proxy_pass http://$http_host$request_url
        * 位置
            * location
- 应用
    ```bash
        ...
        server
        {
            resolver 8.8.8.8;
            listen 82;

            location / 
            {
                proxy_pass http://$http_host$request_url;
            }
        }
        ...

        设置DNS服务器地址为8.8.8.8
        使用默认的53端口作为DNS服务器的服务端口
        代理服务的监听端口设置为82端口
        Nginx服务器接收到的所有请求都是由第5行的location块进行过滤处理

        设置Nginx代理服务器,server块中不能设置server_name
        resolver是必需的,如果没有该指令,Nginx服务器无法处理接收到的域名
        不支持正向代理的HTTPS站点
    ```

#### 反向代理
    反向代理服务器用来让外网的客户端接入局域网中的站点以访问站点内的资源
    我们的角色是站点,目的是把站点的资源发布出去让其它客户端能访问
- 概念
    * 以代理服务器来接受internet上的连接请求,然后将请求转发给内部网络上的服务器,并将从服务器上得到的结果返回给internet上请求连接的客户端,此时代理服务器对外就表现为一个服务器 
- 用途
    * 将防火墙后面的服务器提供给Internet用户访问
        * 保证内网的安全,可以使用反向代理提供WAF功能,阻止web攻击
    * 为后端的多台服务器提供负载平衡,或为后端较慢的服务器提供缓冲服务
        * 负载均衡,通过反向代理服务器来优化网站的负载
    * 可以启用高级URL策略和管理技术,从而使处于不同web服务器系统的web页面同时存在于同一个URL空间下
- 安全性
    * 对外都是透明的,访问者并不知道自己访问的是一个代理
- 配置指令
    * proxy_pass指令
        * 说明
            * 用来设置被代理服务器的地址,可以是主机名称 IP地址加端口号等形式
        * 语法
            * proxy_pass URL;
        * eg
            ```bash
                proxy_pass http://www.myweb.name/uri;
                proxy_pass http://localhost:8000/uri/;
                proxy_pass http://unix:/tmp/backend.socket:/uri/;

                ...
                upstream proxy_svrs
                {
                    server http://192.168.1.1:8001/uri/;
                    server http://192.168.1.2:8001/uri/;
                    server http://192.168.1.3:8001/uri/;
                }
                server
                {
                    ...
                    listen 80;
                    server_name www.myweb.name;

                    location /
                    {
                        proxy_pass proxy_svrs;
                    }
                }
            ```
    * proxy_hide_header
        * 说明
            * 用于设置Nginx服务器在发送HTTP响应时,隐藏一些头域信息
        * 语法
            * proxy_hide_header field;
        * 位置
            * http, server, location
        * nginx默认不会将“Date”、“Server”、“X-Pad”,和“X-Accel-...”响应头发送给客户端.proxy_hide_header指令则可以设置额外的响应头,这些响应头也不会发送给客户端
    * proxy_pass_header
        * 说明
            * 允许传送被屏蔽的后端服务器响应头到客户端
        * 语法
            * proxy_pass_header field;
        * 位置
            * http, server, location
    * proxy_set_header
        * 说明
            * 允许重新定义或者添加发往后端服务器的请求头
        * 语法
            * proxy_set_header field value;
        * 默认
            * proxy_set_header Host $proxy_host;
            * proxy_set_header Connection close;
        * 位置
            * http, server, location
    * proxy_connect_timeout
        * 说明
            * 设置与后端服务器建立连接的超时时间.这个超时一般不可能大于75秒.
        * 语法
            * proxy_connect_timeout time;
        * 默认
            * proxy_connect_timeout 60s;
    * proxy_read_timeout
        * 说明
            * 定义从后端服务器读取响应的超时.此超时是指相邻两次读操作之间的最长时间间隔,而不是整个响应传输完成的最长时间.如果后端服务器在超时时间段内没有传输任何数据,连接将被关闭
        * 语法
            * proxy_read_timeout time;
        * 默认
            * proxy_read_timeout 60s;
    * proxy_send_timeout
        * 说明
            * 定义向后端服务器传输请求的超时.此超时是指相邻两次写操作之间的最长时间间隔,而不是整个请求传输完成的最长时间.如果后端服务器在超时时间段内没有接收到任何数据,连接将被关闭
        * 语法
            * proxy_send_timeout time;
        * 默认
            * proxy_send_timeout 60s;
- 应用
    ```bash
        upstream www_proxy_test_80
        {
            server 190.80.12.112:80;
        }

        server
        {
            listen 80;
            server_name www.site3.com;

            location /
            {
                proxy_pass http://www_proxy_test_80;

                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_redirect off;
            }
        }
    ```
