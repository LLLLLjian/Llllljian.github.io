---
title: Python_基础 (63)
date: 2020-12-15
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    用uwsgi跑定时任务

<!-- more -->

#### 为什么要用uwsgi跑定时任务
> 用系统里面的crontab来跑的话任务成功或失败以及任务返回的结果都无法发送给程序,造成定时任务与程序的割裂,不方便进行控制.想要实现定时任务,必须要有一个daemon进程一直在后台运行,如果Python程序是用uwsgi启动的,使用uwsgi就可以实现

#### 具体实现方式
1. wsgi.py
    ```python
        import uwsgi

        # 将具体的cron job分到另一个文件中写,便于维护
        from cron_job import *

        for job_id, job in enumerate(jobs):
            uwsgi.register_signal(job_id, "", job['name'])
            if len(job['time']) == 1:
                # 每隔一定的秒数执行一次
                uwsgi.add_timer(job_id, job['time'][0])
            else:
                # 像Linux的crontab一样的时间格式,用-1代替’*’表示所有
                # uwsgi.add_cron(signal, minute, hour, day, month, weekday)
                uwsgi.add_cron(job_id, job['time'][0], job['time'][1], job['time'][2], job['time'][3], job['time'][4])
    ```
2. cron_job.py
    ```python
        import time

        def cron_print_time(signum):
            ISOTIMEFORMAT='%Y-%m-%d %X'
            print time.strftime(ISOTIMEFORMAT, time.localtime())

        def cron_print_hello(signum):
            print "hello"

        jobs = [ 
            {
                "name" : cron_print_time,
                "time": [0, 17, -1, -1, 1], #minute, hour, day, month, weekday, "-1" means "all",此例为每个周一的17：00
            },
            {
                "name" : cron_print_hello,
                "time": [2],  #每隔2秒
            },
        ]
    ```





