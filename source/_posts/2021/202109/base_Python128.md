---
title: Python_基础 (128)
date: 2021-09-08
tags: Python
toc: true
---

### 巧用python装饰器
    python 中使用装饰器来统一检查用户权限

<!-- more -->

#### 前言

最近在一个项目中,需要判断 restful 接口函数传入的时候,是否之前已经登录状态是某个特定用户,以及该用户有没有指定的权限.检查下来如果没有的话,立刻返回错误,中断功能.

遮掩的场景虽然也可以通过标准的调用函数来操作,但都不如用装饰器来得简单.

#### Flask
- 装饰器1
    ```python
            def validate_current_is_admin(f):
                @functools.wraps(f)
                def decorated_function(*args, **kws):
                    # 需要在登录状态调用, 检查是否为有admin权限的用户登录,
                    # 如果不是,返回错误码；
                    if g.user.user_name != 'admin':
                        raise CustomFlaskErr(USER_MUST_HAS_ADMIN_PRIVILEGE, status_code=401)

                    # 验证权限是否为 admin, 不是的话,返回401错误
                    if g.user.role_id != Permission.ADMIN:
                        raise CustomFlaskErr(USER_MUST_HAS_ADMIN_PRIVILEGE, status_code=401)
                    return f(*args, **kws)
                return decorated_function
    ```
- 使用1
    ```python
        @app.route('/api/create_user', methods=['POST'])
        @auth.login_required
        @validate_current_is_admin
        def create_user():
            # 获得参数
            user_name = request.json.get('user_name')
            password = request.json.get('password')
        ......
    ```
- 装饰器2
    ```python
        from functools import wraps
        from flask import request, make_response, jsonify

        def token_required(f):
            """
            token验证函数
            """
            @wraps(f)
            def decorated_function(*args, **kwargs):
                """
                装饰器函数
                """
                result = {
                    "data": "fail",
                    "code": 401,
                    "message": "用户未登陆, 缺少token"
                }
                headers = request.headers
                if "my_token" in headers:
                    token = headers["my_token"]
                    user = get_username_by_token(token)
                    if user:
                        request.user = user
                        return f(*args, **kwargs)
                    else:
                        result["message"] = "token %s 无效" % str(token)
                else:
                    result["message"] = "token 不存在"
                return make_response(jsonify(result), result["code"])
            return decorated_function


        def check_auth(role=None):
            """
            分角色的权限认证
            """
            def check_auth_by_role(f):
                """
                权限认证函数
                """
                @wraps(f)
                def decorated_function(*args, **kwargs):
                    """
                    装饰器函数
                    """
                    # 取一下当前用户
                    current_user = request.user
                    # 返回值
                    result = {
                        "data": "",
                        "code": 200,
                        "message": ""
                    }
                    # /a/a1
                    if "a1" in kwargs:
                        # 检查项目是否存在及权限
                        a1 = kwargs["a1"]
                        # 检查a1是否存在
                        a1_info = get_a1_info(a1)
                        if not a1:
                            result["code"] = 404
                            result["message"] = "a1 %s 不存在" % a1

                    # 如果没有权限要求, 并且是get请求, 普通用户即可
                    if (role is None and request.method == "GET"):
                        auth_user_list = a1["admin_user_list"] + a1["user_list"]
                    # 如果要求是admin权限, 并且是增删改操作, 必须是管理员
                    elif (role == "admin" and request.method in ["POST", "PUT", "DELETE"]):
                        auth_user_list = a1["admin_user_list"]
                    else:
                        auth_user_list = a1["user_list"]

                    if current_user in auth_user_list:
                        pass
                    else:
                        result["code"] = 403
                        result["message"] = "无权限操作产品线 %s" % productline
                    if result["code"] == 200:
                        return f(*args, **kwargs)
                    else:
                        return make_response(jsonify(result), result["code"])
                return decorated_function
            return check_auth_by_role
    ```
- 使用2
    ```python
        @app.route('/api/v1/a/<a1>', methods=['DELETE'])
        @token_required
        @check_auth("admin")
        def delete_one(a1):
            """
            删除操作
            """
            ......

        @app.route('/api/v1/a/<a1>', methods=['GET'])
        @token_required
        @check_auth()
        def get_detail(a1):
            """
            查询详情
            """
            ......
    ```

#### Django
- 装饰器
    ```python
        def set_auth(func):
            """
            管理员才能访问的页面
            request.user.is_superuser=1 或者 request.user == config["super_admin"]
            """
            def wrapper(*args, **kwargs):
                """
                闭包
                """
                # 当前文件名-当前方法名-当前行
                current_file = inspect.currentframe()
                base_position = current_file.f_code.co_filename + "-" + func.__name__

                if (args[1].user.is_superuser) or (args[1].user == config["super_admin"]):
                    return func(*args, **kwargs)
                else:
                    raise Exception("无操作权限")
            return wrapper


        def check_auth(skip_auth=False):
            """
            权限控制
            """
            def check_auth_by_rule(f):
                """
                权限认证函数
                """
                @wraps(f)
                def decorated_function(*args, **kwargs):
                    """
                    # 装饰器函数
                    :param args:
                    :param kwargs:
                    :return:
                    """
                    if skip_auth:
                        pass
                    else:
                        # 权限判断
                        ......
                    return f(*args, **kwargs)
                return decorated_function
            return check_auth_by_rule
    ```
