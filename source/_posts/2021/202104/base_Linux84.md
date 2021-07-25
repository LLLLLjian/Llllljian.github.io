---
title: Linux_基础 (84)
date: 2021-04-01
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux之xargs

<!-- more -->

#### 前情提要
> 我有一个文件夹, 文件夹里有好多文件, 我得挨个查看文件里的日志, 并找到一个关键字, 而且我也不能一个一个去cat, 那也太傻了, 想起管道命令, 我就查了一下找到了xargs

#### xargs
1. 作用
    * 将前一个命令的标准输出传递给下一个命令, 作为它的参数, xargs的默认命令是echo, 空格是默认定界符
    * 将多行输入转换为单行
2. 使用模式
    * front command | xargs -option later command
    * front command: 前一个命令
    * -option: xargs的选项
    * later command: 后一个命令
3. xargs常用选项
    * -n: 指定一次处理的参数个数
    * -d: 自定义参数界定符
    * -p: 询问是否运行 later command 参数
    * -t: 表示先打印命令, 然后再执行
    * -i: 逐项处理
4. 示例
    * 测试文本
        ```bash
            $ cat xargs.txt
            a b c d e f g 
            h i j k l m n 
            o p q
            r s t
            u v w x y z
        ```
    * 多行输入单行输出
        ```bash
            $ cat xargs.txt | xargs 
            a b c d e f g h i j k l m n o p q r s t u v w x y z

            $ cat xargs.txt | xargs -t
            /bin/echo a b c d e f g h i j k l m n o p q r s t u v w x y z
            a b c d e f g h i j k l m n o p q r s t u v w x y z
        ```
    * 指定一次处理的参数个数：指定为5, 多行输出
        ```bash
            $ cat xargs.txt | xargs -n 5
            a b c d e
            f g h i j
            k l m n o
            p q r s t
            u v w x y
            z
        ```
    * 询问是否运行 later command 参数
        ```bash
            $ cat xargs.txt | xargs -n 5 -p
            /bin/echo a b c d e?...y
            a b c d e
            /bin/echo f g h i j?...y
            f g h i j
            /bin/echo k l m n o?...y
            k l m n o
            /bin/echo p q r s t?...y
            p q r s t
            /bin/echo u v w x y?...y
            u v w x y
            /bin/echo z?...n
        ```
    * 将所有文件重命名, 逐项处理每个参数
        ```bash
            ls *.txt |xargs -t -i mv {} {}.bak
        ```
5. xargs与管道|的区别
    * | 用来将前一个命令的标准输出传递到下一个命令的标准输入
    * xargs 将前一个命令的标准输出传递给下一个命令, 作为它的参数.
    ```bash
        #使用管道将ls的结果显示出来, ls标准输出的结果作为cat的标准输出
        ls | cat
        #使用xargs将ls的结果作为cat的参数, ls的结果为文件名, 所以cat 文件名即查看文件内容
        ls | xargs cat
    ```
6. xargs与exec的区别
    * exec参数是一个一个传递的, 传递一个参数执行一次命令；xargs一次将参数传给命令, 可以使用-n控制参数个数
        ```bash
            #xargs将参数一次传给echo, 即执行：echo begin ./xargs.txt ./args.txt
            find . -name '*.txt' -type f | xargs echo begin
            #exec一次传递一个参数, 即执行：echo begin ./xargs.txt;echo begin ./args.txt
            find . -name '*.txt' -type f -exec echo begin {} \;
        ```
    * exec文件名有空格等特殊字符也能处理；xargs不能处理特殊文件名, 如果想处理特殊文件名需要特殊处理
        ```bash
            #find后的文件名含有空格
            find . -name '*.txt' -type f | xargs cat
            find . -name '*.txt' -type f -exec cat {} \;
            #xargs处理特殊文件名
            find . -name '*.txt' -type f -print0 | xargs -0  cat
        ```
        * 默认情况下, find 每输出一个文件名, 后面都会接着输出一个换行符 ('\n'),因此我们看到的 find 的输出都是一行一行的,xargs 默认是以空白字符 (空格, TAB, 换行符) 来分割记录的, 因此文件名 ./t t.txt 被解释成了两个记录 ./t 和 t.txt, cat找不到这两个文件,所以报错, 为了解决此类问题,  让 find 在打印出一个文件名之后接着输出一个 NULL 字符 ('') 而不是换行符, 然后再告诉 xargs 也用 NULL 字符来作为记录的分隔符, 即 find -print0 和 xargs -0 , 这样就能处理特殊文件名了

