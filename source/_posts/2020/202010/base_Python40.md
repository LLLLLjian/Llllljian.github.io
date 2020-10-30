---
title: Python_基础 (40)
date: 2020-10-26
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    快来跟我一起学Django！！！

<!-- more -->

#### Django简介
- 基本介绍
    > Django 是一个由 Python 编写的一个开放源代码的 Web 应用框架。使用 Django，只要很少的代码，Python 的程序开发人员就可以轻松地完成一个正式网站所需要的大部分内容，并进一步开发出全功能的 Web服务. Django 本身基于 MVC 模型，即 Model（模型）+ View（视图）+ Controller（控制器）设计模式，MVC 模式使后续对程序的修改和扩展简化，并且使程序某一部分的重复利用成为可能
    * MVC 优势：
        * 低耦合
        * 开发快捷
        * 部署方便
        * 可重用性高
        * 维护成本低
    * 特点
        * 强大的数据库功能
        * 自带强大的后台功能
        * 优雅的网址
- MVC
    * 模型（M）- 编写程序应有的功能，负责业务对象与数据库的映射(ORM)
    * 视图（V）- 图形界面，负责与用户的交互(页面)
    * 控制器（C）- 负责转发请求，对请求进行处理
    ![MVC](/img/20201026_1.png)
- MTC
    * M 表示模型（Model）：编写程序应有的功能，负责业务对象与数据库的映射(ORM)
    * T 表示模板 (Template)：负责如何把页面(html)展示给用户
    * V 表示视图（View）：负责业务逻辑，并在适当时候调用 Model和 Template
    ![MTC](/img/20201026_2.png)
    * 解析：
        * 用户通过浏览器向我们的服务器发起一个请求(request)，这个请求会去访问视图函数：
        * a.如果不涉及到数据调用，那么这个时候视图函数直接返回一个模板也就是一个网页给用户。
        * b.如果涉及到数据调用，那么视图函数调用模型，模型去数据库查找数据，然后逐级返回。
        * 视图函数把返回的数据填充到模板中空格中，最后返回网页给用户。

#### Django安装
> 网上教程很多, 这里就不具体列操作流程了

#### Django创建第一个项目
> 版本说明：
    Python 3.8.2
    Django 3.1.2
- Django管理工具
    * 安装成功之后可以使用django-admin.py进行创建项目
- 创建第一个项目
    ```bash
        django-admin.py startproject testLocalHost

        $ tree
        .
        |____testLocalHost
        | |______init__.py
        | |____settings.py
        | |____urls.py
        | |____wsgi.py
        |____db.sqlite3
        |____manage.py
    ```
- 目录说明
    * HelloWorld: 项目的容器。
    * manage.py: 一个实用的命令行工具，可让你以各种方式与该 Django 项目进行交互。
    * HelloWorld/__init__.py: 一个空文件，告诉 Python 该目录是一个 Python 包。
    * HelloWorld/asgi.py: 一个 ASGI 兼容的 Web 服务器的入口，以便运行你的项目。
    * HelloWorld/settings.py: 该 Django 项目的设置/配置。
    * HelloWorld/urls.py: 该 Django 项目的 URL 声明; 一份由 Django 驱动的网站"目录"。
    * HelloWorld/wsgi.py: 一个 WSGI 兼容的 Web 服务器的入口，以便运行你的项目。
- 组织架构
    ![组织架构](/img/20201026_3.png)
- 常用命令
    ```bash
        django-admin.py startproject sitename  (创建一个名为sitename的Django程序)
        python manage.py runserver ip:port  (启动服务器，默认ip和端口为http://127.0.0.1:8000/)
        python manage.py startapp appname  (新建 app)
        python manage.py syncdb  (同步数据库命令，Django 1.7及以上版本需要用以下的命令）
        python manage.py makemigrations  (显示并记录所有数据的改动)
        python manage.py migrate  (将改动更新到数据库)
        python manage.py createsuperuser  (创建超级管理员)
        python manage.py dbshell  (数据库命令行)
        python manage.py  (查看命令列表)
    ```
- 生命周期
    ![生命周期](/img/20201026_4.png)
- 请求步骤：
    1. 用户通过浏览器请求一个页面
    2. 请求到达Request Middlewares，中间件对request做一些预处理或者直接response请求
    3. URLConf通过urls.py文件和请求的URL找到相应的View
    4. View Middlewares被访问，它同样可以对request做一些处理或者直接返回response 
    5. 调用View中的函数
    6. View中的方法可以选择性的通过Models访问底层的数据
    7. 所有的Model-to-DB的交互都是通过manager完成的
    8. 如果需要，Views可以使用一个特殊的Context
    9. Context被传给Template用来生成页面
        * Template使用Filters和Tags去渲染输出
        * 输出被返回到View
        * HTTPResponse被发送到Response Middlewares
        * 任何Response Middlewares都可以丰富response或者返回一个完全不同的response 
        * Response返回到浏览器，呈现给用户


