---
title: Nginx_基础 (3)
date: 2018-06-27
tags: Nginx
toc: true
---

### Nginx基础使用
    接上一篇,继续学习配置文件指令

<!-- more -->

#### 配置文件详解[nginx.conf]
- use
    * 说明
        * 事件驱动模型的选择
    * 语法
        * use method;
    * 位置
        * event块
    * method可选择的内容有 : select poll kqueue epoll rtsig /dev/poll eventport
- worker_connections
    * 说明
        * 配置最大连接数,设置每个工作进程可以打开的最大并发连接数
    * 语法
        * worker_connections number;
    * 默认值	
        * worker_connections 512;
    * 位置
        * events
- default_type
    * 说明
        * 定义响应的默认MIME类型
    * 语法
        * default_type mime-type;
    * 默认
        * default_type text/plain;
    * 位置
        * http块, server块, location块
    * application/octet-stream : 所有请求生成MIME类型
- log_format
    * 说明
        * 指定日志的格式
    * 语法
        * log_format name string ...;
    * 位置
        * http块
    * string
        * $body_bytes_sent : 发送给客户端的字节数,不包括响应头的大小； 该变量与Apache模块mod_log_config里的“%B”参数兼容.
        * $bytes_sent : 发送给客户端的总字节数.
        * $connection : 连接的序列号.
        * $connection_requests : 当前通过一个连接获得的请求数量.
        * $msec : 日志写入时间.单位为秒,精度是毫秒.
        * $pipe : 如果请求是通过HTTP流水线(pipelined)发送,pipe值为“p”,否则为“.”.
        * $request_length : 请求的长度（包括请求行,请求头和请求正文）.
        * $request_time : 请求处理时间,单位为秒,精度毫秒； 从读入客户端的第一个字节开始,直到把最后一个字符发送给客户端后进行日志写入为止.
        * $status : 响应状态.
        * $time_iso8601 : ISO8601标准格式下的本地时间.
        * $time_local : 通用日志格式下的本地时间.
    * eg
        ```bash
            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                              '$status $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for" $request_time';

            log_format  norequest  '$remote_addr - $remote_user [$time_local] "norequest" '
                                   '$status $body_bytes_sent "$http_referer" '
                                   '"$http_user_agent" "$http_x_forwarded_for" $request_time';
        ```
- access_log
    * 说明
        * 为访问[服务]日志设置路径,格式和缓冲区大小
    * 语法
        * access_log path [format [buffer=size]];
        * access_log off;
    * 位置
        * http块, server块, location块
    * path : 配置服务日志的文件存放的路径和名称
    * format : 根据log_format指令中定义好的格式
    * size : 配置临时存放日志的内存缓存区大小
    * off : 取消记录服务日志的功能
- sendfile
    * 说明
        * 配置允许sendfile方式传输文件
    * 语法
        * sendfile on | off;
    * 默认
        * sendfile off;
    * 位置
        * http块, server块, location块
- sendfile_max_chunk
    * 语法
        * sendfile_max_chunk size;
    * 默认
        * sendfile_max_chunk 0;
    * 位置
        * http块, server块, location块
- keepalive_timeout
    * 说明
        * 配置连接超时时间
    * 语法
        * keepalive_timeout timeout [header_timeout];	
    * 默认
        * keepalive_timeout 75s;
    * 位置
        * http块, server块, location块
    * timeout : 设置客户端的长连接在服务器端保持的最长时间（在此时间客户端未发起新请求,则长连接关闭）
    * header_timeout : 可选项,设置“Keep-Alive: timeout=time”响应头的值. 可以为这两个参数设置不同的值
- keepalive_requests
    * 说明
        * 单连接请求数上限,请求数超过此值,长连接将关闭
    * 语法
        * keepalive_requests number;
    * 默认
        * keepalive_requests 100;
    * 位置
        * http块, server块, location块
- listen
    * 主要说一下监听端口
    * 语法
        * listen port [default_server] [setfib=number] [backlog=number] [rcvbuf=size] [sndbuf=size] [accept_filter=filter] [deferred] [bind] [ipv6only=on|off] [ssl] [so_keepalive=on|off|[keepidle]:[keepintvl]:[keepcnt]];
    * 在没有定义listen指令的情况下,如果以超级用户权限运行nginx,它将监听\*:80,否则他将监听*:8000
    * 位置
        * server块 
- server_name
    * 说明
        * 基于名称的虚拟主机配置
    * 语法
        * server_name name ...;
    * 位置
        * server块
    * 对于name来说,可以只有一个名称,也可以有多个名称并列,之间用空格隔开,每个名字都是一个域名
    * 还可以使用通配符和正则表达式进行匹配
    * 匹配顺序为 : 确切的名字 &gt; 通配符起始的server_name > 通配符结束的server_name > 按顺序第一个匹配成功的正则表达式名字
- location
    * 说明
        * 为某个请求URI（路径）建立配置
    * 语法
        * location [ = | ~ | ~* | ^~ ] uri { ... }
        * location @name { ... }
    * 位置
        * server块, location块
    * = : 用于标准url前,要求请求字符串和url严格匹配.如果已经匹配成功,就停止往下搜索并立刻处理此请求
    * ~ : 用于表示url包含正则表达式,并区分大小写
    * ~* : 用于表示url包含正则表达式,并且不区分大小写
    * ^~ : 用于标准url前,要求Nginx服务器找到标识url和请求字符串匹配度最高的location后,立即使用此location处理请求,而不再使用location块中的正则url和请求字符串做匹配
    * eg
        ```bash
            location = / {
                [ configuration A ]
            }

            location / {
                [ configuration B ]
            }

            location /documents/ {
                [ configuration C ]
            }

            location ^~ /images/ {
                [ configuration D ]
            }

            location ~* \.(gif|jpg|jpeg)$ { 
                [ configuration E ] 
            } 
            请求“/”匹配配置A, 请求“/index.html”匹配配置B, 请求“/documents/document.html”匹配配置C, 请求“/images/1.gif”匹配配置D, 请求“/documents/1.jpg”匹配配置E.
        ```
- root
    * 说明
        * 配置请求的根目录
    * 语法
        * root path;
    * 默认
        * root html; 
    * 位置
        * http块, server块, location块
    * eg
        ```bash
            location /i/ {
                root /data/w3;
            }

            /i/top.gif  =>  /data/w3/i/top.gif

            location /data/ {
                root /locationtest1;
            }

            /data/index.html    =>  /locationtest1/data/index.html
        ```
- alias
    * 说明
        * 更改location的URL
    * 语法
        * alias path
    * 位置
        * location块
    * path的值可以包含变量,但不能使用\$document_root和\$realpath_root这两个变量
    * eg
        ```bash
            location /i/ {
                alias /data/w3/images/;
            }

            /i/top.gif  =>  /data/w3/images/top.gif
        ```
- index
    * 说明
        * 设置网站的默认首页
    * 语法
        * index file ...;
    * 默认
        * index index.html;
    * 位置
        * http块, server块, location块
    * eg
        ```bash
            location ~ ^/data/(.+)/web/ $
            {
                index $1.html index.php index.htm
            }
            /data/locationtest/web  => /data/locationtest/web/locationtest.html
                                    => /data/locationtest/web/index.php
                                    => /data/locationtest/web/index.htm
        ```
- error_page
    * 说明
        * 设置网站的错误页面
    * 语法
        * error_page code ... [=[response]] uri;
    * 位置
        * http块, server块, location块
    * code : 要处理的HTTP错误代码
    * response : 可选项,将code指定的错误代码转化为新的错误代码response
    * uri : 错误页面的路径或者网站地址
    * eg
        ```bash
            error_page 500 502 503 504 /50x.html
            location = /50x.html
            {
                root html;
            }
        ```

