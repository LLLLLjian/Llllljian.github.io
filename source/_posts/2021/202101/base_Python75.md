---
title: Python_基础 (75)
date: 2021-01-04
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django之request

<!-- more -->

#### 先说说我想做的事
> 我想看看request里都是啥东西, 之前记录过一次了 但还是记不清, 那就再记一次

#### request属性
1. HttpRequest.scheme
    * 请求的协议,一般为http或者https,字符串格式(以下属性中若无特殊指明,均为字符串格式)
2. HttpRequest.body
    * http请求的主体,二进制格式
3. HttpRequest.path
    * 所请求页面的完整路径(但不包括协议以及域名),也就是相对于网站根目录的路径.
4. HttpRequest.path_info
    * 获取具有 URL 扩展名的资源的附加路径信息.相对于HttpRequest.path,使用该方法便于移植.
5. HttpRequest.method
    * 获取该请求的方法,比如：GET/POST
6. HttpRequest.encoding
    * 获取请求中表单提交数据的编码
7. HttpRequest.content_type
    * 获取请求的MIME类型(从CONTENT_TYPE头部中获取),django1.10的新特性.
8. HttpRequest.content_params
    * 获取CONTENT_TYPE中的键值对参数,并以字典的方式表示,django1.10的新特性.
9. HttpRequest.GET
    * 返回一个 querydict 对象(类似于字典,本文最后有querydict的介绍),该对象包含了所有的HTTP GET参数
10. HttpRequest.POST
    * 返回一个 querydict ,该对象包含了所有的HTTP POST参数,通过表单上传的所有  字符  都会保存在该属性中.
11. HttpRequest.COOKIES
    * 返回一个包含了所有cookies的字典.
12. HttpRequest.FILES
    * 返回一个包含了所有的上传文件的  querydict  对象.通过表单所上传的所有文件都会保存在该属性中. key的值是input标签中name属性的值,value的值是一个UploadedFile对象
13. HttpRequest.META
    * 返回一个包含了所有http头部信息的字典
14. HttpRequest.session
    * 中间件属性
15. HttpRequest.site
    * 中间件属性
16. HttpRequest.user
    * 中间件属性,表示当前登录的用户
    * 字段
        * username: 用户名
        * first_name
        * last_name
        * email
        * password
        * groups
        * user_permissions
        * is_staff: 布尔型.指定该用户是否可以访问管理站点
        * is_active: 布尔值.指定该用户账户是否应该被视为活跃账户
        * is_superuser: 布尔值.指定该用户拥有所有权限,而不用一个个开启权限
        * last_login: 用户最后一次登录的日期时间
        * date_joined: 指定账户创建时间的日期时间.帐户创建时,默认设置为当前日期／时间
    * 属性
        * is_authenticated
        * is_anonymous
    * 方法
        * get_username(): 返回用户的用户名
        * get_full_name(): 返回 first_name 加上 last_name,中间有一个空格
        * get_short_name(): 返回 first_name
        * set_password(raw_password): 将用户的密码设置为给定的原始字符串,并进行密码哈希处理
        * check_password(raw_password): 如果给定的原始字符串是用户的正确密码,返回 True

#### request方法
1. HttpRequest.get_host()
    * 返回请求的源主机.example:  127.0.0.1:8000
2. HttpRequest.get_port()
    * django1.9的新特性.
3. HttpRequest.get_full_path()
    * 返回完整路径,并包括附加的查询信息.example:  "/music/bands/the_beatles/?print=true"
4. HttpRequest.bulid_absolute_uri(location)
    * 返回location的绝对uri,location默认为request.get_full_path().

#### 打印request中的所有数据行
- eg
    ```python
        from django.core.handlers.wsgi import WSGIRequest

        def test(request):
            # 打印出request的类型
            print(type(request))
            # 打印出request的header详细信息
            print(request.environ)
            # 循环打印出每一个键值对
            for k, v in request.environ.items():
                print(k, v)
    ```


