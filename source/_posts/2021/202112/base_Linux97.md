---
title: Linux_基础 (97)
date: 2021-12-08
tags: Linux
toc: true
---

### Linux积累
    磁盘、内存、CPU

<!-- more -->

#### 前情提要
> 管了这么多机器, 得会查看机器的状态呀.系统的记录一下

##### 磁盘
- 查看磁盘信息
    ```bash
        df -h

        # Filesystem: 文件系统
        # Size:  分区大小
        # Used:  已使用容量
        # Avail:  还可以使用的容量
        # Use%:  已用百分比
        # Mounted on:  挂载点
    ```
- 查看文件夹大小
    ```bash
        # 查看当前目录下所有目录以及子目录的大小
        du -h .

        # 只深入到第0(n)层目录
        du -h --max-depth=0 user

        # 往下1层目录的磁盘大小并排序
        du -h --max-depth=1 | sort -nr
    ```

##### 内存/CPU
- top
    * 查看内存占用情况
    * PID: 当前运行进程的ID
    * USER: 进程所属用户
    * PR: 进程优先级
    * NInice: 反应一个进程“优先级”状态的值
    * VIRT: 进程占用的虚拟内存
    * RES: 进程占用的物理内存
    * SHR: 进程使用的共享内存
    * S: 进程的状态.S表示休眠,R表示正在运行,Z表示僵死状态,N表示该进程优先值为负数
    * %CPU: 进程占用CPU的使用率
    * %MEM: 进程使用的物理内存和总内存的百分比
    * TIME+: 该进程启动后占用的总的CPU时间,即占用CPU使用时间的累加值.
    * COMMAND: 进程启动命令名称
- free
    * 显示内存状态
    * Mem: 内存的使用情况
    * -/+ buffers/cache: 表示物理内存已用多少,可用多少
    * Swap: 交换空间的使用情况
    * total: 总量
    * used: 已使用的
    * free: 空闲的
    * shared: 共享的,在linux里面有很多共享内存,比如一个libc库,很多程序调用,但实际只存一份
    * buffers: 缓存,可回收
    * cached: 缓存,可回收
- ps aux
    * a 显示现行终端机下的所有进程,包括其他用户的进程
    * x 通常与 a 这个参数一起使用,可列出较完整信息
    * u 以用户为主的进程状态
    * USER: 该 process 属于那个使用者账号的
    * PID: 该 process 的号码
    * %CPU: 该 process 使用掉的 CPU 资源百分比
    * %MEM: 该 process 所占用的物理内存百分比
    * VSZ: 该 process 使用掉的虚拟内存量 (Kbytes)
    * RSS: 该 process 占用的固定的内存量 (Kbytes)
    * TTY: 该 process 是在那个终端机上面运作,若与终端机无关,则显示 ?,另外, tty1-tty6 是本机上面的登入者程序,若为 pts/0 等等的,则表示为由网络连接进主机的程序.
    * STAT: 该程序目前的状态,主要的状态有
        * R: 该程序目前正在运作,或者是可被运作
        * S: 该程序目前正在睡眠当中 (可说是 idle 状态),但可被某些讯号 (signal) 唤醒.
        * T: 该程序目前正在侦测或者是停止了
        * Z: 该程序应该已经终止,但是其父程序却无法正常的终止他,造成 zombie (疆尸) 程序的状态
    * START: 该 process 被触发启动的时间
    * TIME : 该 process 实际使用 CPU 运作的时间
    * COMMAND: 该程序的实际指令
- cat /proc/meminfo








