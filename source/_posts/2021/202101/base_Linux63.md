---
title: Linux_基础 (63)
date: 2021-01-13
tags: Linux
toc: true
---

### Linux积累
    磁盘读写测速需要使用的命令dd

<!-- more -->

#### dd命令详解
> dd是Linux/UNIX 下的一个非常有用的命令,作用是用指定大小的块拷贝一个文件,并在拷贝的同时进行指定的转换,所以可以用来测试硬盘的顺序读写能力.可以写文件,可以写裸设备
- 功能说明
    * 读取,转换并输出数据
- 语法
    * dd \[bs=<字节数>]\[cbs=<字节数>]\[conv=<关键字>]\[count=<区块数>]\[ibs=<字节数>]\[if=<文件>]\[obs=<字节数>]\[of=<文件>]\[seek=<区块数>]\[skip=<区块数>]\[--help]\[--version]
- 参数说明
    * bs=<字节数>   将ibs( 输入)与obs(输出)设成指定的字节数.
    * cbs=<字节数>   转换时,每次只转换指定的字节数.
    * conv=<关键字>   指定文件转换的方式.
    * count=<区块数>   仅读取指定的区块数.
    * ibs=<字节数>   每次读取的字节数.
    * if=<文件>   从文件读取.
    * obs=<字节数>   每次输出的字节数.
    * of=<文件>   输出到文件.
    * seek=<区块数>   一开始输出时,跳过指定的区块数.
    * skip=<区块数>   一开始读取时,跳过指定的区块数.
    * --help   帮助.
    * --version   显示版本信息
- 参数详解
    * if=xxx  从xxx读取,如if=/dev/zero,该设备无穷尽地提供0,(不产生读磁盘IO)
    * of=xxx  向xxx写出,可以写文件,可以写裸设备.如of=/dev/null,"黑洞",它等价于一个只写文件. 所有写入它的内容都会永远丢失. (不产生写磁盘IO)
    * bs=8k  每次读或写的大小,即一个块的大小.
    * count=xxx  读写块的总数量
- eg
    * 测试方式: 使用dd指令,对磁盘进行连续写入,不使用内存缓冲区,每次写入8k的数据,总共写入20万次,产生1.6G大小的文件.
    * 测试指令: dd if=/dev/zero of=/data01/test.dbf bs=8k count=200000 conv=fdatasync

#### 应用实例
1. 将本地的/dev/hdb整盘备份到/dev/hdd
    ```bash
        dd if=/dev/hdb of=/dev/hdd
    ```
2. 将/dev/hdb全盘数据备份到指定路径的image文件
    ```bash
        dd if=/dev/hdb of=/root/image
    ```
3. 将备份文件恢复到指定盘
    ```bash
        dd if=/root/image of=/dev/hdb
    ```
4. 备份/dev/hdb全盘数据,并利用gzip工具进行压缩,保存到指定路径
    ```bash
        dd if=/dev/hdb | gzip > /root/image.gz
    ```
5. 将压缩的备份文件恢复到指定盘
    ```bash
        gzip -dc /root/image.gz | dd of=/dev/hdb
    ```
6. 测试磁盘的读写速度
    ```bash
        dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file
        dd if=/root/1Gb.file bs=64k | dd of=/dev/null
    ```

#### /dev/null和/dev/zero的区别
> /dev/null,外号叫无底洞,你可以向它输出任何数据,它通吃,并且不会撑着！
/dev/zero,是一个输入设备,你可你用它来初始化文件.该设备无穷尽地提供0,可以使用任何你需要的数目——设备提供的要多的多.他可以用于向设备或文件写入字符串0.
/dev/null——它是空设备,也称为位桶(bit bucket).任何写入它的输出都会被抛弃.如果不想让消息以标准输出显示或写入文件,那么可以将消息重定向到位桶


