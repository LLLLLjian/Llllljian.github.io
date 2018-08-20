---
title: Nginx_基础 (5)
date: 2018-06-29
tags: Nginx
toc: true
---

### LNMP
    Ubuntu17.04下安装LNMP
    之前已经安装过L M P,这里就安装一下Nginx

<!-- more -->

#### N
    Nginx服务器
    进行安装操作sudo apt-get install nginx
- 安装
    ```bash
        [llllljian@llllljian-virtual-machine ~ 14:05:27 #3]$ ps aux | grep nginx
        lllllji+  2212  0.0  0.0   5140   804 pts/0    S+   14:06   0:00 grep --color=auto nginx

        因为之前安装apache默认的是80端口.所以先修改Apache端口
        [llllljian@llllljian-virtual-machine apache2 14:20:19 #40]$ sudo vim /etc/apache2/sites-available/000-default.conf
        <VirtualHost *:80>  =>  <VirtualHost *:8001>
        
        [llllljian@llllljian-virtual-machine apache2 14:21:14 #41]$ sudo vim ports.conf
        Listen 80   =>  Listen 8001

        [llllljian@llllljian-virtual-machine apache2 14:26:16 #46]$ apache2R
        [ ok ] Restarting apache2 (via systemctl): apache2.service.

        [llllljian@llllljian-virtual-machine apache2 14:36:14 #47]$ sudo netstat -tunlp | grep 8001
        tcp6       0      0 :::8001                 :::*                    LISTEN      4138/apache2

        现在浏览器中访问地址改为http://127.0.0.1:8001
                              http://127.0.0.1:8001/info.php
                              http://127.0.0.1:8001/phpmyadmin

        [llllljian@llllljian-virtual-machine ~ 14:46:25 #49]$ sudo apt-get install nginx

        [llllljian@llllljian-virtual-machine ~ 16:15:07 #334]$ sudo vim /etc/nginx/sites-available/default
        listen 80 default_server; =>  listen 8002 default_server;
        listen [::]:80 default_server; =>  listen [::]:8002 default_server;
        root /var/www;  =>  root /var/nginx/www;

        [llllljian@llllljian-virtual-machine www 16:18:30 #336]$ sudo service nginx start

        浏览器中访问http://127.0.0.1:8002可以看到nginx欢迎页面

        [llllljian@llllljian-virtual-machine www 16:20:12 #337]$ sudo apt-get install php7.0-fpm

        [llllljian@llllljian-virtual-machine www 16:22:45 #338]$ sudo vim /etc/nginx/sites-available/default
        location ~ \.php$ {
          include snippets/fastcgi-php.conf;
            
        #   # With php-fpm (or other unix sockets):
        #   fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        #   # With php-cgi (or other tcp sockets):
            fastcgi_pass 127.0.0.1:9000;
        }

        [llllljian@llllljian-virtual-machine www 16:23:51 #339]$ sudo service nginx reload

        [llllljian@llllljian-virtual-machine www 16:24:07 #342]$ sudo vim /etc/php/7.0/fpm/pool.d/www.conf
        listen = /run/php/php7.0-fpm.sock
        =>
        ;listen = /run/php/php7.0-fpm.sock
        listen = 127.0.0.1:9000

        [llllljian@llllljian-virtual-machine www 16:25:22 #344]$ sudo service php7.0-fpm start

        [llllljian@llllljian-virtual-machine www 16:26:13 #349]$ pwd
        /var/nginx/www
        
        [llllljian@llllljian-virtual-machine www 16:26:20 #350]$ ls -al
        总用量 20
        drwxr-xr-x 2 root root 4096 7月   1 16:26 .
        drwxr-xr-x 3 root root 4096 7月   1 15:52 ..
        -rw-r--r-- 1 root root  654 7月   1 15:54 index.html
        -rw-r--r-- 1 root root  612 7月   1 15:50 index.nginx-debian.html
        -rw-r--r-- 1 root root  165 7月   1 15:51 info1.php

        浏览器中访问http://127.0.0.1:8002/index.html
                   http://127.0.0.1:8002/index.nginx-debian.html
                   http://127.0.0.1:8002/info1.php

        安装phpmyadmin
        之前已经安装过了,现在就要把phpmyadmin与nginx连接起来
        [llllljian@llllljian-virtual-machine www 17:29:30 #476]$ sudo ln -s /usr/share/phpmyadmin /var/nginx/www/

        [llllljian@llllljian-virtual-machine www 17:30:08 #478]$ ls -al
        总用量 20
        drwxr-xr-x 2 root root 4096 7月   1 17:04 .
        drwxr-xr-x 3 root root 4096 7月   1 15:52 ..
        -rw-r--r-- 1 root root  654 7月   1 15:54 index.html
        -rw-r--r-- 1 root root  612 7月   1 15:50 index.nginx-debian.html
        -rw-r--r-- 1 root root  165 7月   1 15:51 info1.php
        lrwxrwxrwx 1 root root   21 7月   1 17:29 phpmyadmin -> /usr/share/phpmyadmin  

        [llllljian@llllljian-virtual-machine www 17:30:12 #479]$ sudo vim /etc/nginx/sites-available/default
        index index.html index.htm index.nginx-debian.html;
        =>
        index index.html index.htm index.nginx-debian.html index.php; 

        浏览器中访问http://127.0.0.1:8002/phpmyadmin/      
    ```

#### 查看安装版本
    ```bash
        [llllljian@llllljian-virtual-machine www 17:31:40 #480]$ ps aux | grep nginx
        root      9240  0.0  0.6  44844  6168 ?        Ss   16:53   0:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
        nobody    9705  0.0  0.3  44976  3296 ?        S    17:19   0:00 nginx: worker process
        nobody    9706  0.0  0.2  44844  2548 ?        S    17:19   0:00 nginx: worker process
        nobody    9709  0.0  0.2  44844  2548 ?        S    17:19   0:00 nginx: worker process
        lllllji+  9796  0.0  0.0   5140   840 pts/0    S+   17:34   0:00 grep --color=auto nginx

        [llllljian@llllljian-virtual-machine www 17:34:58 #482]$ sudo netstat -tunlp | grep 8002
        tcp        0      0 0.0.0.0:8002            0.0.0.0:*               LISTEN      9240/nginx: master
        tcp6       0      0 :::8002                 :::*                    LISTEN      9240/nginx: master

        [llllljian@llllljian-virtual-machine www 17:35:07 #483]$ netstat -tunlp | grep 8002
        (并非所有进程都能被检测到,所有非本用户的进程信息将不会显示,如果想看到所有信息,则必须切换到 root 用户）
        tcp        0      0 0.0.0.0:8002            0.0.0.0:*               LISTEN      -
        tcp6       0      0 :::8002                 :::*                    LISTEN      -

        [llllljian@llllljian-virtual-machine run 17:49:26 #521]$ nginx -v
        nginx version: nginx/1.10.3 (Ubuntu)

        像Apache一样先设置别名
        [llllljian@llllljian-virtual-machine run 17:50:52 #522]$ vim ~/.bashrc
        ...
        alias nginx1S='sudo /etc/init.d/nginx start'
        alias nginx1R='sudo /etc/init.d/nginx restart'
        alias nginx1E='sudo /etc/init.d/nginx stop'
        ...

        [llllljian@llllljian-virtual-machine run 17:51:23 #524]$ source !$

        [llllljian@llllljian-virtual-machine run 17:52:43 #525]$ nginx1E
        [ ok ] Stopping nginx (via systemctl): nginx.service.

        [llllljian@llllljian-virtual-machine run 17:52:51 #526]$ nginx1S
        [ ok ] Starting nginx (via systemctl): nginx.service.

        [llllljian@llllljian-virtual-machine run 17:53:06 #527]$ nginx1R
        [ ok ] Restarting nginx (via systemctl): nginx.service.

        出现这个错误可能是因为.pid执行没有权限
        [llllljian@llllljian-virtual-machine run 17:55:24 #531]$ nginx -s reload
        nginx: [alert] kill(10238, 1) failed (1: Operation not permitted)

        [llllljian@llllljian-virtual-machine nginx 17:57:40 #538]$ head -n 7 nginx.conf
        # user www-data;
        worker_processes  3;
        # worker_processes auto;
        pid /run/nginx.pid;
        include /etc/nginx/modules-enabled/*.conf;

        [llllljian@llllljian-virtual-machine nginx 17:57:48 #539]$ ll /run/nginx.pid
        -rw-r--r-- 1 root root 6 7月   1 17:53 /run/nginx.pid

        [llllljian@llllljian-virtual-machine nginx 17:58:50 #541]$ sudo nginx -s reload

        nginx -s  向主进程发送信号stop, quit, reopen, reload
    ```
