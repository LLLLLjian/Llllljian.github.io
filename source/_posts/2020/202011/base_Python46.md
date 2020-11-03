---
title: Python_基础 (46)
date: 2020-11-03
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    Django + Django-rest-framework小例子

<!-- more -->

#### 要实现的功能
> 使用DRF(Django-rest-framework)实现api接口的增删改查
- 步骤
    1. 安装django 我这里已经安装好了
    2. 创建django项目
    3. 添加博客的Model,  并添加一些初始数据
    4. 使用restframework来添加serializer、viewset、urls

#### 源码部分
- 创建项目和app
    ```bash
        django-admin startproject backend
        cd backend/
        python3 manage.py startapp blog
    ```
- backend/blog/models.py
    ```python
        from django.db import models


        # Create your models here.
        class Blog(models.Model):
            title = models.CharField(max_length=50)
            content = models.CharField(max_length=500)

            class Meta:
                db_table = "t_blog"
    ```
- backend/blog/views.py
    ```python
        from rest_framework import viewsets
        from .models import Blog
        from .serializers import BlogSerializer


        class BlogViewSet(viewsets.ModelViewSet):
            queryset = Blog.objects.all()
            serializer_class = BlogSerializer
    ```
- backend/blog/serializers.py
    ```python
        from rest_framework import serializers
        from .models import Blog


        class BlogSerializer(serializers.HyperlinkedModelSerializer):
            class Meta:
                model = Blog
                extra_kwargs = {
                    "title": {
                        "error_messages": {
                            "required": "标题必须填写",
                            "max_length": "小于50个字符"
                            }
                        },
                    "content": {
                        "error_messages": {
                            "required": "内容必须填写",
                            "max_length": "小于500个字符"
                            }
                        },
                }
                fields = ['id', 'url', 'title', 'content']
    ```
- baclend/backend/urls.py
    ```python
        from django.urls import path, include
        from rest_framework import routers
        from blog.views import BlogViewSet


        router = routers.DefaultRouter()
        router.register('blog', BlogViewSet)

        urlpatterns = [
            path('api/', include(router.urls)),
        ]
    ```
- backend/backend/__init__.py
    ```python
        import pymysql
        pymysql.version_info = (1, 4, 13, "final", 0)
        pymysql.install_as_MySQLdb()
    ```

#### 实现效果图
- 增
    ![增](/img/20201103_1.png)
- 删
    ![删](/img/20201103_2.png)
- 改
    ![改](/img/20201103_3.png)
- 查
    ![查](/img/20201103_4.png)
