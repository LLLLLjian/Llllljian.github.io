---
title: Python_基础 (98)
date: 2021-07-22
tags: Python
toc: true
---

### 快来跟我一起学apscheduler
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之定时任务框架apscheduler

<!-- more -->

#### 调度示例
- eg
    ```python
        # -*- coding: UTF-8 -*-
        import json
        import time
        from pymongo import MongoClient
        from apscheduler.schedulers.background import BackgroundScheduler
        from apscheduler.jobstores.mongodb import MongoDBJobStore
        from apscheduler.executors.pool import ThreadPoolExecutor
        from apscheduler.events import EVENT_JOB_EXECUTED, EVENT_JOB_ERROR, EVENT_JOB_MISSED, EVENT_JOB_SUBMITTED
        from apscheduler.events import EVENT_JOB_MAX_INSTANCES
        from apscheduler.events import JobSubmissionEvent, JobExecutionEvent

        def callback_listener(event):
            """
            # 接收相关的事件，并完成响应的处理任务
            :param event:
            :return:
            """
            job_name = str(event.job_id)
            if isinstance(event, JobSubmissionEvent):
                # 作业被提交, 开始计算
                start_time = event.scheduled_run_times
                logger.info("submit, job_name: %s, start_time: %s" % (job_name, start_time))
            elif isinstance(event, JobExecutionEvent):
                if event.exception:
                    # 作业执行失败了
                    exceptions_info = str(event.exception)
                    trackback_info = str(event.traceback)
                    logger.info("execute failed, job_name: %s, exceptions_info: %s, trackback_info: %s" % (
                        job_name, exceptions_info, trackback_info
                    ))
                    status = "fail"
                else:
                    # 作业执行成功
                    logger.info("execute down, job_name: %s" % job_name)
                    status = "success"
                    exceptions_info = ""
                    trackback_info = ""


        def max_instance_callback_listener(event):
            """
            # 当任务重复提交时
            :param event:
            :return:
            """
            logger.error("events: %s is running and maybe hang out, new task can't start" % str(event.job_id))


        def get_mongodb():
            """
            通过pymongo方式连接数据库
            :return: assessDB对象
            """
            mongodb_str = "mongodb://127.0.0.1:8836"
            while True:
                try:
                    mongodb_client = MongoClient(mongodb_str)
                    if mongodb_client:
                        break
                    else:
                        time.sleep(1)
                except Exception as e:
                    time.sleep(1)
            return mongodb_client


        if __name__ == '__main__':
            jobstores = {
                'default': MongoDBJobStore(
                    # database (str) 用于存储作业的数据库
                    # collection (str) 要在其中存储作业的集
                    # client MongoClient实例
                    client=get_mongodb()
                )
            }
            executors = {
                # 线程池执行器 生成的线程的最大数量20个
                'default': ThreadPoolExecutor(20)
            }
            job_defaults = {
                # coalesce：累计的任务是否执行。True不执行，False,执行。同上，由于某种原因，比如进场挂了，导致任务多次没有调用，则前几次的累计任务的任务是否执行的策略
                # max_instances：同一个任务在线程池中最多跑的实例数。
                'coalesce': True
            }
            # BackgroundScheduler 调用start后主线程不会阻塞。当你不运行任何其他框架时使用，并希望调度器在你应用的后台执行
            scheduler = BackgroundScheduler(
                jobstores=jobstores,
                executors=executors,
                job_defaults=job_defaults,
                timezone="Asia/Shanghai"
            )
            # add_job(func, trigger=None, args=None, kwargs=None, id=None, name=None, misfire_grace_time=undefined, coalesce=undefined, max_instances=undefined, next_run_time=undefined, jobstore='default', executor='default', replace_existing=False, **trigger_args)
            # 每10分钟执行一次func1
            scheduler.add_job(
                # 方法名
                func1,
                # 触发的时间间隔
                'interval',
                seconds=60 * 10,
                # 作业的显式标识符(用于以后修改)
                id="func1",
                # 当出现相同id时替换当前job
                replace_existing=True
            )
            # 每5分钟执行一次fun2
            scheduler.add_job(
                func2,
                'interval',
                seconds=60 * 5,
                id="func2",
                replace_existing=True
            )
            # 每10s执行一次func3
            scheduler.add_job(
                func3,
                'interval',
                seconds=10,
                id="func3",
                replace_existing=True
            )
            # 每天下午2点执行一次func4
            scheduler.add_job(
                func4,
                # 使用crontab式的定时方式
                trigger="cron",
                hour="14",
                id="func4",
                replace_existing=True
            )
            # 每小时40分的时候执行一次func5
            scheduler.add_job(
                func5,
                trigger="cron",
                minute="40",
                id="func5",
                replace_existing=True
            )
            logger.info("cron scheduler starting, Ctrl + C can break!")

            # EVENT_JOB_EXECUTED(JobExecutionEvent) 作业已成功执行
            # EVENT_JOB_ERROR(JobExecutionEvent) 作业在执行期间引发异常
            # EVENT_JOB_MISSED(JobExecutionEvent) 错过了一项工作的执行
            # EVENT_JOB_SUBMITTED(JobSubmissionEvent) 作业已提交给其执行器以运行
            # add_listener(callback, mask=EVENT_ALL)
            # add_listener 事件监听器, 监听到状态码的时候就触发回调函数, mask支持或形式，默认就是EVENT_ALL(所有事件)
            scheduler.add_listener(
                callback_listener,
                EVENT_JOB_EXECUTED | EVENT_JOB_ERROR | EVENT_JOB_MISSED | EVENT_JOB_SUBMITTED
            )

            # EVENT_JOB_MAX_INSTANCES(JobSubmissionEvent) 提交给其执行器的作业未被执行器接受，因为该作业已达到其最大并发执行实例数
            scheduler.add_listener(
                max_instance_callback_listener,
                EVENT_JOB_MAX_INSTANCES
            )
            # 启动 scheduler
            scheduler.start()
    ```







