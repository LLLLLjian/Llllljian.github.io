---
title: 图解HTTP (1)
date: 2019-11-29
tags: HTTP
toc: true
---

### 图解HTTP读书笔记
    记录一下看书的笔记 

<!-- more -->

#### URL和URL
- URL
    * Uniform Resource Locator
    * 统一资源定位符
- URI
    * Uniform Resource Identifier
    * 统一资源标识符
- 绝对URI格式
    ![绝对URI格式](/img/20191129_1.png)
    * 协议方案名 : 使用http或https 等协议方案名获取访问资源时要执行协议类型 不区分字母大小写 最后附一个冒号(:)
    * 登陆信息(认证) : 指定用户名和密码作为从服务器端获取资源时必要的登陆信息
    * 服务器地址 : 使用绝对URI必须指定待访问的服务器地址
    * 服务器端口号 : 指定服务器链接的网络端口号
    * 带层次的文件路径 : 指定服务器上的文件路径来定位特指的资源
    * 查询字符串 : 针对已制定的文件路径内的资源 可以使用查询字符串传入任意参数
    * 片段标识符 : 使用片段标识符通常可标记出已获取资源中的子资源

#### HTTP/1.1 首部字段
- General
    * 通用首部字段
    * Request URL: 请求地址
    * Request Method: 请求方法
    * Status Code: 状态码
    * Remote Address: 请求的远程地址
    * Referrer Policy: referrer策略
- Response Headers
    * Cache-Control: 控制缓存的行为
    * Connection: 逐跳首部 连接的管理
    * Content-Encoding: web服务器支持的返回内容压缩编码类型
    * Content-Type: 返回内容的MIME类型
    * Date: 创建报文的日期时间
    * Expires: 响应过期的日期和时间
    * Pragma: 报文指令
    * Server: web服务器软件名称
    * Transfer-Encoding: 指定报文主题的传输编码方式
    * X-Frame-Options: SAMEORIGIN
- Request Headers
    * Accept: 通知服务器 用户代理能够处理的媒体类型及媒体类型的相对优先级, 一次指定多种媒体类型
    * Accept-Encoding: 告知服务器用户代理支持的内容编码及内容编码的优先级顺序
    * Accept-Language: 告知服务器用户代理能够处理的自然语言集
    * Cache-Control: max-age=0
    * Connection: keep-alive
    * Cookie: 
    * Host: 请求资源所在服务器
    * Sec-Fetch-Dest: document
    * Sec-Fetch-Mode: navigate
    * Sec-Fetch-Site: none
    * Sec-Fetch-User: ?1
    * Upgrade-Insecure-Requests: 1
    * User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36


