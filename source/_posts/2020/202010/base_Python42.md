---
title: Python_基础 (42)
date: 2020-10-28
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    快来跟我一起学Django！！！

<!-- more -->

#### 视图View
> 在Django MTV模式中, View视图负责业务逻辑部分, 路由系统接收到HTTP请求, 并将任务分配给相应的视图函数, 由视图函数来负责响应这个请求.无论视图本身包含什么逻辑, 都要返回响应.其中HTTP请求中产生两个核心对象(django.http): 
    HTTP请求: HttpRequest对象
    HTTP响应: HttpResponse对象
- HttpRequest对象的属性和方法
    ```python
        # 相关属性
        request.scheme # client 的请求协议 通常是http或者https
        request.body # 请求正文, 通常post请求会将数据放入body中, 返回的是一个字符串
        request.data  # 请求的数据部分, 返回的是一个字典对象(除此之外, 与request.body是很类似的)
        request.path   # 获取路径, 请求uri.但是不包含host
        request.path_info # 获取具有 URL 扩展名的资源的附加路径信息.相对于HttpRequest.path, 使用该方法便于移植.例如, 如果应用的WSGIScriptAlias 设置为"/minfo", 那么当path 是"/minfo/music/bands/the_beatles/" 时path_info 将是"/music/bands/the_beatles/".
        request.get_full_path()   # 带数据的路径
        request.method   # 请求方式("POST"/"GET")
        request.GET      # 包含所有HTTP GET参数的类字典对象(获取get方式表单中或url提交的数据)
        request.POST     # 包含所有HTTP POST参数的类字典对象(获取post方式表单中提交的数据)
            name = request.POST.get("user")  # 获取提交的数据(form表单中name属性为user的 用户输入文本值)
            pwd = request.POST.get("pwd")    #(form表单中name属性为pwd的 用户输入的文本值)
        
        # 服务器收到空的POST请求的情况也是可能发生的, 也就是说, 表单form通过HTTP POST方法提交请求, 但是表单中可能没有数据, 因此不能使用
        # if request.POST 来判断是否使用了HTTP POST 方法；应该使用  if request.method == "POST"
        
        request.COOKIES     # 包含所有cookies的标准Python字典对象；keys和values都是字符串.
        FILES:       # 包含所有上传文件的类字典对象；FILES中的每一个Key都是<input type="file" name="" />标签中name属性的值, FILES中的每一个value同时也是一个标准的python字典对象, 包含下面三个Keys: 
            filename:      # 上传文件名, 用字符串表示
            content_type:  # 上传文件的Content Type
            content:       # 上传文件的原始内容
        
        request.user       # 是一个django.contrib.auth.models.User对象, 代表当前登陆的用户.如果访问用户当前没有登陆, user将被初始化为django.contrib.auth.models.AnonymousUser的实例.
        # 你可以通过user的is_authenticated()方法来辨别用户是否登陆: if req.user.is_authenticated(); 只有激活Django中的AuthenticationMiddleware时该属性才可用
        
        request.session   # 唯一可读写的属性, 代表当前会话的字典对象；自己有激活Django中的session支持时该属性才可用.
        
        request.META       # 包含了所有本次HTTP请求的Header信息, 是一个python字典.这个字典中常见的键值有: 
            HTTP_REFERER   # 进站前链接网页, 可以用来统计网站流量来源. (请注意, 它是REFERRER的笔误)
            HTTP_USER_AGENT     # 用户浏览器标识, 可以获知浏览器的型号版本等信息.
            REMOTE_ADDR     # 客户端IP(如果申请是经过代理服务器的话, 那么它可能是以逗号分割的多个IP地址)
        
        
        # 相关方法
        request.get_host() # 返回请求的源主机.example: 127.0.0.1:8000
        request.get_port() # django1.9的新特性.
        request.get_full_path() # 返回完整路径, 并包括附加的查询信息.example: "/music/bands/the_beatles/?print=true"
    ```
- HttpResponse对象的属性和方法
    ```python
        def index(req):
            name='liujian'
            # 页面渲染
            return render(req, 'index.html', {'name' : name})

            # 页面渲染
            return render_to_response('index.html', {'name' : name})

            # 将对应视图函数中所有的变量传给模板
            return render_to_response('index.html', {'name' : name})

            # 跳转
            return redirect("http://www.baidu.com")



    ```
- 实例
    ```python
        # url.py中: 
        url(r"login",   views.login),
        url(r"yse",   views.yes),
        
        # views.py中:   
            def login(request):
                if request.method == "POST":
                    if request.POST.get("user") == "alex" and request.POST.get("pwd") == "666":
                        return redirect("/yes/")
                return render(request,"login.html",locals())
            def yes(request):
                name = "alex"
                return render(request,"yes.html",locals())
        
        # login.html中: 
        <form action="/register/" method="post">
            <div class="input">
                <input type="text" class="inputs" placeholder="用户名" name="user">
            </div>
            <div class="input">
                <input type="password" class="inputs" placeholder="密码" name="pwd">
            </div>
            <input type="button" class="button" value="注册">
        </form>
        # yes.html中: 
        <h1>{{ name }}你好！</h1>
        
        # 总结: render和redirect的区别:
        # 1. render的页面需要模板语言渲染,即需要将数据库的数据加载到html,那么所有的这些数据除了写在yes的视图函数中,必须还要写在login中,代码重复,没有解耦.
        # 2. 最重要的: url没有跳转到/yes/,而是还在/login/,所以当刷新后又得重新登录.
    ```

