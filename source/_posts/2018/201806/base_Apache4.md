---
title: Apache_基础 (4)
date: 2018-06-22
tags: Apache
toc: true
---

### .htaccess文件
    .htaccess文件提供了针对每个目录改变配置的方法.

<!-- more -->

#### 使用前提
    需要将httpd.conf中的AllowOverride改为All,这样才能使用.htaccess中的配置.
    需要注意的是,设置对应目录
    如果想使用其它文件名的配置,可以使用AccessFileName来修改配置文件名

#### 能实现什么
- 文件夹密码保护
- 用户自动重定向
- 自定义错误页面
- 改变你的文件扩展名
- 封禁特定IP地址的用户
- 只允许特定IP地址的用户
- 禁止目录列表
- 使用其他文件作为index文件

#### 文件内容说明
- eg1
    ```bash
        RewriteEngine On
        RewriteBase /
        RewriteCond %{HTTP_HOST} ^(www\.)?xxx\.com$ [NC]
        RewriteCond %{REQUEST_URI} !^/blog/
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^(.*)$ blog/$1

        # 没有输入文件名的默认到到首页
        RewriteCond %{HTTP_HOST} ^(www\.)?xxx\.com$ [NC]
        RewriteRule ^(/)?$ blog/index.php [L]
    ```
- eg2
    ```bash
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} -s [OR]
        RewriteCond %{REQUEST_FILENAME} -l [OR]
        RewriteCond %{REQUEST_FILENAME} -d
        RewriteRule ^.*$ - [NC,L]

        RewriteRule (get_info\.php|info\.php) /example1/$1 [r=301,NC,L]
        RewriteRule !\.(js|ico|gif|jpg|jpeg|png|css|swf|html|htm|xml)$ /example1/index.php [NC,L]

        ErrorDocument 404 /404.html
        ErrorDocument 500 /500.html
    ```
- RewriteEngine
    * 说明
        * 打开或关闭运行时的重写引擎
    * 语法
        * RewriteEngine on|off
    * 默认值
        * RewriteEngine off
    * RewriteEngine指令打开或关闭运行时的重写引擎.
    * 如果设置为off,则此模块在运行时不执行任何重写操作, 同时也不更新SCRIPT_URx环境变量.
    * 使用该指令可以使此模块无效,而无须注释所有的RewriteRule指令
    * 默认情况下,重写配置是不可继承的,也就是必须在每个需要使用重写引擎的虚拟主机中设置一个RewriteEngine on指令
- RewriteBase
    * 语法
        * 设置目录级重写的基准URL
    * 说明
        * RewriteBase URL-path
    * 显式地设置了目录级重写的基准URL
- RewriteCond
    * 说明
        * 定义重写发生的条件
    * 语法
        * RewriteCond TestString CondPattern [flags]
    * RewriteCond指令定义了规则生效的条件,即在一个RewriteRule指令之前可以有一个或多个RewriteCond指令
    * 条件之后的重写规则仅在当前URI与Pattern匹配并且满足此处的条件(TestString能够与CondPattern匹配)时才会起作用
    * TestString
        * %{NAME_OF_VARIABLE}
            * HTTP_HOST : 当前访问的网址的前缀部分,格式是www.xxx.com
            * REQUEST_URI : 这是在HTTP请求行中所请求的资源[eg /index.html"]
            * REQUEST_FILENAME : 与请求相匹配的完整的本地文件系统的文件路径名
    * CondPattern
        * -d(目录) : 将TestString视为一个路径名并测试它是否为一个存在的目录.
        * -f(常规文件) : 将TestString视为一个路径名并测试它是否为一个存在的常规文件.
        * -s(非空的常规文件) : 将TestString视为一个路径名并测试它是否为一个存在的、尺寸大于0的常规文件.
        * -l(符号连接) : 将TestString视为一个路径名并测试它是否为一个存在的符号连接.
    * flags
        * NC : 忽略大小写
        * OR : 条件或,或下一条件
- RewriteRule
    * 说明
        * 为重写引擎定义重写规则
    * 语法
        * RewriteRule Pattern Substitution [flags]
    * Pattern : 正则表达式
    * flags
        * NC : 忽略大小写
        * L : 立即停止重写操作,并不再应用其他重写规则
        * r : 强制重定向
- ErrorDocument
    * 说明
        * 当遇到错误的时候服务器将给客户端什么样的应答
    * 语法
        * ErrorDocument error-code document

