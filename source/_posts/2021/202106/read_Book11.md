---
title: 读书笔记 (11)
date: 2021-06-30
tags: Book
toc: true
---

### 还是要多读书鸭
    Docker容器与容器云读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 一切皆容器:Kubernetes
> Kubernetes == K8s
- 核心组件协作流程
1. 创建pod
    * 当客户端发起一个创建pod的请求后, kubectl向APIServer的/pods端点发送一个HTTP POST请求, 请求的内容即客户端提供的pod资源配置文件
    * APIServer收到该REST API请求后会进行一系列的验证操作, 包括用户认证、授权和资源配额控制等.验证通过后, APIServer调用etcd的存储接口在后台数据库中创建一个pod对象
    * scheduler使用APIServer的API, 定期从etcd获取/监测系统中可用的工作节点列表和待调度pod, 并使用调度策略为pod选择一个运行的工作节点, 这个过程也就是绑定(bind)
    * 绑定成功后, scheduler会调用APIServer的API在etcd中创建一个 binding对象, 描述在一个工作节点上绑定运行的所有pod信息. 同时kubelet会监听APIServer上pod的更新, 如果发现有pod更新信息, 则会自动在podWorker的同步周期中更新对应的pod.这正是Kubernetes实现中“一切皆资源”的体现, 即所有实体对象, 消息等都是作为etcd里保存起来的一种资源来对待, 其他所有组件间协作都通过基于APIServer的数据交换, 组件间一种松耦合的状态
    ![创建pod](/img/20210630_1.png)
2. 创建replication controller
    * 当客户端发起一个创建replication controller的请求后, kubectl向APIServer的/controllers端点发送一个HTTP POST请求, 请求的内容即客户端提供的replication controller资源配置文件.
    * 与创建pod类似, APIServer收到该REST API请求后会进行一系列的验证操作.验证通过后, APIServer调用etcd的存储接口在后台数据库中创建一个replication controller对象.
    * controller manager会定期调用APIServer的API获取期望replication controller对象列表.再遍历期望RC对象列表, 对每个RC, 调用APIServer的API获取对应的pod集的实际状态信息.然后, 同步replication controller的pod期望值与pod的实际状态值, 创建指定副本数的pod
    ![创建replication controller](/img/20210630_2.png)
3. 创建service
    * 当客户端发起一个创建service的请求后, kubectl向APIServer的/services端点发送一个HTTP POST请求, 请求的内容即客户端提供的service资源配置文件.
    * 同样, APIServer收到该REST API请求后会进行一系列的验证操作.验证通过后, APIServer调用etcd的存储接口在后台数据库中创建一个service对象
    *  kube-proxy会定期调用APIServer的API获取期望service对象列表, 然后再遍历期望service对象列表.对每个service, 调用APIServer的API获取对应的pod集的信息, 并从pod信息列表中提取pod IP和容器端口号封装成endpoint对象, 然后调用APIServer的API在etcd中创建该对象
    ![创建service](/img/20210630_3.png)

