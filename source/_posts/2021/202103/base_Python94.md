---
title: Python_基础 (94)
date: 2021-03-29
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    Django之ORM

<!-- more -->

#### 前情提要
> 因为操作ORM的时候要用到或(or), 但是我不知道怎么写就查了一下

#### orm的Q功能
> 在filter里面的条件之间是and的关系, 这里也可以用Q
- eg
    ```python
        from django.db.models import Q
        models.Uinfo.objects.all().filter(Q(id=1)) # 条件是id为1的时候
        models.Uinfo.objects.all().filter(Q(id=1) | Q(id__gt=3)) # 条件是或的关系
        models.Uinfo.objects.all().filter(Q(id=1) & Q(id=4)) # 条件是and的关系
    ```

#### orm的F功能
> 假设数据库有一个员工表, 表中的年龄都自加“1”, 这里就需要到orm的F功能
- eg
    ```python
        from django.db.models import F#首先要导入这个F模块
        models.Uinfo.objects.all().update(age=F("age")+1)#这里的F功能后面的age, 它就会让数据表表中的age这列+1
    ```

#### 执行原生SQL
- eg
    ```python
        # 执行原生SQL
        from django.db import connection, connections
        cursor = connection.cursor()  # cursor = connections['default'].cursor()default 是django里面的数据库配置的default, 也可以取别的值
        cursor.execute("""SELECT * from auth_user where id = %s""", [1])
        row = cursor.fetchone()
    ```

#### 批量新增
- eg
    ```python
        logupload_list_to_insert = list()
        for file_name in file_names:
            logupload_list_to_insert.append(
                models.LogUpload(
                    upload_date=upload_date,
                    project=project_info,
                    module=module_info,
                    cluster=cluster_info,
                    file_name=file_name
                )
            )

        models.LogUpload.objects.bulk_create(logupload_list_to_insert)
    ```
