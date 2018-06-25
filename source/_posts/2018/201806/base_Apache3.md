---
title: Apache_基础 (3)
date: 2018-06-21
tags: Apache
toc: true
---

### httpd-vhosts.conf文件
    Apache配置虚拟主机的主文件
    位置 : /usr/local/apache2.2.17/conf/extra/httpd-vhosts.conf

<!-- more -->

#### 配置虚拟主机的步骤
- 1.修改httpd.conf文件
    ```bash
        vim /usr/local/apache2.2.17/conf/httpd.conf

        # Virtual hosts
        #Include conf/extra/httpd-vhosts.conf

        # Virtual hosts
        Include conf/extra/httpd-vhosts.conf
    ```
- 2.修改httpd-vhosts.conf文件
    ```bash
        <VirtualHost *:80>
            DocumentRoot /www/example1
            ServerName www.example1.com
            ErrorLog "|/usr/local/apache2217/bin/rotatelogs /data/apache_log/errlog_example1_log_%Y%m%d 86400 480"
            CustomLog "|/usr/local/apache2217/bin/rotatelogs /data/apache_log/access_log_%Y%m%d 86400 480" common
            
            <Directory /www/example1>
                Options FollowSymLinks IncludesNOEXEC Indexes
                DirectoryIndex index.html index.htm index.php
                AllowOverride all
                Order Deny,Allow
                Allow from all
                Require all granted
            </Directory>
        </VirtualHost>
    ```
- 3.修改host文件
    * Windows
        * C:\WINDOWS\system32\drivers\etc\hosts
    * Linux
        * /etc/hosts
    * 修改内容
        * 127.0.0.1       www.example1.com

#### 文件内容说明
- &lt;VirtualHost>
    * 说明
        * 包含仅作用于指定主机名或IP地址的指令
    * 语法
        * &lt;VirtualHost addr[:port] [addr[:port]] ...> ... &lt;/VirtualHost>
    * &lt;VirtualHost>和&lt;/VirtualHost>用于封装一组仅作用于特定虚拟主机的指令
    * 当服务器接受了一个特定虚拟主机的文档请求时,它会使用封装在&lt;VirtualHost>配置段中的指令
    * &lt;VirtualHost *:80> 监听所有地址上的80端口
- DocumentRoot 
    * 详细的可以看上一节
    * 指定DocumentRoot时不应包括最后的"/".
    * 这里指的是虚拟目录指向的文件夹
- ServerName
    * 说明
        * 服务器用于辨识自己的主机名和端口号
    * 语法
        * ServerName [scheme://]fully-qualified-domain-name[:port]
    * 主要用于创建重定向URL
- ErrorLog
    * 错误日志,详细的可以看上一节
- CustomLog
    * 服务器日志,详细的可以看上一节
- &lt;Directory> 
    * 详细的可以看上一节
    * 这里指的是对/www/example1目录约束
- Options
    * FollowSymLinks : 服务器允许在此目录中使用符号连接.
    * IncludesNOEXEC : 允许服务器端包含,但禁用"#exec cmd"和"#exec cgi"
    * Indexes : 如果一个映射到目录的URL被请求,而此目录中又没有DirectoryIndex(例如 : index.html),那么服务器会返回由mod_autoindex生成的一个格式化后的目录列表
- DirectoryIndex
    * 当客户端请求的是一个目录是首先寻找相应的资源列表
- AllowOverride
    * .htaccess文件生效,所有具有".htaccess"作用域的指令都允许出现在.htaccess文件中.
- Order
    * Deny指令在Allow指令之前被评估
- Allow
    * 允许所有主机访问
- Require
    * 指定哪些认证用户允许访问该资源

