---
title: Interview_总结 (47)
date: 2019-10-30
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题

<!-- more -->

#### COOKIE详解
- 简介
    * 是指某些网站为了辨别用户身份、进行session跟踪而储存在用户本地终端上的数据
    * 由服务端生成的, 发送给客户端(通常是浏览器)的.Cookie总是保存在客户端中, 按在客户端中的存储位置, 可分为内存Cookie和硬盘Cookie
        * 内存Cookie由浏览器维护, 保存在内存中, 浏览器关闭后就消失了, 其存在时间是短暂的
        * 硬盘Cookie保存在硬盘里, 有一个过期时间, 除非用户手工清理或到了过期时间, 硬盘Cookie不会被删除, 其存在时间是长期的
- 工作原理
    * 创建Cookie
        * 当用户第一次浏览某个使用Cookie的网站时, 该网站的服务器就进行如下工作：该用户生成一个唯一的识别码(Cookie id), 创建一个Cookie对象; 默认情况下它是一个会话级别的cookie, 存储在浏览器的内存中, 用户退出浏览器之后被删除.如果网站希望浏览器将该Cookie存储在磁盘上, 则需要设置最大时效(maxAge), 并给出一个以秒为单位的时间(将最大时效设为0则是命令浏览器删除该Cookie); 将Cookie放入到HTTP响应报头, 将Cookie插入到一个 Set-Cookie HTTP请求报头中; 发送该HTTP响应报文
    * 设置存储Cookie
        * 浏览器收到该响应报文之后, 根据报文头里的Set-Cookied特殊的指示, 生成相应的Cookie, 保存在客户端.该Cookie里面记录着用户当前的信息
    * 发送Cookie
        * 当用户再次访问该网站时, 浏览器首先检查所有存储的Cookies, 如果某个存在该网站的Cookie(即该Cookie所声明的作用范围大于等于将要请求的资源), 则把该cookie附在请求资源的HTTP请求头上发送给服务器
    * 读取Cookie
        * 服务器接收到用户的HTTP请求报文之后, 从报文头获取到该用户的Cookie, 从里面找到所需要的东西
- 作用
    * 记住密码, 下次自动登录
    * 购物车功能.
    * 记录用户浏览数据, 进行商品(广告)推荐
- 缺陷
    * Cookie会被附加在每个HTTP请求中, 所以无形中增加了流量.
    * 由于在HTTP请求中的Cookie是明文传递的, 所以安全性成问题.(除非用HTTPS)
    * Cookie的大小限制在4KB左右.对于复杂的存储需求来说是不够用的.

#### SESSION详解
- 简介
    * Session代表服务器与浏览器的一次会话过程, 这个过程是连续的, 也可以时断时续的.Session是一种服务器端的机制, Session 对象用来存储特定用户会话所需的信息.
    * Session由服务端生成, 保存在服务器的内存、缓存、硬盘或数据库中
- 工作原理
    * 创建Session
        * 当用户访问到一个服务器, 如果服务器启用Session, 服务器就要为该用户创建一个SESSION, 在创建这个SESSION的时候, 服务器首先检查这个用户发来的请求里是否包含了一个SESSION ID, 如果包含了一个SESSION ID则说明之前该用户已经登陆过并为此用户创建过SESSION, 那服务器就按照这个SESSION ID把这个SESSION在服务器的内存中查找出来(如果查找不到, 就有可能为他新创建一个), 如果客户端请求里不包含有SESSION ID, 则为该客户端创建一个SESSION并生成一个与此SESSION相关的SESSION ID.这个SESSION ID是唯一的、不重复的、不容易找到规律的字符串, 这个SESSION ID将被在本次响应中返回到客户端保存, 而保存这个SESSION ID的正是COOKIE, 这样在交互过程中浏览器可以自动的按照规则把这个标识发送给服务器
    * 使用Session
    * 作用
        * 在服务端存储用户和服务器会话的一些信息
        * 判断用户是否登录
        * 购物车功能

#### Cookie和Session的区别
- 存放位置不同
    * Cookie保存在客户端, Session保存在服务端
- 存取方式的不同
    *  Cookie中只能保管ASCII字符串, 假如需求存取Unicode字符或者二进制数据, 需求先进行编码.Cookie中也不能直接存取Java对象.若要存储略微复杂的信息, 运用Cookie是比拟艰难的. 
    * Session中能够存取任何类型的数据, 包括而不限于String、Integer、List、Map等.Session中也能够直接保管Java Bean乃至任何Java类, 对象等, 运用起来十分便当.能够把Session看做是一个Java容器类
- 安全性(隐私策略)的不同
    * Cookie存储在浏览器中, 对客户端是可见的, 客户端的一些程序可能会窥探、复制以至修正Cookie中的内容.而Session存储在服务器上, 对客户端是透明的, 不存在敏感信息泄露的风险. 假如选用Cookie, 比较好的方法是, 敏感的信息如账号密码等尽量不要写到Cookie中.最好是像Google、Baidu那样将Cookie信息加密, 提交到服务器后再进行解密, 保证Cookie中的信息只要本人能读得懂.而假如选择Session就省事多了, 反正是放在服务器上, Session里任何隐私都能够有效的保护
- 有效期上的不同
    * 只需要设置Cookie的过期时间属性为一个很大很大的数字, Cookie就可以在浏览器保存很长时间. 由于Session依赖于名为JSESSIONID的Cookie, 而Cookie JSESSIONID的过期时间默许为–1, 只需关闭了浏览器(一次会话结束), 该Session就会失效.
- 对服务器造成的压力不同 
    * Session是保管在服务器端的, 每个用户都会产生一个Session.假如并发访问的用户十分多, 会产生十分多的Session, 耗费大量的内存.而Cookie保管在客户端, 不占用服务器资源.假如并发阅读的用户十分多, Cookie是很好的选择.
- 跨域支持上的不同 
    * Cookie支持跨域名访问, 例如将domain属性设置为“.baidu.com”, 则以“.baidu.com”为后缀的一切域名均能够访问该Cookie.跨域名Cookie如今被普遍用在网络中.而Session则不会支持跨域名访问.Session仅在他所在的域名内有效
