---
title: Lua_基础 (01)
date: 2020-12-01
tags: Lua
toc: true
---

### 快来跟我一起学Lua
    快来学Lua

<!-- more -->

#### 先说说为什么要学Lua
> 我们最近在在做的项目中会涉及到文件上传的功能, 按照我之前写PHP的想法 只要有一个文件上传类就能很快很方便的解决这个问题, 我去查了一下django中也有类似的功能可以做, 但是带我做项目的大哥还是选择了使用Lua+Nginx去上传文件, 我很苦恼为什么要用这个, 直到我讲出自己的疑惑之后, 开始学习知识了

#### 存在问题
> 假设我们有一个网站,基于Nginx+PHP+JS构架,网站允许用户上传一些小视频、音乐或者PPT等文件在线上展示,单个文件大小限制不超过30MB,那么我们要怎样实现这个上传功能呢？
1. 限制上传文件的大小
    * Nginx层
        ```bash
            # 肯定不能刚好30M, 因为我们还要传一点别的参数
            client_max_body_size 32M;
        ```
    * PHP层
        ```php
            // php.ini
            php.iniupload_max_filesize = 30M;
            post_max_size = 32M;
        ```
2. 缺陷
    * 其实,单凭client_max_body_size,Nginx是不能真正限制上传文件大小的,因为Nginx会先让客户端(一般是浏览器)开始上传请求,直到上传的内容大小超过了限制,Nginx才会中止上传,报413 Request Entity Too Large错误,没超过限制则交给PHP处理.于是,PHP的upload_max_filesize和post_max_size就更没用了,因为PHP获取到文件信息的时候,上传过程已经结束了(这时当然是上传成功,Nginx中止请求的话PHP不会进场).在Nginx传递请求结果前,PHP什么(比如验证用户,验证权限等等)都做不了.如果用户上传了一个大于32MB的时候,直到上传到32MB的时候才能告诉用户文件过大了,那么前面的时间用户不就白等了吗？而且服务器的带宽还是一样被消耗了.我们更希望在上传开始前就能告诉用户文件过大了.很多网站开发,都会把这一步交给JS处理,在新型浏览器(支持HTML5)里,JS的确可以获取input文件的大小；在旧的IE里,也可以通过ActiveX来实现.但是JS的限制处理很容易被绕过去,只要知道上传地址,一个form标签就能把文件传过去, 正常的用户当然不会这样做,但是有意攻击网站的人会.
3. 限制上传文件的速度
    * 如果服务器的入口带宽是100mbps,用户的上行带宽是10mbps,用户上传一个30MB的文件至少需要30秒,那么在30秒内,服务器的带宽只能满足10个用户上传文件,带宽被占满后,服务器就很难再处理其他请求了.所以,限制用户上传文件的速度就很有必要.目前,JS做不到限制上传文件的速度,PHP也做不到.
4. 上传文件的进度
    * 用户上传一个30MB的文件至少需要30秒,那么30秒内应该告知用户上传的进度,不能让用户无感知的等待.HTML5改进了XMLHttpRequest对象,在支持HTML5的新型浏览器里,JS可以获取XMLHttpRequest上传文件的进度；在旧的浏览器的也可以通过Flash与JS结合(比如SWFUpload),从而获取上传文件的进度.但是新型浏览器里,Flash已经被摒弃了,因而要支持新旧浏览器,JS就要写成两套代码.在这里PHP也是帮不上忙,因为PHP拿到传文件信息的时候,上传已经结束了.

#### 解决问题
> 网站是NginX+PHP+JS构架的,PHP和JS解决不了的问题,那应该在NginX上解决它.NginX虽然是一个现成的软件,但是它还是可以继续扩展和修改的.NginX本身没有提供上传文件的复杂处理功能,而在NginX官方认可的第三方扩展模块里,有两个模块可以帮助我们实现复杂的上传文件功能,分别是nginx-upload-modulenginx-upload-progress-module

#### 问题转移
> 问题回到了nginx这里, 我们要做的就是在nginx层实现上传, 使用任何一种后端语言对上传成功之后的文件进行剪切就可以了, 这里就想到了用lua, 因为他可以嵌入到nginx中, 体积也非常小, 便于操作, 所以我又来学lua了...

#### Lua是什么
> Lua 是一种轻量小巧的脚本语言,用标准C语言编写并以源代码形式开放, 其设计目的是为了嵌入应用程序中,从而为应用程序提供灵活的扩展和定制功能.

#### 设计目的
> 其设计目的是为了嵌入应用程序中,从而为应用程序提供灵活的扩展和定制功能.

#### Lua 特性
1. 轻量级: 它用标准C语言编写并以源代码形式开放,编译后仅仅一百余K,可以很方便的嵌入别的程序里.
2. 可扩展: Lua提供了非常易于使用的扩展接口和机制: 由宿主语言(通常是C或C++)提供这些功能,Lua可以使用它们,就像是本来就内置的功能一样.
3. 其它特性:
    1. 支持面向过程(procedure-oriented)编程和函数式编程(functional programming)；
    2. 自动内存管理；只提供了一种通用类型的表(table),用它可以实现数组,哈希表,集合,对象；
    3. 语言内置模式匹配；闭包(closure)；函数也可以看做一个值；提供多线程(协同进程,并非操作系统所支持的线程)支持；
    4. 通过闭包和table可以很方便地支持面向对象编程所需要的一些关键机制,比如数据抽象,虚函数,继承和重载等.

#### Lua 应用场景
1. 游戏开发
2. 独立应用脚本
3. Web 应用脚本
4. 扩展和数据库插件如: MySQL Proxy 和 MySQL WorkBench
5. 安全系统,如入侵检测系统

#### Lua环境安装
> 说一下mac的
    ```bash
        curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
        tar zxf lua-5.3.0.tar.gz
        cd lua-5.3.0
        make macosx test
        make install
    ```
- eg
    ```bash
        $ cat helloWorld.lua 
        print("Hello World!")

        $ lua -v
        Lua 5.3.0  Copyright (C) 1994-2015 Lua.org, PUC-Rio

        $ lua helloWorld.lua
        Hello World!
    ```

#### Lua基本语法
1. 第一个 Lua 程序
    * 交互式
        * lua -i进入
        * ctrl+c退出
        ```bash
            $ lua -i 
            Lua 5.3.0  Copyright (C) 1994-2015 Lua.org, PUC-Rio
            > print("hello World")
            hello World
        ```
    * 脚本式
        * 文件开头可以制定lua的解释器
        ```bash
            $ cat helloWorld.lua
            #!/usr/local/bin/lua

            print("Hello World!")
        ```
2. 注释
    * 单行注释
        ```lua
            -- 两个减号是单行注释:
        ```
    * 多行注释
        ```lua
            --[[
            多行注释
            多行注释
            --]]
        ```
3. 数据类型
    <table class="reference"><tbody><tr><th style="width:20%">数据类型</th><th>描述</th></tr><tr><td>nil</td><td>这个最简单,只有值nil属于该类,表示一个无效值(在条件表达式中相当于false).</td></tr><tr><td>boolean</td><td>包含两个值: false和true.</td></tr><tr><td>number</td><td>表示双精度类型的实浮点数</td></tr><tr><td>string</td><td>字符串由一对双引号或单引号来表示</td></tr><tr><td>function</td><td>由 C 或 Lua 编写的函数</td></tr><tr><td>userdata</td><td>表示任意存储在变量中的C数据结构</td></tr><tr><td>thread</td><td>表示执行的独立线路,用于执行协同程序</td></tr><tr><td>table</td><td> Lua 中的表(table)其实是一个"关联数组"(associative arrays),数组的索引可以是数字、字符串或表类型.在 Lua 里,table 的创建是通过"构造表达式"来完成,最简单构造表达式是{},用来创建一个空表.</td></tr></tbody></table>


