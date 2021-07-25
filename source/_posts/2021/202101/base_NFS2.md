---
title: NFS_基础 (02)
date: 2021-01-11
tags: NFS
toc: true
---

### NFS使用
    NFS与HDFS结合使用

<!-- more -->

#### 学习背景
> hdfs集群已经准备好了, 可是我该怎么使用呢. 在命令中访问HDFS路径的话确实有些繁琐, 那么有没有一种工具可以将HDFS上的空间映射到linux本地磁盘上, 然后再进行操作呢? 有呀, 人领导告诉我了, HDFS服务中的NFS Gateway组件就可以实现

#### HDFS NFS Gateway简介
> HDFS的NFS网关允许客户端挂载HDFS并通过NFS与其进行交互,就像它是本地文件系统的一部分一样.网关支持NFSv3.
- 安装HDFS后,用户可以：
    1. 在NFSv3客户端兼容的操作系统上通过其本地文件系统浏览HDFS文件系统.
    2. 在HDFS文件系统和本地文件系统之间上载和下载文件.
    3. 通过挂载点将数据直接传输到HDFS.(支持文件追加,但不支持随机写入.)
- 图片说明
    * ![PHP常量](/img/20210111_1.png)

#### HDFS+NFS启动与停止
1. 使用root用户停止nfs和rpcbind
    ```bash
        [root]> service nfs stop
        [root]> service rpcbind stop
    ```
2. 使用root用户开启portmap
    ```bash
        [root]> \$HADOOP_HOME/bin/hdfs --daemon start portmap
    ```
3. 开启NFS
    ```bash
        [hdfs]$ \$HADOOP_HOME/bin/hdfs --daemon start nfs3
    ```
4. 关闭NFS
    ```bash
        [hdfs]$ \$HADOOP_HOME/bin/hdfs --daemon stop nfs3
        [root]> \$HADOOP_HOME/bin/hdfs --daemon stop portmap
    ```

#### 客户端挂载
- eg
    ```bash
        # $server是NFSGateway所在的主机,$mount_point代表挂载点
        [root]>mount -t nfs -o vers=3,proto=tcp,nolock,sync,rsize=1048576,wsize=1048576 \$server:/ \$mount_point
    ```

#### 客户端卸载
- eg
    ```bash
        [root]>umount -l \$mount_point
    ```

