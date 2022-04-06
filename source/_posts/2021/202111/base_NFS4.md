---
title: NFS_基础 (04)
date: 2021-11-08
tags: NFS
toc: true
---

### NFS使用
    解决NFS卡住的问题

<!-- more -->

#### 学习背景
> NFS+HDFS 用的用的发现卡住了, 得解决问题呀, 要不系统也不能用了

#### 现象描述
> df -h的时候直接卡住了, ls、umount都不行
- 问题原因
    * 当时在 /var/log/messages 目录下找到了 NFS server hostname not responding, still trying 关键字, 网上查询了之后确认是nfs服务器/网络挂了
    * nfs客户端默认采用hard-mount选项, 而不是soft-mount. 他们的区别是 **soft-mount**: 当客户端加载NFS不成功时, 重试retrans设定的次数.如果retrans次都不成功, 则放弃此操作, 返回错误信息 "Connect time out"; **hard-mount**: 当客户端加载NFS不成功时,一直重试, 直到NFS服务器有响应. hard-mount 是系统的缺省值. 在选定hard-mount 时, 最好同时选 intr , 允许中断系统的调用请求, 避免引起系统的挂起. 当NFS服务器不能响应NFS客户端的 hard-mount请求时,  NFS客户端会显示"NFS server hostname not responding, still trying"
- 解决前提, 多了解一下NFS参数
    * -a: 把/etc/fstab中列出的路径全部挂载. 
    * -t: 需要mount的类型, 如nfs等. 
    * -r: 将mount的路径定为read only. 
    * -v mount: 过程的每一个操作都有message传回到屏幕上. 
    * rsize=n: 在NFS服务器读取文件时NFS使用的字节数, 默认值是4096个字节. 
    * wsize=n: 向NFS服务器写文件时NFS使用的字节数, 默认值是4096个字节. 
    * timeo=n: 从超时后到第1次重新传送占用的1/7秒的数目, 默认值是7/7秒. 
    * retry=n: 在放弃后台mount操作之前可以尝试的次数, 默认值是7 000次. 
    * soft: 使用软挂载的方式挂载系统, 若Client的请求得不到回应, 则重新请求并传回错误信息. 
    * hard: 使用硬挂载的方式挂载系统, 该值是默认值, 重复请求直到NFS服务器回应. 
    * intr: 允许NFS中断文件操作和向调用它的程序返回值, 默认不允许文件操作被中断. 
    * fg: 一直在提示符下执行重复挂载. 
    * bg: 如果第1次挂载文件系统失败, 继续在后台尝试执行挂载, 默认值是失败后不在后台处理. 
    * tcp: 对文件系统的挂载使用TCP, 而不是默认的UDP. 

#### NFS服务器的故障排除
- 故障排除思路:
    1. NFS客户机和服务器的负荷是否太高, 服务器和客户端之间的网络是否正常. 
    2. /etc/exports文件的正确性. 
    3. 必要时重新启动NFS或portmap服务. 
        * 运行下列命令重新启动portmap和NFS: 
        * service portmap restart
        * service nfs start
    4. 检查客户端中的mount命令或/etc/fstab的语法是否正确. 
    5. 查看内核是否支持NFS和RPC服务






