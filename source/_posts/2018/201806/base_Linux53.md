---
title: Linux_基础 (53)
date: 2018-06-15
tags: Linux
toc: true
---

### awk命令
    awk是一个报告生成器,它拥有强大的文本格式化的能力
    通俗讲就是 通过awk将文本整理成我们想要的样子

<!-- more -->

#### awk原型
- Linux所使用的awk其实是gawk
    ```bash
        [llllljian@llllljian-virtual-machine ~ 09:35:13 #31]$ which awk
        /usr/bin/awk

        [llllljian@llllljian-virtual-machine ~ 14:19:15 #32]$ ll /usr/bin/awk
        lrwxrwxrwx. 1 root root 4 6月  29 2017 /usr/bin/awk -> gawk
    ```
- 可以将awk理解为一个脚本语言解释器

#### awk基础 
- 处理内容
    * 将一行当中分成数个字段来处理
    * 适合处理小型数据
- 允许模式
    * awk '条件类型1{动作1}条件类型2{动作2}...' filename
- 执行流程
    * 读入第一行,并将第一行的资料填入$0,$1,$2...等变数中
    * 依据 “条件类型” 的限制,判断是否需要进行后面的动作
    * 做完所有的动作和条件类型
    * 若还有后续的行的数据,就重复上面1-3步骤,知道所有的数据都读完
- 内置变量
    <table><tr><th>变量名称</th><th>代表意义</th></tr><tr><td>FS</td><td>输入字段分隔符, 默认为空白字符</td></tr><tr><td>OFS</td><td>输出字段分隔符, 默认为空白字符</td></tr><tr><td>RS</td><td>输入记录分隔符(输入换行符), 指定输入时的换行符</td></tr><tr><td>ORS</td><td>输出记录分隔符(输出换行符),输出时用指定符号代替换行符</td></tr><tr><td>NF</td><td>number of Field,当前行的字段的个数(即当前行被分割成了几列),字段数量</td></tr><tr><td>NR</td><td>行号,当前处理的文本行的行号.</td></tr><tr><td>FNR</td><td>各文件分别计数的行号</td></tr><tr><td>FILENAME</td><td>当前文件名<tr><td>ARGC</td><td>命令行参数的个数</td></tr><tr><td>ARGV</td><td>数组,保存的是命令行所给定的各参数</td></tr><tr><td>$0</td><td>代表整行</td></tr><tr><td>${n}</td><td>当前行分割后的第n列</td></tr><tr><td>$NF</td><td>当前行分割后的最后一列</td></tr></table>
- 逻辑运算符
    <table><tr><th>运算单元</th><th>代表意义</th></tr><tr><td>></td><td>大于</td></tr><tr><td><</td><td>小于</td></tr><tr><td>>=</td><td>大于或等于</td></tr><tr><td><=</td><td>小于或等于</td></tr><tr><td>==</td><td>等于</td></tr><tr><td>!=</td><td>不等于</td></tr></table>
- 最常用的动作
    * print
        * 简单输出,自动换行
    * printf
        * 不能接受管道符参数,也不能之直接跟文件名,可以跟系统命令执行的结果
        * 不能自动换行
- 模式
    * 空模式
    * 关系运算模式
    * BEGIN/END模式 
        * BEGIN 指定了处理文本之前需要执行的操作
        * END 指定了处理文本之后需要执行的操作

#### awk实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180615 17:12:38 #39]$ cat 1.txt
        a	b	c	d
        1	2	3	4
        e	f	g	h
        5	6	7	8
        
        [llllljian@llllljian-virtual-machine 20180615 17:12:59 #40]$ cat 1.txt | awk '{print $2}'
        b
        2
        f
        6

        [llllljian@llllljian-virtual-machine 20180615 17:14:29 #41]$ cat 1.txt | awk '{print "2:" $2}'
        2:b
        2:2
        2:f
        2:6

        [llllljian@llllljian-virtual-machine 20180615 18:25:40 #42]$ cat 1.txt | awk '{print "2:" "$2"}'
        2:$2
        2:$2
        2:$2
        2:$2

        [llllljian@llllljian-virtual-machine 20180615 18:26:46 #43]$ cat 1.txt | awk '{print $FN}'
        a	b	c	d
        1	2	3	4
        e	f	g	h
        5	6	7	8

        [llllljian@llllljian-virtual-machine 20180615 18:27:08 #44]$ cat 1.txt | awk '{print $NF}'
        d
        4
        h
        8

        [llllljian@llllljian-virtual-machine 20180615 18:29:30 #48]$ head -n 5 /etc/passwd| awk '{FS=":"} {print $1 "\t" $3}'
        root:x:0:0:root:/root:/bin/bash	
        bin	1
        daemon	2
        adm	3
        lp	4

        [llllljian@llllljian-virtual-machine 20180615 18:37:09 #50]$ head -n 5 /etc/passwd| awk 'BEGIN {FS=":"} {print $1 "\t" $3}'
        root	0
        bin	1
        daemon	2
        adm	3
        lp	4

        [llllljian@llllljian-virtual-machine 20180615 18:43:07 #62]$ awk '{print $1 "\t" $3} END{print "A\tB"}' 1.txt
        a	c
        1	3
        e	g
        5	7
        A	B

        [llllljian@llllljian-virtual-machine 20180615 18:46:25 #64]$ awk '{print $1,$2}' 1.txt
        a b
        1 2
        e f
        5 6

        [llllljian@llllljian-virtual-machine 20180615 18:46:45 #65]$ awk '{print $1 $2}' 1.txt
        ab
        12
        ef
        56

        [llllljian@llllljian-virtual-machine 20180615 18:46:50 #66]$ awk '{print $1$2}' 1.txt
        ab
        12
        ef
        56
        
        [llllljian@llllljian-virtual-machine 20180615 18:46:55 #67]$ awk 'BEGIN {OFS="-----"} {print $1,$2}' 1.txt
        a-----b
        1-----2
        e-----f
        5-----6
    ```