---
title: Linux_基础 (60)
date: 2019-07-10
tags: Linux
toc: true
---

### Linux使用命令
    列一些实用的linux命令

<!-- more -->

#### 展示文件夹下文件详情
- linux命令
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 17:56:37 #2]$ ls -l --time-style=+'%Y-%m-%d %H:%M:%S' /var/nginx/html/tp5/
        total 144
        drwxrwxrwx  4 root   root    4096 2019-07-20 01:31:35 application
        -rwxrwxrwx  1 root   root    1070 2019-06-30 11:18:48 build.php
        -rwxrwxrwx  1 root   root   34738 2019-06-30 11:18:48 CHANGELOG.md
        -rwxrwxrwx  1 root   root     787 2019-07-18 12:53:20 composer.json
        -rwxrwxrwx  1 root   root   48611 2019-07-18 12:55:50 composer.lock
        drwxrwxrwx  2 root   root    4096 2019-07-26 16:57:02 config
        drwxrwxrwx  2 root   root    4096 2019-06-30 11:18:48 extend
        -rwxrwxrwx  1 root   root    1822 2019-06-30 11:18:48 LICENSE.txt
        drwxrwxrwx  4 root   root    4096 2019-07-20 02:13:14 public
        drwxrwxrwx  2 ubuntu ubuntu  4096 2019-07-15 18:02:48 python
        -rwxrwxrwx  1 root   root    6613 2019-06-30 11:18:48 README.md
        drwxrwxrwx  2 root   root    4096 2019-06-30 11:18:48 route
        drwxrwxrwx  5 root   root    4096 2019-07-05 16:42:52 runtime
        -rwxrwxrwx  1 root   root     823 2019-06-30 11:18:48 think
        drwxrwxrwx  5 root   root    4096 2019-06-30 11:19:05 thinkphp
        drwxrwxrwx 14 root   root    4096 2019-07-18 12:55:50 vendor
    ```

#### 查看今天的错误日志
- linux命令
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 18:04:08 #17]$ sudo tail -1 /var/log/nginx/access.log | grep `date +%d/%b/%Y`
        160.119.129.62 - - [26/Jul/2019:17:09:42 +0800] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/601.7.7 (KHTML, like Gecko) Version/9.1.2 Safari/601.7.7"
    ```

#### 查看进程
- linux命令
    ```bash
        ps x -o pid,user,pcpu,pmem,vsz,rss,stat,start,time,cmd --sort=-pcpu,-pmem,pid
    ```

#### 查看系统平均负载
- linux命令
    ```bash
        cat /proc/loadavg
    ```
