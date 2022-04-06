---
title: Python_基础 (123)
date: 2021-09-01
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### 钩子函数
- demo
    ```python
        from flask import Flask

        app = Flask(__name__)


        @app.before_first_request
        def first():
            """
            项目启动后接受到的第一个请求, 所要执行的函数, 整个项目的第一次, 和浏览器没有关系
            """
            print('我是第一次')


        @app.before_request
        def before1():
            """
            执行响应函数之前, 相当于django中的process_request, 在执行响应函数之前做一些事情
            总结: 请求执行之前的顺序是:谁先注册, 谁就先执行
            但如果before_request中有返回值, 那后面的before就不会执行, 且响应函数也不会执行,但是after_request任然会全部执行(这里与django不同, django是同级返回)
            """
            print('我是before1')
            return 'ok'


        @app.before_request
        def before2():
            """
            因为before1中有返回, 所以before2不会调用
            """
            print('我是before2')


        @app.after_request
        def after1(response):
            """
            after_request必须接受一个参数, 参数为response对象, 且必须返回
            响应函数之后执行, 相当于django的process_response,在响应函数之后执行的
            总结: after_request的执行顺序是: 先注册, 后执行
            """
            print('响应后的参数', response)
            print('我是after1')
            return response


        @app.after_request
        def after2(response):
            print('响应后的参数', response)
            print('我是after2')
            return response


        @app.teardown_request
        def teardown_request_a(exc):
            print('I am in teardown_request_a')


        @app.teardown_request
        def teardown_request_b(exc):
            print('I am in teardown_request_b')


        @app.errorhandler(404)
        def source_not_find(err):
            print('404错误')
            raise err


        @app.errorhandler(400)
        def param_valid(err):
            print('400错误')
            raise err


        @app.route('/')
        def index():
            print('我是响应函数')
            return 'ok'


        if __name__ == '__main__':
            app.run()
        # 输出结果
        # 我是第一次
        # 我是before1
        # 响应后的参数 <Response 2 bytes [200 OK]>
        # 我是after2
        # 响应后的参数 <Response 2 bytes [200 OK]>
        # 我是after1
        # I am in teardown_request_b
        # I am in teardown_request_a
    ```
- 执行顺序
    ![钩子函数执行顺序](/img/20210901_1.png)

