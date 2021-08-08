---
title: Python_基础 (101)
date: 2021-07-27
tags: Python
toc: true
---

### 快来跟我一起学apscheduler
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之定时任务框架apscheduler

<!-- more -->

#### 作业存储
- 添加job
    * func1
        ```python
            # add_job()返回一个 apscheduler.job.Job 的实例
            import datetime
            from apscheduler.schedulers.background import BackgroundScheduler

            def job_func(text):
                print("当前时间：", datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3])

            scheduler = BackgroundScheduler()
            # 在每年 1-3、7-9 月份中的每个星期一、二中的 00:00, 01:00, 02:00 和 03:00 执行 job_func 任务
            scheduler .add_job(job_func, 'cron', month='1-3,7-9',day='0, tue', hour='0-3')

            scheduler.start()
        ```
    * func2
        ```python
            import datetime
            from apscheduler.schedulers.background import BackgroundScheduler

            # 只适用于应用运行期间不会改变的 job
            @scheduler.scheduled_job(job_func, 'interval', minutes=2)
            def job_func(text):
                print(datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3])

            scheduler = BackgroundScheduler()
            scheduler.start()
        ```
- 移除job
    * func1
        ```python
            # remove_job()是根据job的id来移除, 所以要在job创建的时候指定一个id
            scheduler.add_job(job_func, 'interval', minutes=2, id='job_one')
            scheduler.remove_job(job_one)
        ```
    * func2
        ```python
            # job.remove()则是对job执行remove方法即可
            job = add_job(job_func, 'interval', minutes=2, id='job_one')
            job.remvoe()
        ```
- 获取job列表
    * 通过scheduler.get_jobs()方法能够获取当前调度器中的所有job的列表
- 修改job
    * job的id是无法被修改的
    * func1
        ```python
            scheduler.add_job(job_func, 'interval', minutes=2, id='job_one')
            scheduler.start()
            # 将触发时间间隔修改成 5分钟
            scheduler.modify_job('job_one', minutes=5)
        ```
    * func2
        ```python
            job = scheduler.add_job(job_func, 'interval', minutes=2)
            # 将触发时间间隔修改成 5分钟
            job.modify(minutes=5)
        ```
- 关闭job
    * 默认情况下调度器会等待所有正在运行的作业完成后, 关闭所有的调度器和作业存储.如果你不想等待, 可以将 wait 选项设置为 False.
    * eg
        ```python
            scheduler.shutdown()
            scheduler.shutdown(wait=false)
        ```

