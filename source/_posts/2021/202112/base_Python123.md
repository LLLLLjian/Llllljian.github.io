---
title: Python_基础 (123)
date: 2021-12-03
tags: Python
toc: true
---

### django-apscheduler
    python+django+apscheduler = django-apscheduler

<!-- more -->

#### 结合一下前两天学的
- code
    ```python
        # -*- coding: utf-8 -*-
        # !/usr/bin/python3
        """
        启动方式 python manage.py runapscheduler
        """
        import threading
        import random
        import time
        from apscheduler.events import EVENT_JOB_MAX_INSTANCES
        from apscheduler.events import JobSubmissionEvent, JobExecutionEvent
        from apscheduler.triggers.cron import CronTrigger
        from django.core.management.base import BaseCommand
        from django_apscheduler.models import DjangoJobExecution
        from django_apscheduler import util
        from crontab.base_apscheduler import scheduler
        from apscheduler.schedulers.blocking import BlockingScheduler
        from apscheduler.executors.pool import ThreadPoolExecutor
        from django_apscheduler.jobstores import DjangoJobStore

        executors = {
            # 线程池执行器 生成的线程的最大数量20个
            'default': ThreadPoolExecutor(20)
        }
        job_defaults = {
            # coalesce: 累计的任务是否执行.True不执行, False,执行.同上, 由于某种原因, 比如进场挂了, 导致任务多次没有调用, 则前几次的累计任务的任务是否执行的策略
            # max_instances: 同一个任务在线程池中最多跑的实例数.
            'coalesce': True
        }
        scheduler = BlockingScheduler(
            executors=executors,
            job_defaults=job_defaults,
            timezone="Asia/Shanghai"
        )
        scheduler.add_jobstore(DjangoJobStore(), "default")


        @util.close_old_connections
        def delete_old_job_executions(max_age=1_296_000):
            """
            删除15天前的运行历史job数据
            """
            DjangoJobExecution.objects.delete_old_job_executions(max_age)


        def debug_time():
            """
            测试apscheduler任务
            """
            sleeptime = random.randint(1, 50)
            logger.error("time sleep %s" % sleeptime)
            time.sleep(sleeptime)
            logger.error("now time is %s, date is %s" % (
                int(time.time()),
                time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
            )

        def max_instance_callback_listener(event):
            """
            # 当任务重复提交时
            :param event:
            :return:
            """
            logger.error("events: %s is running and maybe hang out, new task can't start" % str(event.job_id))


        class Command(BaseCommand):
            help = "执行后台定时任务"

            def handle(self, *args, **options):
                """
                后台任务主体
                from apscheduler.triggers.cron import CronTrigger

                # 每10s执行一次
                scheduler.add_job(
                    my_job,
                    trigger=CronTrigger(second="*/10"),  # Every 10 seconds
                    id="my_job",  # The `id` assigned to each job MUST be unique
                    max_instances=1,
                    replace_existing=True,
                )

                # 每周一的 00时00分执行一次
                scheduler.add_job(
                    delete_old_job_executions,
                    trigger=CronTrigger(
                        day_of_week="mon", hour="00", minute="00"
                    ),  # Midnight on Monday, before start of the next work week.
                    id="delete_old_job_executions",
                    max_instances=1,
                    replace_existing=True,
                )
                """
                # ---------------------------------- 时间间隔执行 S ----------------------------------
                # debug time 每5分钟执行一次
                scheduler.add_job(
                    debug_time,
                    'interval',
                    seconds=60 * 5,
                    id="debug_time",
                    replace_existing=True
                )

        # EVENT_JOB_MAX_INSTANCES(JobSubmissionEvent) 提交给其执行器的作业未被执行器接受, 因为该作业已达到其最大并发执行实例数
        scheduler.add_listener(
            max_instance_callback_listener,
            EVENT_JOB_MAX_INSTANCES
        )

        try:
            logger.info("Starting scheduler...")
            scheduler.start()
        except KeyboardInterrupt:
            logger.info("Stopping scheduler...")
            scheduler.shutdown()
            logger.info("Scheduler shut down successfully!")

    ```

