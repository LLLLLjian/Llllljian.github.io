---
title: Python_基础 (122)
date: 2021-08-31
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### RequestID
> Flask Log Request Id是Flask的一个扩展, 它可以解析和处理请求处理器(如Amazon ELB、Heroku Request Id或任何用于微服务的多层基础结构)发送的请求Id.一种常见的使用场景是在日志系统中注入请求id, 以便所有日志记录(即使是第三方库发出的日志记录)都附加了发起调用的请求id.这可以大大改进问题的跟踪和调试.
- Installation
    ```bash
        pip install flask-log-request-id
    ```
- Usage
    * example1
        ```python
            # Flask Log Request Id提供了current_Request_Id()函数, 可随时使用该函数获取已启动执行链的请求Id.

            from flask_log_request_id import RequestID, current_request_id

            [...]

            RequestID(app)


            @app.route('/')
            def hello():
                print('Current request id: {}'.format(current_request_id()))
        ```
    * example2
        ```python
            import logging
            import logging.config
            import json

            from random import randint
            from flask import Flask
            from flask import request
            from flask_log_request_id import RequestID
            from flask_log_request_id import RequestIDLogFilter

            logging.basicConfig(level=logging.DEBUG)
            app = Flask(__name__)
            RequestID(app)

            # Setup logging
            handler = logging.StreamHandler()
            handler.setFormatter(
                logging.Formatter("%(asctime)s - %(name)s - level=%(levelname)s - request_id=%(request_id)s - %(message)s")
            )
            handler.setLevel(0)
            handler.addFilter(RequestIDLogFilter())  # << Add request id contextual filter
            logging.getLogger().addHandler(handler)


            @app.before_request
            def log_each_request():
                """
                # 打印每个请求的请求输入日志
                """
                params = json.dumps(request.args) if request.method == 'GET' else json.dumps(request.get_json())
                logging.info("{}-{}-{}".format(request.method, request.path, params))


            def generic_add(a, b):
                """
                Simple function to add two numbers that is not aware of the request id
                """
                logging.error('Called generic_add({}, {})'.format(a, b))
                return a + b


            @app.route('/')
            def index():
                a, b = randint(1, 15), randint(1, 15)
                logging.debug('Adding two random numbers {} {}'.format(a, b))
                return str(generic_add(a, b))


            if __name__ == "__main__":
                app.run(debug=True)

            2021-08-31 13:59:29,083 - root - level=INFO - request_id=75d5d629-9a84-473c-829c-b656170cb63e - GET-/-{}
            2021-08-31 13:59:29,084 - root - level=DEBUG - request_id=75d5d629-9a84-473c-829c-b656170cb63e - Adding two random numbers 15 7
            2021-08-31 13:59:29,084 - root - level=ERROR - request_id=75d5d629-9a84-473c-829c-b656170cb63e - Called generic_add(15, 7)
            2021-08-31 13:59:29,085 - werkzeug - level=INFO - request_id=None - 127.0.0.1 - - [29/Aug/2021 13:59:29] "GET / HTTP/1.1" 200 -
        ```
    * example3
        ```python
            from flask_log_request_id import current_request_id

            @app.after_request
            def append_request_id(response):
                """
                所有的响应信息中都添加X-REQUEST-ID, 方便排查问题
                """
                response.headers.add('X-REQUEST-ID', current_request_id())
                return response
        ```
