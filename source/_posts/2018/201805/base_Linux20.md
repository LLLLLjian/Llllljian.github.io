---
title: Linux_基础 (20)
date: 2018-05-07
tags: Linux
toc: true
---

### 文件与目录的默认权限与隐藏权限
    有关文件与目录的默认权限与隐藏权限的一些基础

<!-- more -->

#### 文件预设权限
- 获取当前系统的默认预设权限
    ```bash
        umask
        0022
        
        umask -S
        u=rwx,g=rx,o=rx
    ```
- 预设情况
    * 建立文件,没有可执行的权限,666
        * (-rw-rw-rw-) - (-----w--w-) = (-rw-r--r--)
    * 建立目录,权限全部开放,777
        * (drwxrwxrwx) - (d----w--w-) = (drwxr-xr-x)
- 修改
    * 临时修改
        * umask 002
    * 永久修改
        * vim /etc/bashrc
        * source /etc/bashrc

#### 文件隐藏属性
- 查看文件的隐藏属性
    * lsattr [-adR] 文件或目录
    * 显示文件的扩展属性
    * 选项与参数
        * -a 展示隐藏档的属性
        * -d 如果接的是目录,仅列出目录本身的属性而非目录内的档名
        * -R 连同子目录的数据也一并列出来
- 配置文件隐藏属性
    * chattr
        * 命令格式
            * chattr [ -RVf ] [ -v version ] [ mode ] files…
        * 命令功能
            * 改变一个文件的隐藏属性
        * 命令参数
        	* -R 	递归更改目录下所有子目录和文件的属性
            * -V 	显示详细信息
            * -f 	忽略大部分错误信息
            * -v version 	设置文件的档案号码
        * mode
        	* A 	文件的atime(access time)不可被修改,这样可以减少磁盘I/O数量,对于笔记本电脑有利于提高续航能力
            * S 	硬盘I/O同步选项,功能类似sync
            * a 	即append,设定该参数后,只能向文件中添加数据,而不能删除,多用于服务器日志文件安全,只有root才能设定这个属性
            * i 	文件不能被删除、改名、设定链接关系,同时不能写入或新增内容(即使是root用户）.只有root才能设定这个属性
            * c 	即compresse,文件会自动的经压缩后再存储,读取时会自动的解压
            * d 	即no dump,设定文件不能成为dump程序的备份目标
            * j 	即journal,设定此参数使得当通过mount参数”data=ordered”或”data=writeback”挂载的文件系统,文件在写入时会先被记录(在journal中).如果filesystem被设定参数为data=journal,则该参数自动失效
            * s 	即secure,保密选项.设置了s属性的文件在被删除时,其所有数据块会被写入0
            * u 	即undelete,反删除选项.与s相反,文件在被删除时,其所有的数据块都保留着,用户今后可以恢复该文件

#### 文件特殊权限
- SUID
    * Set UID
    * 会出现在文件拥有者权限的执行位上,具有这种权限的文件会在其执行时,使调用者暂时获得该文件拥有者的权限
    * 代码理解
        ```bash
            ls -l /usr/bin/passwd
            -rwsr-xr-x. 1 root root 27832 6月  10 2014 /usr/bin/passwd

            ls -l /etc/shadow  
            ---------- 1 root root 4053 2月  12 10:49 /etc/shadow

            修改密码逻辑
            根据passwd命令文件拥有者执行位上的s,获得了passwd的所有者及root的权限,从而对shadow进行写入操作
        ```
    * 使用SUID前提
        * SUID只对二进制文件有效  
        * 调用者对该文件有执行权  
        * 在执行过程中,调用者会暂时获得该文件的所有者权限  
        * 该权限只在程序执行的过程中有效  
- SGID
    * Set GID
    * 出现在文件所属组权限的执行位上面
    * 在执行过程中获取该文件所属组的权限
    * 代码理解
        ```bash
            mkdir -m 2777 testGID

            ls -al
            drwxrwsrws 2 llllljian llllljian 4096 May 07 17:08 testGID
        ```
- SBIT
    * Sticky Bit
    * 出现在其他用户权限的执行位上
    * 某一个目录拥有SBIT权限时,则任何一个能够在这个目录下建立文件的用户,该用户在这个目录下所建立的文件,只有该用户自己和root可以删除,其他用户均不可以
    * 代码说明
        ```bash
            ls -ld /tmp 
            drwxrwxrwt. 27 root root 4096 5月  07 17:13 /tmp
        ```
- 特殊权限的设定
    * 通过数字设定
        ```bash
            4 为 SUID
            2 为 SGID
            1 为 SBIT

            cd /tmp
            
            创建具有 SUID 的权限
            mkdir -m 4755 test1
            ll test1
            drwsr-xr-x 1 llllljian llllljian 4096 May 07 17:12 test1

            加入具有 SUID 的权限
            touch test2     
            chmod 4755 test2; 
            ll test2
            -rwsr-xr-x 1 llllljian llllljian 0 May 07 17:15 test2

            加入具有 SUID/SGID 的权限
            touch test3 
            chmod 6755 test3; 
            ll test3
            -rwsr-sr-x 1 llllljian llllljian 0 May 07 17:17 test3

            加入 SBIT 的功能
            touch test4 
            chmod 1755 test4
            ll test 4            
            -rwxr-xr-t 1 llllljian llllljian 0 May 07 17:19 test4
            
            具有空的 SUID/SGID 权限
            touch test5 
            chmod 7666 test5;
            ll test5
            -rwSrwSrwT 1 llllljian llllljian 0 May 07 17:21 test5
        ```