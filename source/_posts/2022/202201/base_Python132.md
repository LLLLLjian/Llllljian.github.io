---
title: Python_基础 (132)
date: 2022-01-17
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=mongoengine
    pymongo来操作mongodb数据库, 但是直接把数据库的操作代码写在脚本中, 使得应用代码的耦合性太强, 不利于代码的优化管理
    mongoengine是一个对象文档映射器(ODM), 相当于基于sql对象关系映射器(ORM)

<!-- more -->

#### 增
- func1
    ```python
        ross = User(
            email='ross@example.com',
            first_name='Ross',
            last_name='Lawley'
        ).save()
    ```
- func2
    ```python
        ross = User(email='ross@example.com')
        ross.first_name = 'Ross'
        ross.last_name = 'Lawley'
        ross.save()
    ```

#### 删除
- func
    ```python
        # 查可以先看后边的
        ross = User.objects(first_name='Ross')
        ross.delete()
    ```




