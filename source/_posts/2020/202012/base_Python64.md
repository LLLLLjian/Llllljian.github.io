---
title: Python_基础 (64)
date: 2020-12-16
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    记录一下我们的实现方式

<!-- more -->

#### 实现方式
1. urls.py
    ```python
        ...
        # 后台任务
        import crontab.backend_task
        ...
    ```
2. crontab.backend_task.py
    ```python
        import threading
        import time
        import sys
        import os

        def func1():
            while True:
                # 每五分钟执行一次
                do...
                time.sleep(300)
        
        def func2():
            # 取一下当前时间戳 然后判断一下当前时间戳到运行的时间还有多少秒就sleep多少秒
            while True:
                # 获取当前时间戳
                now_timestamp = int(time.time())
                # 要执行时间点的时间戳
                deal_date = time.strftime("%Y-%m-%d 23:00:00")
                deal_timestamp = int(time.mktime(time.strptime(deal_date, "%Y-%m-%d %H:%M:%S")))
                diff_timestamp = deal_timestamp - now_timestamp
                if (diff_timestamp > 0):
                    time.sleep(diff_timestamp)
                else:
                    time.sleep(diff_timestamp + 86400)

                do...


        def backend_task():
            """
            周期性任务启动线程
            """
            th = threading.Thread(target=func1)
            th.setDaemon(True)
            th.start()

            th = threading.Thread(target=func2)
            th.setDaemon(True)
            th.start()


        backend_task()
    ```




