---
title: Python_基础 (131)
date: 2022-01-14
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=mongoengine
    pymongo来操作mongodb数据库, 但是直接把数据库的操作代码写在脚本中, 使得应用代码的耦合性太强, 不利于代码的优化管理
    mongoengine是一个对象文档映射器(ODM), 相当于基于sql对象关系映射器(ORM)

<!-- more -->

#### model设置
- code
    ```python
        class User(Document):
            name = StringField()
            is_admin = BooleanField()

            meta = {
                # 可以自己定义, 默认就是定义的类的缩写加下划线
                'collection': 'YourDocument',
                # 限制文档的数量/大小
                'max_documents': 1000,
                'max_size': 2000000,
                # 指定文档的默认排序方式, 优先级低于order_by
                'ordering': ['-published_date'],
                # 创建索引
                'index_background': True, # 后台创建索引(如果不设置这个话, 就会马上创建索引, 表很大的时候就需要耗费很长时间, 生成索引的过程中表会被锁住, 从而导致该表无法提供服务, 严重的话会导致线上服务崩溃)
                "indexes": [
                    'user_id', # 单列索引
                    [('dt', 1), ('user_id', 1)], # dt,user_id的复合索引, 每个字段都采取升序(升序为1, 降序为-1)
                ]
            }

            # 定义默认的搜索条件(不推荐)
            @queryset_manager
            def objects(doc_cls, queryset):
                # 修改排序
                return queryset.order_by('-date')

            # 自定义 BlogPost.live_posts()
            @queryset_manager
            def get_admin(doc_cls, queryset):
                return queryset.filter(is_admin=True)
    ```





