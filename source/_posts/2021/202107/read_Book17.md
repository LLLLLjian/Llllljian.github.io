---
title: 读书笔记 (17)
date: 2021-07-08
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 深入解析Pod对象(一):基本概念
- pod与container关系
    * Pod看成传统环境里的“机器”、把容器看作是运行在这个“机器”里的“用户程序”
    * Pod 的网络定义: 配置这个“机器”的网卡
    * Pod 的存储定义: 配置这个“机器”的磁盘
    * Pod 的安全定义: 配置这个“机器”的防火墙
    * Pod 的调度: 这台“机器”运行在哪个服务器之上
- Pod重要字段的含义和用法
    * NodeSelector: 是一个供用户将 Pod 与 Node 进行绑定的字段
        ```bash
            # 这样的一个配置,意味着这个 Pod 永远只能运行在携带了“disktype: ssd”标签(Label)的节点 上;否则,它将调度失败.
            apiVersion: v1
            kind: Pod
            ...
            spec:
                nodeSelector:
                    disktype: ssd
        ```
    * NodeName: 一旦 Pod 的这个字段被赋值,Kubernetes 项目就会被认为这个 Pod 已经经过了调 度,调度的结果就是赋值的节点名字.所以,这个字段一般由调度器负责设置,但用户也可以设置 它来“骗过”调度器,当然这个做法一般是在测试或者调试的时候才会用到.
    * HostAliases: 定义了 Pod 的 hosts 文件(比如 /etc/hosts)里的内容
        ```bash
            apiVersion: v1
            kind: Pod
            ...
            spec:
                hostAliases:
                - ip: "10.1.2.3"
                    hostnames:
                    - "foo.remote"
                    - "bar.remote"
            ...

            cat /etc/hosts
            # Kubernetes-managed hosts file. 
            127.0.0.1 localhost
            ...
            10.244.135.10 hostaliases-pod 
            10.1.2.3 foo.remote
            10.1.2.3 bar.remote
        ```
    * shareProcessNamespace: True,意味着这个 Pod 里的容器要共享 PID Namespace
        ```bash
            # 定义了两个容器:一个是 nginx 容器,一个是开启了 tty 和 stdin 的 shell 容器
            apiVersion: v1
            kind: Pod
            metadata:
                name: nginx
            spec:
                shareProcessNamespace: true
                containers:
                - name: nginx
                image: nginx
                - name: shell
                image: busybox
                # 为了能够在 tty 中输入信息,你 还需要同时开启 stdin(标准输入流)
                stdin: true
                # Linux 给用户提供的一个常驻小程 序,用于接收用户的标准输入,返回操作系统的标准输出
                tty: true

            $ kubectl create -f nginx.yaml
            $ kubectl attach -it nginx -c shell
            / # ps ax
            PID USER TIME COMMAND
            1 root
            8 root
            14 101
            15 root
            21 root
            0:00 /pause
            0:00 nginx: master process nginx -g daemon off; 0:00 nginx: worker process
            0:00 sh
            0:00 ps ax
        ```
    * Lifecycle: 它定义的是 Container Lifecycle Hooks.顾名思义,Container Lifecycle Hooks 的作用,是在容器状态发生变化时触发一系列“钩子”.
        ```bash
            apiVersion: v1
            kind: Pod
            metadata:
                name: lifecycle-demo
            spec:
                containers:
                - name: lifecycle-demo-container
                    image: nginx
                    lifecycle:
                        # 在容器启动后,立刻执行一个指定的操作.需要明确的是, postStart 定义的操作,虽然是在 Docker 容器 ENTRYPOINT 执行之后,但它并不严格保证顺序. 也就是说,在 postStart 启动时,ENTRYPOINT 有可能还没有结束.当然,如果 postStart 执行超时或者错误,Kubernetes 会在该 Pod 的 Events 中报出该容器启动 失败的错误信息,导致 Pod 也处于失败的状态.
                        postStart:
                            exec:
                                # 在容器成功启动之后,在 /usr/share/message 里写入了一句“欢迎信 息”
                                command: ["/bin/sh", "-c", "echo Hello from the postStart handler > /usr/share/message"
                        # 容器被杀死之前(比如,收到了 SIGKILL 信号).而需要明 确的是,preStop 操作的执行,是同步的.所以,它会阻塞当前的容器杀死流程,直到这个 Hook 定义操作完成之后,才允许容器被杀死,这跟 postStart 不一样.
                        preStop:
                            exec:
                                # 在这个容器被删除之前,先调用了 nginx 的退出指令 (即 preStop 定义的操作),从而实现了容器的“优雅退出”.
                                command: ["/usr/sbin/nginx","-s","quit"]
        ```
- Pod当前状态pod.status.phase
    1. Pending.这个状态意味着,Pod 的 YAML 文件已经提交给了 Kubernetes,API 对象已经被 创建并保存在 Etcd 当中.但是,这个 Pod 里有些容器因为某种原因而不能被顺利创建.比 如,调度不成功.
    2. Running.这个状态下,Pod 已经调度成功,跟一个具体的节点绑定.它包含的容器都已经创 建成功,并且至少有一个正在运行中.
    3. Succeeded.这个状态意味着,Pod 里的所有容器都正常运行完毕,并且已经退出了.这种情 况在运行一次性任务时最为常见.
    4. Failed.这个状态下,Pod 里至少有一个容器以不正常的状态(非 0 的返回码)退出.这个状 态的出现,意味着你得想办法 Debug 这个容器的应用,比如查看 Pod 的 Events 和日志.
    5. Unknown.这是一个异常状态,意味着 Pod 的状态不能持续地被 kubelet 汇报给 kube- apiserver,这很有可能是主从节点(Master 和 Kubelet)间的通信出现了问题.
