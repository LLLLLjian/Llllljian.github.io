---
title: Python_基础 (56)
date: 2020-11-30
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之form深入

<!-- more -->

#### 先说说我想做的事
1. 注册表单验证
    * 用户名正则验证
    * 用户名不能存在
    * 密码正则验证
    * 确认密码正则验证
    * 确认密码与密码一致
    * 邮箱正则验证
2. 登陆表单验证
    * 用户名正则验证
    * 用户名需存在
    * 密码正则验证
    * 密码需要正确

#### 为了这些我做的准备
1. 蠢办法
    * 获取->验证->抛异常->返回code
    * 很好理解,但代码很多
2. 利用form.valid
    ```python
        from django.core.exceptions import ValidationError
        from django.core.validators import RegexValidator

        class UserEmailPassword(forms.Form):
            """
            用户注册的表单数据类
            """
            username = forms.CharField(
                """
                用户名正则
                """
                validators=[
                    RegexValidator(r'^[a-zA-Z]{1}[a-z0-9A-Z-_]{5,20}$', "请输入用户名！支持大小写字母、数字、-、_字符,必须以字母开头,长度6-20")
                ],
                error_messages={
                    "required": "用户名不能为空",
                },
            )
            password = forms.CharField(
                """
                密码正则
                """
                validators=[
                    RegexValidator(r'^[a-z0-9A-Z-_]{6,}$', "请输入密码！支持大小写字母、数字、-、_字符,最少6个字符")
                ],
                error_messages={
                    "required": "密码不能为空",
                },
            )
            passwordrepeat = forms.CharField(
                """
                确认密码正则
                """
                validators=[
                    RegexValidator(r'^[a-z0-9A-Z-_]{6,}$', "请再次输入确认密码！支持大小写字母、数字、-、_字符,最少6个字符")
                ],
                error_messages={
                    "required": "确认密码不能为空",
                },
            )
            email = forms.EmailField(
                """
                邮箱自验证
                """
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
                    RegexValidator(r'^[a-zA-Z]{1}[a-z0-9A-Z-_]{5,20}$', "请输入用户名！支持大小写字母、数字、-、_字符,必须以字母开头,长度6-20")
                ],
                error_messages={
                    "required": "用户名不能为空",
                },
            )
            password = forms.CharField(
                validators=[
                    RegexValidator(r'^[a-z0-9A-Z-_]{6,}$', "请输入密码！支持大小写字母、数字、-、_字符,最少6个字符")
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

        def login(request):
            ...
            form = UserPassword(body)
            if form.is_valid():
                ...
            else:
                message, code, httpcode = get_error_msg(form)
                logger.error(log_info)
                login_json = {
                    "code": code,
                    "message": message,
                    "requestId": request.request_id
                }
                return JsonResponse(login_json, status=httpcode)

        def register(request):
            ...
            form = UserEmailPassword(body)
            if form.is_valid():
                ...
            else:
                message, code, httpcode = get_error_msg(form)
                logger.error(log_info)
                login_json = {
                    "code": code,
                    "message": message,
                    "requestId": request.request_id
                }
                return JsonResponse(login_json, status=httpcode)

        def get_error_msg(self):
            """
            获取form表单错误
            获取!form.is_valid的错误信息
            返回值为 message code httcode
            message 返回的汉字描述
            code 返回的code描述
            httpcode 返回的httpcode码
            """
            if hasattr(self, 'errors'):
                errors = self.errors.get_json_data()
                code_list = ["required", "invalid"]
                httpcode = 400
                for key, message_dicts in errors.items():
                    if (message_dicts[0]["code"] in code_list):
                        message_dicts[0]["code"] = "InvalidParam"
                    if message_dicts[0]["code"] == "ResourceNotFound":
                        httpcode = 404
                    return message_dicts[0]["message"], message_dicts[0]["code"], httpcode
            else:
                return "未知错误"
    ```
