---
title: Python_基础 (43)
date: 2020-10-29
tags: 
    - Python
    - Django
toc: true
---

### RESTful API设计指南
    学Django-rest-framework之前先看看RESTful API

<!-- more -->

### RESTful API设计指南

#### 简介
- REST(英文：Representational State Transfer, 简称REST)描述了一个架构样式的网络系统, 比如 web 应用程序.它首次出现在 2000 年 Roy Fielding 的博士论文中, 他是 HTTP 规范的主要编写者之一.在目前主流的三种Web服务交互方案中, REST相比于SOAP(Simple Object Access protocol, 简单对象访问协议)以及XML-RPC更加简单明了, 无论是对URL的处理还是对Payload的编码, REST都倾向于用更加简单轻量的方法设计和实现.值得注意的是REST并没有一个明确的标准, 而更像是一种设计的风格
- 定义：简单来说REST是一种系统架构设计风格(而非标准), 一种分布式系统的应用层解决方案
- 目的：Client和Server端进一步解耦

#### 协议
    API与用户的通信协议, 总是使用HTTPs协议

#### 域名
    1. 应该尽量将API部署在专用域名之下,(这中情况会存在跨域问题) eg : https://api.example.com
    2. 如果确定API很简单, 不会有进一步扩展, 可以考虑放在主域名下.eg : https://example.org/api/

#### 版本(Versioning)
    应该将API的版本号放入URL.eg : https://api.example.com/v1/
    另一种做法是, 将版本号放在HTTP头信息中, 但不如放入URL方便和直观.Github采用这种做法

#### 路径(Endpoint)
    路径又称"终点"(endpoint), 表示API的具体网址.在RESTful架构中, 每个网址代表一种资源(resource), 所以网址中不能有动词, 只能有名词, 而且所用的名词往往与数据库的表格名对应.一般来说, 数据库中的表都是同种记录的"集合"(collection), 所以API中的名词也应该使用复数.
    举例来说, 有一个API提供动物园(zoo)的信息, 还包括各种动物和雇员的信息, 则它的路径应该设计成下面这样.
        * https://api.example.com/v1/zoos
        * https://api.example.com/v1/animals
        * https://api.example.com/v1/employees

#### HTTP动词
    对于资源的具体操作类型, 由HTTP动词表示.常用的HTTP动词有下面五个(括号里是对应的SQL命令).
        * GET(SELECT)：从服务器取出资源(一项或多项).
        * POST(CREATE)：在服务器新建一个资源.
        * PUT(UPDATE)：在服务器更新资源(客户端提供改变后的完整资源).
        * PATCH(UPDATE)：在服务器更新资源(客户端提供改变的属性).
        * DELETE(DELETE)：从服务器删除资源.

#### 过滤信息(Filtering)
    如果记录数量很多, 服务器不可能都将它们返回给用户.API应该提供参数, 过滤返回结果.下面是一些常见的参数.
        * https://api.example.com/v1/zoos?limit=10：指定返回记录的数量
        * https://ap.example.com/v1/zoos?offset=10：指定返回记录的开始位置
        * https://api.example.com/v1/zoos?page=2&per_page=100：指定第几页, 以及每页的记录数
        * https://api.example.com/v1/zoos?sortby=name&order=asc：指定返回结果按照哪个属性排序, 以及排序顺序
        * https://api.example.com/v1/zoos?animal_type_id=1：指定筛选条件
    参数的设计允许存在冗余, 即允许API路径和URL参数偶尔有重复.比如, GET /zoo/ID/animals 与 GET /animals?zoo_id=ID 的含义是相同的.

#### 状态码(Status Codes)
    服务器向用户返回的状态码和提示信息, 常见的有以下一些(方括号中是该状态码对应的HTTP动词).
        * 200 OK - [GET]：服务器成功返回用户请求的数据, 该操作是幂等的(Idempotent).
        * 201 CREATED - [POST/PUT/PATCH]：用户新建或修改数据成功.
        * 202 Accepted - [*]：表示一个请求已经进入后台排队(异步任务)
        * 204 NO CONTENT - [DELETE]：用户删除数据成功.
        * 400 INVALID REQUEST - [POST/PUT/PATCH]：用户发出的请求有错误, 服务器没有进行新建或修改数据的操作, 该操作是幂等的.
        * 401 Unauthorized - [*]：表示用户没有权限(令牌、用户名、密码错误).
        * 403 Forbidden - [*] 表示用户得到授权(与401错误相对), 但是访问是被禁止的.
        * 404 NOT FOUND - [*]：用户发出的请求针对的是不存在的记录, 服务器没有进行操作, 该操作是幂等的.
        * 406 Not Acceptable - [GET]：用户请求的格式不可得(比如用户请求JSON格式, 但是只有XML格式).
        * 410 Gone -[GET]：用户请求的资源被永久删除, 且不会再得到的.
        * 422 Unprocesable entity - [POST/PUT/PATCH] 当创建一个对象时, 发生一个验证错误.
        * 500 INTERNAL SERVER ERROR - [*]：服务器发生错误, 用户将无法判断发出的请求是否成功.

#### 错误处理(Error handling)
    如果状态码是4xx, 就应该向用户返回出错信息.一般来说, 返回的信息中将error作为键名, 出错信息作为键值即可.
    {
        error: "Invalid API key"
    }

#### 返回结果
    针对不同操作, 服务器向用户返回的结果应该符合以下规范.
        * GET /collection：返回资源对象的列表(数组)
        * GET /collection/resource：返回单个资源对象
        * POST /collection：返回新生成的资源对象
        * PUT /collection/resource：返回完整的资源对象
        * PATCH /collection/resource：返回完整的资源对象
        * DELETE /collection/resource：返回一个空文档

#### Hypermedia API
    RESTful API最好做到Hypermedia, 即返回结果中提供链接, 连向其他API方法, 使得用户不查文档, 也知道下一步应该做什么


