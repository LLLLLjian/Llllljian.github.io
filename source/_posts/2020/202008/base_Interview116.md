---
title: Interview_总结 (116)
date: 2020-08-14
tags: Interview
toc: true
---

### 高并发
    高并发和大流量解决方案考察点

<!-- more -->

#### 高并发架构相关概念
- 并发
    * 在操作系统中是指一个时间段中有几个程序都处于已启动运行到运行完毕之间, 且这几个程序都是在同一个处理机上运行, 但任一时刻点上只有一个程序在处理机上运行
- 我们所说的高并发
    * 通常是指并发访问, 也就是在某个时间点有很多个访问同时到达
- QPS
    * 每秒请求或查询的数量, 在互联网领域指每秒响应请求数(指HTTP请求)
- 吞吐量
    * 单位时间内处理的请求数量(通常由QPS和并发数决定)
- 响应时间
    * 从请求发出到收到请求花费的时间
- PV
    * 综合浏览量page view, 及页面访问量或者点击量, 一个访客在24小时内访问的页面数量
- UV
    * 独立访客Unique Visitor, 即一定时间范围内相同访客多次访问网站, 只计算1个独立访客

#### 高并发解决方案案例：
1. 流量优化：防盗链处理
2. 前端优化：减少HTTP请求,添加异步请求,启用浏览器缓存和文件压缩,CDN加速,建立独立图片服务器
3. 服务端优化：页面静态化,并发处理
4. 数据库优化：数据库缓存,分库分表,分区操作,读写分离,负载均衡
5. Web优化：负载均衡(LVS,nginx反向代理)

#### WEB资源防盗链
- 盗链概念：
    * 盗链是指在自己的页面上展示一些并不在自己服务器上的内容
    * 获得他人服务器上的资源地址,绕过别人的资源展示页面,直接在自己的页面上向最终用户提供内容
    * 常见的是小站盗用大站的图片,音乐,视频,软件等.
    * 通过盗链可以减轻自己服务器的负担,因为真实的空间和流量均是来自别人的服务器
- 防盗链概念：
    * 防止别人通过一些技术手段绕过本站的资源展示页面,盗用本站的资源,让绕开本站资源展示页面的资源链接失效.
    * 可以大大减轻服务器及带宽的压力
- 工作原理
    * 通过refever或者签名,网站可以检测目标网页访问的来源网页,如果是资源文件,则可以追踪到显示它的网页地址
    * 一旦检测到来源不是本站即进行阻止或者返回指定的页面
    * 通过计算签名的方式,判断请求是否合法,如果合法则显示,否则返回错误信息
    ```bash
        Referer
        Nginx模块 ngx_http_referer_module用于阻挡来源非法的域名请求
        Nginx指令 valid_referers,全局变量$invalid_referer
        valid_referers none|blocked|server_names|string...;
            none:"referer"来源头部为空的情况
            blocked:"referer"来源头部不为空,但是里面的值被代理或者防火墙删除了,这些值都不以http://或者https://开头
            server_names:"referer"来源头部包含当前的server_names
        eg:
        location ~.*\.(gif|jpg|png|flv|swf|rar|zip)$
        {
            valid_referers none blocked imooc.com *.imooc.com;
            if($invalid_referer)
            {
                #return 403
                rewrite ^/http://www.imooc.com/403.jpg;
            }
        }
    ```
- 传统防盗链遇到的问题——伪造Referer
    ```bash
        可以使用加密签名解决
        使用第三方模块HttpAccessKeyModule实现nginx防盗链
        accesskey on|off 模块开关
        accesskey_hashmethod md5|sha-l签名加密方式
        accesskey_arg GET参数名称
        accesskey_signature加密规则
        eg:
            location ~.*\.(gif|jpg|png|flv|swf|rar|zip)$
            {
                accesskey on;
                accesskey_hashmethod md5;
                accesskey_arg sign;
                accesskey_signature "zuiyn$remote_addr";
            }

        在php文件加上
        $sign = md5('zuiyn'. $_SERVER['REMOTE_ADDR']);
        通过get传参即可请求
        echo '<img src="./logo_new.png?sign='. $sign .'">';
    ```
      

