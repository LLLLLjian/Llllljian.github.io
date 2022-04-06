---
title: Python_基础 (44)
date: 2020-10-30
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    快来跟我一起学Django-rest-framework！！！

<!-- more -->

#### 基础

##### 安装
- 两种方式
    * <a href="https://github.com/encode/django-rest-framework">github</a>
    * pip直接安装
        ```bash
            pip install djangorestframework
        ```

##### 需要先了解的一些知识
1. 面向对象封装的两大特性
    * 把同一类方法封装到类中
    * 将数据封装到对象中
2. CBV
    * 基于反射实现根据请求方式不同, 执行不同的方法
    * 原理: url-->view方法-->dispatch方法(反射执行其它方法: GET/POST/PUT/DELETE等等)

#### 简单实例
> 创建一个项目和一个app(我这里命名为api)
- settings.py
    ```python
        INSTALLED_APPS = [
            ...
            'api',
            'rest_framework',
        ]
    ```
- urls.py
    ```python
        from django.contrib import admin
        from django.urls import path
        from API.views import AuthView

        urlpatterns = [
            path('admin/', admin.site.urls),
            path('api/v1/auth/',AuthView.as_view()),
        ]
    ```
- models.py
    ```python
        from django.db import models

        class UserInfo(models.Model):
            USER_TYPE = (
                (1,'普通用户'),
                (2,'VIP'),
                (3,'SVIP')
            )

            user_type = models.IntegerField(choices=USER_TYPE)
            username = models.CharField(max_length=32)
            password = models.CharField(max_length=64)

        class UserToken(models.Model):
            user = models.OneToOneField(UserInfo,on_delete=models.CASCADE)
            token = models.CharField(max_length=64)
    ```
- views.py
    ```python
        from django.http import JsonResponse
        from rest_framework.views import APIView
        from api import models


        def md5(user):
            import hashlib
            import time
            # 当前时间, 相当于生成一个随机的字符串
            ctime = str(time.time())
            m = hashlib.md5(bytes(user, encoding='utf-8'))
            m.update(bytes(ctime, encoding='utf-8'))
            return m.hexdigest()


        class AuthView(APIView):
            def post(self, request, *args, **kwargs):
                ret = {'code': 1000, 'msg': None}
                try:
                    user = request.POST
                    pwd = request.POST.get("password")
                    obj = models.UserInfo.objects.filter(username=user, password=pwd).first()
                    ret['user'] = user
                    ret['pwd'] = pwd
                    ret['obj'] = obj
                    if not obj:
                        ret['code'] = 1001
                        ret['msg'] = '用户名或密码错误'
                        return JsonResponse(ret)  # 没有该语句, 永远不会返回用户名密码错误
                    # 为用户创建token
                    token = md5(user)
                    # 存在就更新, 不存在就创建
                    models.UserToken.objects.update_or_create(user=obj, defaults={'token': token})
                    ret['token'] = token
                except(Exception):
                    ret['code'] = 1002
                    ret['msg'] = '请求异常'
                return JsonResponse(ret)

            def get(self, request, *args, **kwargs):
                ret = {'code': 200, 'msg': "get输出"}
                user = request.GET.get("username")
                pwd = request.GET.get("password")
                ret['user'] = user
                ret['pwd'] = pwd
                return JsonResponse(ret)
    ```
- as_view()方法说明
    * 源码
        ```python
                @classonlymethod
                def as_view(cls, **initkwargs):  # 实际上是一个闭包  返回 view函数
                    """
                    Main entry point for a request-response process.
                    """
                    for key in initkwargs:
                        if key in cls.http_method_names:
                            raise TypeError("You tried to pass in the %s method name as a "
                                            "keyword argument to %s(). Don't do that."
                                            % (key, cls.__name__))
                        if not hasattr(cls, key):
                            raise TypeError("%s() received an invalid keyword %r. as_view "
                                            "only accepts arguments that are already "
                                            "attributes of the class." % (cls.__name__, key))

                    def view(request, *args, **kwargs):  # 作用: 增加属性,  调用dispatch方法 
                        self = cls(**initkwargs)  # 创建一个 cls 的实例对象,  cls 是调用这个方法的 类(Demo)
                        if hasattr(self, 'get') and not hasattr(self, 'head'):
                            self.head = self.get
                        self.request = request  # 为对象增加 request,  args,  kwargs 三个属性
                        self.args = args
                        self.kwargs = kwargs
                        return self.dispatch(request, *args, **kwargs)  # 找到指定的请求方法,  并调用它
                    view.view_class = cls
                    view.view_initkwargs = initkwargs

                    # take name and docstring from class
                    update_wrapper(view, cls, updated=())

                    # and possible attributes set by decorators
                    # like csrf_exempt from dispatch
                    update_wrapper(view, cls.dispatch, assigned=())
                    return view

                def dispatch(self, request, *args, **kwargs):
                    # Try to dispatch to the right method; if a method doesn't exist,
                    if request.method.lower() in self.http_method_names:  # 判断请求的方法类视图是否拥有,  http_method_names=['get', 'post']
                        handler = getattr(self, request.method.lower(), self.http_method_not_allowed)  # 如果存在 取出该方法
                    else:
                        handler = self.http_method_not_allowed
                    return handler(request, *args, **kwargs)  # 执行该方法
        ```
    * 简化版
        ```python
            @classonlymethod
            def as_view(cls, **initkwargs):  # 实际上是一个闭包  返回 view函数
                """
                Main entry point for a request-response process.
                """
                def view(request, *args, **kwargs):  # 作用: 增加属性,  调用dispatch方法 
                    self = cls(**initkwargs)  # 创建一个 cls 的实例对象,  cls 是调用这个方法的 类(Demo)
                    if hasattr(self, 'get') and not hasattr(self, 'head'):
                        self.head = self.get
                    self.request = request  # 为对象增加 request,  args,  kwargs 三个属性
                    self.args = args
                    self.kwargs = kwargs
                    return self.dispatch(request, *args, **kwargs)  # 找到指定的请求方法,  并调用它

                return view

            def dispatch(self, request, *args, **kwargs):
                # Try to dispatch to the right method; if a method doesn't exist,
                if request.method.lower() in self.http_method_names:  # 判断请求的方法类视图是否拥有,  http_method_names=['get', 'post']
                    handler = getattr(self, request.method.lower(), self.http_method_not_allowed)  # 如果存在 取出该方法
                else:
                    handler = self.http_method_not_allowed
                return handler(request, *args, **kwargs)  # 返回该请求方法执行的结果
        ```
    * 再简化
        ```python
            def as_view(): # 校验 + 返回view方法
                # 一些校验
                ...
                def view(): # 执行视图
                    # 增加 为对象request, args, kwargs 属性
                    ...
                    return dispatch() # 调用指定的请求方法
                return view

            def dispatch(): # 真正的查找指定的方法, 并调用该方法
                ...
                return handler()
        ```
    * 调用顺序
        * as_view --> view --> dispatch
        * 可以看出as_view实际上是一个闭包, 它的作用做一些校验工作, 再返回view方法.而view方法的作用是给请求对象补充三个参数, 并调用 dispatch方法处理. dispatch方法查找到指定的请求方法, 并执行. 可以得出结论: 实际上真正实现查找的方法是 dispatch方法
    * 附上一张图片
    ![as_view](/img/20201030_1.png)
