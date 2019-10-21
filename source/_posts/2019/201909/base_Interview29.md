---
title: Interview_总结 (29)
date: 2019-09-11
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 对比篇
- `Cookie`与`Session`区别
    * Session是在服务端保存的一个数据结构，用来跟踪用户的状态，这个数据可以保存在集群、数据库、文件中
    * Cookie是客户端保存用户信息的一种机制，用来记录用户的一些信息，也是实现Session的一种方式。
- `GET`与`POST`区别
    <table class="dataintable"><tbody><tr><th style="width:20%;">&nbsp;</th><th>GET</th><th>POST</th></tr><tr><td>后退按钮/刷新</td><td>无害</td><td>数据会被重新提交(浏览器应该告知用户数据会被重新提交)。</td></tr><tr><td>书签</td><td>可收藏为书签</td><td>不可收藏为书签</td></tr><tr><td>缓存</td><td>能被缓存</td><td>不能缓存</td></tr><tr><td>编码类型</td><td>application/x-www-form-urlencoded</td><td>application/x-www-form-urlencoded 或 multipart/form-data。为二进制数据使用多重编码。</td></tr><tr><td>历史</td><td>参数保留在浏览器历史中。</td><td>参数不会保存在浏览器历史中。</td></tr><tr><td>对数据长度的限制</td><td>是的。当发送数据时，GET 方法向 URL 添加数据；URL 的长度是受限制的(URL 的最大长度是 2048 个字符)。</td><td>无限制。</td></tr><tr><td>对数据类型的限制</td><td>只允许 ASCII 字符。</td><td>没有限制。也允许二进制数据。</td></tr><tr><td>安全性</td><td><p>与 POST 相比，GET 的安全性较差，因为所发送的数据是 URL 的一部分。</p><p>在发送密码或其他敏感信息时绝不要使用 GET ！</p></td><td>POST 比 GET 更安全，因为参数不会被保存在浏览器历史或 web 服务器日志中。</td></tr><tr><td>可见性</td><td>数据在 URL 中对所有人都是可见的。</td><td>数据不会显示在 URL 中。</td></tr></tbody></table>
- `include`与`require`区别
    * incluce在用到时加载, 每次执行代码时是读取不同的文件，或者有通过一组文件迭代的循环
    * require在一开始就加载, 执行多次的代码用require()效率比较高
- `Memcached`与`Redis`区别
- `InnoDB`和`MyISAM`区别
    * InnoDB支持事务，而MyISAM不支持事务
    * InnoDB支持行级锁，而MyISAM支持表级锁
    * InnoDB支持MVCC(多版本并发控制), 而MyISAM不支持
    * InnoDB支持外键，而MyISAM不支持
    * InnoDB不支持全文索引，而MyISAM支持。(X)
    * InnoDB：如果要提供提交、回滚、崩溃恢复能力的事务安全(ACID兼容)能力，并要求实现并发控制，InnoDB是一个好的选择
    * MyISAM：如果数据表主要用来插入和查询记录，则MyISAM(但是不支持事务)引擎能提供较高的处理效率
- `HTTP`与`HTTPS`区别
    * https协议需要到ca申请证书，一般免费证书较少，因而需要一定费用。
    * http是超文本传输协议，信息是明文传输，https则是具有安全性的ssl加密传输协议。
    * http和https使用的是完全不同的连接方式，用的端口也不一样，前者是80，后者是443。
    * http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全。
- `Apache`与`Nginx`区别
    * nginx 相对 apache 的优点：
        * 轻量级，同样起web 服务，比apache 占用更少的内存及资源
        * 抗并发，nginx 处理请求是异步非阻塞的，而apache 则是阻塞型的，在高并发下nginx
        * 能保持低资源低消耗高性能
        * 高度模块化的设计，编写模块相对简单
        * 社区活跃，各种高性能模块出品迅速啊
    * apache 相对nginx 的优点：
        * rewrite ，比nginx 的rewrite 强大
        * 模块超多，基本想到的都可以找到
        * 少bug ，nginx 的bug 相对较多
        * 超稳定
    * 作为 Web 服务器：相比 Apache，Nginx 使用更少的资源，支持更多的并发连接，体现更高的效率，这点使 Nginx 尤其受到虚拟主机提供商的欢迎
    * Nginx 配置简洁, Apache 复杂 ，Nginx 启动特别容易, 并且几乎可以做到7*24不间断运行，即使运行数个月也不需要重新启动. 你还能够不间断服务的情况下进行软件版本的升级. Nginx 静态处理性能比 Apache 高 3倍以上 ，Apache 对 PHP 支持比较简单，Nginx 需要配合其他后端来使用 ,Apache 的组件比 Nginx 多.
    * 最核心的区别在于apache是同步多进程模型，一个连接对应一个进程；nginx是异步的，多个连接(万级别)可以对应一个进程 .
    * nginx的优势是处理静态请求，cpu内存使用率低，apache适合处理动态请求，所以现在一般前端用nginx作为反向代理抗住压力，apache作为后端处理动态请求
- `define()`与`const`区别
    * const是在编译时定义常量，而define()方法是在运行时定义常量。
    * const不能用在if语句中， defne()能用在if语句中
    * define()的一个常用场景是先判断常量是否已经定义再定义常量
    * 除非要在if分支里定义常量或者是通过表达式的值来命名常量， 其他情况(即使是只是简单的为了代码的可读性)都推荐用const替代define()。

