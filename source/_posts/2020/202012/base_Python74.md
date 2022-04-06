---
title: Python_基础 (74)
date: 2020-12-30
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django之CORS跨域请求

<!-- more -->

#### 先说说我想做的事
> 前后端分离了就设计到跨域请求了, 先解决跨域吧

#### 什么是跨域请求
> 简单来说就是当前发起的请求的域与该请求指向的资源所在的域不一致.当协议+域名+端口号均相同,那么就是同一个域

#### 跨域问题
> CORS需要浏览器和服务器同时支持, 整个CORS通信过程,都是浏览器自动完成,不需要用户参与.对于开发者来说,CORS通信与同源的AJAX通信没有差别,代码完全一样.浏览器一旦发现AJAX请求跨源,就会自动添加一些附加的头信息,有时还会多出一次附加的请求,但用户不会有感觉
- 浏览器将CORS请求分成两类
    * 简单请求(simple request)
        * 只要同时满足以下两大条件,就属于简单请求
        1. 请求方法是以下三种方法之一: (也就是说如果你的请求方法是什么put、delete等肯定是非简单请求)
            1. HEAD
            2. GET
            3. POST
        2. HTTP的头信息不超出以下几种字段: (如果比这些请求头多,那么一定是非简单请求)
            1. Accept
            2. Accept-Language
            3. Content-Language
            4. Last-Event-ID
            5. Content-Type: 只限于三个值application/x-www-form-urlencoded、multipart/form-data、text/plain,也就是说,如果你发送的application/json格式的数据,那么肯定是非简单请求,vue的axios默认的请求体信息格式是json的,ajax默认是urlencoded的.
    * 非简单请求(not-so-simple request)
        * 两次请求,在发送数据之前会先发一次请求用于做“预检”,只有“预检”通过后才再发送一次请求用于数据传输.
        * 关于“预检”
        * 如果复杂请求是PUT等请求,则服务端需要设置允许某请求,否则“预检”不通过 Access-Control-Request-Method
        * 如果复杂请求设置了请求头,则服务端需要设置允许某请求头,否则“预检”不通过 Access-Control-Request-Headers

#### 报错信息
![跨域报错信息](/img/20201230_1.png)

#### 解决方案
1. JSONP,比较原始的方法,本质上是利用html的一些不受同源策略影响的标签,例如: &gt;a>,&gt;img>,&gt;iframe>,&gt;script>等,从而实现跨域请求,但是这种方法只支持GET的请求方式.
2. CORS,Cross-Origin Resource Sharing,是一个新的W3C标准,它新增的一组HTTP首部字段,允许服务端声明哪些源站有权限访问哪些资源,换言之,它允许浏览器向声明了CORS的跨域服务器发出XML HttpRequest请求,从而客服Ajax只能同源使用的限制.在django框架中就是利用CORS来解决跨域请求的问题.

#### django-cors-headers类库
> django-cors-headers处理跨域请求,一个为响应添加跨源资源共享(CORS)头的Django应用.这允许从其他源向Django应用程序发出浏览器内请求.
- 安装
    ```bash
        pip install django-cors-headers
    ```
- 配置settings.py
    ```python
        INSTALLED_APPS = [
            ...
            'corsheaders',
            ...
        ]

        MIDDLEWARE = [
            'corsheaders.middleware.CorsMiddleware',	# 放最前面
            ...
        ]

        # 如果为True,则将不使用白名单,并且将接受所有来源.默认为False
        CORS_ORIGIN_ALLOW_ALL = True
        # 授权进行跨站点HTTP请求的来源列表.默认为[]
        CORS_ORIGIN_WHITELIST = []
        # CORS_ALLOW_METHODS: 实际请求所允许的HTTP动词列表
        CORS_ALLOW_METHODS = [
            'DELETE',
            'GET',
            'OPTIONS',
            'PATCH',
            'POST',
            'PUT',
        ]
        # CORS_ALLOW_HEADERS: 发出实际请求时可以使用的非标准HTTP标头的列表
        CORS_ALLOW_HEADERS = [
            'accept',
            'accept-encoding',
            'authorization',
            'content-type',
            'dnt',
            'origin',
            'user-agent',
            'x-csrftoken',
            'x-requested-with',
        ]
    ```

