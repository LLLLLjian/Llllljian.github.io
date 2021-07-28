---
title: 读书笔记 (13)
date: 2021-07-02
tags: Book
toc: true
---

### 还是要多读书鸭
    深入剖析kubernetes读书笔记

<!-- more -->

#### 故事背景
> 我只会docker run, 还是要深入的看看底层的知识, 高T给推荐了一本书, 写一写读书笔记

#### 白话容器基础(一):从进程说开去
- 创建一个容器进行分析
    ```bash
        docker run -it busybox /bin/bash
        ps
        PID USER TIME COMMAND
        1 root 0:00 /bin/bash
        10 root 0:00 ps
    ```
    * 分析
        1. 请帮我启动一个容器, 在容器里执行 /bin/sh, 并且给我分配一个命令行终端跟这个容器交互
        2. 在 Docker 里最开始执行的 /bin/sh, 就是这个容器内部的第 1 号进程 (PID=1), 而这个容器里一共只有两个进程在运行.这就意味着, 前面执行的 /bin/sh, 以及 我们刚刚执行的 ps, 已经被 Docker 隔离在了一个跟宿主机完全不同的世界当中
        3. 本来, 每当我们在宿主机上运行了一个 /bin/sh 程序, 操作系统都会给它分配一个进程编号, 比 如 PID=100.这个编号是进程的唯一标识, 就像员工的工牌一样.所以 PID=100, 可以粗略地 理解为这个 /bin/sh 是我们公司里的第 100 号员工, 而第 1 号员工就自然是比尔 · 盖茨这样统 领全局的人物.而现在, 我们要通过 Docker 把这个 /bin/sh 程序运行在一个容器当中.这时候, Docker 就会 在这个第 100 号员工入职时给他施一个“障眼法”, 让他永远看不到前面的其他 99 个员工,  更看不到比尔 · 盖茨.这样, 他就会错误地以为自己就是公司里的第 1 号员工.这种机制, 其实就是对被隔离应用的进程空间做了手脚, 使得这些进程只能看到重新计算过的进 程编号, 比如 PID=1.可实际上, 他们在宿主机的操作系统里, 还是原来的第 100 号进程.
        4. 这种技术, 就是 Linux 里面的 Namespace 机制.而 Namespace 的使用方式也非常有意思: 它其实只是 Linux 创建新进程的一个可选参数.我们知道, 在 Linux 系统中创建线程的系统调用是 clone(), 比如: **int pid = clone(main_function, stack_size, SIGCHLD, NULL);** 这个系统调用就会为我们创建一个新的进程, 并且返回它的进程号 pid.而当我们用 clone() 系统调用创建一个新进程时, 就可以在参数中指定 CLONE_NEWPID 参 数, 比如:**int pid = clone(main_function, stack_size, CLONE_NEWPID | SIGCHLD, NULL);** 这时, 新创建的这个进程将会“看到”一个全新的进程空间, 在这个进程空间里, 它的 PID 是 1.之所以说“看到”, 是因为这只是一个“障眼法”, 在宿主机真实的进程空间里, 这个进程 的 PID 还是真实的数值, 比如 100.当然, 我们还可以多次执行上面的 clone() 调用, 这样就会创建多个 PID Namespace, 而每个 Namespace 里的应用进程, 都会认为自己是当前容器里的第 1 号进程, 它们既看不到宿主机 里真正的进程空间, 也看不到其他 PID Namespace 里的具体情况.
        5. 而除了我们刚刚用到的 PID Namespace, Linux 操作系统还提供了 Mount、UTS、IPC、 Network 和 User 这些 Namespace, 用来对各种不同的进程上下文进行“障眼法”操作.比如, Mount Namespace, 用于让被隔离进程只看到当前 Namespace 里的挂载点信息; Network Namespace, 用于让被隔离进程看到当前 Namespace 里的网络设备和配置.


#### 白话容器基础(二):隔离与限制
- 为什么Docker项目比虚拟机更受欢迎
    * 因为使用虚拟化技术作为应用沙盒, 就必须要由 Hypervisor 来负责创建虚拟机, 这个虚 拟机是真实存在的, 并且它里面必须运行一个完整的 Guest OS 才能执行用户的应用进程.这就 不可避免地带来了额外的资源消耗和占用.根据实验, 一个运行着 CentOS 的 KVM 虚拟机启动后, 在不做优化的情况下, 虚拟机自己就 需要占用 100~200 MB 内存.此外, 用户应用运行在虚拟机里面, 它对宿主机操作系统的调用 就不可避免地要经过虚拟化软件的拦截和处理, 这本身又是一层性能损耗, 尤其对计算资源、网 络和磁盘 I/O 的损耗非常大.
    * 而相比之下, 容器化后的用户应用, 却依然还是一个宿主机上的普通进程, 这就意味着这些因为 虚拟化而带来的性能损耗都是不存在的;而另一方面, 使用 Namespace 作为隔离手段的容器 并不需要单独的 Guest OS, 这就使得容器额外的资源占用几乎可以忽略不计
    * 总结一下: **敏捷**和**高性能**是容器相较于虚拟机最大的优势, 但是**隔离得不彻底**是它最大的问题(在容器内使用top, 会看到宿主机的CPU和内存数据, 造成这个问题的原因就是, /proc 文件系统并不知道用户通过 Cgroups 给这个容器做了什么样 的资源限制, 即:/proc 文件系统不了解 Cgroups 限制的存在)
- 重新理解cgroups
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 20:12:53 #2]$ while : ; do : ; done &
        [1] 24376

        [llllljian@llllljian-cloud-tencent ~ 20:13:24 #3]$ top
        PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
        24376 lllllji+  20   0   21784   2060      0 R 97.0  0.2   0:17.74 bash

        # ubuntu
        [llllljian@llllljian-cloud-tencent ~ 20:15:48 #7]$ cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us
        -1
        [llllljian@llllljian-cloud-tencent ~ 20:18:12 #8]$ cat /sys/fs/cgroup/cpu/cpu.cfs_period_us
        100000

        # Centos
        # $ cat /sys/fs/cgroup/cpu/container/cpu.cfs_quota_us
        # -1
        # $ cat /sys/fs/cgroup/cpu/container/cpu.cfs_period_us
        # 100000

        # 在每 100 ms 的时间里, 被该控制组 限制的进程只能使用 20 ms 的 CPU 时间, 也就是说这个进程只能使用到 20% 的 CPU 带宽
        [llllljian@llllljian-cloud-tencent ~ 20:18:32 #9]$ echo 20000 > /sys/fs/cgroup/cpu/cpu.cfs_quota_us

        # 把被限制的进程的 PID 写入 container 组里的 tasks 文件, 上面的设置就会对该 进程生效了
        [llllljian@llllljian-cloud-tencent ~ 20:18:40 #9]$ echo 24376 > /sys/fs/cgroup/cpu/tasks

        [llllljian@llllljian-cloud-tencent ~ 20:20:22 #10]$ top
        PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
        24376 lllllji+  20   0   21784   2060      0 R 20.0  0.2   0:17.74 bash
    ```
    * 通过 cpu share 可以设置容器使用 CPU 的优先级
        ```bash
            # container_A 的 cpu share 1024, 是 container_B 的两倍.当两个容器都需要 CPU 资源时, container_A 可以得到的 CPU 是 container_B 的两倍.
            # 需要特别注意的是, 这种按权重分配 CPU 只会发生在 CPU 资源紧张的情况下.如果 container_A 处于空闲状态, 这时, 为了充分利用 CPU 资源, container_B 也可以分配到全部可用的 CPU
            docker run --name"container_A" -c 1024 ubuntu
  
            docker run --name"container_B" -c 512 ubuntu
        ```
    * 限制cpu配额
        ```bash
            # 只能使用到 20% 的 CPU 带宽
            docker run -d --cpu-period=100000 --cpu-quota=20000 --name test-c1 nginx:latest
        ```
    * 限制cpu可用数量
        ```bash
            # 参数通过--cpus=<value>指定, 意思限制可用cpu个数, 列如--cpus=2.5表示该容器可使用的cpu个数最多是2.5个
            docker run -d --cpus=2 --name test-c2 nginx:latest
        ```
    * 使用固定的cpu
        ```bash
            # 通过--cpuset-cpus参数指定, 表示指定容器运行在某个或某些个固定的cpu上, 多个cpu使用逗号隔开.例如四个cpu, 0代表第一个cpu, --cpuset-cpus=1,3代表该容器只能运行在第二个或第四个cpu上.查看cpu可以通过cat /proc/cpuinfo查看.
            docker run -d --cpuset-cpus=1,3 --name test-c3 nginx:latest
        ```



