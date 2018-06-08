---
title: Linux_基础 (15)
date: 2018-04-28
tags: Linux
toc: true
---

### mkdir命令与rmdir命令
    mkdir命令用来创建指定的名称的目录,要求创建目录的用户在当前目录中具有写权限,并且指定的目录名不能是当前目录中已有的目录
    rmdir的功能是删除空目录,一个目录被删除之前必须的空的

<!-- more -->

#### mkdir命令
- 命令格式
    * mkdir [选项]目录
- 命令功能
    * 通过该命令可以在指定的位置创建名称为dirName的文件夹或目录.要求创建文件夹或目录的用户必须对所创建的文件夹父文件夹具有写权限,但在同一个文件夹或目录下不能有同名（区分大小写）的文件夹或目录
- 命令参数
    * -m,-mode=模式,设定权限<模式>（类似chmod）,而不是rwxrwxrwx或umask
    * -p,--parents,可以是一个路径名称.若路径中的某些目录尚不存在,加上此选项后,系统将自动建立好那些尚不存在的目录,即一次可以建立多个目录.
    * -v,--verbose,每次创建新目录都显示信息.
    * --help,显示帮助信息并退出.
    * --version,输出版本信息并退出.
- 命令实例
    * 递归创建多个目录
        ```bash
            mkdir -p test1/test1.1
        ```
    * 创建权限为777的目录
        ```bash
            mkdir -m 777 test3
        ```
    * 创建新目录都显示信息
        ```bash
            mkdir -v test4
        ```

#### rmdir命令
- 命令格式
    * rmdir [选项]  目录
- 命令功能
    * 从一个目录中删除一个或多个子目录项,删除目录时需要有对父目录写的权限.
- 命令参数
    * -p 递归删除目录dirname,当子目录删除后其父目录为空时,也一同被删除.
    * 如果整个路径被删除或由于某种原因保留部分路径,则系统在标准输出上显示相应的信息.
    * -v,--verbose,显示指令执行过程.
- 命令实例
    * 不能删除非空目录
        ```bash
            rmdir test1/
            rmdir: failed to remove 'test1/': Directory not empty
        ```
    * 使用参数p进行删除
        ```bash
            mkdir -p test1/test2/

            ll
            总用量 8
            drwxr-xr-x 2 llllljian llllljian 4096 4月  28 14:14 test1
            drwxr-xr-x 2 llllljian llllljian 4096 8月  27 16:30 test

            cd test1

            rmdir -p test1/test2/

            ll
            drwxr-xr-x 2 llllljian llllljian 4096 8月  27 16:30 test
        ```