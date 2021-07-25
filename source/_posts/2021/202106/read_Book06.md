---
title: 读书笔记 (06)
date: 2021-06-23
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

- Kubernetes是啥
    * 是一个管理跨主机容器化应用的系统, 实现了包括应用部署、高可用管理和弹性伸缩在内的一系列基础功能并封装成一套完整、简单易用的RESTful API对外提供服务
    * K8s建立了一套健壮的集群自恢复机制, 包括：容器的自动重启、自动重调度及自动备份
    * K8s的服务对象是：由多个容器组合而成的复杂应用, 如：弹性、分布式的服务架构.K8s引入了专门对容器进行分组管理的pod, K8s对外提供容器服务的模式是：用户提交容器集群运行所需要的资源的申请(就是个配置文件), 然后由K8s负责完成这些容器的调度任务(就是自动地为这些容器选择运行的宿主机)
- pod
    * 在K8s中, 能够被创建、调度和管理的最小单元是pod, 而非单个容器.一个pod是由若干个Docker容器构成的容器组(pod意为豆荚,里面容纳了很多豆子)
    * pod可以想象成一个篮子, 而容器则是篮子里的鸡蛋, 当K9S需要调度容器时, 它直接把一个篮子(连同里面的鸡蛋)从一个宿主机调度到另一个宿主机, 篮子和鸡蛋的关系主要表现为以下几点
        * 一个pod里的容器能有多少资源取决于这个篮子的大小
        * label也是贴在篮子上的
        * IP分配给篮子而不是容器, 篮子里面的所有容器共享这个IP
        * 哪怕只有一个鸡蛋(容器), K8s仍然会给他分配一个篮子
    * pod特性
        * IP及对应的network namespace是由pod里的容器所共享的
        * 通过K8s volume机制, 在容器之间共享储存
        * 同一个pod内的应用容器能够使用System VIPC或者POSIX消息队列进行通信
        * 同一个pod内的应用容器共享主机名(可以通过localhost直接访问另一个容器)
- label
    * 通过label, 可以在K8s集群管理工具kubectl中方便地实现pod等资源对象的定位和组织, 只要传入-l key=value即可匹配到有key=value标签的pod
        ```bash
            # 列举所有匹配标签{"name": "nginx"}的pod
            kubectl get -l name=nginx
            # 选择key值等于environment而且value值等于production的资源对象
            kubectl get -l environment=production
            # 选择key值等于tier且value值不等于frontend的资源对象
            kubectl get -l tier!=frontend
        ```
    * labels属性是一组绑定到K8s对象(eg:pod)上的键值对, 同一个对象labels属性的key必须独一无二.label的数据结构非常简单, 就是一个key和value均为string类型的map结构



