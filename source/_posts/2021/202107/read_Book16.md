---
title: 读书笔记 (16)
date: 2021-07-07
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 为什么我们需要Pod
> Pod,实际上是在扮演传统基础设施里“虚拟机”的角色;而容器,则是这个虚拟机里运行的用户程序
Pod 是 Kubernetes 里的原子调度单 位.这就意味着,Kubernetes 项目的调度器,是统一按照 Pod 而非容器的资源需求进行计算的

- eg
    * 假设有一个应用是由三个进程ProcessA、ProcessB、ProcessC组成的,这三个进程一定要运行在同一台机器上,否则他们之间基于Socket 的通信和文件交换,都会出现问题.现在要把这个应用容器化,由于受限于容器的“单进程模型”,这三个模块必须被 分别制作成三个不同的容器.而在这三个容器运行的时候,它们设置的内存配额都是 1 GB.假设Kubernetes 集群上有两个节点:node-1 上有 3 GB 可用内存,node-2 有 2.5 GB 可 用内存.顺序执行:"docker run ContainerA" "docker run ContainerB"和"docker run ContainerC", 创建这三个容器.ContainerA和ContainerB很有很有可能运行在node-2节点上,当运行ContainerC时,可用资源只有0.5G,但是ContainerC还必须运行在node-2上,这就是一个典型的成组调度(gang scheduling)没有被妥善处理的例子.
    * 但是这个场景如果放在Kuburnetes的pod模型中就可以迎刃而解了,Pod 是 Kubernetes 里的原子调度单 位.这就意味着,Kubernetes 项目的调度器,是统一按照 Pod 而非容器的资源需求进行计算的.所以,像 ContainerA、ContainerB 和 ContainerC这样的三个容器,正是一个典型的由三个容器组成的 Pod.Kubernetes 项目在调度时,自然就会去选择可用内存等于 3 GB 的 node-1 节点进行 绑定,而根本不会考虑 node-2.
    * 像这样容器间的紧密协作,我们可以称为“超亲密关系”.这些具有“超亲密关系”容器的典型特 征包括但不限于:互相之间会发生直接的文件交换、使用 localhost 或者 Socket 文件进行本地通 信、会发生非常频繁的远程调用、需要共享某些 Linux Namespace(比如,一个容器要加入另一个 容器的 Network Namespace)等等.这也就意味着,并不是所有有“关系”的容器都属于同一个 Pod.比如,PHP 应用容器和 MySQL 虽然会发生访问关系,但并没有必要、也不应该部署在同一台机器上,它们更适合做成两个 Pod.
- Pod 的实现原理
    1. Pod只是一个逻辑概念,Kubernetes 真正处理的,还是宿主机操作系统上 Linux 容器的 Namespace 和 Cgroups,而并不存在一个所谓的 Pod 的边界或者隔离环境.Pod 里的所有容器,共享的是同一个 Network Namespace,并且可以声明共享同一个 Volume.那这么来看的话,一个有 A、B 两个容器的 Pod,不就是等同于一个容器(容器 A)共享另外一个 容器(容器 B)的网络和 Volume 的玩儿法么?这好像通过 docker run --net --volumes-from 这样的命令就能实现嘛,比如:**docker run --net=B --volumes-from=B --name=A image-A ...**,但如果这样的话,容器 B 就必须比容器 A 先启动,这样一个 Pod 里的 多个容器就不是对等关系,而是拓扑关系了
- Pod底层
    * ![Pod底层](/img/20210707_1.png)
    * Pod 的实现需要使用一个中间容器,这个容器叫作 Infra 容器.在 这个 Pod 中,Infra 容器永远都是第一个被创建的容器,而其他用户定义的容器,则通过 Join Network Namespace 的方式,与 Infra 容器关联在一起.
    * 对于 Pod 里的容器 A 和容器 B 来说
        * 它们可以直接使用 localhost 进行通信;
        * 它们看到的网络设备跟 Infra 容器看到的完全一样;
        * 一个 Pod 只有一个 IP 地址,也就是这个 Pod 的 Network Namespace 对应的 IP 地址;
        * 当然,其他的所有网络资源,都是一个 Pod 一份,并且被该 Pod 中的所有容器共享;
        * Pod 的生命周期只跟 Infra 容器一致,而与容器 A 和 B 无关.
- 容器设计模式
    * WAR 包与 Web 服务器
        * 现在有一个 Java Web 应用的 WAR 包,它需要被放在 Tomcat 的 webapps 目录下运行起来, 如果现在只能用 Docker 来做这件事情,那该如何处理这个组合关系呢
            * 一种方法是,把 WAR 包直接放在 Tomcat 镜像的 webapps 目录下,做成一个新的镜像运行起 来.可是,这时候,如果你要更新 WAR 包的内容,或者要升级 Tomcat 镜像,就要重新制作一 个新的发布镜像,非常麻烦.
            * 另一种方法是,你压根儿不管 WAR 包,永远只发布一个 Tomcat 容器.不过,这个容器的 webapps 目录,就必须声明一个 hostPath 类型的 Volume,从而把宿主机上的 WAR 包挂载进 Tomcat 容器当中运行起来.不过,这样你就必须要解决一个问题,即:如何让每一台宿主机, 都预先准备好这个存储有 WAR 包的目录呢?这样来看,你只能独立维护一套分布式存储系统了.
        * 解决方案
            ```bash
                apiVersion: v1
                kind: Pod
                metadata:
                    name: javaweb-2 
                spec:
                    initContainers:
                    - image: geektime/sample:v2
                        name: war
                        command: ["cp", "/sample.war", "/app"] 
                        volumeMounts:
                        - mountPath: /app
                            name: app-volume
                    containers:
                    - image: geektime/tomcat:7.0
                        name: tomcat
                        command: ["sh","-c","/root/apache-tomcat-7.0.42-v2/bin/start.sh"] 
                        volumeMounts:
                        - mountPath: /root/apache-tomcat-7.0.42-v2/webapps
                            name: app-volume 
                        ports:
                        - containerPort: 8080
                            hostPort: 8001
                    volumes:
                    - name: app-volume
                        emptyDir: {}
            ```
        * 方案解读
            * 在这个 Pod 中,我们定义了两个容器,第一个容器使用的镜像是 geektime/sample:v2,这个镜像 里只有一个 WAR 包(sample.war)放在根目录下.而第二个容器则使用的是一个标准的 Tomcat 镜像.在 Pod 中,所有 Init Container 定义的容器,都会比 spec.containers 定义的用户容器先启动.并 且,Init Container 容器会按顺序逐一启动,而直到它们都启动并且退出了,用户容器才会启动.所以,这个 Init Container 类型的 WAR 包容器启动后,我执行了一句 "cp /sample.war /app", 把应用的 WAR 包拷贝到 /app 目录下,然后退出.而后这个 /app 目录,就挂载了一个名叫 app-volume 的 Volume. 接下来就很关键了.Tomcat 容器,同样声明了挂载 app-volume 到自己的 webapps 目录下.所以,等 Tomcat 容器启动时,它的 webapps 目录下就一定会存在 sample.war 文件:这个文件 正是 WAR 包容器启动时拷贝到这个 Volume 里面的,而这个 Volume 是被这两个容器共享的.
    * 容器的日志收集
        * 有一个应用,需要不断地把日志文件输出到容器的 /var/log 目录中.可以把一个 Pod 里的 Volume 挂载到应用容器的 /var/log 目录上.然后,我在这个 Pod 里同时运行一个 sidecar 容器,它也声明挂载同一个 Volume 到自己的 /var/log 目录上.这样,接下来 sidecar 容器就只需要做一件事儿,那就是不断地从自己的 /var/log 目录里读取日志 文件,转发到 MongoDB 或者 Elasticsearch 中存储起来.这样,一个最基本的日志收集工作就完成了.









