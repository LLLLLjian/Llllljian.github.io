---
title: Linux_基础 (26)
date: 2018-05-15
tags: Linux
toc: true
---

### Linux系统常见的压缩命令
    压缩指令很多,且不同的指令所用的压缩技术并不相同,批次之间无法互通压缩/解压文件
    下载到某个压缩文件的时候需要知道该文件是何种压缩指令制作出来的,方便解压

<!-- more -->

#### 常见的压缩文件后缀
- *.Z compress程序压缩的文件
- *.zip zip程序压缩的文件
- *.gz gzip程序压缩的文件
- *.bz2 bzip2程序压缩的文件
- *.xz xz程序压缩的文件
- *.tar tar程序大宝的数据,并没有压缩过
- *.tar.gz tar程序大宝的数据,并且经过gzip的压缩
- *.tar.bz2 tar程序大宝的数据,并且经过bzip2的压缩
- *.tar.xz tar程序大宝的数据,并且经过xz的压缩

#### .gz
- 将文件压缩为 .gz 格式,只能压缩文件：gzip
    * gzip
    * 压缩文件,压缩后格式为.gz
    * 语法： gzip【需要压缩的文件】
    * 压缩后文件格式：.gz
    * 只能压缩文件,不能压缩目录
    * 压缩完后不保留原文件
    * 实例
        ```bash
            gzip 20180515/
            gzip: 20180515/ is a directory -- ignored

            touch testgzip.txt

            gzip testgzip.txt
            
            ll
            总用量 4
            drwxrwxrwx 2 llllljian llllljian  6 5月  15 19:13 20180515
            -rw-rw-r-- 1 llllljian llllljian 59 5月  15 19:55 testgzip.txt.gz
        ```
- 将 .gz 文件解压：gunzip
    * gunzip
    * 将格式为.gz的压缩文件解压
    * 语法： gunzip【压缩文件名】
    * 解压后不保留原文件
    * 实例
        ```bash
            gunzip testgzip.txt.gz
            
            ll
            总用量 4
            drwxrwxrwx 2 llllljian llllljian  6 5月  15 19:13 20180515
            -rw-rw-r-- 1 llllljian llllljian 25 5月  15 19:55 testgzip.txt
        ```

#### .tar.gz
- 将文件或目录压缩为 .tar.gz 格式：tar -zcf
    * tar
    * 将文件压缩为.tar.gz格式
    * 语法： tar 选项【-zcf】【压缩后文件名】【目录】　　　
        * -c 打包
        * -v 显示详细信息
        * -f  指定文件名
        * -z 打包同时压缩
    * 压缩后文件格式：.tar.gz
    * 通过tar压缩后是保留原文件或原目录的
    * 实例
        ```bash
            tar -zvcf 20180515.tar.gz 20180515
            20180515/
            20180515/testtar.txt

            ll
            总用量 4
            drwxrwxrwx 2 llllljian llllljian  24 5月  15 20:06 20180515
            -rw-rw-r-- 1 llllljian llllljian 155 5月  15 20:08 20180515.tar.gz
        ```
- 将 .tar.gz 文件解压：tar -zxf
    * tar
    * 将格式为.tar.gz的压缩文件解压
    * tar 选项【-zxf】【.tar.gz的压缩文件名】【指定解压后的文件存放目录,默认当前目录】
        * -x 解包
        * -v 显示详细信息
        * -f 指定解压文件
        * -z 解压缩
    * 实例
        ```bash
            tar -zxf 20180515.tar.gz
            
            ll
            总用量 4
            drwxrwxr-x 2 llllljian llllljian  24 5月  15 20:06 20180515
            -rw-rw-r-- 1 llllljian llllljian 155 5月  15 20:08 20180515.tar.gz
        ```

#### .zip
- 将文件或目录压缩为 .zip 格式：zip
    * zip
    * 将文件或目录压缩为.zip格式
    * zip 选项【-r】【压缩后文件名】【文件或目录】
        * -r  压缩目录
    * 压缩后文件格式：.zip
    * 通过zip压缩后是保留原文件或原目录的.
- 将 .zip 文件解压：unzip 
    * unzip
    * 将格式为.zip的压缩文件解压
    * unzip【.zip的压缩文件名】
    * unzip解压之后也是保留原文件的

#### .bz2
- 将文件压缩为 .bz2 格式,只能压缩文件：bzip2
    * bzip2
    * 将文件压缩为.bz2 格式
    * 语法： bzip2 选项【-k】 【文件】
        * -k　　产生压缩文件后保留原文件
    * 压缩后文件格式：.bz2
- 将 .bz2 文件解压：bunzip2
    * bunzip2
    * 将格式为.bz2的压缩文件解压
    * 语法：bunzip2 选项【-k】 【压缩文件】
        * -k　　解压缩文件后保留原文件
    * 不加参数k,解压之后不保留原文件
