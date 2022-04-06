---
title: Python_基础 (118)
date: 2021-08-25
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### 与Django对比
- 快速介绍
    * Django是一个Python Web框架, 适合时间不多的完美主义者.Django提供了一个功能齐全的Model-View-Controller框架.Django使开发人员无需第三方库和工具即可创建网站.Django于2005年7月15日发布, 由Django Software Foundation(DSF)开发和管理.它是免费的并且具有更多版本的开源.
    * Flask是基于Python的微框架 .Flask是由奥地利开发商Armin Ronacher于2010年4月1日发布的.微框架意味着Flask旨在保持其重量轻和简单但仍然可以进行高度扩展.Flask的真正力量在于它非常灵活.
- 形象类比
    * Django类似于精装修的房子, 自带豪华家具、非常齐全功能强大的家电, 什么都有了, 拎包入住即可, 十分方便
    ![Django](/img/20210825_1.png)
    * Flask类似于毛坯房, 自己想把房子装修成什么样自己找材料, 买家具自己装.材料和家具种类非常丰富, 并且都是现成免费的, 直接拿过去用即可
    ![Flask](/img/20210825_2.png)
- 用户灵活性
    * Django 可在不使用太多第三方库和工具的条件下开发各种优秀的Web应用程序.但是, Django缺少部分对模块优化的空间.因此, 开发人员使用内置功能创建Web应用程序.这意味着如果开发人员想要修改Django一些默认的设定或者规则, 这将不容易.
    * Flask是一个扩展性很好的Web框架, 可以使用各种Web开发库和工具来灵活地开发Web应用程序.对于经验丰富的开发人员可以自由地插入和使用他们喜欢的库和数据库. 框架很少会强制开发人员使用什么.相反, 开发人员可以转到自己喜欢的技术栈中.
- 在体量上的区别
    * Django
        * 大而全, 功能极其强大, 是Python web框架的先驱, 用户多, 第三方库极其丰富.
        * 非常适合企业级网站的开发, 但是对于小型的微服务来说, 总有“杀鸡焉有宰牛刀”的感觉, 体量较大, 非常臃肿, 定制化程度没有Flask高, 也没有Flask那么灵活.
    * Flask
        * 小巧、灵活, 让程序员自己决定定制哪些功能, 非常适用于小型网站.
        * 对于普通的工人来说将毛坯房装修为城市综合体还是很麻烦的, 使用Flask来开发大型网站也一样, 开发的难度较大, 代码架构需要自己设计, 开发成本取决于开发者的能力和经验.
- 在实际工作中如何选择这两个框架呢
    * 如果你想搞懂Python web开发WSGI协议原理以及实现过程、或者你想灵活定制组件, 完全DIY你的应用、想实现微服务, 那么建议你选择Flask.
    * 如果你关注产品的最终交付、想快速开发一个大的应用系统(比如新闻类网站、商城、ERP等), 那么建议你选择Django, 你想得到的功能它都有, 想不到的功能它也有.
- 两种框架实现helloWorld
    * Django
        ```bash
            $ pip install django
            $ django-admin startproject myproject
            $ python manage.py startapp myapp
            $ cat views.py
            from django.http import HttpResponse

            def index(request):
                return HttpResponse("Hello World!!")
            $ cat urls.py
            from django.conf.urls import url
            from . import views

            urlpatterns = [
                url(r"^$", views.index, name="index")
            ] 
        ```
    * Flask
        ```bash
            $ pip install flask
            $ cat hello.py
            from flask import Flask

            app = Flask(__name__)

            @app.route("/")
            def hello():
                return "Hello World!"

            if __name__ == "__main__":
                app.run()
        ```
- 总结
    * Flask提供了灵活性, 简单性和细粒度的控制.
    * Flask不受限制, 让你决定如何实现应用程序.
    * Django为你的Web应用程序开发提供了管理面板, 数据库界面, 目录结构和ORM的全方位体验.




