---
title: NFS_基础 (03)
date: 2021-01-12
tags: NFS
toc: true
---

### NFS使用
    NFS与HDFS结合使用

<!-- more -->

#### 学习背景
> 好不容易挂载上了, 但我上传个文件也太费劲了吧. 30MB的文件就超时了？ 人都傻了, 这个问题要是不解决, 之前NFS挂载的方式就不能用了 就要推翻重写了, 快看看怎么提升NFS传输速度吧

#### 测试nfs文件读写速度
- 写
    ```bash
        [root@aaaaa llllljian]# time dd if=/dev/zero of=./hdfs/test.txt bs=8k count=1024
        1024+0 records in
        1024+0 records out
        8388608 bytes (8.4 MB) copied, 93.4429 s, 89.8 kB/s

        real	1m33.477s
        user	0m0.005s
        sys	0m0.058s

        mount -t nfs -o vers=3,nolock,noacl,rsize=65536,wsize=65536,timeo=15,noac 127.0.0.1:/user/hadoop hdfs

        [root@aaaaa llllljian]# time dd if=/dev/zero of=./hdfs/test2.txt bs=8k count=1024
        1024+0 records in
        1024+0 records out
        8388608 bytes (8.4 MB) copied, 0.251554 s, 33.3 MB/s

        real	0m0.281s
        user	0m0.000s
        sys	0m0.016s
    ````
- 读
    ```bash
        [root@aaaaa llllljian]# time dd if=./hdfs/test.txt of=/dev/null bs=8k count=1024
        1024+0 records in
        1024+0 records out
        8388608 bytes (8.4 MB) copied, 2.28505 s, 3.7 MB/s

        real	0m2.289s
        user	0m0.000s
        sys	0m0.032s

        mount -t nfs -o vers=3,nolock,noacl,rsize=65536,wsize=65536,timeo=15,noac 127.0.0.1:/user/hadoop hdfs

        [root@aaaaa llllljian]# time dd if=./hdfs/test.txt of=/dev/null bs=8k count=1024
        1024+0 records in
        1024+0 records out
        8388608 bytes (8.4 MB) copied, 0.00395494 s, 2.1 GB/s

        real	0m0.010s
        user	0m0.001s
        sys	0m0.005s
    ```

#### nfs读写优化
> 如果挂载命令是 mount -o nolock 127.0.0.1:/user/hadoop hdfs传输速度可能很慢, 只有几K到几十K左右, 所以我们要优化
1. 设置块大小
    * 设置risize和wsize参数, risize和wsize指定了server端和client端的传输的块大小
    * 如果没有指定,那么,系统根据nfs的版本来设置缺省的risize和wsize大小.大多数情况是4K
    * 系统缺省的块可能会太大或者太小,这主要取决于你的kernel和你的网卡,太大或者太小都有可能导致nfs 速度很慢
2. 网络传输包的大小
3. nfs挂载的优化
    * timeo:如果超时,客户端等待的时间,以十分之一秒计算
    * retrans：超时尝试的次数
    * bg：后台挂载,很有用
    * hard：如果server端没有响应,那么客户端一直尝试挂载
    * wsize：写块大小
    * rsize：读块大小
    * intr：可以中断不成功的挂载
    * noatime：不更新文件的inode访问时间,可以提高速度
    * async：异步读写
4. nfsd的个数
5. nfsd的队列长度

#### HDFS+NFS挂载之后出现的问题
1. 读hdfs文件有缓存, 需要新建一个文件夹之后才能看到所有的文件夹
    * 挂载的时候指明不需要属性缓存,这样才算是真正的sync了.但是,由此会带来服务性能的损失,缓存内存跟实写硬盘肯定不是一个数量级的
    * 默认情况下 kernel 对文件和目录的属性维护了一份 metadata缓存,文件和目录属性(包括许可权、大小、和时间戳)缓存的目的是减少 NFSPROC_GETATTR 远程过程调用(RPC)的需求.tail -f 的实现是 sleep+fstat 来观察文件属性(主要是文件大小)的变化,然后读入文件并输出.可见,tail -f 是否能实时输出文件内容主要取决于 fstat 的结果,由于 metadata cache 的存在,fstat 轮询到的并不是实时的文件属性.因此,即使在NFS服务器端文件已经更新了,但 tail -f 却没法知道文件已经改动了,于是输出就会出现延时
    * 添加参数 noac, 即attribute caching的简称



