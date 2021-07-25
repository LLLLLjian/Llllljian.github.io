---
title: Python_基础 (93)
date: 2021-03-24
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    Django之中间件

<!-- more -->

#### 中间件
> 中间件是 Django 请求/响应处理的钩子框架.它是一个轻量级的、低级的“插件”系统, 用于全局改变 Django 的输入或输出.每个中间件组件负责做一些特定的功能
1. 中间件的定义方法
    * 定义一个中间件工厂函数, 然后返回一个可以别调用的中间件.
    * 中间件工厂函数需要接收一个可以调用的get_response对象.
    * 返回的中间件也是一个可以被调用的对象, 并且像视图一样需要接收一个request对象参数, 返回一个response对象
    * demo
        ```python
            def simple_middleware(get_response):
            # 此处编写的代码仅在Django第一次配置和初始化的时候执行一次.
                def middleware(request):
                # 此处编写的代码会在每个请求处理视图前被调用.
                response = get_response(request)
                # 此处编写的代码会在每个请求处理视图之后被调用.
                return response
            return middleware
        ```
    * eg
        ```python
            def my_middleware(get_response):
                print('init 被调用')
                def middleware(request):
                    print('before request 被调用')
                    response = get_response(request)
                    print('after response 被调用')
                    return response
            return middleware

            MIDDLEWARE = [
                ...
                'users.middleware.my_middleware', # 添加中间件
                ...
            ]

            def demo_view(request):
                print('view 视图被调用')
                return HttpResponse('OK')

            # out: 
            # init 被调用
            # before request 被调用
            # view 视图被调用
            # after response 被调用
        ```
2. 执行流程
    * ![简单中间件执行流程](/img/20210324_1.png)
3. 多个中间件的执行顺序
    * 在请求视图被处理前, 中间件由上至下依次执行
    * 在请求视图被处理后, 中间件由下至上依次执行
    * ![多个中间件执行流程](/img/20210324_2.png)
    * eg
        ```python
            def my_middleware(get_response):
                print('init 被调用')
                def middleware(request):
                    print('before request 被调用')
                    response = get_response(request)
                    print('after response 被调用')
                    return response
            return middleware
            
            def my_middleware2(get_response):
                print('init2 被调用')
                def middleware(request):
                    print('before request 2 被调用')
                    response = get_response(request)
                    print('after response 2 被调用')
                    return response
                return middleware

            MIDDLEWARE = [
                ...
                'users.middleware.my_middleware', # 添加
                'users.middleware.my_middleware2', # 添加
                ...
            ]

            # out:
            # init2 被调用
            # init 被调用
            # before request 被调用
            # before request 2 被调用
            # view 视图被调用
            # after response 2 被调用
            # after response 被调用
        ```

#### 总结
1. 装饰器
    * ![装饰器顺序](/img/20210324_3.png)
    * 对于装饰器来说, 在这里程序从上到下执行, 开始记录装饰器1-3, 然后读到了函数的时候, 装饰器开始装饰, 把函数的引用传入装饰器中, 从装饰器3开始往上装饰, 所以这时候开始执行装饰器3的初始化, 并把装饰完的函数当做一个新的函数, 再次把新的引用传入到装饰器2, 接着装饰器2进行初始化,再次把新的函数的引用传入到装饰器1进行装饰, 这时候装饰器1的初始化开始, 并开始执行, 从而接下来的执行顺序为1-3执行装饰的内容, 最后再执行本来的函数, 达到一个对原有函数增加功能和特性的要求
    * 从程序开始的顺序, 从上到下读取----》从下到上装饰----》从上到下执行
2. 中间件
    * 与装饰器类似
    * 从程序开始的顺序, 从上到下读取----》从下到上初始化init()----》从上到下执行请求前----》视图的请求----》从下到上执行请求后
