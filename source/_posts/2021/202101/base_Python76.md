---
title: Python_基础 (76)
date: 2021-01-06
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django之django-cas-ng

<!-- more -->

#### 先说说我想做的事
> 公司内部项目,要使用统一登陆平台去进行用户登陆, 自己写sso有点呆, 看了看之前项目用的是django-cas 有点老古董了, 所以我就自作主张切换成 django-cas-ng了. 其实两个东西是一样的 只不过cas-ng是新版而已

#### django-cas-ng简介
> django-cas-ng是Django CAS(中央身份验证服务)1.0 / 2.0 / 3.0客户端库,支持SSO(单点登录)和单一注销(SLO)
它支持Django 2.0、2.1、2.2、3.0和Python 3.5+！
该项目继承于2014年的django-cas(自2013年4月以来未更新).ng代表“下一代”

#### 环境说明
1. Django               3.1.2
2. django-cas-ng        4.1.1
3. Python               3.8.2

#### django-cas-ng安装及配置
- 安装
    ```bash
        pip3 install django-cas-ng
    ```
- 配置
    1. urls.py
        ```python
            import django_cas_ng.views

            urlpatterns = [
                ...
                url('^v1/login/$', django_cas_ng.views.LoginView.as_view(), name='cas_ng_login'),
                url('^v1/logout/$', django_cas_ng.views.LogoutView.as_view(), name='cas_ng_logout'),
            ]
        ```
    2. settings.py
        ```python
            INSTALLED_APPS = (
                # ... other installed apps
                'django_cas_ng',
            )
            
            AUTHENTICATION_BACKENDS = (
                'django.contrib.auth.backends.ModelBackend',
                'django_cas_ng.backends.CASBackend',
            )

            # CAS 的地址
            CAS_SERVER_URL = 'xxxxxxxxxx'
            # 重定向用户时要添加到登录URL的其他URL参数
            CAS_EXTRA_LOGIN_PARAMS = {'xx': 'xxxxx'}
            # 如果为False,则退出应用程序也不会使用户也退出CAS.默认值为True
            CAS_LOGOUT_COMPLETELY = True
            CAS_PROVIDE_URL_TO_LOGOUT = True
            # 登陆或者注销之后  跳转的地址
            CAS_REDIRECT_URL = 'xxxxxxxx'
            CAS_CHECK_NEXT = lambda _: True
            # 存入所有 CAS 服务端返回的 User 数据.
            CAS_APPLY_ATTRIBUTES_TO_USER = True
            CAS_AUTO_CREATE_USERS = True
        ```
- 创建对应的数据库
    ```bash
        python3.8 manage.py makemigrations
        python3.8 manage.py migrate
    ```



