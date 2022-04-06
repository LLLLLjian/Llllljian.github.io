---
title: Linux_基础 (16)
date: 2018-05-02
tags: Linux
toc: true
---

### 文件与目录管理
    有关文件与目录的一些基础管理部分

<!-- more -->

#### 文件与目录的检视:ls
    基础4已经有介绍了

#### 复制cp
- 命令格式
    * cp [选项]..  [-T] 源  目的   
    * cp [选项]..   源...  目录      
    * cp [选项]..  -t   目录  源
- 命令功能
    * 将源文件复制至目标文件,或将多个源文件复制至目标目录
- 命令参数
	* -a: 此参数的效果和同时指定"-dpR"参数相同；
	* -d: 当复制符号连接时,把目标文件或目录也建立为符号连接,并指向与源文件或目录连接的原始文件或目录；
	* -f: 强行复制文件或目录,不论目标文件或目录是否已存在；
	* -i: 覆盖既有文件之前先询问用户；
	* -l: 对源文件建立硬连接,而非复制文件；
	* -p: 保留源文件或目录的属性；
	* -R/r: 递归处理,将指定目录下的所有文件与子目录一并处理；
	* -s: 对源文件建立符号连接,而非复制文件；
	* -u: 使用这项参数后只会在源文件的更改时间较目标文件更新时或是名称相互对应的目标文件并不存在时,才复制文件；
	* -S: 在备份文件时,用指定的后缀“SUFFIX”代替文件的默认后缀；
	* -b: 覆盖已存在的文件目标前将目标文件备份；
	* -v: 详细显示命令执行的操作.
- 使用范例
    * 复制单个文件到目标目录,文件在目标文件中不存在
        ```bash
            ll 3*
            -rw-r--r-- 1 root root 0 5月  02 21:49 3.txt

            sudo cp 3.txt 3_1.txt

            ll 3*
            -rw-r--r-- 1 root root 0 5月  02 22:15 3_1.txt
            -rw-r--r-- 1 root root 0 5月  02 21:49 3.txt
        ```
    * 复制整个目录
        ```bash
            ls -Al
            总用量 16
            drwxrwxrwx 2 root      root      4096 5月  02 22:15 0502test
            drwxrwxrwx 3 root      root      4096 5月  14 21:45 0413test
            drwxrwxrwx 3 root      root      4096 5月  14 20:31 0414test
            drwxr-xr-x 9 llllljian llllljian 4096 5月  14 21:53 llllljian

            sudo cp -a 0502test/ 0502_2test

            ls -Al
            总用量 20
            drwxrwxrwx 2 root      root      4096 5月  02 22:15 0502_2test
            drwxrwxrwx 2 root      root      4096 5月  02 22:15 0502test
            drwxrwxrwx 3 root      root      4096 4月  14 21:45 0413test
            drwxrwxrwx 3 root      root      4096 4月  14 20:31 0414test
            drwxr-xr-x 9 llllljian llllljian 4096 4月  14 21:53 llllljian
        ```
    * 为复制的文件建立一个连结档
        ```bash
            ls -Al
            总用量 8
            -rwxrwxrwx 1 root root    0 5月  02 21:49 1_1.txt
            -rwxrwxrwx 1 root root    0 5月  02 21:49 1_2.txt
            -rwxrwxrwx 1 root root    0 5月  02 21:49 1_3.txt
            -rwxrwxrwx 1 root root    0 5月  02 21:49 1_4.txt
            -rwxrwxrwx 1 root root    0 5月  02 21:49 1.txt
            -rwxrwxrwx 1 root root    0 5月  02 22:13 2_1.txt
            -rwxrwxrwx 1 root root    0 5月  02 21:49 2.txt
            -rwxrwxrwx 1 root root    0 5月  02 22:20 3_1.txt
            -rwxrwxrwx 1 root root    0 5月  02 21:49 3.txt

            cp -s 3.txt 3_2.txt

            ls -Al
            总用量 0
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 1_1.txt
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 1_2.txt
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 1_3.txt
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 1_4.txt
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 1.txt
            -rwxrwxrwx 1 root      root      0 5月  02 22:13 2_1.txt
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 2.txt
            -rwxrwxrwx 1 root      root      0 5月  02 22:20 3_1.txt
            lrwxrwxrwx 1 llllljian llllljian 5 5月  02 22:28 3_2.txt -> 3.txt
            -rwxrwxrwx 1 root      root      0 5月  02 21:49 3.txt
        ```
