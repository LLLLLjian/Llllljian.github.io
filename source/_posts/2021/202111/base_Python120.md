---
title: Python_基础 (120)
date: 2021-11-30
tags: Python
toc: true
---

### django-apscheduler
    python+django+apscheduler = django-apscheduler

<!-- more -->

#### 前情提要
> 我们的后台任务有点呆瓜, 是一个进程直接夯在那, 进程里又起了多个线程去做任务,虽然说也可以吧,但是管理起来很麻烦,而且查看任务的运行状态也只能去日志里看,页面上无法直观的看到运行状态及耗时,恰好另一个项目用的是flask+apscheduler实现的,本来我想直接用原生的apscheduler, 但是发现django有一个封装好的、更简便的类库,那我就直接用这个了呀

#### django-apscheduler定时任务
- 安装
    ```python
        pip install apscheduler
        pip install django-apscheduler
    ```
- 初始化app
    ```python
        # setting.py
        INSTALLED_APPS = [
            ...
            'django_apscheduler'
        ]
    ```
- 初始化表
    ```python
        python manage.py makemigrations
        python manage.py migrate
        # 会创建两张表：django_apscheduler_djangojob/django_apscheduler_djangojobexecution
    ```
- func1
    ```python
        # 如果是通过python manage.py runserver启动服务
        # 直接在urls.py中引入以下内容
        from apscheduler.schedulers.background import BackgroundScheduler
        from django_apscheduler.jobstores import DjangoJobStore, register_events, register_job
        
        scheduler = BackgroundScheduler()
        scheduler.add_jobstore(DjangoJobStore(), "default")

        # 时间间隔3秒钟打印一次当前的时间
        @register_job(scheduler, "interval", seconds=3, id='test_job')
        def test_job():
            print("我是apscheduler任务")
        # per-execution monitoring, call register_events on your scheduler
        register_events(scheduler)
        scheduler.start()
        print("Scheduler started!")
    ```
- APScheduler调度器
    * BlockingScheduler: 调用start函数后会阻塞当前线程.当调度器是你应用中唯一要运行的东西时使用
        ```python
            from apscheduler.schedulers.blocking import BlockingScheduler
            import time
            
            def job():
                print('job 3s')
            
            
            if __name__=='__main__':
                sched = BlockingScheduler(timezone='MST')
                sched.add_job(
                    job,
                    'interval',
                    id='3_second_job',
                    seconds=3
                )
                sched.start()
                # BlockingScheduler调用start函数后会阻塞当前线程,导致主程序中while循环不会被执行到
                while(True):
                    print('main 1s')
                    time.sleep(1)
            
            运行结果：
            job 3s
            job 3s
            job 3s
            job 3s
        ```
    * BackgroundScheduler: 调用start后主线程不会阻塞.当你不运行任何其他框架时使用,并希望调度器在你应用的后台执行
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time

            def job():
                print('job 3s')

            if __name__=='__main__':
            
                sched = BackgroundScheduler(timezone='MST')
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()
                # BackgroundScheduler调用start函数后并不会阻塞当前线程,所以可以继续执行主程序中while循环的逻辑
                while(True):
                    print('main 1s')
                    time.sleep(1)
            
            运行结果：
            main 1s
            main 1s
            main 1s
            job 3s
            main 1s
            main 1s
            main 1s
            job 3s
        ```
- 如何让job在start()后就开始运行
    * 通过上边BackgroundScheduler的例子可以看出调用start函数后,job()并不会立即开始执行.而是等待3s后,才会被调度执行
    * 那么如何才能让调度器调用start函数后,job()就立即开始执行呢
    * 现在没有好的办法解决, 最简单粗暴的办法就是一开始先执行一次
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time
            
            def job():
                print('job 3s')
            
            
            if __name__=='__main__':
                job()
                sched = BackgroundScheduler(timezone='MST')
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()
            
                while(True):
                    print('main 1s')
                    time.sleep(1)
            
            
            运行结果：
            job 3s
            main 1s
            main 1s
            main 1s
            job 3s
            main 1s
            main 1s
            main 1s
        ```
- 如果job执行时间过长会怎么样
    * 如果执行job()的时间需要5s,但调度器配置为每隔3s就调用一下job(),会发生什么情况呢
        ```python
            from apscheduler.schedulers.background import BackgroundScheduler
            import time
            
            def job():
                print('job 3s')
                time.sleep(5)
            
            if __name__=='__main__':
            
                sched = BackgroundScheduler(timezone='MST')
                sched.add_job(job, 'interval', id='3_second_job', seconds=3)
                sched.start()
            
                while(True):
                    print('main 1s')
                    time.sleep(1)
            
            运行结果：
            main 1s
            main 1s
            main 1s
            job 3s
            main 1s
            main 1s
            main 1s
            Execution of job "job (trigger: interval[0:00:03], next run at: 2018-05-07 02:44:29 MST)" skipped: maximum number of running instances reached (1)
            main 1s
            main 1s
            main 1s
            job 3s
            main 1s
        ```
    * 结论: 3s时间到达后,并不会“重新启动一个job线程”,而是会跳过该次调度,等到下一个周期(再等待3s),又重新调度job()
    * 如何让多个job()同时运行
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
            
            运行结果：
            main 1s
            main 1s
            main 1s
            job 3s
            main 1s
            main 1s
            main 1s
            job 3s
            main 1s
            main 1s
            main 1s
            job 3s
        ```
- 每个job是怎么被调度的
    * 查看job运行时的进程和线程
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
            
            运行结果：
            main 1s
            main 1s
            main 1s
            job thread_id-10644, process_id-8872
            main 1s
            main 1s
            main 1s
            job thread_id-3024, process_id-8872
            main 1s
            main 1s
            main 1s
            job thread_id-6728, process_id-8872
            main 1s
            main 1s
            main 1s
            job thread_id-11716, process_id-8872
        ```
    * 结论: 同一个进程ID 不同的线程ID, job是用线程去调度的 
- 设置任务执行周期
    ```python
        # 周一到周五的6.30分之行一次
        scheduler.add_job(
            job,
            "cron",
            day_of_week="1-5",
            hour=6,
            minute=30
        )

        # 每天的1.05分执行一次
        scheduler.add_job(
            job,
            'cron',
            hour=1,
            minute=5
        )
        
        # 每天的19-21点23分执行一次
        scheduler.add_job(
            job,
            'cron',
            hour ='19-21',
            minute= '23'
        )

        # 每300秒执行一次
        scheduler.add_job(
            job,
            'interval',
            seconds=300
        )

        # 在1月,3月,5月,7-9月,每天的下午2点,每一分钟执行一次任务
        scheduler.add_job(
            func=job,
            trigger='cron',
            month='1,3,5,7-9',
            day='*',
            hour='14',
            minute='*'
        )
  
        # 当前任务会在 6、7、8、11、12 月的第三个周五的 0、1、2、3 点执行
        scheduler.add_job(
            job,
            'cron',
            month='6-8,11-12',
            day='3rd fri',
            hour='0-3'
        )
  
        #从开始时间到结束时间,每隔俩小时运行一次
        scheduler.add_job(
            job,
            'interval',
            hours=2,
            start_date='2021-11-01 00:00:00',
            end_date='2021-11-30 23:59:59'
        )

        # 周一到周五,每天9:30:10执行
        @register_job(scheduler, 'cron', day_of_week='mon-fri', hour='9', minute='30', second='10',id='task_time')
        def test_job():
            t_now = time.localtime()
            print(t_now)
    ```

