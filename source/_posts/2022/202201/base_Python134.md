---
title: Python_基础 (134)
date: 2022-01-19
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=mongoengine
    pymongo来操作mongodb数据库, 但是直接把数据库的操作代码写在脚本中, 使得应用代码的耦合性太强, 不利于代码的优化管理
    mongoengine是一个对象文档映射器(ODM), 相当于基于sql对象关系映射器(ORM)

<!-- more -->

#### 改
- 修改符
    * set – set a particular value, 设置某个值
    * unset – delete a particular value (since MongoDB v1.3), 删除某个值
    * inc – increment a value by a given amount, 增加
    * dec – decrement a value by a given amount, 减少
    * push – append a value to a list, 增加列表一个值
    * push_all – append several values to a list, 增加列表多个值(传入一个列表)
    * pop – remove the first or last element of a list depending on the value, 取出一个列表最前或最后的值
    * pull – remove a value from a list, 删除一个列表的值
    * pull_all – remove several values from a list, 删除一个列表多个值
    * add_to_set – add value to a list only if its not in the list already, 加入列表一个值, 如果它之前不在其中.
- 更新
    ```python
        # 修改符和检索操作符用法差不多, 只是他们在域名之前, 如果没有指定修改符, 那么默认是set
        post = BlogPost(title='Test', page_views=0, tags=['database'])
        post.save()
        BlogPost.objects(id=post.id).update_one(inc__page_views=1)
        # 发生变化, 重新加载
        post.reload()
        print(post.page_views)
        # 1
        BlogPost.objects(id=post.id).update_one(set__title='Example Post')
        # 和上边语句执行的效果是一样的
        # BlogPost.objects(id=post.id).update_one(title='Example Post')
        post.reload()
        print(post.title)
        # 'Example Post'
        BlogPost.objects(id=post.id).update_one(push__tags='nosql')
        post.reload()
        print(post.tags)
        # ['database', 'nosql']
        # 不存在就新增(只有新增的时候才设置createtime), 存在就更新
        models.User.objects(
            query_username="aa"
        ).update_one(
            set_on_insert__createtime=int(time.time()),
            set__updatetime=int(time.time()),
            set__userinfo=result,
            upsert=True
        )
    ```






