---
title: Python_基础 (100)
date: 2021-07-26
tags: Python
toc: true
---

### 快来跟我一起学apscheduler
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之定时任务框架apscheduler

<!-- more -->

#### 触发器
- date触发器
    * date是最基本的一种调度, 作业任务只会执行一次.它表示特定的时间点触发
    * 参数
        * run_date (datetime 或 str): 作业的运行日期或时间
        * timezone (datetime.tzinfo 或 str): 指定时区
    * eg
        ```python
            from datetime import datetime
            from datetime import date
            from apscheduler.schedulers.background import BackgroundScheduler

            def job_func(text):
                print(text)

            scheduler = BackgroundScheduler()
            # 在 2021-07-26 时刻运行一次 job_func 方法
            scheduler .add_job(job_func, 'date', run_date=date(2021, 07, 26), args=['text'])
            # 在 2021-07-26 14:00:00 时刻运行一次 job_func 方法
            scheduler .add_job(job_func, 'date', run_date=datetime(2017, 07, 26, 14, 0, 0), args=['text'])
            # 在 2021-07-26 14:00:01 时刻运行一次 job_func 方法
            scheduler .add_job(job_func, 'date', run_date='2021-07-26 14:00:01', args=['text'])

            scheduler.start()
        ```
- interval触发器
    * 固定时间间隔触发
    * 参数
        * weeks (int): 间隔几周
        * days (int): 间隔几天
        * hours (int): 间隔几小时
        * minutes (int): 间隔几分钟
        * seconds (int): 间隔多少秒
        * start_date (datetime 或 str): 开始日期
        * end_date (datetime 或 str): 结束日期
        * timezone (datetime.tzinfo 或str): 时区
    * eg
        ```python
            import datetime
            from apscheduler.schedulers.background import BackgroundScheduler

            def job_func(text):
                print(datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3])

            scheduler = BackgroundScheduler()
            # 每隔两分钟执行一次 job_func 方法
            scheduler .add_job(job_func, 'interval', minutes=2)
            # 在 2021-07-26 14:00:01 ~ 2021-07-2614:00:10 之间, 每隔两分钟执行一次 job_func 方法
            scheduler .add_job(job_func, 'interval', minutes=2, start_date='2021-07-26 14:00:01' , end_date='2021-07-26 14:00:10')

            scheduler.start()
        ```
- cron触发器
    * 在特定时间周期性地触发, 和Linux crontab格式兼容.它是功能最强大的触发器
    * 参数
        * year (int 或 str): 年, 4位数字
        * month (int 或 str): 月 (范围1-12)
        * day (int 或 str): 日 (范围1-31
        * week (int 或 str): 周 (范围1-53)
        * day_of_week (int 或 str): 周内第几天或者星期几 (范围0-6 或者 mon,tue,wed,thu,fri,sat,sun)
        * hour (int 或 str): 时 (范围0-23)
        * minute (int 或 str): 分 (范围0-59)
        * second (int 或 str): 秒 (范围0-59)
        * start_date (datetime 或 str): 最早开始日期(包含)
        * end_date (datetime 或 str): 最晚结束时间(包含)
        * timezone (datetime.tzinfo 或str): 指定时区
    * eg
        ```python
            import datetime
            from apscheduler.schedulers.background import BackgroundScheduler

            def job_func(text):
                print("当前时间: ", datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3])

            scheduler = BackgroundScheduler()
            # 在每年 1-3、7-9 月份中的每个星期一、二中的 00:00, 01:00, 02:00 和 03:00 执行 job_func 任务
            scheduler .add_job(job_func, 'cron', month='1-3,7-9',day='0, tue', hour='0-3')

            scheduler.start()
        ```
