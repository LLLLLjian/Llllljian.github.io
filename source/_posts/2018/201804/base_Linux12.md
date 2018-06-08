---
title: Linux_基础 (12)
date: 2018-04-25
tags: Linux
toc: true
---

### ln命令
    可以通过ln对不同的文档之间创建连接关系

<!-- more -->

#### 命令格式
     ln [参数][源文件或目录][目标文件或目录]

#### 命令功能
- 软连接
    * 软链接,以路径的形式存在.类似于Windows操作系统中的快捷方式
    * 软链接可以 跨文件系统 ,硬链接不可以
    * 软链接可以对一个不存在的文件名进行链接
    * 软链接可以对目录进行链接
- 硬连接
    * 硬链接,以文件副本的形式存在.但不占用实际空间.
    * 不允许给目录创建硬链接
    * 硬链接只有在同一个文件系统中才能创建
- 注意
    * ln命令会保持每一处链接文件的同步性
    * 软链接相当于Windows的快捷方式,不会占磁盘空间
    * 硬链接会生成一个和源文件大小相同的文件

#### 命令参数
- 必要参数
    * -b 删除,覆盖以前建立的链接
	* -d 允许超级用户制作目录的硬链接
	* -f 强制执行
	* -i 交互模式,文件存在则提示用户是否覆盖
	* -n 把符号链接视为一般目录
	* -s 软链接(符号链接)
	* -v 显示详细的处理过程
- 选择参数
	* -S “-S<字尾备份字符串> ”或 “--suffix=<字尾备份字符串>”
	* -V “-V<备份方式>”或“--version-control=<备份方式>”
	* --help 显示帮助信息
	* --version 显示版本信息 

#### 使用实例
- 软链接创建
    ```bash
        创建文件1.txt 并写入当前时间
        vim 1.txt

        cat 1.txt
        2018年4月25日21:25:52

        软链接
        ln -s 1.txt 2.txt

        ll
        总用量 16
        drwxrwxrwx 3 root      root      4096 4月  25 21:19 ./
        drwxrwxrwx 3 root      root      4096 4月  25 20:31 ../
        drwxrwxrwx 2 root      root      4096 4月  25 20:32 0425_1_1/
        -rw-rw-r-- 1 llllljian llllljian   25 4月  25 21:18 1.txt
        lrwxrwxrwx 1 llllljian llllljian    5 4月  25 21:19 2.txt -> 1.txt

        查看软链接 文件2.txt的内容
        cat 2.txt
        2018年4月25日21:25:52

        修改软链接 文件2.txt的内容
        vim 2.txt

        cat 2.txt
        2018年4月25日21:25:52
        2018年4月25日21:28:03

        查看软链接 文件1.txt的内容
        cat 1.txt
        2018年4月25日21:25:52
        2018年4月25日21:28:03

        对已有文件进行软链接
        touch 3.txt
        ln -s 1.txt 3.txt
        ln: 无法创建符号链接'3.txt': 文件已存在

        相对路径进行软链接
        ln -s 1.txt /home/0425test/0425_1/0425_1_1/1.txt

        cd 0425_1_1/

        ll
        总用量 8
        drwxrwxrwx 2 root      root      4096 4月  25 21:24 ./
        drwxrwxrwx 3 root      root      4096 4月  25 21:22 ../
        lrwxrwxrwx 1 llllljian llllljian    5 4月  25 21:24 1.txt -> 1.txt

        相对路径软链接报错
        cat 1.txt
        cat: 1.txt: 符号连接的层数过多

        绝对路径进行软链接
        ln -sv /home/0425test/0425_1/1.txt /home/0425test/0425_1/0425_1_1/2.txt 
        '/home/0425test/0425_1/0425_1_1/2.txt' -> '/home/0425test/0425_1/1.txt'

        ll
        总用量 8
        drwxrwxrwx 2 root      root      4096 4月  25 21:31 ./
        drwxrwxrwx 3 root      root      4096 4月  25 21:22 ../
        lrwxrwxrwx 1 llllljian llllljian    5 4月  25 21:24 1.txt -> 1.txt
        lrwxrwxrwx 1 llllljian llllljian   27 4月  25 21:31 2.txt -> /home/0425test/0425_1/1.txt

        绝对路径软链接成功
        cat 2.txt
        2018年4月25日21:25:52
        2018年4月25日21:28:03

        对目录进行软链接
        ln -sv /home/0425test/0425_1/0425_1_1/ /home/0413test/
        '/home/0413test/0425_1_1' -> '/home/0425test/0425_1/0425_1_1/'

        pwd
        /home/0425test/0425_1/0425_1_1

        ll
        总用量 8
        drwxrwxrwx 2 root      root      4096 4月  25 21:44 ./
        drwxrwxrwx 3 root      root      4096 4月  25 21:22 ../
        lrwxrwxrwx 1 llllljian llllljian    5 4月  25 21:24 1.txt -> 1.txt
        lrwxrwxrwx 1 llllljian llllljian   27 4月  25 21:31 2.txt -> /home/0425test/0425_1/1.txt

        pwd
        /home/0413test

        ll
        总用量 36
        drwxrwxrwx 3 root      root      4096 4月  25 21:45 ./
        drwxr-xr-x 5 root      root      4096 4月  25 20:29 ../
        drwxrwxr-x 2 llllljian llllljian 4096 4月  13 16:47 0413_1/
        lrwxrwxrwx 1 llllljian llllljian   31 4月  25 21:45 0425_1_1 -> /home/0425test/0425_1/0425_1_1//
        -rwxr-xr-x 1 llllljian llllljian    8 4月  13 13:20 1.txt*
        -rw-rw-r-- 1 root      root         9 4月  13 13:24 2.txt
        -rwxrwxrwx 1 llllljian llllljian    0 4月  13 14:38 3_1.txt*
        -rwxrwxrwx 1 root      llllljian   25 4月  13 19:34 3_2.txt*
        -rwxrwxrwx 1 root      llllljian   25 4月  13 19:42 3_3.txt*
        -rwxrwxrwx 1 root      llllljian   25 4月  13 16:06 3.txt*
        -rw-r--r-- 1 llllljian root        26 4月  13 20:45 4.txt

        cd 0425_1_1

        ll
        总用量 8
        drwxrwxrwx 2 root      root      4096 4月  25 21:44 ./
        drwxrwxrwx 3 root      root      4096 4月  25 21:22 ../
        lrwxrwxrwx 1 llllljian llllljian    5 4月  25 21:24 1.txt -> 1.txt
        lrwxrwxrwx 1 llllljian llllljian   27 4月  25 21:31 2.txt -> /home/0425test/0425_1/1.txt

        pwd
        /home/0413test/0425_1_1
    ```
- 硬链接创建
    ```bash
        ls -i可以查看文件的inode number.硬链接文件的inode number才相同
        硬链接和原文件是无法区分的
        ll的第二列或者ll -i的第三列大于2的说明该文件是硬链接

        硬链接目录失败
        ln /home/0425test/ /home/0413test/
        ln: /home/0425test/: 不允许将硬链接指向目录

        vim 3.txt
        cat 3.txt
        2018年4月25日22:00:36

        ln 3.txt 4.txt
        
        cat 4.txt
        2018年4月25日22:00:36
        
        4.txt和3.txt是硬链接文件
        ll -i
        总用量 16
        269531 drwxrwxrwx 2 root      root      4096 4月  25 21:54 ./
        269528 drwxrwxrwx 3 root      root      4096 4月  25 21:22 ../
        269536 lrwxrwxrwx 1 llllljian llllljian    5 4月  25 21:24 1.txt -> 1.txt
        269538 lrwxrwxrwx 1 llllljian llllljian   27 4月  25 21:31 2.txt -> /home/0425test/0425_1/1.txt
        269548 -rw-rw-r-- 2 llllljian llllljian   25 4月  25 21:53 3.txt
        269548 -rw-rw-r-- 2 llllljian llllljian   25 4月  25 21:53 4.txt

        复制文件的inode number也不相同
        cp 4.txt 4_1.txt
        ll -i
        总用量 20
        269531 drwxrwxrwx 2 root      root      4096 4月 25 22:03 ./
        269528 drwxrwxrwx 3 root      root      4096 4月 25 21:22 ../
        269536 lrwxrwxrwx 1 llllljian llllljian    5 4月 25 21:24 1.txt -> 1.txt
        269538 lrwxrwxrwx 1 llllljian llllljian   27 4月 25 21:31 2.txt -> /home/0425test/0425_1/1.txt
        269548 -rw-rw-r-- 2 llllljian llllljian   25 4月 25 21:53 3.txt
        269550 -rw-rw-r-- 1 llllljian llllljian   25 4月 25 22:03 4_1.txt
        269548 -rw-rw-r-- 2 llllljian llllljian   25 4月 25 21:53 4.txt

        查找inode number为 269548 的硬链接文件
        find -inum 269548
        ./4.txt
        ./3.txt
    ```
- 查找软链接文件
    ```bash
        ls -lR / 2> /dev/null | grep /home/0425test/
        lrwxrwxrwx 1 llllljian llllljian   31 4月 25 21:45 0425_1_1 -> /home/0425test/0425_1/0425_1_1/
        /home/0425test/0425_1:
        /home/0425test/0425_1/0425_1_1:
        lrwxrwxrwx 1 llllljian llllljian 27 4月 25 21:31 2.txt -> /home/0425test/0425_1/1.txt
        lrwxrwxrwx 1 llllljian llllljian 0 4月 25 22:12 cwd -> /home/0425test/0425_1/0425_1_1
        lrwxrwxrwx 1 llllljian llllljian 0 4月 25 22:12 cwd -> /home/0425test/0425_1/0425_1_1
        
        cd /home/0413test/
        ll
        总用量 36
        drwxrwxrwx 3 root      root      4096 4月 25 21:45 ./
        drwxr-xr-x 5 root      root      4096 4月 25 20:29 ../
        drwxrwxr-x 2 llllljian llllljian 4096 4月  13 16:47 0413_1/
        lrwxrwxrwx 1 llllljian llllljian   31 4月 25 21:45 0425_1_1 -> /home/0425test/0425_1/0425_1_1//
        -rwxr-xr-x 1 llllljian llllljian    8 4月  13 13:20 1.txt*
        -rw-rw-r-- 1 root      root         9 4月  13 13:24 2.txt
        -rwxrwxrwx 1 llllljian llllljian    0 4月  13 14:38 3_1.txt*
        -rwxrwxrwx 1 root      llllljian   25 4月  13 19:34 3_2.txt*
        -rwxrwxrwx 1 root      llllljian   25 4月  13 19:42 3_3.txt*
        -rwxrwxrwx 1 root      llllljian   25 4月  13 16:06 3.txt*
        -rw-r--r-- 1 llllljian root        26 4月  13 20:45 4.txt
        
        cd /home/0425test/0425_1/0425_1_1/
        ll
        总用量 20
        drwxrwxrwx 2 root      root      4096 4月 25 22:03 ./
        drwxrwxrwx 3 root      root      4096 4月 25 22:12 ../
        lrwxrwxrwx 1 llllljian llllljian    5 4月 25 21:24 1.txt -> 1.txt
        lrwxrwxrwx 1 llllljian llllljian   27 4月 25 21:31 2.txt -> /home/0425test/0425_1/1.txt
        -rw-rw-r-- 2 llllljian llllljian   25 4月 25 21:53 3.txt
        -rw-rw-r-- 1 llllljian llllljian   25 4月 25 22:03 4_1.txt
        -rw-rw-r-- 2 llllljian llllljian   25 4月 25 21:53 4.txt
    ```
- 查找硬链接文件
    ```bash
        ll -i
        总用量 20
        269531 drwxrwxrwx 2 root      root      4096 4月 25 22:03 ./
        269528 drwxrwxrwx 3 root      root      4096 4月 25 22:12 ../
        269536 lrwxrwxrwx 1 llllljian llllljian    5 4月 25 21:24 1.txt -> 1.txt
        269538 lrwxrwxrwx 1 llllljian llllljian   27 4月 25 21:31 2.txt -> /home/0425test/0425_1/1.txt
        269548 -rw-rw-r-- 2 llllljian llllljian   25 4月 25 21:53 3.txt
        269550 -rw-rw-r-- 1 llllljian llllljian   25 4月 25 22:03 4_1.txt
        269548 -rw-rw-r-- 2 llllljian llllljian   25 4月 25 21:53 4.txt
        
        find / 2> /dev/null  -inum 269548
        /home/0425test/0425_1/0425_1_1/4.txt
        /home/0425test/0425_1/0425_1_1/3.txt
    ```