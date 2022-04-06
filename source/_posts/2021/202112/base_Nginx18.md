---
title: Nginx_基础 (18)
date: 2021-12-13
tags: Nginx
toc: true
---

### 还学Nginx
    nginx之try_files

<!-- more -->

#### 前情提要
> 今天在看nginx配置文件的时候 发现有try_files 那我一想 我不能不会呀, 所以记录一下

#### try_files详解
- 作用
    * try_files是nginx中http_core核心模块所带的指令, 主要是能替代一些rewrite的指令, 提高解析效率
- 语法规则
    ```bash
        # 格式1
        try_files file ... uri; 
        # 格式2
        try_files file ... =code;

        # 关键点1 按指定的file顺序查找存在的文件, 并使用第一个找到的文件进行请求处理
        # 关键点2 查找路径是按照给定的root或alias为根路径来查找的
        # 关键点3 如果给出的file都没有匹配到, 则重新请求最后一个参数给定的uri, 就是新的location匹配
        # 关键点4 如果是格式2, 如果最后一个参数是 = 404 , 若给出的file都没有匹配到, 则最后返回404的响应码
    ```
- 举例
    ```bash
        # 比如 请求 127.0.0.1/images/test.gif 会依次查找 
        # 1.文件/opt/html/images/test.gif
        # 2.文件夹 /opt/html/images/test.gif/下的index文件 
        # 3.请求127.0.0.1/images/default.gif
        location /images/ {
            root /opt/html/;
            try_files $uri   $uri/  /images/default.gif;
        }
    ```
- 其他注意事项
    * 1.try-files 如果不写上 $uri/, 当直接访问一个目录路径时, 并不会去匹配目录下的索引页  即 访问127.0.0.1/images/ 不会去访问  127.0.0.1/images/index.html 
- 其他用法
    ```bash
        location / {
            try_files /system/maintenance.html
                    $uri $uri/index.html $uri.html
                    @mongrel;
        }

        location @mongrel {
            proxy_pass http://mongrel;
        }
        # 以上中若未找到给定顺序的文件, 则将会交给location @mongrel处理(相当于匹配到了@mongrel来匹配)
    ```








