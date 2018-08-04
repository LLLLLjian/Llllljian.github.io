---
title: PHP_基础 (6)
date: 2018-07-16
tags: 
    - PHP 
    - Interview
toc: true
---

### PHP面试点
    持续更新

<!-- more -->

#### PHP
    是一个基于服务端来创建动态网站的脚本语言

#### OOP[面向对象]
- 是程序的一种设计方式,它利于提高程序的重用性,使程序结构更加清晰.主要特征：封装、继承、多态
- 易维护 质量高 效率高 易扩展

#### SESSION与COOKIE的区别
- 存储位置
    * session存储于服务器,cookie存储于浏览器
- 安全性
    * session安全性比cookie高
- session为‘会话服务’,在使用时需要开启服务,cookie不需要开启,可以直接用
- SESSION依赖于COOKIE进行传递. 禁用COOKIE后,session不能正常使用.
- SESSION的缺点
    * 保存在服务器端,每次读取都从服务器进行读取,对服务器有资源消耗.
- SESSION保存在服务器端的文件或数据库中,默认保存在文件中,文件路径由php配置文件的session.save_path指定

#### HTTP状态码
- 一 消息系列
- 二 成功系列
    * 200 请求成功
- 三 重定向系列
    * 302 临时移动
    * 304 未修改 
- 四 请求错误系列
    * 403 禁止访问
    * 404 文件未找到
- 五 服务器端错误系列
    * 500 服务器内部错误
    * 502 错误网关
    * 503 服务器超时

#### get与post表单提交方法
- get是把参数数据队列加到提交表单的ACTION属性所指的URL中,值和表单内各个字段一一对应,在URL中可以看到
- ost是通过HTTP post机制,将表单内各个字段与其内容放置在HTML HEADER内一起传送到ACTION属性所指的URL地址
- get传值一般在2KB以内,post传值大小可以在php.ini中进行设置
- get安全性非低,post安全性较高,执行效率却比Post高

#### echo(),print(),print_r()的区别
- echo是PHP语句, print和print_r是函数,语句没有返回值,函数可以有返回值(即便没有用) 
- Print()只能打印出简单类型变量的值(如int,string) 
- print_r()可以打印出复杂类型变量的值(如数组,对象) 
- echo 输出一个或者多个字符串

#### 魔术方法
- __call()当调用不存在的方法时会自动调用的方法 
- __autoload()在实例化一个尚未被定义的类是会自动调用次方法来加载类文件 
- __set()当给未定义的变量赋值时会自动调用的方法 
- __get()当获取未定义变量的值时会自动调用的方法 
- __construct()构造方法,实例化类时自动调用的方法 
- __destroy()销毁对象时自动调用的方法 
- __unset()当对一个未定义变量调用unset()时自动调用的方法 
- __isset()当对一个未定义变量调用isset()方法时自动调用的方法 
- __clone()克隆一个对象 
- __tostring()当输出一个对象时自动调用的方法

#### XSS攻击
- GET或POST内容未过滤,可以提交JS以及HTML等恶意代码.
- 所有传递到后台的数据都要过滤HTML标签

#### CSRF跨站攻击
- 强迫受害者的浏览器向一个易受攻击的Web应用程序发送请求,最后达到攻击者所需要的操作行为
- 采用类似随即码或者令牌的形式,让用户操作唯一性(token)

#### sql注入安全问题
- 通过把SQL命令插入到Web表单递交或输入域名或页面请求的查询字符串,最终达到欺骗服务器执行恶意的SQL命令
- POST提交,过滤参数,PDO绑定

#### php.ini中magic_quotes_gpc, magic_quotes_runtime的作用
- magic_quotes_gpc的作用是在POST、GET、COOKIE数据上使用addslashes()自动转义
- magic_quotes_runtime参数的作用是设置状态,当状态为0时则关闭自动转义,设置为1则自动转义,将数据库中取出来的单引号、双引号、反斜线这些字符加上反斜杠转义.

#### 单引号双引号
- 单引号内部的变量不会执行, 双引号会执行
- 单引号解析速度比双引号快.
- 单引号只能解析部分特殊字符,双引号可以解析所有特殊字符

#### 修改session的生存时间
- 在php.ini 中设置 session.gc_maxlifetime = 1440 //默认时间
- session_set_cookie_params(24 * 3600)

#### private、protected、public
- private
    * 私有成员, 在类的内部才可以访问.
- protected
    * 保护成员,该类内部和继承类中可以访问.
- public
    * 公共成员,完全公开,没有访问限制

#### $this和self、parent
- $this 当前对象, 在当前类中使用,使用->调用属性和方法.
- self 当前类, 也在当前类中使用,不过需要使用::调用
- parent 当前类的父类, 在类中使用

#### Memcach的理解
- Memcache是一种缓存技术,在一定的时间内将动态网页经过解析之后保存到文件,下次访问时动态网页就直接调用这个文件,而不必在重新访问数据库.
- 使用memcache做缓存的好处是：提高网站的访问速度,减轻高并发时服务器的压力. 
- Memcache的优点：稳定、配置简单、多机分布式存储、速度快

#### include与require的区别
- 加载失败的处理方式不同
    * include在引入不存文件时产生一个警告且脚本还会继续执行
    * require则会导致一个致命性错误且脚本停止执行
- 文件引用方式
    * include有返回值,而require没有[require的速度比include快]
- require_once表示了只包含一次,避免了重复包含

#### PHP运行方式
- CGI
    * 通用网关接口
    * 是一个可伸缩地、高速地在HTTP server和动态脚本语言间通信的接口
    * 把网页和Web服务器中的执行程序连接起来,它把HTML接收的指令传递给服务器的执行程序,再把服务器执行程序的结果返还给HTML页
- FastCGI
    * 激活后一直运行,像是一个常驻的CGI
    * PHP的FastCGI进程管理器是PHP-FPM
- CLI
    * 命令行运行
- Web模块模式
    * Apache等Web服务器运行的模式
    * 以mod_php5模块的形式集成
    * 接收Apache传递过来的PHP文件请求,并处理这些请求,然后将处理后的结果返回给Apache
- ISAPI
    * 是微软提供的一套面向Internet服务的API接口.一个ISAPI的DLL,可以在被用户请求激活后长驻内存,等待用户的另一个请求,还可以在一个DLL里设置多个用户请求处理函数,此外,ISAPI的DLL应用程序和WWW服务器处于同一个进程中,效率要显著高于CGI

#### 获取文件扩展名
    ```php
        function getExt1($filename)
        {
            $arr = explode('.',$filename);
            return array_pop($arr);;
        }

        function getExt2($filename)
        {
            $ext = strrchr($filename,'.');
            return $ext;
        }

        function getExt3($filename)
        {
            $pos = strrpos($filename, '.');
            $ext = substr($filename, $pos);
            return $ext;
        }

        function getExt4($filename)
        {
            $arr = pathinfo($filename);
            $ext = $arr['extension'];
            return $ext;
        }

        function getExt5($filename)
        {
            $str = strrev($filename);
            return strrev(strchr($str,'.',true));
        }
    ```

