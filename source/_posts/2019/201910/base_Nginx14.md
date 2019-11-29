---
title: Nginx_基础 (14)
date: 2019-10-23
tags: Nginx
toc: true
---

### 再学Nginx
    太长时间不看, 有点忘了, 温故而知新.

<!-- more -->

#### Nginx 的常命令和配置文件
- [Nginx常用命令]<div id ="id1"></div>
    * 使用nginx操作命令前提<div id ="id2"></div>
        ```bash
            # 要将nginx配置到bin目录下 否则所有的命令都要到nginx文件夹中执行
            [ubuntu@llllljian-cloud-tencent ~ 19:26:08 #10]$ which nginx
            /usr/sbin/nginx
        ```
    * 查看nginx的版本号<div id ="id3"></div>
        ```bash
            [ubuntu@llllljian-cloud-tencent nginx 19:37:28 #30]$ nginx -v
            nginx version: nginx/1.10.3 (Ubuntu)
        ```
    * 启动nginx<div id ="id4"></div>
        ```bash
            [ubuntu@llllljian-cloud-tencent nginx 19:38:12 #33]$ alias | grep nginx | grep start
            alias nginx1S='sudo /etc/init.d/nginx start' # 启动
        ```
    * 关闭nginx<div id ="id5"></div>
        ```bash
            [ubuntu@llllljian-cloud-tencent nginx 19:38:12 #34]$ alias | grep nginx | grep stop
            alias nginx1E='sudo /etc/init.d/nginx stop' # 停止
        ```
    * 重新加载nginx<div id ="id6"></div>
        ```bash
            [ubuntu@llllljian-cloud-tencent nginx 19:40:46 #35]$ alias | grep nginx | grep restart
            alias nginx1R='sudo /etc/init.d/nginx restart' # 平滑启动
        ```
- [Nginx配置文件]<div id ="id7"></div>
    * 配置文件位置<div id ="id8"></div>
        ```bash
            [ubuntu@llllljian-cloud-tencent nginx 16:46:31 #5]$ vim /etc/nginx/nginx.conf
        ```
    * nginx的组成部分<div id ="id9"></div>
        ```bash
            user www-data; # 配置运行 Nginx服务器的用户
            worker_processes auto; # 允许生成的 worker process数
            pid /run/nginx.pid; # 进程 PID 存放路径

            events {
                worker_connections 768; # 每个 work process 支持的最大连接数为768
            }

            http {
                sendfile on;
                tcp_nopush on;
                tcp_nodelay on;
                keepalive_timeout 65;
                types_hash_max_size 2048;

                include /etc/nginx/mime.types;
                default_type application/octet-stream;

                ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
                ssl_prefer_server_ciphers on;

                access_log /var/log/nginx/access.log;
                error_log /var/log/nginx/error.log;

                gzip on;
                gzip_disable "msie6";

                include /etc/nginx/conf.d/*.conf; # 包含/etc/nginx/conf.d/目录下所有以conf结尾的配置
                include /etc/nginx/sites-enabled/*; # 包含/etc/nginx/sites-enabled/目录下的所有配置

                # /etc/nginx/sites-enabled/sites-available/default 配置中的内容
                server {
                    listen 80 default_server; # 监听80端口
                    listen [::]:80 default_server;

                    root /var/nginx/html; # 文件默认路径

                    index index.html index.htm index.nginx-debian.html index.php;

                    server_name _;

                    access_log /var/log/nginx/access.log;
                    error_log /var/log/nginx/error.log;

                    location / {
                        try_files $uri $uri/ =404;
                    }
                    
                    location /tp5/public/ {
                        if (!-e $request_filename){
                            rewrite  ^/tp5/public/(.*)$  /tp5/public/index.php?s=/$1  last;
                        }
                    }

                    location ~ \.php$ {
                        include snippets/fastcgi-php.conf;
                        fastcgi_pass 127.0.0.1:9000;
                    }
                }
            }
        ```


