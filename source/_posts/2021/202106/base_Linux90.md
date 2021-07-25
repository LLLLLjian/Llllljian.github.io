---
title: Linux_基础 (90)
date: 2021-06-02
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### 获取脚本名称
- 需求描述
    * 写shell脚本的过程中, 有时会需要获取脚本的名字, 比如, 有的时候, 脚本中会有usage()这种函数, 可能就会用到脚本的名字.
- 实现方法
    * shell脚本中, 通过使用$0就可以获取到脚本的名字或者说脚本本身.
1. demo
    ```bash
        # !/bin/bash
        # functionusage means how to use this script.
        # 如果脚本执行时, 脚本的参数是0个, 那么就调用usage函数, 然后退出

        usage()
        {
            echo "Usage: $0 process_name1"
            echo "for example $0 mysqld"
        }

        # if no parameter is passed to script then show how to use.
        if [ $# -eq 0];then
            usage
            exit
        fi
    ```

#### 检查端口是否被占用
- code
    ```bash
        # 查看端口是否被占用
        Pid=`/usr/sbin/lsof -i:$PORT | awk '{ print $1 " " $2 }'`
        if [ "$Pid" != "" ];then
            exit 1
        else
            exit 0
        fi
    ```





