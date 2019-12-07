---
title: Nginx_基础 (16)
date: 2019-10-25
tags: Nginx
toc: true
---

### 再学Nginx
    太长时间不看, 有点忘了, 温故而知新.

<!-- more -->

#### Nginx负载均衡配置实例
- 实现效果<div id="id1"></div>
    * 访问xxx.xxx.xxx.xxx, 会请求到两个页面, 一个是apache的index页, 一个是nginx的index页
- 准备工作<div id="id2"></div>
    * 访问xxx.xxx.xxx.xxx:8001访问到的是apache的index页
    * 访问xxx.xxx.xxx.xxx:8002访问到的是nginx的index页
- 在nginx的配置文件中进行负载均衡的配置<div id="id3"></div>
    ```bash
        [ubuntu@llllljian-cloud-tencent ~ 17:58:38 #12]$ cat /etc/nginx/sites-available/default
        upstream nginxTest.com {
              server 127.0.0.1:8001;
              server 127.0.0.1:8002;
        }
        server {
            listen 80 default_server;
            listen [::]:80 default_server;
        
            location / {
                proxy_pass         http://nginxTest.com/;
                proxy_set_header   Host             $host; 
                proxy_set_header   X-Real-IP        $remote_addr; 
                proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for; 
                #try_files $uri $uri/ =404;
            }
        }
    ```
- nginx分配服务器策略<div id="id4"></div>
    * 轮询(默认)
        * 每个请求按时间顺序逐一分配到不同的后端服务器,如果后端服务器down掉,能自动剔除
    * 权重(weight)
        * 默认为 1,权重越高被分配的客户端越多
        ```bash
            upstream nginxTest.com {
                server 127.0.0.1:8001 weight=10;   #  在这儿
                server 127.0.0.1:8002 weight=1;
            }
        ```
    * 哈希(ip_hash)
        * 每个请求按访问 ip 的 hash 结果分配,这样每个访客固定访问一个后端服务器
        ```bash
            upstream nginxTest.com {
                ip_hash;#  在这儿
                server 127.0.0.1:8001;   
                server 127.0.0.1:8002;
            }
        ```
    * 第三方(fail)
        * 按后端服务器的响应时间来分配请求,响应时间短的优先分配
        ```bash
            upstream nginxTest.com {
                server 127.0.0.1:8001;   
                server 127.0.0.1:8002;
                fair; #  在这儿
            }
        ```

#### Nginx动静分离配置实例
- 什么是动静分离<div id="id5"></div>
    * 根本上来说, 动态请求跟静态请求分开
    * 通过 location 指定不同的后缀名实现不同的请求转发.通过 expires 参数设置,可以使 浏览器缓存过期时间,减少与服务器之前的请求和流量
- 准备工作<div id="id6"></div>
    * /usr/share/nginx/html文件夹下准备静态文件
- 具体配置<div id="id7"></div>
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
