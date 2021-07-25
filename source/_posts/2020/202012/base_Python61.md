---
title: Python_基础 (61)
date: 2020-12-11
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    django的crontab

<!-- more -->

#### 先说说我要干什么
> 后台任务脚本定时去做一些定时的事, 我刚开始打算写crontab去定时, 后来查了一下 发现django中有类似的三方类库可以帮我快速去做完这件事, 学习一下

#### django-crontab

##### 安装
    ```bash
        pip install django-crontab
    ```

##### 加入
    ```python
        # setting.py
        INSTALLED_APPS = (
            ...
            'django-crontab',
            ...
        )
    ```

##### 配置
1. 定时任务时间设置
    * 同crontab
    ```python
        # setting.py
        CRONJOBS = (
            # * * * * *
            # 分 时 日 月 周      命令
            # M: 分钟(0-59)每分钟用*或者 */1表示
            # H：小时(0-23)(0表示0点)
            # D：天(1-31)
            # m: 月(1-12)
            # d: 一星期内的天(0~6,0为星期天)

            # 初级模式
            # 每五分钟执行一次my_scheduled_job这个程序
            ('*/5 * * * *', 'myproject.myapp.cron.my_scheduled_job'),
        
            # 中级模式
            # 将程序my_scheduled_job的结果输出到文件/tmp/last_scheduled_job.log中
            ('0   0 1 * *', 'myproject.myapp.cron.my_scheduled_job', '> /tmp/last_scheduled_job.log'),
        
            #高级模式
            # ['dumpdata', 'auth']和{'indent': 4}都是参数,只是[]中的参数是按照顺序代入,而{}中的参数指定了变量名称,最后一个也是输出结果的后缀
            ('0   0 * * 0', 'django.core.management.call_command', ['dumpdata', 'auth'], {'indent': 4}, '> /home/john/backups/last_sunday_auth_backup.json'),
        )
    ```

##### 开启定时任务
1. 添加定时任务到系统中
    ```bash
        python manage.py crontab add
    ```
2. 显示已经激活的定时任务
    ```bash
        python manage.py crontab show
    ```
3. 移除定时任务
    ```bash
        python manage.py crontab remove
    ```
4. 查看定时任务是否设置成功
    ```bash
        crontab -l
    ```

