---
title: Python_基础 (99)
date: 2021-07-23
tags: Python
toc: true
---

### 快来跟我一起学apscheduler
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之定时任务框架apscheduler

<!-- more -->

#### 调度器
- 调度器配置方式
    * way1
        ```python
            from pytz import utc

            from apscheduler.schedulers.background import BackgroundScheduler
            from apscheduler.jobstores.mongodb import MongoDBJobStore
            from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
            from apscheduler.executors.pool import ThreadPoolExecutor, ProcessPoolExecutor


            jobstores = {
                'mongo': MongoDBJobStore(),
                'default': SQLAlchemyJobStore(url='sqlite:///jobs.sqlite')
            }
            executors = {
                'default': ThreadPoolExecutor(20),
                'processpool': ProcessPoolExecutor(5)
            }
            job_defaults = {
                'coalesce': False,
                'max_instances': 3
            }
            scheduler = BackgroundScheduler(
                jobstores=jobstores,
                executors=executors,
                job_defaults=job_defaults,
                timezone=utc
            )
        ```
    * way2
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler


            # The "apscheduler." prefix is hard coded
            scheduler = BackgroundScheduler({
                'apscheduler.jobstores.mongo': {
                    'type': 'mongodb'
                },
                'apscheduler.jobstores.default': {
                    'type': 'sqlalchemy',
                    'url': 'sqlite:///jobs.sqlite'
                },
                'apscheduler.executors.default': {
                    'class': 'apscheduler.executors.pool:ThreadPoolExecutor',
                    'max_workers': '20'
                },
                'apscheduler.executors.processpool': {
                    'type': 'processpool',
                    'max_workers': '5'
                },
                'apscheduler.job_defaults.coalesce': 'false',
                'apscheduler.job_defaults.max_instances': '3',
                'apscheduler.timezone': 'UTC',
            })
        ```
    * way3
        ```python
            from pytz import utc

            from apscheduler.schedulers.background import BackgroundScheduler
            from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
            from apscheduler.executors.pool import ProcessPoolExecutor


            jobstores = {
                'mongo': {'type': 'mongodb'},
                'default': SQLAlchemyJobStore(url='sqlite:///jobs.sqlite')
            }
            executors = {
                'default': {'type': 'threadpool', 'max_workers': 20},
                'processpool': ProcessPoolExecutor(max_workers=5)
            }
            job_defaults = {
                'coalesce': False,
                'max_instances': 3
            }
            scheduler = BackgroundScheduler()

            # ..这里可以添加任务

            scheduler.configure(
                jobstores=jobstores,
                executors=executors,
                job_defaults=job_defaults,
                timezone=utc
            )
        ```
- 调度器类型
    * BlockingScheduler : 调度器在当前进程的主线程中运行, 也就是会阻塞当前线程.
    * BackgroundScheduler : 调度器在后台线程中运行, 不会阻塞当前线程.
    * AsyncIOScheduler : 结合 asyncio 模块(一个异步框架)一起使用.
    * GeventScheduler : 程序中使用 gevent(高性能的Python并发框架)作为IO模型, 和 GeventExecutor 配合使用.
    * TornadoScheduler : 程序中使用 Tornado(一个web框架)的IO模型, 用 ioloop.add_timeout 完成定时唤醒.
    * TwistedScheduler : 配合 TwistedExecutor, 用 reactor.callLater 完成定时唤醒.
    * QtScheduler : 你的应用是一个 Qt 应用, 需使用QTimer完成定时唤醒.
    * 主要区分一下BackgroundScheduler和BlockingScheduler
        * 区别主要在于BlockingScheduler会阻塞主线程的运行, 而BackgroundScheduler不会阻塞
        * BlockingScheduler: 调用start函数后会阻塞当前线程.当调度器是你应用中唯一要运行的东西时(如上例)使用.
        * BackgroundScheduler: 调用start后主线程不会阻塞.当你不运行任何其他框架时使用, 并希望调度器在你应用的后台执行.
        ```python
            from apscheduler.schedulers.blocking import BlockingScheduler
            import time

            def job():
                print('job 3s')


            if __name__=='__main__':

                sched = BlockingScheduler(timezone='MST')
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()

                while(True):
                    print('main 1s')
                    time.sleep(1)

            # 输出结果
            # job 3s
            # job 3s
            # job 3s
            # job 3s
            # 结果分析
            # BlockingScheduler调用start函数后会阻塞当前线程, 导致主程序中while循环不会被执行到
        ```
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time

            def job():
                print('job 3s')


            if __name__=='__main__':

                sched = BackgroundScheduler(timezone='MST')
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()

                while(True):
                    print('main 1s')
                    time.sleep(1)
            
            # 输出结果
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # main 1s
            # 结论
            # BackgroundScheduler调用start函数后并不会阻塞当前线程, 所以可以继续执行主程序中while循环的逻辑
            # 调用start函数后, job()并不会立即开始执行.而是等待3s后, 才会被调度执行
        ```
- 如果job执行时间过长会怎么样
    * Q: 如果执行job()的时间需要5s, 但调度器配置为每隔3s就调用一下job()
    * demo
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time


            def job():
                print('job 3s')
                time.sleep(5)


            if __name__ == '__main__':

                sched = BackgroundScheduler(timezone='MST')
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()

                while(True):
                    print('main 1s')
                    time.sleep(1)

            # 输出结果
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # main 1s
            # main 1s
            # main 1s
            # Execution of job "job (trigger: interval[0:00:03], next run at: 2018-05-07 02:44:29 MST)" skipped: maximum number of running instances reached (1)
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # main 1s
            # 结果分析
            # 3s时间到达后, 并不会“重新启动一个job线程”, 而是会跳过该次调度, 等到下一个周期(再等待3s), 又重新调度job().
        ```
    * demo1
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time

            def job():
                print('job 3s')
                time.sleep(5)

            if __name__=='__main__':
                job_defaults = { 'max_instances': 2 }
                sched = BackgroundScheduler(timezone='MST', job_defaults=job_defaults)
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()

                while(True):
                    print('main 1s')
                    time.sleep(1)

            # 输出结果
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # main 1s
            # main 1s
            # main 1s
            # job 3s
            # 结果分析
            # max_instances设置为2, 允许2个job()同时运行
        ```
- 每个job是怎么被调度的
    * 先说结论: job()最终是以线程的方式被调度执行
    * prove
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time,os,threading

            def job():
                print('job thread_id-{0}, process_id-{1}'.format(threading.get_ident(), os.getpid()))
                time.sleep(50)

            if __name__=='__main__':
                job_defaults = { 'max_instances': 20 }
                sched = BackgroundScheduler(timezone='MST', job_defaults=job_defaults)
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()

                while(True):
                    print('main 1s')
                    time.sleep(1)

            # 输出结果
            # main 1s
            # main 1s
            # main 1s
            # job thread_id-10644, process_id-8872
            # main 1s
            # main 1s
            # main 1s
            # job thread_id-3024, process_id-8872
            # main 1s
            # main 1s
            # main 1s
            # job thread_id-6728, process_id-8872
            # main 1s
            # main 1s
            # main 1s
            # job thread_id-11716, process_id-8872
            # 结果分析
            # 每个job()的进程ID都相同, 但线程ID不同.所以, job()最终是以线程的方式被调度执行
        ```


