---
title: Interview_总结 (123)
date: 2020-08-25
tags: 
    - HTTP
    - Interview
toc: true
---

### 带你看遍HTTP
    今日被问傻系列-我的心里为啥没HTTP

<!-- more -->

#### HTTP和HTTPS的区别
1. HTTP 是超文本传输协议, 信息是明文传输, 存在安全风险的问题.HTTPS 则解决 HTTP 不安全的缺陷, 在 TCP 和 HTTP 网络层之间加入了 SSL/TLS 安全协议, 使得报文能够加密传输.
2. HTTP 连接建立相对简单,  TCP 三次握手之后便可进行 HTTP 的报文传输.而 HTTPS 在 TCP 三次握手之后, 还需进行 SSL/TLS 的握手过程, 才可进入加密报文传输.
3. HTTP 的端口号是 80, HTTPS 的端口号是 443.
4. HTTPS 协议需要向 CA(证书权威机构)申请数字证书, 来保证服务器的身份是可信的

#### HTTP Get和Post区别
1. get方法一般用于请求,post方法一般用于表单的提交
2. get方法是不安全的
3. get 请求的 URL 有长度限制,而 post 请求会把参数和值放在消息体中,对数据长度没有要求.
4. get 请求会被浏览器主动 cache,而 post 不会,除非手动设置.
5. get 请求在浏览器反复的 回退/前进 操作是无害的,而 post 操作会再次提交表单请求.
6. get 请求在发送过程中会产生一个 TCP 数据包；post 在发送过程中会产生两个 TCP 数据包.对于 get 方式的请求,浏览器会把 http header 和 data 一并发送出去,服务器响应 200(返回数据)；而对于 post,浏览器先发送 header,服务器响应 100 continue,浏览器再发送 data,服务器响应 200 ok(返回数据)

#### UDP和TCP的区别
> UDP 的全称是 User Datagram Protocol,用户数据报协议.它不需要所谓的握手操作,从而加快了通信速度,允许网络上的其他主机在接收方同意通信之前进行数据传输.数据报是与分组交换网络关联的传输单元.
TCP 的全称是Transmission Control Protocol ,传输控制协议.它能够帮助你确定计算机连接到 Internet 以及它们之间的数据传输.通过三次握手来建立 TCP 连接,三次握手就是用来启动和确认 TCP 连接的过程.一旦连接建立后,就可以发送数据了,当数据传输完成后,会通过关闭虚拟电路来断开连接.
- UDP特点
    * UDP 能够支持容忍数据包丢失的带宽密集型应用程序
    * UDP 具有低延迟的特点
    * UDP 能够发送大量的数据包
    * UDP 能够允许 DNS 查找,DNS 是建立在 UDP 之上的应用层协议
- TCP特点
    * TCP 能够确保连接的建立和数据包的发送
    * TCP 支持错误重传机制
    * TCP 支持拥塞控制,能够在网络拥堵的情况下延迟发送
    * TCP 能够提供错误校验和,甄别有害的数据包.
![UDP和TCP的区别](/img/20200825_1.png)

#### TCP为什么要三次握手
1. 客户端发送请求【寻址请求】
    * Client将标志位SYN置1,随机产生一个值seq=J,并将数据包发给Server Client进入SYN_SENT状态,等待Server确认
    * 让我们建立连接吧, 我发送的信号序列会从456开始
2. 服务器端收到报文请求,回应客户端【确认请求】
    * Server收到数据包后标志位SYN=1知道Client请求建立连接,Server将标志位SYN和ACK都置1, 随机产生一个值,并将数据包发给Client确认连接请求,Server进入SYN_RCVD状态
    * 收到, 我已经准备好接收序号457了, 我发送的信息序号会从123开始
3. 客户端收到服务端的报文进行回应.【连接请求】
    * Client收到确认后若ACK为1,则将该数据包发送给Server,Server检查ACK为1则连接建立成功, Client与Server进入ESTABLISHED状态完成三次握手,可以传输数据
    * 很好, 我也收到了你的序号, 可以向我发送编号124的信息了
- 套娃说法
    * 传输开始前,A知道自己的序列号,B知道自己的序列号.第一次握手,B知道了A的序列号；第二次握手,A知道B知道A的序列号；第三次握手,B知道A知道B的序列号.这样,对于A和B而言,都知道“对方已经知道自己的序列号”这一现实,所以TCP连接可以建立

#### TCP为什么要四次挥手
1. 数据验证请求码
    * Clien发送一个FIN,用来关闭Client到Server的数据传送,Client进入FIN_WAIT_1状态
2. 传输结束标记
    * Server收到FIN后,发送一个ACK给Client,Server进入CLOSE_WAIT状态
3. 确认结束标记
    * Server发送一个FIN,用来关闭Server到Client的数据传送,Server进入LAST_ACK状态
4. 连接断开标记
    * Client收到FIN后,Client进入TIME_WAIT状态,发送ACK给Server,Server进入CLOSED状态,完成四次握手
- 总结
    * 前两次挥手是为了断开client至server的连接,后两次挥手是为了断开server至client的连接,如果没有第四次挥手,会出现如下状况：server发送FIN数据包并携带ACK至client之后直接断开连接,如果client没有收到这个FIN数据包,那么client会一直处于等待关闭状态,这是为了确保TCP协议是面向连接安全有保证锝.上面解释了为什么不是三次挥手,同理,两次挥手也是不安全的.不能保证server与client都能正确关闭连接释放资源,而不会造成资源浪费

#### 请你说一下HTTP常见的请求头
- 通用标头
    * Date: 创建报文的日期, 格林威治标准时间
    * Cache-Control: 控制缓存的行为
    * Connection: 决定当前事务(一次三次握手和四次挥手)完成后,是否会关闭网络连接.Connection 有两种,一种是持久性连接,即一次事务完成后不关闭网络连接; 另一种是非持久性连接,即一次事务完成后关闭网络连接
    ![通用标头](/img/20200825_2.png)
- 实体标头
    * Content-Length: 实体报头指示实体主体的大小,以字节为单位,发送到接收方.
    * Content-Language: 实体报头描述了客户端或者服务端能够接受的语言.
    * Content-Encoding: 这又是一个比较麻烦的属性,这个实体报头用来压缩媒体类型.Content-Encoding 指示对实体应用了何种编码
    ![实体标头](/img/20200825_3.png)
- 请求标头
    * Host: Host请求头指明了服务器的域名(对于虚拟主机来说),以及(可选的)服务器监听的 TCP 端口号
    * Referer: 来自于哪个页面
    * If-Modified-Since: 用于确认代理或客户端拥有的本地资源的有效性
    * Accept: 接受请求 HTTP 标头会通告客户端其能够理解的 MIME 类型
    * Accept-Charset: accept-charset 属性规定服务器处理表单数据所接受的字符集
    ![请求标头](/img/20200825_4.png)
- 响应标头
    * Keep-Alive: Keep-Alive 表示的是 Connection 非持续连接的存活时间,可以进行指定.
    * Server: 服务器标头包含有关原始服务器用来处理请求的软件的信息
    * Set-Cookie: Set-Cookie 用于服务器向客户端发送 sessionID.
    * Transfer-Encoding: 首部字段 Transfer-Encoding 规定了传输报文主体时采用的编码方式
    ![响应标头](/img/20200825_5.png)

#### 地址栏输入URL发生了什么


