---
title: Nginx_基础 (17)
date: 2021-03-19
tags: Nginx
toc: true
---

### 还学Nginx
    搭建nginx做文件下载服务器

<!-- more -->

#### nginx文件下载服务器
> 因为我们的项目需要有一个agent安装包让别的人下载,之前都是放到别的服务器上通过wget方式下载的,这次想改到自己服务器的nginx上, 所以学一下相关知识
1. 修改nginx配置
    ```bash
        vim /etc/nginx/nginx.conf

        user nginx;
        worker_processes auto;
        error_log /var/log/nginx/error.log;
        pid /run/nginx.pid;
        include /usr/share/nginx/modules/*.conf;
        events {
            worker_connections 1024;
        }
        http {
            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                            '$status $body_bytes_sent "$http_referer" '
                            '"$http_user_agent" "$http_x_forwarded_for"';
            access_log  /var/log/nginx/access.log  main;
            sendfile            on;
            tcp_nopush          on;
            tcp_nodelay         on;
            keepalive_timeout   65;
            types_hash_max_size 2048;
            include             /etc/nginx/mime.types;
            default_type        application/octet-stream;
            # Load modular configuration files from the /etc/nginx/conf.d directory.
            # See http://nginx.org/en/docs/ngx_core_module.html#include
            # for more information.
            include /etc/nginx/conf.d/*.conf;
            server {
                listen       80 default_server;
                listen       [::]:80 default_server;
                server_name  _;
                # Load configuration files for the default server block.
                include /etc/nginx/default.d/*.conf;
                location / {
                    root    /usr/share/nginx/html/download;
                autoindex on;    #开启索引功能
                autoindex_exact_size off;  #关闭计算文件确切大小(单位bytes),只显示大概大小(单位kb、mb、gb)
                autoindex_localtime on;   #显示本机时间而非 GMT 时间
                }
                error_page 404 /404.html;
                    location = /40x.html {
                }
                error_page 500 502 503 504 /50x.html;
                    location = /50x.html {
                }
            }
        }
    ```
2. 配置完成后重启服务器
    ```bash
        sudo /usr/local/nginx/sbin/nginx -s reload
    ```
3. 创建下载路径
    ```bash
        mkdir /usr/share/nginx/html/download
    ```
4. 上传文件并授权755
    ```bash
        tar -zcf 'agent.tar.gz' 'agent'
        mv agent.tar.gz /usr/share/nginx/html/download
        chmod 755 /usr/share/nginx/html/download/agent.tar.gz
    ```
5. 浏览器打开ngixn地址
    * 浏览器打开http://xxxxx/ 就可以看到文件列表了
6. 下载并解压压缩包
    ```bash
        wget http://xxxxx/agent.tar.gz -O agent.tar.gz
        tar -xzf agent.tar.gz
    ```



