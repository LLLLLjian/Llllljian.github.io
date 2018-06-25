---
title: Apache_基础 (2)
date: 2018-06-20
tags: Apache
toc: true
---

### httpd.conf文件
    Apache配置的主文件
    位置 : /usr/local/apache2.2.17/conf/httpd.conf

<!-- more -->

#### 文件内容说明
- ServerRoot
    * 说明
        * 安装服务器的基础目录
    * 语法 
        * ServerRoot directory-path
    * 默认值
        * ServerRoot /usr/local/apache
    * 设置了服务器所在的目录.一般来说它将包含conf/和logs/子目录.其它配置文件的相对路径即基于此目录 (比如Include或LoadModule).
- Listen
    * 说明
        * 服务器监听的IP地址和端口
    * 语法
        * Listen [IP-address:]portnumber [protocol]
        * protocol未指定的话,将为443端口使用默认的https协议,为其它端口使用http协议
    * Listen指令指示Apache只在指定的IP地址和端口上监听
    * 默认情况下Apache会在所有IP地址上监听
    * Listen指令指定服务器在那个端口或地址和端口的组合上监听接入请求.如果只指定一个端口,服务器将在所有地址上监听该端口
    * eg
        ```bash
            服务器接受80和8000端口上的请求
            Listen 80
            Listen 8000

            服务器在两个确定的地址端口组合上接受请求
            Listen 192.170.2.1:80
            Listen 192.170.2.5:8000

            IPv6地址
            Listen [2001:db8::a00:20ff:fea7:ccea]:80

            在8443端口运行https协议
            Listen 192.170.2.1:8443 https
        ```
- LoadModule
    * 说明
        * 加载目标文件或库,并将其添加到活动模块列表
    * 语法
        * LoadModule module filename
    * 该指令加载目标文件或库filename并将模块结构名module添加到活动模块列表
    * module就是源代码文件中用于拼写module的外部变量名,并作为模块标识符(Module Identifier)列在模块文档中
- IfModule
    * 说明
        * 封装指令并根据指定的模块是否启用为条件而决定是否进行处理
    * 语法
        * &lt;IfModule [!]module-file|module-identifier> ... &lt;/IfModule>
    * &lt;IfModule test>...&lt;/IfModule>配置段用于封装根据指定的模块是否启用而决定是否生效的指令.在&lt;IfModule>配置段中的指令仅当test为真的时候才进行处理.如果test为假,所有其间的指令都将被忽略
    * 主要用于需要根据某个特定的模块是否存在来决定是否使用某些配置的时候.指令一般都放在&lt;IfModule>配置段中
- User
    * 说明
        * 实际服务于请求的子进程运行时的用户
    * 语法
        * User unix-userid
        * Group #用户ID
        * Group 用户名
    * 默认
        * User #-1
    * 为了使用这个指令,服务器必须以root身份启动和初始化
    * 如果你以非root身份启动服务器,子进程将不能够切换至非特权用户,并继续以启动服务器的原始用户身份运行.
    * 如果确实以root用户启动了服务器,那么父进程将仍然以root身份运行
    * 为了安全考虑,不要将User设置为root
- Group
    * 说明
        * 对请求提供服务的Apache子进程运行时的用户组
    * 语法
        * Group unix-group
        * Group #组ID
        * Group 组名
    * 默认
        * Group #-1
    * Apache必须以root初始化启动,否则在切换用户组时会失败,并继续以初始化启动时的用户组运行
    * 为了安全考虑,不要将Group设置为root
- DocumentRoot
    * 说明
        * 组成网络上可见的主文档树的根目录
    * 语法
        * DocumentRoot directory-path
    * 默认值
        * DocumentRoot /usr/local/apache2/htdocs
    * 指定DocumentRoot时不应包括最后的"/".
- &lt;Directory>
    * 说明
        * 封装一组指令,使之仅对文件空间中的某个目录及其子目录生效
    * 语法
        * &lt;Directory directory-path> ... &lt;/Directory>
    * Options 
        * 配置在特定目录中可以使用哪些特性
        * FollowSymLinks : 服务器允许在此目录中使用符号连接
    * AllowOverride
        * 确定允许存在于.htaccess文件中的指令类型
        * All : 所有具有".htaccess"作用域的指令都允许出现在.htaccess文件中
        * None : .htaccess文件将被完全忽略.事实上,服务器根本不会读取.htaccess文件.
    * Order
        * 控制默认的访问状态与Allow和Deny指令生效的顺序
        * Deny,Allow : Deny指令在Allow指令之前被评估.默认允许所有访问.任何不匹配Deny指令或者匹配Allow指令的客户都被允许访问
        * Allow,Deny : Allow指令在Deny指令之前被评估.默认拒绝所有访问.任何不匹配Allow指令或者匹配Deny指令的客户都将被禁止访问
    * Allow 
        * 控制哪些主机能够访问服务器的该区域
        * Allow from all : 允许所有主机访问
    * Deny 
        * 控制哪些主机被禁止访问服务器
        * Deny from all : 拒绝所有主机访问
    * Satisfy 
        * 主机级别的访问控制和用户认证之间的相互关系
        * 默认行为(All)采取客户端首先通过地址访问限制并且输入有效的用户名和密码的方式
- DirectoryIndex
    * 说明
        * 当客户端请求一个目录时寻找的资源列表
    * 语法
        * DirectoryIndex local-url [local-url] ...
    * 默认值
        * DirectoryIndex index.html
    * 当客户端在请求的目录名的末尾刻意添加一个"/"以表示请求该目录的索引时,服务器需要寻找的资源列表.Local-url(%已解码的)是一个相对于被请求目录的文档的URL(通常是那个目录中的一个文件).可以指定多个URL,服务器将返回最先找到的那一个.若一个也没有找到,并且那个目录设置了Indexes选项,服务器将会自动产生一个那个目录中的资源列表
    * 通俗讲就是说请求的地址没有指定到文件的时候,默认请求展示的页面,如果没有这个页面就展示文件夹内的文件内容
- ErrorLog 
    * 说明
        * 存放错误日志的位置
    * 语法
        * ErrorLog file-path|syslog[:facility]
    * 默认值
        * ErrorLog logs/error_log
    * 指定了当服务器遇到错误时记录错误日志的文件
    * 如果file-path不是一个以斜杠(/)开头的绝对路径,那么将被认为是一个相对于ServerRoot的相对路径
    * 如果file-path以一个管道符号(|)开头,那么会为它指定一个命令来处理错误日志
    * eg
        ```bash
            ErrorLog "logs/error_log"

            # 每天生成一个错误日志
            # rotatelogs logfile [ rotationtime [ offset ]] | [ filesizeM ]
            # rotationtime 86400 时间间隔为一天
            # offset 480 相对于UTC的时差的分钟数.中国第八时区,相差8小时 = 480分钟
            ErrorLog "|/usr/local/apache2217/bin/rotatelogs /data/apache_log/errlog_log_%Y%m%d 86400 480"
        ```
- LogLevel
    * 说明
        * 控制错误日志的详细程度
    * 语法
        * LogLevel level
    * 默认值
        * LogLevel warn
    * Level	描述
        * emerg	紧急(系统无法使用)
        * alert	必须立即采取措施
        * crit	致命情况	
        * error	错误情况	
        * warn	警告情况	
        * notice	一般重要情况
        * info	普通信息	
        * debug	调试信息	
- LogFormat 
    * 说明
        * 定义访问日志的记录格式
    * 语法
        * LogFormat format|nickname [nickname]
    * 默认值
        * LogFormat "%h %l %u %t \"%r\" %>s %b"
    * 配合CustomLog使用
- CustomLog 
    * 说明
        * 设定日志的文件名和格式
    * 语法
        * CustomLog file|pipe format|nickname [env=[!]environment-variable]
    * 用来对服务器的请求进行日志记录
    * eg
        ```bash
            # “%｛Referer｝i”代表访问网站时,自己所处的地址,
            # “%{User-Agent}i”代表用户使用什么浏览器访问的网站,以及用户所使用的系统是什么操作系统.
            # “common”字段很重要,它代表是自己定义的

            LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
            LogFormat "%h %l %u %t \"%r\" %>s %b" common

            LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio

            CustomLog "|/usr/local/apache2217/bin/rotatelogs /data/apache_log/access_log_%Y%m%d 86400 480" common
        ```
- ScriptAlias 
    * 说明
        * 映射一个URL到文件系统并视之为CGI脚本
    * 语法
        * ScriptAlias URL-path file-path|directory-path
    * ScriptAlias指令的行为与Alias指令相同,但同时它又标明此目录中含有应该由cgi-script处理器处理的CGI脚本
    * eg
        ```bash
            对http://xxxxx/cgi-bin/foo的请求会引导服务器执行/web/cgi-bin/foo脚本.
            ScriptAlias /cgi-bin/ /web/cgi-bin/
        ```
- DefaultType
    * 说明
        * 在服务器无法由其他方法确定内容类型时,发送的默认MIME内容类型
    * 语法
        * DefaultType MIME-type
    * 默认值
        * DefaultType text/plain
    * 当一个未知类型出现时,将会使用DefaultType
- TypesConfig 
    * 说明
        * 指定mime.types文件的位置
    * 语法
        * TypesConfig file-path
    * 默认值
        * TypesConfig conf/mime.types
- AddType
    * 说明
        * 在给定的文件扩展名与特定的内容类型之间建立映射
    * 语法
        * AddType MIME-type extension [extension] ...
    * 在给定的文件扩展名与特定的内容类型之间建立映射关系
    * eg
        ```bash
            AddType application/x-compress .Z
            AddType application/x-gzip .gz .tgz
            AddType application/x-httpd-php .php
        ``` 
- SSLRandomSeed
    * 说明
        * 指定伪随机数生成器(PRNG)的随机数种子源
    * 语法
        * SSLRandomSeed context source [bytes]
    * OpenSSL启动时(context=startup) 
    * 建立新SSL连接时(context=connect)
    * source=builtin 永远可用的内置源
- Include 
    * 说明
        * 在服务器配置文件中包含其它配置文件
    * 语法
        * Include file-path|directory-path
    * 在服务器配置文件中加入其它配置文件
