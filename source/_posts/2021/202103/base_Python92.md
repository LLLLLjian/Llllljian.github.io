---
title: Python_基础 (92)
date: 2021-03-23
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    通过Nginx部署Django

<!-- more -->

#### 前情提要
> 我们的项目到我手里的时候已经搭建好了, 自己没有搭建过, 这里就试着搭建一遍

#### 环境准备
1. 安装nginx
2. 安装python3.7
3. 安装django3.2

#### 安装uwsgi
1. 通过pip安装uwsgi
    ```python
        python3 -m pip install uwsgi
    ```
2. 创建test.py
    ```python
        [ubuntu@llllljian-cloud-tencent test 21:32:01 #22]$ cat test.py
        def application(env, start_response):
            start_response('200 OK', [('Content-Type','text/html')])
            return [b"Hello World"]
    ```
3. 通过uwsgi运行该文件
    ```python
        [ubuntu@llllljian-cloud-tencent test 21:32:03 #23]$ uwsgi --http :8700 --wsgi-file test.py
    ```
4. 页面访问ip:8700, 就可以看到Hello World了

#### 关联Nginx+uwsgi+Django
1. 在manage.py同级目录新建文件uwsgi.ini
    ```bash
        [ubuntu@llllljian-cloud-tencent mysite 22:37:43 #178]$ cat uwsgi.ini
        # myweb_uwsgi.ini file
        [uwsgi]

        # Django-related settings

        socket = :8500

        # the base directory (full path)
        chdir           = /var/nginx/html/mysite

        # Django s wsgi file
        module          = mysite.wsgi

        # process-related settings
        # master
        master          = true

        # maximum number of worker processes
        processes       = 4

        # ... with appropriate permissions - may be needed
        # chmod-socket    = 664
        # clear environment on exit
        vacuum          = true
    ```
2. 配置uwsgi和Nginx的连接
    ```bash
        server {
            listen         8700; 
            server_name    127.0.0.1 
            charset UTF-8;
            access_log      /var/log/nginx/web_access.log;
            error_log       /var/log/nginx/web_error.log;

            client_max_body_size 75M;

            location / { 
                include uwsgi_params;                   # 通过uwsgi转发请求
                uwsgi_pass 127.0.0.1:8500;              # 和上文配置的socket端口保持一致
                uwsgi_read_timeout 15;                  # 设置请求超时时间
            }   
            location /static {                          # 访问静态资源
                expires 30d;
                autoindex on; 
                add_header Cache-Control private;
                alias /var/web/;
            }
        }
    ```
3. 设置允许访问的ip
    ```bash
        [ubuntu@llllljian-cloud-tencent mysite 22:40:12 #180]$ vim mysite/settings.py
        ....
        ALLOWED_HOSTS = ["xx.xx.xx.xx"]
    ```
4. 重启nginx并且启动项目
    ```bash
        [ubuntu@llllljian-cloud-tencent mysite 22:40:19 #181]$ uwsgi --ini uwsgi.ini
        [uWSGI] getting INI configuration from uwsgi.ini
        *** Starting uWSGI 2.0.19.1 (64bit) on [Sun May 23 22:42:02 2021] ***
        compiled with version: 5.4.0 20160609 on 23 May 2021 13:25:32
        os: Linux-4.4.0-130-generic #156-Ubuntu SMP Thu Jun 14 08:53:28 UTC 2018
        nodename: llllljian-cloud-tencent
        machine: x86_64
        clock source: unix
        pcre jit disabled
        detected number of CPU cores: 1
        current working directory: /var/nginx/html/mysite
        detected binary path: /usr/local/bin/uwsgi
        chdir() to /var/nginx/html/mysite
        your processes number limit is 3299
        your memory page size is 4096 bytes
        detected max file descriptor number: 1024
        lock engine: pthread robust mutexes
        thunder lock: disabled (you can enable it with --thunder-lock)
        uwsgi socket 0 bound to TCP address :8500 fd 3
        Python version: 3.7.1 (default, Dec 23 2019, 00:52:34)  [GCC 5.4.0 20160609]
        *** Python threads support is disabled. You can enable it with --enable-threads ***
        Python main interpreter initialized at 0x28067d0
        your server socket listen backlog is limited to 100 connections
        your mercy for graceful operations on workers is 60 seconds
        mapped 364600 bytes (356 KB) for 4 cores
        *** Operational MODE: preforking ***
        WSGI app 0 (mountpoint='') ready in 1 seconds on interpreter 0x28067d0 pid: 17815 (default app)
        *** uWSGI is running in multiple interpreter mode ***
        spawned uWSGI master process (pid: 17815)
        spawned uWSGI worker 1 (pid: 17834, cores: 1)
        spawned uWSGI worker 2 (pid: 17835, cores: 1)
        spawned uWSGI worker 3 (pid: 17836, cores: 1)
        spawned uWSGI worker 4 (pid: 17837, cores: 1)
        [pid: 17837|app: 0|req: 1/1] 111.194.45.70 () {42 vars in 761 bytes} [Sun May 23 14:42:13 2021] GET / => generated 10697 bytes in 22 msecs (HTTP/1.1 200) 5 headers in 153 bytes (1 switches on core 0)
    ```
5. 访问http://xx.xx.xx.xx:8700/, 这时候可以看见一个小火箭, 并且会在启动项目页面看到一个请求

