---
title: Nginx_基础 (7)
date: 2018-07-03
tags: Nginx
toc: true
---

### Nginx的Rewrite功能
    主要看一下Nginx的重写

<!-- more -->

#### 后端服务器组的配置指令
- upstream
    * 说明
        * 定义一组服务器。 这些服务器可以监听不同的端口。 而且，监听在TCP和UNIX域套接字的服务器可以混用
    * 语法
        * upstream name { ... }
    * 位置
        * http
    * 默认情况下,某个服务器组接收到请求之后,按照轮叫调度策略顺序选择组内服务器处理请求.如果一个服务器在处理请求的过程中出现错误,请求会被顺次交给组内的下一个服务器进行处理,以此类推,直到正常相应.但如果所有的组内服务器都出错,则返回最后一个服务器的处理结果.可以根据服务器的处理能力配置不同的权重
    * eg
        ```bash
            upstream backend {
                server backend1.example.com weight=5;
                server 127.0.0.1:8080       max_fails=3 fail_timeout=30s;
                server unix:/tmp/backend3;
            }

            每7个请求会通过以下方式分发： 5个请求分到backend1.example.com， 一个请求分到第二个服务器，一个请求分到第三个服务器。 与服务器通信的时候，如果出现错误，请求会被传给下一个服务器，直到所有可用的服务器都被尝试过。 如果所有服务器都返回失败，客户端将会得到最后通信的那个服务器的（失败）响应结果。
        ```
- server
    * 说明
        * 定义服务器的地址address和其他参数parameters
    * 语法
        * server address [parameters];
    * 位置
        * upstream
    * parameters
        * weight=number : 设定服务器的权重，默认是1。
        * max_fails=number : 设定Nginx与服务器通信的尝试失败的次数。在fail_timeout参数定义的时间段内，如果失败的次数达到此值，Nginx就认为服务器不可用。在下一个fail_timeout时间段，服务器不会再被尝试。 失败的尝试次数默认是1。设为0就会停止统计尝试次数，认为服务器是一直可用的。 你可以通过指令proxy_next_upstream、 fastcgi_next_upstream和 memcached_next_upstream来配置什么是失败的尝试。 默认配置时，http_404状态不被认为是失败的尝试。
        * fail_timeout=time : 设定统计失败尝试次数的时间段。在这段时间中，服务器失败次数达到指定的尝试次数，服务器就被认为不可用。服务器被认为不可用的时间段。默认情况下，该超时时间是10秒。
        * backup : 标记为备用服务器。当主服务器不可用以后，请求会被传给这些服务器。
        * down : 标记服务器永久不可用，可以跟ip_hash指令一起使用。
    * eg
        ```bash
            upstream backend {
                server backend1.example.com     weight=5;
                server 127.0.0.1:8080           max_fails=3 fail_timeout=30s;
                server unix:/tmp/backend3;

                server backup1.example.com:8080 backup;
            }

            服务器组名为backend
            组内包含四台服务器,
            分别是
            基于域名的backend1.example.com,权重设置为5,为组内最大,优先接收和处理请求
            基于IP地址的127.0.0.1:8080,如果在30s内连续请求3次失败,则该服务器在之后的30s内被任务是无效的
            用于进程间通信的Unix Domain Socket
            备用服务器backup1.example.com:8080
        ```
- ip_bash
    * 说明
        * 用于会话保持功能,将某个客户端的多次请求定向到组内同一台服务器上,保证客户端和服务器之间建立稳定的会话
        * 只有该服务器处于无效[down]状态时,客户端请求才会被下一个服务器接收和处理
    * 语法
        * ip_hash;
    * 位置
        * upstream
    * ip_bash不能和weight一起使用
    * eg
        ```bash
            upstream backend {
                ip_hash;

                server backend1.example.com;
                server backend2.example.com;
            }

            服务器组名为backend
            组内包含两台服务器,backend1.example.com和backend2.example.com
            ip_hash;存在时,使用同一台客户端向Nginx服务器发送请求,将会看到一直是由服务器backend1.example.com响应
            ip_hash;注释掉,两台服务器轮流响应请求
        ```
- keepalive connections;
    * 说明
        * 用于控制网络连接保持功能
        * 保证Nginx服务器的工作进程为服务器组打开一部分网络连接,并且将数量控制在一定的范围内
    * 语法
        * keepalive connections;
    * 位置
        * upstream
    * connections : Nginx服务器每一个工作进程允许该服务器组保持的空闲网络连接数的上限.如果超过该值,工作进程将采取最近最少使用的策略关闭网络连接
- least_conn
    * 说明
        * 指定服务器组的负载均衡方法，根据其权重值，将请求发送到活跃连接数最少的那台服务器。
        * 如果这样的服务器有多台，那就采取有权重的轮转法进行尝试
    * 语法
        * least_conn;
    * 位置
        * upstream

#### Rewrite功能的配置
- 地址重写
    * 地址标准化
    * 地址重写后地址栏中的地址会变成正确的地址
    * 一次地址重写产生两次请求
    * 地址重写没有限制地址
    * 地址重写到的页面必须使用完全的路径名表示
    * 地址重写不能将客户端请求的参数传递给新的页面
- 地址转发
    * 地址转发后客户端浏览器地址栏中的地址显示是不变的
    * 一次地址转发过程中只会产生一次网络请求
    * 地址转发一般发生在同一站点项目内
    * 地址转发到的页面可以不用全路径名表示
    * 地址转发过程中，可以将客户端请求的request范围内的属性传递给新的页面
    * 地址转发的速度比地址重写的速度快。
- if指令
    * 说明
        * 用于条件判断，并根据条件判断结果选择不同的Nginx配置，可以配置在server或location块中进行配置
    * 语法
        * if (condition) { ... }
    * 位置
        * server块, location块
    * condition
        * 变量名；如果变量值为空或者是以“0”开始的字符串，则条件为假
        * 使用“=”和“!=”运算符比较变量和字符串
        * 使用“~”（大小写敏感）和“~*”（大小写不敏感）运算符匹配变量和正则表达式。正则表达式可以包含匹配组，匹配结果后续可以使用变量$1..$9引用。如果正则表达式中包含字符“}”或者“;”，整个表达式应该被包含在单引号或双引号的引用中。
        * 使用“-f”和“!-f”运算符检查文件是否存在
        * 使用“-d”和“!-d”运算符检查目录是否存在
        * 使用“-e”和“!-e”运算符检查文件、目录或符号链接是否存在
        * 使用“-x”和“!-x”运算符检查可执行文件
- break指令
    * 说明
        * 中断当前相同作用域中的其它Nginx配置.
        * 与该指令处于同一作用域的Nginx配置中，位于它前面的配置生效，位于后面的指令配置就不再生效了
        * Nginx服务器在根据配置处理请求的过程中遇到该指令的时候，回到上一层作用域继续向下读取配置
    * 语法
        * break;
    * 位置
        * server, location, if
- return指令
    * 说明
        * 用于完成对请求的处理,直接向客户端返回相应状态代码
        * 处于该指令后的Nginx配置都是无效的
    * 语法
        * return code [text];
        * return code URL;
        * return URL;
    * 位置
        * server, location, if
    * text 返回给客户端的响应体内容，可以调用变量
    * code 返回给客户端HTTP状态码，范围为0-999
    * URL 返回给客户端的URL地址
- rewrite指令
    * 说明
        * 通过正则表达式的匹配来改变URI，可以同时存在一个或多个指令，按照顺序依次对URI进行匹配
    * 语法
        * rewrite regex replacement [flag];
    * 位置
        * server, location, if
    * regex 用于匹配URL的正则表达式.使用括号'()'标记要截取的内容
    * replacement 匹配成功之后用于替换URL中被截取内容的字符串
    * flag
        * last 停止执行当前这一轮的ngx_http_rewrite_module指令集，然后查找匹配改变后URI的新location；
        * break 停止执行当前这一轮的ngx_http_rewrite_module指令集；
        * redirect 在replacement字符串未以'http：//'或“https：//”开头时，使用返回状态码为302的临时重定向；
        * permanent 返回状态码为301的永久重定向。
- rewrite_log指令
    * 说明
        * 开启或者关闭将ngx_http_rewrite_module模块指令的处理日志以notice级别记录到错误日志中。
    * 语法
        * rewrite_log on | off;
    * 默认
        * rewrite_log off;
    * 位置
        * http, server, location, if
- set指令
    * 说明
        * 为指定变量variable设置变量值value。value可以包含文本、变量或者它们的组合
    * 语法
        * set variable value;
    * 位置
        * server, location, if
- uninitialized_variable_warn指令
    * 说明
        * 控制是否记录变量未初始化的警告到日志
    * 语法
        * uninitialized_variable_warn on | off;
    * 默认
        * uninitialized_variable_warn on;
    * 位置
        * http, server, location, if
- Rewrite常用全局变量
    <table><thead><tr><th>变量</th><th>说明</th><tbody><tr><td>$args<td>存放了请求url中的请求指令。比如<a href="http://www.myweb.name/server/source?arg1=value1&amp;arg2=value2" rel=nofollow target=_blank>http://www.myweb.name/server/source?arg1=value1&amp;arg2=value2</a>中的arg1=value1&amp;arg2=value2<tr><td>$content_length<td>存放请求头中的Content-length字段<tr><td>$content_type<td>存放了请求头中的Content-type字段<tr><td>$document_root<td>存放了针对当前请求的根路径<tr><td>$document_uri<td>请求中的uri,不包含请求指令 ，比如比如<a href="http://www.myweb.name/server/source?arg1=value1&amp;arg2=value2" rel=nofollow target=_blank>http://www.myweb.name/server/source?arg1=value1&amp;arg2=value2</a>中的/server/source<tr><td>$host<td>存放了请求url中的主机字段，比如比如<a href="http://www.myweb.name/server/source?arg1=value1&amp;arg2=value2" rel=nofollow target=_blank>http://www.myweb.name/server/source?arg1=value1&amp;arg2=value2</a>中的www.myweb.name。如果请求中的主机部分字段不可用或者为空，则存放nginx配置中该server块中server_name指令的配置值<tr><td>$http_user_agent<td>存放客户端的代理<tr><td>$http_cookie<td>cookie<tr><td>$limit_rate<td>nginx配置中limit_rate指令的配置值<tr><td>$remote_addr<td>客户端的地址<tr><td>$remote_port<td>客户端与服务器端建立连接的端口号<tr><td>$remote_user<td>变量中存放了客户端的用户名<tr><td>$request_body_file<td>存放了发给后端服务器的本地文件资源的名称<tr><td>$request_method<td>存放了客户端的请求方式，如get,post等<tr><td>$request_filename<td>存放当前请求的资源文件的路径名<tr><td>$requset_uri<td>当前请求的uri,并且带有指令<tr><td>$query_string<td><code>$args</code>含义相同<tr><td>\$scheme<td>客户端请求使用的协议，如http,https,ftp等<tr><td>$server_protocol<td>客户端请求协议的版本，如”HTTP/1.0”,”HTTP/1.1”<tr><td>$server_addr<td>服务器的地址<tr><td>$server_name<td>客户端请求到达的服务器的名称<tr><td>$server_port<td>客户端请求到达的服务器的端口号<tr><td>$uri<td>同<code>$document_uri</code></table>


