---
title: Nginx_基础 (8)
date: 2018-07-04
tags: Nginx
toc: true
---

### Nginx的Rewrite功能
    接上一节

<!-- more -->

#### Rewrite的使用

##### 域名跳转
- 域名跳转
    ```bash
        ...
        server
        {
            listen 80;
            server_name jump.myweb.name;
            rewrite ^/ http://www.myweb.info/;
            ...
        }
        ...

        客户端访问http://jump.myweb.name时,URL将被Nginx服务器重写为http://www.myweb.info/
        客户得到的数据实际是由http://www.myweb.info/响应的
    ```
- 多域名跳转
    ```bash
        ...
        server
        {
            listen 80;
            server_name jump.myweb.name jump.myweb.info;

            if ($host ~ myweb\.info) 
            {
                rewrite ^(.*) http://www.myweb.name$1 permanent;
            }
            ...
        }
        ...

        客户端访问http://www.myweb.info/reqsource时,URL将被Nginx服务器重写为http://www.myweb.name/reqsource,客户端得到的数据是由http://www.myweb.name响应的
    ```
- 三级域名跳转
    ```bash
        ...
        server
        {
            listen 80;
            server_name jump1.myweb.name jump2.myweb.name;

            if ($http_host ~* ^(.*)\.myweb\name$) 
            {
                rewrite ^(.*) http://jump.myweb.name$1;
                break;
            }
            ...
        }
        ...

        客户端访问http://jump1.myweb.name/reqsource或http://jump2.myweb.name/reqsource,URL都被Nginx服务器重写为http://jump.myweb.name/reqsource,实现三级域名的跳转
    ```

##### 域名镜像
- 整个网站
    ```bash
        ...
        server
        {
            ...
            listen 80;
            server_name mirror1.myweb.name;
            rewrite ^(.*) http://jump1.myweb.name$1 last;
        }

        server
        {
            ...
            listen 81;
            server_name mirror2.myweb.name;
            rewrite ^(.*) http://jump2.myweb.name$1 last;
        }
        ...
    ```
- 某个子目录
    ```bash
        ...
        server
        {
            listen 80;
            server_name jump.myweb.name;
            location ^~ /source1
            {
                ...
                rewrite ^/source1(.*) http://jump.myweb.name/websrc2$1 last;
                break;
            }

            location ^~ /source2
            {
                ...
                rewrite ^/source2(.*) http://jump.myweb.name/websrc2$1 last;
                break;
            }
            ...
        }
        ...
    ```

##### 独立域名
    ```bash
        ...
        server
        {
            ...
            listen 80;
            server_name bbs.myweb.name;
            rewrite ^(.*) http://www.myweb.name/bbs$1 last;
            break;
        }
        server
        {
            ...
            listen 81;
            server_name home.myweb.name;
            rewrite ^(.*) http://www.myweb.name/home$1 last;
            break;
        }
        ...
    ```

##### 目录自动添加"/"
    ```bash
        ...
        server
        {
            ...
            listen 81;
            server_name www.myweb.name;
            
            location ^~ /bbs
            {
                if (-d $request_filename) 
                {
                    rewrite ^/(.*)([^/])$ http://$host/$1$2/ permanent;
                }
            }
        }
        ...
    ```

##### 目录合并
    ```bash
        ...
        server
        {
            ...
            listen 80;
            server_name www.myweb.name;

            location ^~ /server
            {
                ...
                rewrite ^/server-([0-9]+)-([0-9]+)-([0-9]+)-([0-9]+)-([0-9]+)\.htm$ /server/$1/$2/$3/$4/$5.htm last;
                break;
            }
            ...
        }
        ...

        客户端访问 http://www.myweb.name/server-12-34-56-78-9.htm
        实际访问的是 http://www.myweb.name/server/12/34/56/78/9.htm
    ```

##### 防盗链
- 根据文件类型
    ```bash
        ...
        server
        {
            ...
            listen 80;
            server_name www.myweb.name;

            location ~* ^.+\.(gif|jpg|png|swf|flv|rar|zip)$
            {
                ...
                valid_referers none blocked server_names *. myweb.name;

                if ($invalid_referer) 
                {
                    rewrite ^/ http://www.myweb.com/images/forbidden.png;
                }
            }
            ...
        }
        ...
    ```
- 根据目录
    ```bash
        ...
        server
        {
            ...
                listen 80;
                server_name www.myweb.name;

                location /file/
                {
                    ...
                    root /server/file/;
                    valid_referers none blocked server_names *. myweb.name;

                    if ($invalid_referer)
                    {
                        rewrite ^/ http://www.myweb.com/images/forbidden.png;
                    }
                    ...
                }
            ...
        }
        ...
    ```
