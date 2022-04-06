---
title: Linux_基础 (9)
date: 2018-04-20
tags: Linux
toc: true
---

### chmod命令
    chmod命令用于改变linux系统文件或目录的访问权限.用它控制文件或目录的访问权限.
    该命令有两种用法.一种是包含字母和操作符表达式的文字设定法；另一种是包含数字的数字设定法.
    Linux系统中的每个文件和目录都有访问许可权限,用它来确定谁可以通过何种方式对文件和目录进行访问和操作

<!-- more -->

#### 命令格式
    chmod [-cfvR] [--help] [--version] mode file

#### 命令功能
    用于改变文件或目录的访问权限,用它控制文件或目录的访问权限.

#### 命令参数
- 必要参数: 
	* -c 当发生改变时,报告处理信息
	* -f 错误信息不输出
	* -R 处理指定目录以及其子目录下的所有文件
	* -v 运行时显示详细处理信息
- 选择参数: 
	* --reference=<目录或者文件> 设置成具有指定目录或者文件具有相同的权限
	* --version 显示版本信息
- 权限参数
	* <权限范围>+<权限设置> 使权限范围内的目录或者文件具有指定的权限
	* <权限范围>-<权限设置> 删除权限范围的目录或者文件的指定权限
	* <权限范围>=<权限设置> 设置权限范围内的目录或者文件的权限为指定的值
    * 权限范围
        * u : 目录或者文件的当前的用户
        * g : 目录或者文件的当前的群组
        * o : 除了目录或者文件的当前用户或群组之外的用户或者群组
        * a : 所有的用户及群组  
    * 权限代号
        * r : 读权限,用数字4表示
        * w : 写权限,用数字2表示
        * x : 执行权限,用数字1表示
        * - : 删除权限,用数字0表示
        * s : 特殊权限

#### 使用实例
- 增加文件所有用户组可执行权限
    ```bash
        ls -al 3*
        -rwxrw-rw- 1 llllljian llllljian  0 4月  20 14:38 3_1.txt
        -rw-r--r-- 1 root      llllljian 25 4月  20 19:34 3_2.txt
        -rw-r--r-- 1 root      llllljian 25 4月  20 19:42 3_3.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  20 16:06 3.txt

        sudo chmod -v a+x 3*
        '3_1.txt' 的权限模式保留为0777 (rwxrwxrwx)
        mode of '3_2.txt' changed from 0644 (rw-r--r--) to 0755 (rwxr-xr-x)
        mode of '3_3.txt' changed from 0644 (rw-r--r--) to 0755 (rwxr-xr-x)
        '3.txt' 的权限模式保留为0775 (rwxrwxr-x)

        ls -al 3*
        -rwxrwxrwx 1 llllljian llllljian  0 4月  20 14:38 3_1.txt
        -rwxr-xr-x 1 root      llllljian 25 4月  20 19:34 3_2.txt
        -rwxr-xr-x 1 root      llllljian 25 4月  20 19:42 3_3.txt
        -rwxrwxr-x 1 root      llllljian 25 4月  20 16:06 3.txt
    ```
- 同时修改不同用户权限
    ```bash
        ls -al 3*
        -r-------- 1 llllljian llllljian  0 4月  20 14:38 3_1.txt
        -r-------- 1 root      llllljian 25 4月  20 19:34 3_2.txt
        -r-------- 1 root      llllljian 25 4月  20 19:42 3_3.txt
        -r-------- 1 root      llllljian 25 4月  20 16:06 3.txt

        sudo chmod ug+w,o+x 3*

        ls -al 3*
        -rw--w---x 1 llllljian llllljian  0 4月  20 14:38 3_1.txt
        -rw--w---x 1 root      llllljian 25 4月  20 19:34 3_2.txt
        -rw--w---x 1 root      llllljian 25 4月  20 19:42 3_3.txt
        -rw--w---x 1 root      llllljian 25 4月  20 16:06 3.txt
    ```
- 添加全部权限
    ```bash
        ls -al 3*
        -rw--w---x 1 llllljian llllljian  0 4月  20 14:38 3_1.txt
        -rw--w---x 1 root      llllljian 25 4月  20 19:34 3_2.txt
        -rw--w---x 1 root      llllljian 25 4月  20 19:42 3_3.txt
        -rw--w---x 1 root      llllljian 25 4月  20 16:06 3.txt
        
        sudo chmod -R 777 3*

        ls -al 3*
        -rwxrwxrwx 1 llllljian llllljian  0 4月  20 14:38 3_1.txt
        -rwxrwxrwx 1 root      llllljian 25 4月  20 19:34 3_2.txt
        -rwxrwxrwx 1 root      llllljian 25 4月  20 19:42 3_3.txt
        -rwxrwxrwx 1 root      llllljian 25 4月  20 16:06 3.txt
    ```