---
title: Linux_基础 (89)
date: 2021-06-01
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### case语句
- 用途
    * case ... esac 与其他语言中的 switch ... case 语句类似, 是一种多分枝选择结构
- 语句格式
    ```bash
        case 值 in
        模式1)
            command1
            command2
            command3
        ;;
        模式2)
            command1
            command2
            command3
        ;;
        *)
            command1
            command2
            command3
        ;;
        esac
    ```
- 说明
    * case工作方式如上所示.取值后面必须为关键字 in, 每一模式必须以右括号结束.取值可以为变量或常数.匹配发现取值符合某一模式后, 其间所有命令开始执行直至 ;;.;; 与其他语言中的 break 类似, 意思是跳到整个 case 语句的最后.
    * 取值将检测匹配的每一个模式.一旦模式匹配, 则执行完匹配模式相应命令后不再继续其他模式.如果无一匹配模式, 使用星号 * 捕获该值, 再执行后面的命令
- eg
    ```bash
        echo 'Input a number:'
        read Num
        case $Num in
            1)  echo 'You select 1'
            ;;
            2)  echo 'You select 2'
            ;;
            3)  echo 'You select 3'
            ;;
            4|5)  echo 'You select 4 or 5'
            ;;
            *)  echo 'default'
            ;;
        esac
    ```
- eg1
    ```bash
        #!/bin/bash
        option=$1
        case ${option} in
        -f) echo "param is -f"
            ;;
        -d) echo "param is -d"
            ;;
        *) 
            echo "$0:usage: [-f ] | [ -d ]"
            exit 1  #退出码
            ;;
        esac
    ```




