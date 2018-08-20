---
title: Linux_基础 (54)
date: 2018-06-17
tags: Linux
toc: true
---

### awk补充
    awk变量
    awk格式化输出
    awk模式

<!-- more -->

#### 变量
- 内置变量
    * 内置变量就是awk预定义好的、内置在awk内部的变量
    * NR
        ```bash
            [llllljian@llllljian-virtual-machine 20180617 10:17:58 #14]$ cat 1.txt
            a	b	c	d
            1	2	3	4
            e	f	g	h
            5	6	7	8

            [llllljian@llllljian-virtual-machine 20180617 10:18:05 #15]$ awk '{print NR,$0}' 1.txt
            1 a	b	c	d
            2 1	2	3	4
            3 e	f	g	h
            4 5	6	7	8
        ```
    * FNR
        ```bash
            [llllljian@llllljian-virtual-machine 20180617 10:23:29 #25]$ cat 1.txt
            a	b	c	d
            1	2	3	4
            e	f	g	h
            5	6	7	8

            [llllljian@llllljian-virtual-machine 20180617 10:23:31 #26]$ cat 2.txt
            a#b#c#d
            1#2#3#4
            e#f#g#h
            5#6#7#8

            [llllljian@llllljian-virtual-machine 20180617 10:23:35 #27]$ awk '{print NR,$0}' 1.txt 2.txt
            1 a	b	c	d
            2 1	2	3	4
            3 e	f	g	h
            4 5	6	7	8
            5 a#b#c#d
            6 1#2#3#4
            7 e#f#g#h
            8 5#6#7#8

            [llllljian@llllljian-virtual-machine 20180617 10:24:15 #28]$ awk '{print FNR,$0}' 1.txt 2.txt
            1 a	b	c	d
            2 1	2	3	4
            3 e	f	g	h
            4 5	6	7	8
            1 a#b#c#d
            2 1#2#3#4
            3 e#f#g#h
            4 5#6#7#8
        ```
    * RS
        ```bash
            [llllljian@llllljian-virtual-machine 20180617 10:28:54 #7]$ cat 3.txt
            a b c d
            1 2 3 4

            [llllljian@llllljian-virtual-machine 20180617 10:28:58 #8]$ awk '{print NR,$0}' 3.txt
            1 a b c d
            2 1 2 3 4

            [llllljian@llllljian-virtual-machine 20180617 10:29:04 #9]$ awk -v RS=" " '{print NR,$0}' 3.txt
            1 a
            2 b
            3 c
            4 d
            1
            5 2
            6 3
            7 4
        ```
    * ORS
    * FILENAME
    * ARGC/ARGBV
- 自定义变量
    * 用户定义的变量

#### 格式化输出
- print
    * 简单输出,自动换行
- printf 
    * 格式化输出,需手动换行
    * 使用printf动作输出的文本不会换行,如果需要换行,可以在对应的"格式替换符"后加入"\n"进行转义.
    * 使用printf动作时,"指定的格式" 与 "被格式化的文本" 之间,需要用"逗号"隔开.
    * 使用printf动作时,"格式"中的"格式替换符"必须与 "被格式化的文本" 一一对应
- 实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180617 19:08:31 #33]$ cat 1.txt
        a	b	c	d
        1	2	3	4
        e	f	g	h
        5	6	7	8

        [llllljian@llllljian-virtual-machine 20180617 19:08:58 #34]$ awk '{print $1}' 1.txt
        a
        1
        e
        5
        [llllljian@llllljian-virtual-machine 20180617 19:09:29 #35]$ awk '{printf $1}' 1.txt
        a1e5[llllljian@llllljian-virtual-machine 20180617 19:09:52 #36]$ awk '{printf "%s\n",$1}' 1.txt
        a
        1
        e
        5
        
        [llllljian@llllljian-virtual-machine 20180617 19:09:59 #38]$ awk '{printf  "第%s行 第一列: %s 第二列: %s\n" ,NR,$1,$2}' 1.txt
        第1行 第一列: a 第二列: b
        第2行 第一列: 1 第二列: 2
        第3行 第一列: e 第二列: f
        第4行 第一列: 5 第二列: 6

        [llllljian@llllljian-virtual-machine 20180617 19:18:29 #50]$ awk -v FS=":" 'BEGIN{printf "%-10s\t %s\n", "用户名称","用户id"} NR<6{printf "%-10s\t %s\n",$1,$3}' /etc/passwd
        用户名称      	 用户id
        root      	 0
        bin       	 1
        daemon    	 2
        adm       	 3
        lp        	 4
    ```

#### 模式
- awk会先处理完当前行,再处理下一行,如果不指定任何"条件",awk会一行一行的处理文本中的每一行,如果指定了"条件",只有满足"条件"的行才会被处理,不满足"条件"的行就不会被处理.这样说是不是比刚才好理解一点了呢？这其实就是awk中的"模式".

#### printf
- 命令功能
    * 格式化输出结果
- 命令格式
    * printf(选项)(参数)
- 命令参数
    * 格式替代符
        * %b 相对应的参数被视为含有要被处理的转义序列之字符串.
        * %c ASCII字符.显示相对应参数的第一个字符
        * %d, %i 十进制整数
        * %e, %E, %f 浮点格式
        * %g %e或%f转换,看哪一个较短,则删除结尾的零
        * %G %E或%f转换,看哪一个较短,则删除结尾的零
        * %o 不带正负号的八进制值
        * %s 字符串
        * %u 不带正负号的十进制值
        * %x 不带正负号的十六进制值,使用a至f表示10至15
        * %X 不带正负号的十六进制值,使用A至F表示10至15
        * %% 字面意义的%
    * 转义序列
        * a\a 警告字符,通常为ASCII的BEL字符
        * a\b 后退
        * a\c 抑制(不显示）输出结果中任何结尾的换行字符(只在%b格式指示符控制下的参数字符串中有效）,而且,任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符,都被忽略
        * a\f 换页(formfeed）
        * a\n 换行
        * a\r 回车(Carriage return）
        * a\t 水平制表符
        * a\v 垂直制表符
        * a\\\ 一个字面上的反斜杠字符
        * a\ddd 表示1到3位数八进制值的字符,仅在格式字符串中有效
        * a\0ddd 表示1到3位的八进制值字符
- 命令实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180617 21:49:38 #53]$ printf testString
        testString[llllljian@llllljian-virtual-machine 20180617 21:52:22 #54]$ printf "testString\n"
        testString

        [llllljian@llllljian-virtual-machine 20180617 21:52:35 #55]$ printf "%s\n" 1 11 111
        1
        11
        111

        [llllljian@llllljian-virtual-machine 20180617 21:53:59 #56]$ printf "%f\n" 1 11 111
        1.000000
        11.000000
        111.000000

        [llllljian@llllljian-virtual-machine 20180617 21:55:10 #58]$ printf "( %s )\n" 1 11 111
        ( 1 )
        ( 11 )
        ( 111 )

        [llllljian@llllljian-virtual-machine 20180617 21:55:26 #59]$ printf "%s %s\n" 1 11 111
        1 11
        111 

        [llllljian@llllljian-virtual-machine 20180617 21:57:16 #62]$ printf "%7s %5s %4s\n" 姓名 性别 年龄 小赵 男 20 小李 女 21
        姓名 性别 年龄
        小赵   男   20
        小李   女   21

        [llllljian@llllljian-virtual-machine 20180617 21:57:25 #63]$ printf "%-7s %-5s %-4s\n" 姓名 性别 年龄 小赵 男 20 小李 女 21
        姓名  性别 年龄
        小赵  男   20  
        小李  女   21  

        [llllljian@llllljian-virtual-machine 20180617 21:59:55 #68]$ printf "正负 数值\n"; printf "%4s %+5d \n" 正 100 负 -30
        正负 数值
        正  +100 
        负   -30
    ```
