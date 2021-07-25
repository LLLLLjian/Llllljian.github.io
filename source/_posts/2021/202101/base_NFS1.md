---
title: NFS_基础 (01)
date: 2021-01-08
tags: NFS
toc: true
---

### NFS使用
    NFS是啥能干啥

<!-- more -->

#### 学习背景
> 我们的hdfs集群搞好了, docker里使用集群的方式采用nfs挂载的方式, 在线上使用的时候 发现上传文件特别慢, 领导让我测一下读写速度, 嘻嘻嘻, 全是知识点

#### NFS简介
> 网络文件系统(NFS)是一种在网络上的机器间共享文件的方法,文件就如同位于客户的本地硬盘驱动器上一样. Red Hat Linux 既可以是 NFS 服务器也可以是 NFS 客户,这意味着它可以把文件系统导出给其它系统,也可以挂载从其它机器上导入的文件系统

#### NFS优点
1. 本地工作站使用更少的磁盘空间,因为通常的数据可以存放在一台机器上而且可以通过网络访问到.
2. 用户不必在每个网络上机器里头都有一个home目录.Home目录 可以被放在NFS服务器上并且在网络上处处可用.
3. 诸如软驱,CDROM,和 Zip(是指一种高储存密度的磁盘驱动器与磁盘)之类的存储设备可以在网络上面被别的机器使用.

#### NFS组成
1. NFS至少有两个主要部分: 一台服务器和一台(或者更多)客户机.
2. 客户机远程访问存放在服务器上的数据.为了正常工作,一些进程需要被配置并运行.

#### NFS应用
1. 多个机器共享一台CDROM或者其他设备.这对于在多台机器中安装软件来说更加便宜跟方便.
2. 在大型网络中,配置一台中心 NFS 服务器用来放置所有用户的home目录可能会带来便利.这些目录能被输出到网络以便用户不管在哪台工作站上登录,总能得到相同的home目录.
3. 几台机器可以有通用的/usr/ports/distfiles 目录.这样的话,当您需要在几台机器上安装port时,您可以无需在每台设备上下载而快速访问源码

#### 客户端的挂载
1. 通过mount命令挂载
    * 命令
        ```bash
            mkdir /mnt/stb
            mount 192.168.1.162:/home/stb /mnt/stb 
            mount -t nfs 192.168.1.162:/home/stb /mnt/stb -o nolock
        ```
    * NOTE
        * 其中客户端必须有 /mnt/stb目录
        * 在本地文件系统的 /mnt/stb 目录中不应该有子目录
    * mount时出错
        * mount.nfs: Input/output error
            * 在客户端也需启动portmap
        * mount: 192.168.1.111:/utuLinux failed, reason given by server: Permission denied
            * 查看配置文件exports,是否为允许挂载的客户
        * mount: RPC: Unable to receive; errno = No route to host
            * 查看防火墙状态, 确认防火墙为关闭状态
        * mount: RPC: Unable to receive; errno = Connection refused
            * 首先看nfs服务是否开启,其次看rpcbind是否开启,如果rpcbind没有运行,那在重新开启rpcbind后,要再restart nfs服务,因为重启rpcbind已对nfs的一些配置造成影响,需要restart
2. 使用/etc/fstab来挂载NFS

#### mount命令参数
- 命令格式
    * mount [-t vfstype] [-o  options] device dir
- 参数说明
    * -a: 把/etc/fstab中列出的路径全部挂载.
    * -t: 需要mount的类型,如nfs等.
    * -r: 将mount的路径定为read only.
    * -v mount: 过程的每一个操作都有message传回到屏幕上.
    * rsize=n: 在NFS服务器读取文件时NFS使用的字节数,默认值是1 024个字节.
    * wsize=n: 向NFS服务器写文件时NFS使用的字节数,默认值是1 024个字节.
    * timeo=n: 从超时后到第1次重新传送占用的1/7秒的数目,默认值是7/7秒.
    * retry=n: 在放弃后台mount操作之前可以尝试的次数,默认值是7 000次.
    * soft: 使用软挂载的方式挂载系统,若Client的请求得不到回应,则重新请求并传回错误信息.
    * hard: 使用硬挂载的方式挂载系统,该值是默认值,重复请求直到NFS服务器回应.
    * intr: 允许NFS中断文件操作和向调用它的程序返回值,默认不允许文件操作被中断.
    * fg: 一直在提示符下执行重复挂载.
    * bg: 如果第1次挂载文件系统失败,继续在后台尝试执行挂载,默认值是失败后不在后台处理.
    * tcp: 对文件系统的挂载使用TCP,而不是默认的UDP.
- 命令示例
    ```bash
        mount -n -o nolock,rsize=1024,wsize=1024,timeo=15 210.41.141.155:/work/nfs_root /mnt
    ```

