---
title: Python_基础 (124)
date: 2021-12-06
tags: Python
toc: true
---

### django-apscheduler
    python+django+apscheduler = django-apscheduler

<!-- more -->

#### 调度任务页面扩展
> 那我能不能从页面上直观的看到job运行状态及对任务进行增删改查
- job运行状态
    ```python
        def get_job_list():
            job_list = DjangoJob.objects.all()
            job_list_json = []
            for job in job_list:
                tmp_dict = model_to_dict(job)
                # 平均执行时间
                tmp_dict["avg_duration_time"] = DjangoJobExecution.objects.filter(
                    job=tmp_dict["id"]
                ).aggregate(
                    avg_duration_time=Avg('duration')
                )["avg_duration_time"]
                # 下次执行时间
                if tmp_dict["next_run_time"]:
                    tmp_dict["next_run_time"] = time.strftime(
                        "%Y-%m-%d %H:%M:%S", time.localtime(tmp_dict["next_run_time"].timestamp())
                    )
                    # 任务状态
                    tmp_dict["status"] = "执行中"
                else:
                    tmp_dict["next_run_time"] = "-"
                    tmp_dict["status"] = "暂停"
                job_list_json.append(tmp_dict)
            return job_list_json
    ```
- job历史运行状态
    ```python
        def get_history_joblist():
            job_list = DjangoJobExecution.objects.filter().all()
            job_list_json = []
            for job in job_list:
                tmp_dict = model_to_dict(job)
                if tmp_dict["job"] in config["crontab_dict"]:
                    tmp_dict["job_name"] = config["crontab_dict"][tmp_dict["job"]]
                else:
                    tmp_dict["job_name"] = tmp_dict["job"]
                tmp_dict["run_time"] = time.strftime(
                    "%Y-%m-%d %H:%M:%S", time.localtime(tmp_dict["run_time"].timestamp())
                )
                if tmp_dict["finished"]:
                    tmp_dict["finished_time"] = time.strftime(
                        "%Y-%m-%d %H:%M:%S", time.localtime(int(tmp_dict["finished"]))
                    )
                else:
                    tmp_dict["finished_time"] = ""
                job_list_json.append(tmp_dict)
            return job_list_json
    ```
- 增
    ```python
        import json
        from django.http import JsonResponse
        from apscheduler.schedulers.background import BackgroundScheduler
        from django_apscheduler.jobstores import DjangoJobStore, register_events, register_job


        scheduler = BackgroundScheduler()
        scheduler.add_jobstore(DjangoJobStore(), 'default')

        def test_add_task(request):
            if request.method == 'POST':
                content = json.loads(request.body.decode())  # 接收参数
                try:
                    start_time = content['start_time']  # 用户输入的任务开始时间, '10:00:00'
                    start_time = start_time.split(':')
                    hour = int(start_time)[0]
                    minute = int(start_time)[1]
                    second = int(start_time)[2]
                    s = content['s']  # 接收执行任务的各种参数
                    # 创建任务
                    scheduler.add_job(test, 'cron', hour=hour, minute=minute, second=second, args=[s])
                    code = '200'
                    message = 'success'
                except Exception as e:
                    code = '400'
                    message = e
                    
                back = {
                    'code': code,
                    'message': message
                }
                return JsonResponse(json.dumps(data, ensure_ascii=False), safe=False)

        def test(s):
            pass

        register_events(scheduler)
        scheduler.start()
        
        # 如果新增的方法不在当前页面的话 方法名为 'package.module:some.object',即 包名.模块:函数名
    ```
- 删
    ```python
        # 获取一下job信息
        job_info = DjangoJob.objects.filter(id=body["job_name"]).get()
        # 会把详情也都删掉
        job_info.delete()
    ```
- 改(暂停/开启)
    ```python
        import pickle
        from apscheduler.util import convert_to_datetime
        from django_apscheduler.models import DjangoJob
        from django_apscheduler.models import DjangoJobExecution
        from django_apscheduler.util import get_django_internal_datetime

        # 任务信息
        job_info = DjangoJob.objects.filter(id=body["job_name"]).get()
        job_state = pickle.loads(job_info.job_state)
        trigger = job_state["trigger"]

        if (body["action"] == "pause"):
            # 暂停
            job_info.next_run_time = None
            job_state["next_run_time"] = None
            job_info.job_state = pickle.dumps(job_state)
            job_info.save()
        elif (body["action"] == "resume"):
            # 重启
            now = convert_to_datetime(datetime.datetime.now(), "Asia/Shanghai", "next_run_time")
            next_run_time = trigger.get_next_fire_time(now, now)
            job_info.next_run_time = get_django_internal_datetime(next_run_time)
            job_state["next_run_time"] = next_run_time
            # 更改一下job_state
            job_info.job_state = pickle.dumps(job_state)
            job_info.save()
    ```

