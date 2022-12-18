---
title: Linux_基础 (99)
date: 2022-08-11
tags: Linux
toc: true
---

### Linux积累
    关于bash脚本需要知道的点

<!-- more -->

#### 前情提要
> Linux公社学习笔记

#### 变量

Bash 变量区分大小写.要声明变量, 请使用等号(=), 名称在左侧, 值在右侧

```bash
    STATE=LinuxMi
```

此声明分配给STATE的值是一个单词.如果您的值中需要空格, 请在其周围使用引号：

```bash
    STATE="Ubuntu Linux"
```

您需要使用美元符号($)前缀来引用其他变量或语句中的变量：

```bash
    STATE=LinuxMi
    LOCATION="My Site is $STATE"
```

#### 注释

您可以在 Bash 中使用井号或井号 ( # ) 符号进行注释.shell 会自动忽略注释.

```bash
    #!/bin/bash
    # STATE=LinuxMi.com
    # LOCATION="My Site is $STATE"
```

#### 接收用户输入
> read

```bash
    echo "What do you want ?: "
    read response
    echo $response
```

#### 声明数组

Bash中的数组就像大多数语言一样.您可以通过在括号中指定元素来在 Bash 中声明一个数组变量.

```bash
    Countries=('Ubuntu' 'Debian' 'CentOS', "openSUSE", "Linuxmi.com")
```

通过引用变量名访问数组将获取第一个元素.您可以使用星号作为索引来访问整个数组.

```bash
    echo ${Countries[*]}
```

您还可以指定数组的索引来访问特定元素.数组的索引从零开始.

```bash
    echo "${Countries[4]}"
```

#### 条件语句
1. if 
```bash
    if [[ condition ]]; then
        echo statement1
    elif [[condition ]]; then
        echo statement2
    else [[condition ]]; then
        echo statement3
    fi
```
2. case
```bash
    NAME=LinuxMi
    case $NAME in
    "Debian") # 模式
        echo "Debian是目前世界最大的非商业性Linux发行版之一" # 声明
        ;; # case 结束
    "LinuxMi" | "Ubuntu")
        echo  "openSUSE"
        ;;
    "CentOS" | "oracle linux")
        echo  "linux"
        ;;
    *) # 默认模式
        echo "linuxmi.com" # 默认声明
        ;;
    esac # case声明结束
```

#### 循环
1. for
```bash
    for ((a = 0 ; a < 10 ; a+2)); do
        echo $a
    done

    for i in {1..7}; do
        echo $1
    done
```
2. 死循环
```bash
    while true; do
        echo ${date}
    done
```

#### 函数

在 Bash 中声明函数不需要关键字.您可以使用名称声明函数, 然后在函数体之前加上括号
```bash
    print_working_directory() {
        echo $PWD  #从脚本调用PWD命令
    }
    echo "当前的目录是 $(print_working_directory)"
```

函数可以在 Bash 中返回变量.您所需要的只是return关键字

```bash 
    print_working_directory() {
        return $PWD
    }
```



