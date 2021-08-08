---
title: Python_基础 (102)
date: 2021-07-28
tags: Python
toc: true
---

### 快来跟我一起学apscheduler
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之定时任务框架apscheduler

<!-- more -->

#### 调度器事件
> 调度器允许添加事件侦听器.部分事件会有特有的信息, 比如当前运行次数等.add_listener(callback,mask)中, 第一个参数是回调对象, mask是指定侦听事件类型, mask参数也可以是逻辑组合.回调对象会有一个参数就是触发的事件.
- eg
    ```python
        def my_listener(event):
            if isinstance(event, JobSubmissionEvent):
                print("The job is running :)")
            elif isinstance(event, JobExecutionEvent):
                if event.exception:
                    print('The job crashed :(')
                else:
                    print('The job worked :)')

        def my_listener1(event):
            print("events: %s is running and maybe hang out, new task can't start" % str(event.job_id))

        # 当任务执行完或任务出错时, 调用my_listener
        scheduler.add_listener(
            my_listener,
            EVENT_JOB_EXECUTED | EVENT_JOB_ERROR | EVENT_JOB_SUBMITTED
        )

        # 当前一个任务没执行完后一个任务又要执行导致出错的时候 也可以捕获到
        scheduler.add_listener(
            my_listener1,
            EVENT_JOB_MAX_INSTANCES
        )
    ```
- 事件类型
    <table><thead><tr><th>Constant</th><th>Description</th><th>Event class</th></tr></thead><tbody><tr><td>EVENT_SCHEDULER_STARTED</td><td>The scheduler was started</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_SCHEDULER_SHUTDOWN</td><td>The scheduler was shut down</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_SCHEDULER_PAUSED</td><td>Job processing in the scheduler was paused</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_SCHEDULER_RESUMED</td><td>Job processing in the scheduler was resumed</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_EXECUTOR_ADDED</td><td>An executor was added to the scheduler</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_EXECUTOR_REMOVED</td><td>An executor was removed to the scheduler</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_JOBSTORE_ADDED</td><td>A job store was added to the scheduler</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_JOBSTORE_REMOVED</td><td>A job store was removed from the scheduler</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_ALL_JOBS_REMOVED</td><td>All jobs were removed from either all job stores or one particular job store</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.SchedulerEvent" target="_blank" rel="noopener noreferrer"><code>SchedulerEvent</code></a></td></tr><tr><td>EVENT_JOB_ADDED</td><td>A job was added to a job store</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobEvent" target="_blank" rel="noopener noreferrer"><code>JobEvent</code></a></td></tr><tr><td>EVENT_JOB_REMOVED</td><td>A job was removed from a job store</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobEvent" target="_blank" rel="noopener noreferrer"><code>JobEvent</code></a></td></tr><tr><td>EVENT_JOB_MODIFIED</td><td>A job was modified from outside the scheduler</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobEvent" target="_blank" rel="noopener noreferrer"><code>JobEvent</code></a></td></tr><tr><td>EVENT_JOB_SUBMITTED</td><td>A job was submitted to its executor to be run</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobSubmissionEvent" target="_blank" rel="noopener noreferrer"><code>JobSubmissionEvent</code></a></td></tr><tr><td>EVENT_JOB_MAX_INSTANCES</td><td>A job being submitted to its executor was not accepted by the executor because the job has already reached its maximum concurrently executing instances</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobSubmissionEvent" target="_blank" rel="noopener noreferrer"><code>JobSubmissionEvent</code></a></td></tr><tr><td>EVENT_JOB_EXECUTED</td><td>A job was executed successfully</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobExecutionEvent" target="_blank" rel="noopener noreferrer"><code>JobExecutionEvent</code></a></td></tr><tr><td>EVENT_JOB_ERROR</td><td>A job raised an exception during execution</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobExecutionEvent" target="_blank" rel="noopener noreferrer"><code>JobExecutionEvent</code></a></td></tr><tr><td>EVENT_JOB_MISSED</td><td>A job’s execution was missed</td><td><a href="https://apscheduler.readthedocs.io/en/latest/modules/events.html#apscheduler.events.JobExecutionEvent" target="_blank" rel="noopener noreferrer"><code>JobExecutionEvent</code></a></td></tr><tr><td>EVENT_ALL</td><td>A catch-all mask that includes every event type</td><td>N/A</td></tr></tbody></table>


