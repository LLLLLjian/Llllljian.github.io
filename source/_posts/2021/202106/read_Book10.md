---
title: 读书笔记 (10)
date: 2021-06-29
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
- APIServer
    * Kubernetes APIServer负责对外提供Kubernetes API服务, 它运行在Kubernetes的管理节点master节点中.作为系统管理指令的统一人口, APIServer担负着统揽全局的重任, 任何对资源进行增删改查的操作都要交给APIServer处理后才能提交给etcd.
    * Kubernetes APIServer总体上由两个部分组成:HTTP/HTTPS服务和一些功能性插件.其中这些插件又可以分成两类:一部分与底层IaaS平台(Cloud Provider)相关, 另一部分与资源的管理控制(admission control)相关
    1. APIServer的职能
        * 对外提供基于RESTfuI的管理接口, 支持对Kubernetes的资源对象譬如:pod, service,replication controller、工作节点等进行增、删、改、查和监听操作
        * 配置Kubernetes的资源对象, 并将这些资源对象的期望状态和当前实际存储在etcd中供Kubernetes其他组件读取和分析.(Kubernetes除了etcd之外没有任何持久化节点)
        * 提供可定制的功能性插件(支持用户自定义), 完善对集群的管理
        * 系统日志收集功能, 暴露在/logs API.
        * 可视化的API
- scheduler
    * 资源调度器本身经历了长足的发展, 一向受到广泛关注.Kubernetes scheduler是一个典型的单体调度器.它的作用是根据特定的调度算法将pod调度到指定的工作节点上, 这一过程通常被称为绑定(bind).
    * scheduler的输人是待调度pod和可用的工作节点列表, 输出则是应用调度算法从列表中选择的一个最优的用于绑定待调度pod的节点.
- controller manager
    * Kubernetes controller manager行在集群的master节点上, 是基于pod API上的一个独立服务, 它管理着Kubernetes集群中的各种控制器, 包括读者已经熟知的replication controller和node controller.相比之下, APIServer负责接收用户的请求, 并完成集群内资源的“增删改”, 而controller manager系统中扮演的角色是在一旁默默地管控这些资源, 确保它们永远保持在用户所预期的状态.
- kubelet
    * kubelet组件是Kubernetes集群工作节点上最重要的组件进程, 它负责管理和维护在这台主机上运行着的所有容器.本质上, 它的工作可以归结为使得pod的运行状态(status)与它的期望值(spec)一致.目前, kubelet支持docker和rkt两种容器;而社区也在尝试使用C/S架构来支持更多container runtime与Kubernetes的结合.
- kube-proxy
    * ​Kubernetes基于service、endpoint等概念为用户提供了一种服务发现和反向代理服务, 而kube-proxy就是这种服务的底层实现机制.kube-proxy支持TCP和UDP连接转发, 默认情况下基于Round Robin算法将客户端流量转发到与service对应的一组后端pod.在服务发现的实现上, Kube-proxy使用etcd的watch机制, 监控集群中service和endpoint对象数据的动态变化, 并且维护一个从service到endpoint的映射关系, 从而保证了后端pod的IP变化不会对访问者造成影响.另外kube-proxy还支持session affinity(即会话保持或粘滞会话).


