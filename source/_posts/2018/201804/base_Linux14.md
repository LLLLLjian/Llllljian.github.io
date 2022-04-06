---
title: Linux_基础 (14)
date: 2018-04-27
tags: Linux
toc: true
---

### cd命令与pwd命令
    cd命令是linux的最基本命令之一,其它命令的操作都是建立在cd命令之上的
    pwd命令用来查看当前工作目录的完整路径

<!-- more -->

#### cd命令
- 命令格式
    * cd [目录名]
- 命令功能
    * 切换当前目录至dirName
- 常用范例
    * 进入系统根目录
        ```bash
            cd /

            pwd
            /
        ```
    * 使用 cd 命令进入用户主目录
        ```bash
            cd

            pwd 
            /home/llllljian

            cd ~

            pwd
            /home/llllljian

            cd ~othername

            pwd 
            /home/othername
        ```
    * 返回进入此目录之前所在的目录
        ```bash
            pwd
            /home/lllljian

            cd /usr/local/

            cd -
            /home/llllljian

            pwd
            /home/llllljian
        ```
    * 把上个命令的参数作为cd参数使用
        ```bash
            cd !$
            cd -
            /usr/local

            date +%A
            Friday

            cd !$
            cd +%A
            -bash: +%A: No such file or directory

            !$ 获取上一个命令的参数
        ```

#### pwd命令
- 命令格式
    * pwd [选项]
- 命令功能
    * 查看当前目录的完整路径
- 常用参数
    * 一般情况下不带任何参数 如果目录是链接时: 使用pwd -P命令显示出实际路径,而非使用链接路径
- 常用实例
    * 显示真正链接
        ```bash
            ll
            ...
            test1 -> /home/test2/
            ...

            cd test

            pwd
            /test

            pwd -P
            /home/test2

            pwd -L
            /test
        ```
