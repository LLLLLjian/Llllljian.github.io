---
title: Linux_基础 (5)
date: 2018-04-16
tags: Linux
toc: true
---

### chgrp命令
    在lunix系统里,文件或目录的权限的掌控以拥有者及所诉群组来管理.可以使用chgrp指令取变更文件与目录所属群组,这种方式采用群组名称或群组识别码都可以.Chgrp命令就是change group的缩写！要被改变的组名必须要在/etc/group文件内存在才行

<!-- more -->

#### 命令格式
    chgrp [选项] [组] [文件]

#### 命令功能
    chgrp命令可采用群组名称或群组识别码的方式改变文件或目录的所属群组.使用权限是超级用户.

#### 命令参数
- 必要参数
	* -c 当发生改变时输出调试信息
	* -f 不显示错误信息
	* -R 处理指定目录以及其子目录下的所有文件
	* -v 运行时显示详细的处理信息
	* --dereference 作用于符号链接的指向,而不是符号链接本身
	* --no-dereference 作用于符号链接本身
- 选择参数
    * --reference=<文件或者目录>
	* --help 显示帮助信息
	* --version 显示版本信息

#### 使用实例
- 改变文件的群组属性 
    ```bash
        ls -al 3*
        -rwxrw-rw- 1 llllljian llllljian  0 4月  16 14:38 3_1.txt
        -rwxrwxr-x 1 root      root      25 4月  16 16:06 3.txt

        sudo chgrp -v llllljian 3.txt
        changed group of '3.txt' from root to llllljian

        ls -al 3*
        -rwxrw-rw- 1 llllljian llllljian  0 4月  16 14:38 3_1.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  16 16:06 3.txt
    ```
- 根据指定文件改变文件的群组属性 
    ```bash
        ls -alt 3*
        -rw-r--r-- 1 root      root      25 4月  16 19:34 3_2.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  16 16:06 3.txt
        -rwxrw-rw- 1 llllljian llllljian  0 4月  16 14:38 3_1.txt

        sudo chgrp --reference=3_1.txt 3_2.txt

        ls -alt 3*
        -rw-r--r-- 1 root      llllljian 25 4月  16 19:34 3_2.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  16 16:06 3.txt
        -rwxrw-rw- 1 llllljian llllljian  0 4月  16 14:38 3_1.txt
    ```
- 通过群组识别码改变文件群组属性
    ```bash
        ls -alt 3*
        -rw-r--r-- 1 root      root      25 4月  16 19:42 3_3.txt
        -rw-r--r-- 1 root      llllljian 25 4月  16 19:34 3_2.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  16 16:06 3.txt
        -rwxrw-rw- 1 llllljian llllljian  0 4月  16 14:38 3_1.txt

        sudo chgrp 1000 3_3.txt

        ls -alt 3*
        -rw-r--r-- 1 root      llllljian 25 4月  16 19:42 3_3.txt
        -rw-r--r-- 1 root      llllljian 25 4月  16 19:34 3_2.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  16 16:06 3.txt
        -rwxrw-rw- 1 llllljian llllljian  0 4月  16 14:38 3_1.txt
    ```