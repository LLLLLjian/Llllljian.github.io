---
title: Python_基础 (125)
date: 2021-12-07
tags: Python
toc: true
---

### django主从
    Django的主从再看一下

<!-- more -->

#### 前情提要
> 测试上已经把django-apscheduler稳定运行了两天了,结果今天上正式出问题了.排查了一下 出现问题的原因是 测试环境主从我设置的是同一个数据库,不会有主从延迟的问题,但是线上数据库用的是一主两从,apscheduler的job任务被调度之后写到主库马上去从库查就会有延迟,数据库就直接报错了,所以这里要设置一下 一旦查的是apscheduler相关的表的话 默认强制走主库
- 读写分离
    * 手动设置主库查询
        ```python
            data = models.Class.objects.using('default').all()
        ```
    * 配置自动
        ```python
            # router.py
            class Router:
            # 读操作用从库1/从库2
            def db_for_read(self,model,**kwargs):
                return random.choice(['salve1', 'salve2'])

            # 写操作用主库
            def db_for_write(self,model,**kwargs):
                return 'default'

            # setting.py
            DATABASE_ROUTERS = ['app01.router.Router',]
        ```
    * 不同的应用/不同的表选择不同的数据库
        ```python
            import random
            import json
            class Router:
                def db_for_read(self, model, **kwargs):
                    print(json.dumps(model, indent=4, ensure_ascii=False))
                    # 其中有个_meta属性很有用
                    print(json.dumps(dir(model), indent=4, ensure_ascii=False))
                    # 获取当前model对象所在的应用名称
                    a = model._meta.app_label
                    # 获取当前操作的model对象的表名,也可以根据表名来进行多数据库读的分配
                    m = model._meta.model_name
                    # 可以根据应用选择不用的库来进行读取
                    if a == 'app01':
                        return 'db1'
                    elif a == 'app02':
                        return 'db2'
                    if m == "user":
                        return 'default'
                    return random.choice(['db1','db2','db3'])

                def db_for_write(self,model,**kwargs):
                    return 'default'
        ```
- 插曲
    * 如何格式化dict并输出
    ```python
        import json

        dict = {'Infomation': '成绩单',
                'Students': [{'Name': '小明', 'Age': 22, 'Grade': {'Chinese': 80, 'Math': 100, 'English': 90}},
                            {'Name': '小红', 'Age': 21, 'Grade': {'Chinese': 70, 'Math': 90, 'English': 80}}]}
        # 缩进4空格,中文字符不转义成Unicode
        print(json.dumps(dict, indent=4, ensure_ascii=False))

        {
            "Infomation": "成绩单",
            "Students": [
                {
                    "Name": "小明",
                    "Age": 22,
                    "Grade": {
                        "Chinese": 80,
                        "Math": 100,
                        "English": 90
                    }
                },
                {
                    "Name": "小红",
                    "Age": 21,
                    "Grade": {
                        "Chinese": 70,
                        "Math": 90,
                        "English": 80
                    }
                }
            ]
        }
    ```
