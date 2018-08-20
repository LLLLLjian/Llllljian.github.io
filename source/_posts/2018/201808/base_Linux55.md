---
title: Linux_基础 (55)
date: 2018-08-11
tags: Linux
toc: true
---

### Linux下软件安装
    安装文件名为xxx.tar.gz，软件以源码形式发送的
    安装文件名为xxx.i386.rpm，软件以二进制形式发送的

<!-- more -->

#### 通过压缩包安装
- 首先，将安装文件拷贝至家目录中
    ```bash
        cp xxx.tar.gz ~
    ```
- 由于该文件是被压缩并打包的,应对其解压缩
    ```bash
        cd
        tar xvzf xxx.tar.gz 
    ```
- 执行该命令后，安装文件按路径，解压缩在当前目录下.用ls命令可以看到解压缩后的文件.通常在解压缩后产生的文件中，有“Install”的文件.该文件为纯文本文件，详细讲述了该软件包的安装方法
- 执行解压缩后产生的一个名为configure的可执行脚本程序.它是用于检查系统是否有编译时所需的库，以及库的版本是否满足编译的需要等安装所需要的系统信息.为随后的编译工作做准备
    ```bash
        cd xxx
        ./configure 
    ```
- 检查通过后，将生成用于编译的MakeFile文件.此时，可以开始进行编译了.编译的过程视软件的规模和计算机性能的不同，所耗费的时间也不同
    ```bash
        make
    ```
- 成功编译后，键入如下的命令开始安装
    ```bash
        make install
    ```
- 安装完毕，应清除编译过程中产生的临时文件和配置过程中产生的文件.键入如下命令
    ```bash
        make clean
        make distclean 
    ```


#### 通过二进制文件安装
- eg
    ```bash
        rpm -i filename.i386.rpm 
    ```

#### configure命令详解
    configure一般是tar.gz包里面的一个可执行文件，./configure是执行它，其作用就是根据系统情况自动生成编译时所需的Makefile文件
- 查看所有的配置选项
    ```bash
        ./configure  --help
    ```
- 配置选项说明
    * --prefix=PREFIX
        * 配置安装的路径，如果不配置该选项，安装后可执行文件默认放在/usr /local/bin，库文件默认放在/usr/local/lib，配置文件默认放在/usr/local/etc，其它的资源文件放在/usr /local/share
    * -–with
        * 提供一些需要与新安装的软件包交互的软件包的位置
    * -–enable
        * 生成链接库
    * -–without
        * 不让新安装的软件包与系统已有的软件包交互
    * -–disable
        * 关闭额外的运行库文件
- php编译安装configure一些参数详解
    ```bash
        ./configure
        # 指定php安装目录
        --prefix=/usr/local/php728
        # 指定php.ini位置
        --with-config-file-path=/usr/local/php728
        # 整合apache,apxs功能是使用mod_so中的LoadModule指令,加载指定模块到apache,要求apache要打开SO模块
        --with-apxs2=/usr/local/apache/bin/apxs
        # 打开对png图片的支持
        --with-png-dir
        # 打开gd库的支持 
        --with-gd 
        # 打开对jpeg图片的支持
        --with-jpeg-dir=/usr 
        # 打开libxml2库的支持
        --with-libxml-dir=/usr 
        --with-mysqli=mysqlnd 
        --with-pdo-mysql=mysqlnd
        # 打开pear命令的支持，PHP扩展用的
        --with-pear
        # 打开zlib库的支持，用于http压缩传输
        --with-zlib
        # 打开curl浏览工具的支持 
        --with-curl
        # 关闭iconv函数，字符集间的转换 
        --with-iconv
        # openssl的支持，加密传输https时用到的
        --with-openssl 
        --enable-cli 
        --enable-dba 
        --enable-zip
        --enable-fpm 
        --enable-xml 
        --enable-ftp 
        --enable-soap 
        --enable-pcntl 
        --enable-bcmath 
        --enable-opcache 
        --enable-sockets 
        --enable-mbstring
    ```



