---
title: Interview_总结 (143)
date: 2021-10-11
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### CGI
> CGI(Common Gateway Inteface): 字面意思就是通用网关接口, 是一个很基本的协议

#### FastCGI
> CGI的一个扩展,  提升了性能, 废除了 CGI fork-and-execute (来一个请求 fork 一个新进程处理, 处理完再把进程 kill 掉)的工作方式, 转而使用一种长生存期的方法, 减少了进程消耗, 提升了性能

#### wsgi
> WSGI的全称是Web Server Gateway Interface, 翻译过来就是Web服务器网关接口. 具体的来说, WSGI是一个规范, 定义了Web服务器如何与Python应用程序进行交互, 使得使用Python写的Web应用程序可以和Web服务器对接起来

#### uWSGI
> 是一个Web服务器, 它实现了WSGI协议、uwsgi、http等协议. 用于接收前端服务器转发的动态请求并处理后发给 web 应用程序

#### uwsgi
> 与WSGI一样是一种通信协议, 它是uWSGI服务器的独占协议,用于定义传输信息的类型
- 这些名词关系图
    ![uWSGI wsgi](/img/20211011_1.png)

#### Django请求生命周期

![Django请求生命周期](/img/20211011_2.png)
1. 过程描述
    * 用户输入网址, 浏览器发起请求
    * WSGI(服务器网关接口)创建socket服务端, 接受请求
    * 中间件处理请求
    * url路由, 根据当前请求的url找到相应的视图函数
    * 进入view, 进行业务处理, 执行类或者函数, 返回字符串
    * 再次通过中间件处理相应
    * WSGI返回响应
    * 浏览器渲染

#### 列举django的内置组件
- Form
    * 来处理web开发中的表单相关事项.form最常做的是对用户输入的内容进行验证
    * eg
        ```python
            class UserEmailPassword(forms.Form):
                """
                用户注册的表单数据类
                """
                username = forms.CharField(
                    validators=[
                        RegexValidator(r'^[a-zA-Z]{1}[a-z0-9A-Z-_]{5,20}$', "请输入用户名！支持大小写字母、数字、-、_字符, 必须以字母开头, 长度6-20")
                    ],
                    error_messages={
                        "required": "用户名不能为空",
                    },
                )
                password = forms.CharField(
                    validators=[
                        RegexValidator(r'^[a-z0-9A-Z-_]{6,}$', "请输入密码！支持大小写字母、数字、-、_字符, 最少6个字符")
                    ],
                    error_messages={
                        "required": "密码不能为空",
                    },
                )
                passwordrepeat = forms.CharField(
                    validators=[
                        RegexValidator(r'^[a-z0-9A-Z-_]{6,}$', "请再次输入确认密码！支持大小写字母、数字、-、_字符, 最少6个字符")
                    ],
                    error_messages={
                        "required": "确认密码不能为空",
                    },
                )
                email = forms.EmailField(
                    error_messages={
                        'required': u'邮箱不能为空',
                        'invalid': '邮箱格式错误'
                    }
                )

                def clean_username(self):
                    """
                    局部钩子
                    对用户名进行校验(已存在用户直接抛出异常)
                    """
                    val = self.cleaned_data.get("username")
                    if User.objects.filter(username=val):
                        raise ValidationError('该用户已经存在', code="ResourceAlreadyExist")
                    else:
                        return val

                def clean(self):
                    """
                    全局钩子
                    校验确认密码与密码是否一致
                    """
                    if self.cleaned_data.get("password") == self.cleaned_data.get("passwordrepeat"):
                        return self.cleaned_data
                    else:
                        raise ValidationError('两次输入的密码不一致', code="PasswordInconsistency")


            class UserPassword(forms.Form):
                """
                用户登录的表单数据类
                """
                username = forms.CharField(
                    validators=[
                        RegexValidator(r'^[a-zA-Z]{1}[a-z0-9A-Z-_]{5,20}$', "请输入用户名！支持大小写字母、数字、-、_字符, 必须以字母开头, 长度6-20")
                    ],
                    error_messages={
                        "required": "用户名不能为空",
                    },
                )
                password = forms.CharField(
                    validators=[
                        RegexValidator(r'^[a-z0-9A-Z-_]{6,}$', "请输入密码！支持大小写字母、数字、-、_字符, 最少6个字符")
                    ],
                    error_messages={
                        "required": "密码不能为空",
                    },
                )

                def clean_username(self):
                    """
                    局部钩子
                    对用户名进行校验(不存在用户直接抛出异常)
                    """
                    val = self.cleaned_data.get("username")
                    if User.objects.filter(username=val):
                        return val
                    else:
                        raise ValidationError('用户不存在', code="ResourceNotFound")

            # 登陆
            form = UserPassword(body)
            if form.is_valid():
                pass
            else:
                errors = form.errors.get_json_data()
                print(errors)

            # 注册
            form = UserEmailPassword(body)
            if form.is_valid():
                pass
            else:
                errors = form.errors.get_json_data()
                print(errors)
        ```
- ORM
    * 实现了数据模型与数据库的解耦,即数据模型的设计不需要依赖于特定的数据库,通过简单的配置就可以轻松更换数据库
- SESSION/COOKIE
- 中间件
    * 介于request(请求)与response(响应)处理之间的一道处理过程,相对比较轻量级,位于web服务端与url路由层之间

#### django中间件
- 什么是中间件并简述其作用
    * 中间件是一个用来处理Django请求和响应的框架级钩子. 它是一个轻量、低级别的插件系统, 用于在全局范围内改变Django的输入和输出. 每个中间件组件都负责做一些特定的功能. 
- django中间件的5个方法及应用场景
    * process_request : 请求进来时,权限认证
    * process_view : 路由匹配之后,能够得到视图函数
    * process_exception : 异常时执行
    * process_template_responseprocess : 模板渲染时执行
    * process_response : 请求有响应时执行

#### FBV和CBV
- FBV
    * Function Base Views
    * 一个url对应一个视图函数
- CBV
    * Class Base views
    * 一个url对应一个类

#### django中csrf的实现机制
1. django第1次响应来自某个客户端的请求时,服务器随机产生1个token值, 把这个token保存在session中;同时服务器把这个token放到cookie中交给前端页面；
2. 该客户端再次发起请求时, 把这个token值加入到请求数据或者头信息中,一起传给服务器；
3. 服务器校验前端请求带过来的token和session里的token是否一致. 

