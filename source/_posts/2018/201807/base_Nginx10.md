---
title: Nginx_基础 (10)
date: 2018-07-06
tags: Nginx
toc: true
---

### Nginx服务器负载均衡
    实现负载均衡是Nginx服务器反向代理服务的一个重要用途

<!-- more -->

#### 负载均衡概念
    利用一定的分配策略将网络负载平衡地分摊到网络集群的各个操作单元上,使得单个重负载任务能够分担到多个单元上并行处理,或者使得大量并发访问或数据流量分担到多个单元上分别处理,从而减少用户的等待响应时间

#### 负载均衡分类
- 静态负载均衡
    * 一般轮询算法
    * 基于比率的加权轮询算法
    * 基于优先级的加权轮询算法
- 动态负载均衡
    * 基于任务量的最少连接优先算法
    * 基于性能的最快响应优先算法
    * 预测算法
    * 动态性能分配算法

#### Nginx负载均衡算法
- 轮询(默认）
    * 每个请求按时间顺序逐一分配到不同的后端服务,如果后端某台服务器死机,自动剔除故障系统,使用户访问不受影响.
- weight(轮询权值）
    * weight的值越大分配到的访问概率越高,主要用于后端每台服务器性能不均衡的情况下.或者仅仅为在主从的情况下设置不同的权值,达到合理有效的地利用主机资源.
- ip_hash
    * 每个请求按访问IP的哈希结果分配,使来自同一个IP的访客固定访问一台后端服务器,并且可以有效解决动态网页存在的session共享问题.
- fair
    * 比 weight、ip_hash更加智能的负载均衡算法,fair算法可以根据页面大小和加载时间长短智能地进行负载均衡,也就是根据后端服务器的响应时间 来分配请求,响应时间短的优先分配.Nginx本身不支持fair,如果需要这种调度算法,则必须安装upstream_fair模块.
- url_hash
    * 按访问的URL的哈希结果来分配请求,使每个URL定向到一台后端服务器,可以进一步提高后端缓存服务器的效率.Nginx本身不支持url_hash,如果需要这种调度算法,则必须安装Nginx的hash软件包.

#### Nginx负载均衡
    Nginx服务器实现了静态的基于优先级的加权轮询算法,主要使用的配置是proxy_pass指令和upsteam指令
- 配置实例1
    * 对所有请求实现一般轮询规则的负载均衡
    * eg
        ```bash
            ...
            upstream backend 
            {
                server 192.168.1.2:80;
                server 192.168.1.3:80;
                server 192.168.1.4:80;
            }

            server 
            {
                listen 80;
                server_name www.myweb.name;
                index index.html index.htm;

                location / 
                {
                    proxy_pass http://backend;
                    proxy_set_header Host $host;
                    ...
                }
                ...
            }
            ...

            backend服务器组中所有服务器的优先级默认为1,采取一般轮转策略依次接收请求任务
            所有访问www.myweb.name的请求都会在backend服务器组中实现负载均衡
        ```
- 配置实例2
    * 对所有请求实现加权轮转规则的负载均衡
    * eg
        ```bash
            ...
            upstream backend
            {
                server 192.168.1.2:80 weight=5;
                server 192.168.1.3:80 weight=2;
                server 192.168.1.4:80;
            }

            server 
            {
                listen 80;
                server_name www.myweb.name;
                index index.html index.htm;

                location / 
                {
                    proxy_pass http://backend;
                    proxy_set_header Host $host;
                    ...
                }
                ...
            }
            ...

            backend服务器组中的服务器被赋予了不同的优先级别.weight变量的值就是轮转策略中的权值
            192.168.1.2:80的级别最高,优先接收和处理客户端的请求
            192.168.1.4:80的级别最低,是接收和处理客户端请求最少的服务器
            192.168.1.3:80介于二者之间
        ```
- 配置实例3
    * 对特定资源实现负载均衡
    * eg
        ```bash
            ...
            upstream videobackend
            {
                server 192.168.1.2:80;
                server 192.168.1.3:80;
                server 192.168.1.4:80;
            }

            upstream filebackend
            {
                server 192.168.1.5:80;
                server 192.168.1.6:80;
                server 192.168.1.7:80;
            }

            server
            {
                listen 80;
                server_name www.myweb.name;
                index index.html index.htm;

                location /video/
                {
                    proxy_pass http://videobackend;
                    proxy_set_header Host $host;
                    ...
                }

                location /file/
                {
                    proxy_pass http://filebackend;

                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                    ...
                }
                ...
            }
            ...

            设置了两组被代理的服务器组
            所有对"http://www.myweb.name/video/*"的请求,名为"videobackend"的一组进行负载均衡
            所有对"http://www.myweb.name/file/*"的请求,名为"filebackend"的一组进行负载均衡
        ```
- 配置实例4
    * 对不同域名实现负载均衡
    * eg
        ```bash
            ...
            upstream bbsbackend
            {
                server 192.168.1.2:80 weight=2;
                server 192.168.1.3:80 weight=2;
                server 192.168.1.4:80;
            }

            upstream homebackend
            {
                server 192.168.1.4:80;
                server 192.168.1.5:80;
                server 192.168.1.6:80;
            }

            server
            {
                listen 80;
                server_name home.myweb.name;
                index index.html index.htm;

                location /
                {
                    proxy_pass http://homebackend;
                    proxy_set_header Host $host;
                    ...
                }
                ...
            }

            server
            {
                listen 81;
                server_name bbs.myweb.name;
                index index.html index.htm;

                location /
                {
                    proxy_pass http://bbsbackend;
                    proxy_set_header Host $host;
                    ...
                }
                ...
            }
            ...

            设置了两个虚拟服务器和两组后端被代理的服务器组
            如果客户端请求域名为"home.myweb.name,则由服务器server1接收并转向homebackend服务器进行负载均衡处理
            如果客户端请求域名为"bbs.myweb.name,则由服务器server2接收并转向bbsbackend服务器进行负载均衡处理
        ```
- 配置实例5
    * 实现带有URL重写的负载均衡
    * eg
        ```bash
            ...
            upstream backend
            {
                server 192.168.1.2:80;
                server 192.168.1.3:80;
                server 192.168.1.4:80;
            }

            server
            {
                listen 80;
                server_name www.myweb.name;
                index index.html index.htm;

                location /file/
                {
                    rewrite ^(/file/.*)/media/(.*)\.*S $1/mp3/$2.mp3 last;
                }

                location /
                {
                    proxy_pass http://backend;
                    proxy_set_header Host $host;
                    ...
                }
                ...
            }
            ...

            如果客户端的请求URL为 http://www.myweb.name/file/download/media/1.mp3
            重写后的结果为http://www.myweb.name/file/download/mp3/1.mp3
            再转发到后端的backend服务器组中实现负载均衡
        ```