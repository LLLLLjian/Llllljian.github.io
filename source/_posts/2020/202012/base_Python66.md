---
title: Python_基础 (66)
date: 2020-12-18
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    在django项目中单独运行某个python文件

<!-- more -->

#### 使用场景
> 我希望直接通过运行python文件来实现定时任务的时候发现运行报错, 因为我倒入了django相关的类, 所以我需要在运行该文件之前应该先加载django的配置

#### demo1
- 该文件和manage.py不在同一级
    ```python
        import sys
        import os
        import django

        # 这两行很重要,用来寻找项目根目录,os.path.dirname要写多少个根据要运行的python文件到根目录的层数决定
        BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        sys.path.append(BASE_DIR)

        os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myapp.settings')
        django.setup()

        from myapp.models import Person

        if __name__ == "__main__":
            all =Person.objects.all().values()
            print(all)
    ```

#### demo2
- 该文件和manage.py在同一级
    ```python
        import os
        import django

        os.environ.setdefault("DJANGO_SETTINGS_MODULE", "myapp.settings")  # NoQA
        django.setup()

        from myapp.models import Person

        if __name__ == "__main__":
            all =Person.objects.all().values()
            print(all)
    ```


