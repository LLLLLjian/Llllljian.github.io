---
title: 读书笔记 (15)
date: 2021-07-06
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 从容器到容器云:谈谈Kubernetes的本质
> 实际上,过去很多的集群管理项目(比如 Yarn、Mesos,以及 Swarm)所擅长的,都是把一个容 器,按照某种规则,放置在某个最佳节点上运行起来.这种功能,我们称为“调度”.而 Kubernetes 项目所擅长的,是按照用户的意愿和整个系统的规则,完全自动化地处理好容器之 间的各种关系.这种功能,就是我们经常听到的一个概念:编排.所以说,Kubernetes 项目的本质,是为用户提供一个具有普遍意义的容器编排工具.

- 一个正在运行的 Linux 容器,其实可以被“一分为二”地看待:
1. 一组联合挂载在 /var/lib/docker/aufs/mnt 上的 rootfs,这一部分我们称为“容器镜 像”(Container Image),是容器的静态视图;
2. 一个由 Namespace+Cgroups 构成的隔离环境,这一部分我们称为“容器运行 时”(Container Runtime),是容器的动态视图.

- Kubernetes全局架构
    * ![Kubernetes全局架构](/img/20210706_1.png)
    * master节点: 控制节点
        * 负责API服务的 kube-apiserver
        * 负责调度的 kube-scheduler
        * 负责容器编排的 kube-controller-manager
    * node节点: 计算节点
        * 核心组件: kubelet主要负责同容器运行时(比如 Docker 项目)打交道

- Kubernetes项目核心功能全景图
    * ![Kubernetes项目核心功能全景图](/img/20210706_2.png)
    * 首先遇到了容器间“紧密协作”关系的难题,于是就扩展到了Pod
    * 有了Pod之后,我们希望能一次启动多个应用的实例,这样就需要Deployment这个Pod的多实例管理器
    * 而有了这样一组相同的 Pod 后,我们又需要通过一个固定的 IP 地址和端口以负载均衡的方式访问它,于是就有了 Service.
    * Kubernetes 定义了新的、基于 Pod 改进后的对象.比如 Job,用来描述一次性运行的 Pod(比如,大数据任务);再比如 DaemonSet,用来描述每个宿主机上必须且只能运行一个副本 的守护进程服务;又比如 CronJob,则用于描述定时任务等等
- Kubernetes 项目如何启动一个容器化任务呢
    * 如果是自己 DIY 的话,可能需要启动两台虚拟机,分别安装两个 Nginx,然后使用 keepalived 为这两个虚拟机做一个虚拟 IP.
    * 而如果使用 Kubernetes 项目呢?你需要做的则是编写如下这样一个 YAML 文件(比如名叫 nginx-deployment.yaml)
        ```bash
            # nginx-deployment.yaml
            # 定义了一个 Deployment 对象,它的主体部分(spec.template 部分)是一个使用 Nginx 镜像的 Pod,而这个 Pod 的副本数是 2(replicas=2)
            apiVersion: apps/v1
            kind: Deployment
            metadata:
            name: nginx-deployment labels:
                app: nginx
            spec:
                replicas: 2
                selector:
                    matchLabels:
                        app: nginx
                template:
                    metadata:
                        labels:
                            app: nginx
                    spec:
                        containers:
                        - name: nginx
                            image: nginx:1.7.9
                            ports:
                            - containerPort: 80
            
            # 创建
            $ kubectl create -f nginx-deployment.yaml
        ```

#### 牛刀小试:我的第一个容器化应用
> Kubernetes 推荐的使用方式,是用一个 YAML 文件来描述你所要部署的 API 对象.然 后,统一使用 kubectl apply 命令完成对这个对象的创建和更新操作.而 Kubernetes 里“最小”的 API 对象是 Pod.Pod 可以等价为一个应用,所以,Pod 可以由多个 紧密协作的容器组成.在 Kubernetes 中,我们经常会看到它通过一种 API 对象来管理另一种 API 对象,比如 Deployment 和 Pod 之间的关系;而由于 Pod 是“最小”的对象,所以它往往都是被其他对象控 制的.这种组合方式,正是 Kubernetes 进行容器编排的重要模式.而像这样的 Kubernetes API 对象,往往由 Metadata 和 Spec 两部分组成,其中 Metadata 里的 Labels 字段是 Kubernetes 过滤对象的主要手段.在这些字段里面,容器想要使用的数据卷,也就是 Volume,正是 Pod 的 Spec 字段的一部分.而 Pod 里的每个容器,则需要显式的声明自己要挂载哪个 Volume.
