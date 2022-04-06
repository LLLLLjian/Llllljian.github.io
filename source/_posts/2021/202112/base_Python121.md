---
title: Python_基础 (121)
date: 2021-12-01
tags: Python
toc: true
---

### django-apscheduler
    python+django+apscheduler = django-apscheduler

<!-- more -->

#### 前情提要
> 昨天学了一下django-apscheduler,但是真正到项目中用的时候,我们用的是uwsgi, 把定时调度任务写到urls.py里的话, 任务会被执行多次, 这个不太行呀

#### 问题现象
> 从日志里看 同一时间 任务直接被执行了多次,执行的个数为起的uwsgi的数量, 猜测是uwsgi会根据配置启动复数个进程的django,而 APScheduler 也会依附于 django 的启动同时启动,因此在每个 APScheduler 的定时任务也会是复数个同时执行

#### 问题解决
- 通过端口占用
    * 占用一个未用端口, 从而保证其他django启动的时候去检测, 如果已被占用则不在启动, 从而实现用端口锁,保证只会启用一个 APScheduler 进程
    ```python
        try:
            # 利用一个占用端口来检测是否已经启动, 如已占用则说明已启动
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.bind(("127.0.0.1", 44444))
        except socket.error:
            print("!!!scheduler started, DO NOTHING")
        else:
            try:
                if settings.SYNC_TASK_TOOGLE == 'true':
                    print('scheduler running !!!')
                    scheduler.start()
                else:
                    print('No need scheduler')
            except Exception as e:
                # 一般是没生成表,就启动当前程序就会报错
                print(e)
    ```
- 通过文件锁
    * 通过文件锁的方式保证APScheduler只运行一次
        ```python
            def initscheduler(scheduler):
                f = open("scheduler.lock", "wb")
                try:
                    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)

                    register_events(scheduler)
                    scheduler.start()
                except:
                    pass

                def unlock():
                    fcntl.flock(f, fcntl.LOCK_UN)
                    f.close()

                atexit.register(unlock)
            
            scheduler = BackgroundScheduler()
            # 调度器使用DjangoJobStore()
            scheduler.add_jobstore(DjangoJobStore(), "default")
            ...
            # 调用文件锁函数,实例化调度器
            initscheduler(scheduler)
        ```
- 再起一个进程去做
    * 自定义一个管理命令. python manage.py runapscheduler
        ```python
            # runapscheduler.py
            import logging

            from django.conf import settings

            from apscheduler.schedulers.blocking import BlockingScheduler
            from apscheduler.triggers.cron import CronTrigger
            from django.core.management.base import BaseCommand
            from django_apscheduler.jobstores import DjangoJobStore
            from django_apscheduler.models import DjangoJobExecution
            from django_apscheduler import util

            logger = logging.getLogger(__name__)


            def my_job():
                # Your job processing logic here...
                pass


            # The `close_old_connections` decorator ensures that database connections, that have become
            # unusable or are obsolete, are closed before and after our job has run.
            @util.close_old_connections
            def delete_old_job_executions(max_age=604_800):
                """
                This job deletes APScheduler job execution entries older than `max_age` from the database.
                It helps to prevent the database from filling up with old historical records that are no
                longer useful.
                
                :param max_age: The maximum length of time to retain historical job execution records.
                                Defaults to 7 days.
                """
                DjangoJobExecution.objects.delete_old_job_executions(max_age)


            class Command(BaseCommand):
                help = "Runs APScheduler."

                def handle(self, *args, **options):
                    scheduler = BlockingScheduler(timezone=settings.TIME_ZONE)
                    scheduler.add_jobstore(DjangoJobStore(), "default")

                    scheduler.add_job(
                        my_job,
                        trigger=CronTrigger(second="*/10"),  # Every 10 seconds
                        id="my_job",  # The `id` assigned to each job MUST be unique
                        max_instances=1,
                        replace_existing=True,
                    )
                    logger.info("Added job 'my_job'.")

                    scheduler.add_job(
                        delete_old_job_executions,
                        trigger=CronTrigger(day_of_week="mon", hour="00", minute="00"),  # Midnight on Monday, before start of the next work week.
                        id="delete_old_job_executions",
                        max_instances=1,
                        replace_existing=True,
                    )
                    logger.info(
                        "Added weekly job: 'delete_old_job_executions'."
                    )

                    try:
                        logger.info("Starting scheduler...")
                        scheduler.start()
                    except KeyboardInterrupt:
                        logger.info("Stopping scheduler...")
                        scheduler.shutdown()
                        logger.info("Scheduler shut down successfully!")
        ```

