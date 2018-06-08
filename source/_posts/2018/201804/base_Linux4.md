---
title: Linux_基础 (4)
date: 2018-04-13
tags: Linux
toc: true
---

### ls命令
    ls命令是linux下最常用的命令.ls命令就是list的缩写,缺省下ls用来打印出当前目录的清单,如果ls指定其他目录,那么就会显示指定目录里的文件及文件夹清单.
    通过ls命令不仅可以查看linux文件夹包含的文件,而且可以查看文件权限(包括目录、文件夹、文件权限)查看目录信息等等

<!-- more -->

#### 命令格式
    ls [选项] [目录名]

#### 命令功能
    列出目标目录中所有的子目录和文件

#### 常用参数
- 选择参数
	* -a, 列出目录下的所有文件,包括以“.”开头的隐含文件
	* -A 同-a,但不列出“.”(表示当前目录)和“..”(表示当前目录的父目录).
	* -c  配合 -lt：根据 ctime 排序及显示 ctime (文件状态最后更改的时间)配合 
    * -l：显示 ctime 但根据名称排序否则：根据 ctime 排序
	* -C 每栏由上至下列出项目
	* -d, –directory 将目录象文件一样显示,而不是显示其下的文件.
	* -D, –dired 产生适合 Emacs 的 dired 模式使用的结果
	* -f 对输出的文件不进行排序,-aU 选项生效,-lst 选项失效
	* -g 类似 -l,但不列出所有者
	* -G, –no-group 不列出任何有关组的信息
	* -h, –human-readable 以容易理解的格式列出文件大小 (例如 1K 234M 2G)
	* –si 类似 -h,但文件大小取 1000 的次方而不是 1024
	* -H, –dereference-command-line 使用命令列中的符号链接指示的真正目的地
	* -i, –inode 印出每个文件的 inode 号
	* -I, –ignore=样式 不印出任何符合 shell 万用字符<样式>的项目
	* -k 即 –block-size=1K,以 k 字节的形式表示文件的大小.
	* -l 除了文件名之外,还将文件的权限、所有者、文件大小等信息详细列出来.
	* -L, –dereference 当显示符号链接的文件信息时,显示符号链接所指示的对象而并非符号链接本身的信息
	* -m 所有项目以逗号分隔,并填满整行行宽
	* -o 类似 -l,显示文件的除组信息外的详细信息.   
	* -r, –reverse 依相反次序排列
	* -R, –recursive 同时列出所有子目录层
	* -s, –size 以块大小为单位列出所有文件的大小
	* -S 根据文件大小排序
	* -t 以文件修改时间排序
	* -u 配合 -lt:显示访问时间而且依访问时间排序
	* -U 不进行排序;依文件系统原有的次序列出项目
	* -v 根据版本进行排序
	* -w, –width=COLS 自行指定屏幕宽度而不使用目前的数值
	* -x 逐行列出项目而不是逐栏列出
	* -X 根据扩展名排序
	* -1 每行只列出一个文件
	* –help 显示此帮助信息并离开
	* –version 显示版本信息并离开

#### 使用说明
- 在使用 ls 命令时要注意命令的格式：在命令提示符后,首先是命令的关键字,接下来是命令参数
- 在命令参数之前要有一短横线“-”,所有的命令参数都有特定的作用,自己可以根据需要选用一个或者多个参数,在命令参数的后面是命令的操作对象
- 多个参数可以连在一起使用 也可以分开
- 命令的操作对象可以指向某个目录 默认是当前目录

#### 使用实例
- 列出目标文件夹下的所有文件和目录的详细资料
    ```bash
        ls -l -A -R /home/0413test[ls -ARl /home/0413test 二者效果相同] 
        .:
        总用量 16
        drwxrwxr-x 2 llllljian llllljian 4096 4月  13 16:47 0413_1
        -rwxr-xr-x 1 llllljian llllljian    8 4月  13 13:20 1.txt
        -rw-rw-r-- 1 llllljian llllljian    9 4月  13 13:24 2.txt
        -rwxrw-rw- 1 llllljian llllljian    0 4月  13 14:38 3_1.txt
        -rwxrwxr-x 1 root      root        25 4月  13 16:06 3.txt

        ./0413_1:
        总用量 4
        -rw-rw-r-- 1 llllljian llllljian 25 4月  13 16:47 0413_1.txt
    ```
- 列出当前目录中所有以“3”开头的目录的详细内容
    ```bash
        ls -l 3*
        -rwxrw-rw- 1 llllljian llllljian  0 4月  13 14:38 3_1.txt
        -rwxrwxr-x 1 root      root      25 4月  13 16:06 3.txt
    ```
- 只列出文件下的子目录
    ```bash
        ls -F | grep /$
        0413_1/
    ```
- 列出目前工作目录下所有名称是3开头的档案,按时间排序[正序]
    ```bash
        ls -ltr 3*
        -rwxrw-rw- 1 llllljian llllljian  0 4月  13 14:38 3_1.txt
        -rwxrwxr-x 1 root      root      25 4月  13 16:06 3.txt
    ```
- 列出当前目录下的所有文件（包括隐藏文件）的绝对路径, 对目录不做递归
    ```bash
        find $PWD -maxdepth 1 | xargs ls -ld
        drwxrwxrwx 3 root      root      4096 4月  13 16:46 /home/0413test
        drwxrwxr-x 2 llllljian llllljian 4096 4月  13 16:47 /home/0413test/0413_1
        -rwxr-xr-x 1 llllljian llllljian    8 4月  13 13:20 /home/0413test/1.txt
        -rw-rw-r-- 1 llllljian llllljian    9 4月  13 13:24 /home/0413test/2.txt
        -rwxrw-rw- 1 llllljian llllljian    0 4月  13 14:38 /home/0413test/3_1.txt
        -rwxrwxr-x 1 root      root        25 4月  13 16:06 /home/0413test/3.txt
    ```
- 指定文件时间输出格式
    ```bash
        ls -ctl --time-style=long-iso
        总用量 16
        drwxrwxr-x 2 llllljian llllljian 4096 2018-04-13 16:47 0413_1
        -rwxrwxr-x 1 root      root        25 2018-04-13 16:08 3.txt
        -rwxrw-rw- 1 llllljian llllljian    0 2018-04-13 15:07 3_1.txt
        -rwxr-xr-x 1 llllljian llllljian    8 2018-04-13 15:00 1.txt
        -rw-rw-r-- 1 llllljian llllljian    9 2018-04-13 13:24 2.txt

        ls -ctl --full-time
        总用量 16
        drwxrwxr-x 2 llllljian llllljian 4096 2018-04-13 16:47:13.273542993 +0800 0413_1
        -rwxrwxr-x 1 root      root        25 2018-04-13 16:08:19.318809903 +0800 3.txt
        -rwxrw-rw- 1 llllljian llllljian    0 2018-04-13 15:07:51.446080406 +0800 3_1.txt
        -rwxr-xr-x 1 llllljian llllljian    8 2018-04-13 15:00:50.014456524 +0800 1.txt
        -rw-rw-r-- 1 llllljian llllljian    9 2018-04-13 13:24:31.026986168 +0800 2.txt
    ```

#### 永久显示彩色目录列表
    打开/etc/bashrc, 加入如下一行:
    alias ls="ls --color"
    下次启动bash时就可以像在Slackware里那样显示彩色的目录列表了, 其中颜色的含义如下:
    1. 蓝色-->目录
    2. 绿色-->可执行文件
    3. 红色-->压缩文件
    4. 浅蓝色-->链接文件
    5. 灰色-->其他文件