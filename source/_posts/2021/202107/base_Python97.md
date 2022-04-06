---
title: Python_基础 (97)
date: 2021-07-21
tags: Python
toc: true
---

### 快来跟我一起学apscheduler
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之定时任务框架apscheduler

<!-- more -->

#### apscheduler是什么
> 全称Advanced Python Scheduler, 作用为在指定的时间规则执行指定的作业.
1. 指定时间规则的方式可以是间隔多久执行, 可以是指定日期时间的执行, 也可以类似Linux系统中Crontab中的方式执行任务.
2. 指定的任务就是一个Python函数.

#### 为什么要用apscheduler
1. 可以在程序运行过程中动态的新增任务和删除任务
2. 在任务运行过程中, 还可以把任务存储起来, 下次启动运行依然保留之前的状态
3. 是基于 Python语言的库, 所以是可以跨平台的

#### apscheduler基本概念
- Job作业
    * 作用
        * Job作为APScheduler最小执行单位.
        * 创建Job时指定执行的函数, 函数中所需参数, Job执行时的一些设置信息.
    * 构建说明
        * id: 指定作业的唯一ID
        * name: 指定作业的名字
        * trigger: apscheduler定义的触发器, 用于确定Job的执行时间, 根据设置的trigger规则, 计算得到下次执行此job的时间,  满足时将会执行
        * executor: apscheduler定义的执行器, job创建时设置执行器的名字, 根据字符串你名字到scheduler获取到执行此job的 执行器, 执行job指定的函数
        * max_instances: 执行此job的最大实例数, executor执行job时, 根据job的id来计算执行次数, 根据设置的最大实例数来确定是否可执行
        * next_run_time: Job下次的执行时间, 创建Job时可以指定一个时间[datetime],不指定的话则默认根据trigger获取触发时间
        * misfire_grace_time: Job的延迟执行时间, 例如Job的计划执行时间是21:00:00, 但因服务重启或其他原因导致21:00:31才执行, 如果设置此key为40,则该job会继续执行, 否则将会丢弃此job
        * coalesce: Job是否合并执行, 是一个bool值.例如scheduler停止20s后重启启动, 而job的触发器设置为5s执行一次, 因此此job错过了4个执行时间, 如果设置为是, 则会合并到一次执行, 否则会逐个执行
        * func: Job执行的函数
        * args: Job执行函数需要的位置参数
        * kwargs: Job执行函数需要的关键字参数
- Trigger触发器
    * Trigger绑定到Job, 在scheduler调度筛选Job时, 根据触发器的规则计算出Job的触发时间, 然后与当前时间比较确定此Job是否会被执行, 总之就是根据trigger规则计算出下一个执行时间.
    * Trigger有多种种类, 指定时间的DateTrigger, 指定间隔时间的IntervalTrigger, 像Linux的crontab一样的CronTrigger
- Executor执行器
    * Executor在scheduler中初始化, 另外也可通过scheduler的add_executor动态添加Executor. 每个executor都会绑定一个alias, 这个作为唯一标识绑定到Job, 在实际执行时会根据Job绑定的executor找到实际的执行器对象, 然后根据执行器对象执行Job
    * Executor的种类会根据不同的调度来选择, 如果选择AsyncIO作为调度的库, 那么选择AsyncIOExecutor, 如果选择tornado作为调度的库, 选择TornadoExecutor, 如果选择启动进程作为调度, 选择ThreadPoolExecutor或者ProcessPoolExecutor都可以
    * Executor的选择需要根据实际的scheduler来选择不同的执行器
- Jobstore作业存储
    * Jobstore在scheduler中初始化, 另外也可通过scheduler的add_jobstore动态添加Jobstore.每个jobstore都会绑定一个alias, scheduler在Add Job时, 根据指定的jobstore在scheduler中找到相应的jobstore, 并将job添加到jobstore中.
    * Jobstore主要是通过pickle库的loads和dumps【实现核心是通过python的__getstate__和__setstate__重写实现】, 每次变更时将Job动态保存到存储中, 使用时再动态的加载出来, 作为存储的可以是redis, 也可以是数据库【通过sqlarchemy这个库集成多种数据库】, 也可以是mongodb等
- Event事件
    * Event是APScheduler在进行某些操作时触发相应的事件, 用户可以自定义一些函数来监听这些事件, 当触发某些Event时, 做一些具体的操作
    * 常见的比如.Job执行异常事件 EVENT_JOB_ERROR.Job执行时间错过事件 EVENT_JOB_MISSED
- Listener监听事件
    * Listener表示用户自定义监听的一些Event, 当Job触发了EVENT_JOB_MISSED事件时可以根据需求做一些其他处理.
- Scheduler调度器
    * Scheduler是APScheduler的核心, 所有相关组件通过其定义.scheduler启动之后, 将开始按照配置的任务进行调度.除了依据所有定义Job的trigger生成的将要调度时间唤醒调度之外.当发生Job信息变更时也会触发调度.
    * scheduler可根据自身的需求选择不同的组件, 如果是使用AsyncIO则选择AsyncIOScheduler, 使用tornado则选择TornadoScheduler.

#### Scheduler添加job流程
![Scheduler添加job流程](/img/20210721_1.png)


#### Scheduler调度流程
![Scheduler调度流程](/img/20210721_2.png)



