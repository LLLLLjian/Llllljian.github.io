---
title: Python_基础 (127)
date: 2021-09-07
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### Flask之exception

在 python 开发中,利用 flask 写 restful api 函数的时候,除了标准的400、500等这些返回码通过 abort() 返回以外,怎么另外返回自定义的错误代码和信息呢？

我们碰到的业务场景是对于api 输入参数的各类校验以及在业务逻辑执行的时候,都会返回统一的400代码,同时也会返回我们约定的描述详细错误的代码以及描述字符串,提供给调用方来处理,这样可以让其用户体验做得更好,同时详细错误代码和描述字符串也会自动打印在 log 日志中

flask 的官方文档中告诉我们: 

> 默认情况下,错误代码会显示一个黑白的错误页面.如果你要定制错误页面, 可以使用 errorhandler()装饰器

- demo
    ```python
        @app.errorhandler(CustomFlaskErr)
        def handle_flask_error(error):

            # response 的 json 内容为自定义错误代码和错误信息
            response = jsonify(error.to_dict())
            
            # response 返回 error 发生时定义的标准错误代码
            response.status_code = error.status_code
            
            return response

        USER_ALREADY_EXISTS = 20001  # 用户已经存在
        J_MSG = {USER_ALREADY_EXISTS: 'user already exists'}

        class CustomFlaskErr(Exception):
            # 默认的返回码
            status_code = 400

            # 自己定义了一个 return_code,作为更细颗粒度的错误代码
            def __init__(self, return_code=None, status_code=None, payload=None):
                Exception.__init__(self)
                self.return_code = return_code
                if status_code is not None:
                    self.status_code = status_code
                self.payload = payload

            # 构造要返回的错误代码和错误信息的 dict
            def to_dict(self):
                rv = dict(self.payload or ())
                
                # 增加 dict key: return code
                rv['return_code'] = self.return_code
                
                # 增加 dict key: message, 具体内容由常量定义文件中通过 return_code 转化而来
                rv['message'] = J_MSG[self.return_code]
                
                # 日志打印
                logger.warning(J_MSG[self.return_code])
                
                return rv
    ```
- use
    ```python
            # 用户名输入为空
            if user_name is None:
                raise CustomFlaskErr(USER_NAME_ILLEGAL, status_code=400)
    ```

