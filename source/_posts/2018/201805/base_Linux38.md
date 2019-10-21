---
title: Linux_基础 (38)
date: 2018-05-30
tags: Linux
toc: true
---

### 管线命令pipe
    管道就是用 | 连接两个命令,以前面一个命令的标准输出作为后面命令的标准输入,与连续执行命令是有区别的,值得注意的管道对于前一条命令的标准错误输出没事有处理能力的

<!-- more -->

#### 字符转换命令
- tr
    * 命令格式
        * tr(选项)(参数)
    * 命令功能
        * 对来自标准输入的字符进行替换、压缩和删除.它可以将一组字符变成另一组字符,经常用来编写优美的单行命令
    * 命令参数
        * 选项
            * -c或——complerment：取代所有不属于第一字符集的字符；
            * -d或——delete：删除所有属于第一字符集的字符；
            * -s或--squeeze-repeats：把连续重复的字符以单独一个字符表示；
            * -t或--truncate-set1：先删除第一字符集较第二字符集多出的字符.
        * 参数
            * 字符集1：指定要转换或删除的原字符集.当执行转换操作时,必须使用参数“字符集2”指定转换的目标字符集.但执行删除操作时,不需要参数“字符集2”；
            * 字符集2：指定要转换成的目标字符集.
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180530 13:54:50 #19]$ echo "HELLO WORLD" | tr 'A-Z' 'a-z'
            hello world

            [llllljian@llllljian-virtual-machine 20180530 13:58:46 #21]$ echo "hello 123 world 456" | tr -d '0-9'
            hello  world 

            [llllljian@llllljian-virtual-machine 20180530 14:05:54 #32]$ cat 1.txt
            1	2	3	4
            5	6	7	8

            [llllljian@llllljian-virtual-machine 20180530 14:05:57 #33]$ cat -A 1.txt
            1^I2^I3^I4$
            5^I6^I7^I8$

            [llllljian@llllljian-virtual-machine 20180530 14:06:01 #34]$ cat 1.txt | tr '\t' ' '
            1 2 3 4
            5 6 7 8

            补集中包含了数字0~9、空格和换行符\n,所以没有被删除,其他字符全部被删除了
            [llllljian@llllljian-virtual-machine 20180530 14:07:43 #36]$ echo aa.,a 1 b#$bb 2 c*/cc 3 ddd 4 | tr -d -c '0-9 \n'
            1  2  3  4

            输出1 2 3 ... 每次输出一个 将空格\n替换成+号 结果相加  输出相加的结果或者0
            [llllljian@llllljian-virtual-machine 20180530 14:10:06 #40]$ echo 1 2 3 4 5 6 7 8 9 | xargs -n 1 | echo $[ $(tr '\n' '+') 0 ]
            45
            [llllljian@llllljian-virtual-machine 20180530 14:11:05 #41]$ echo a b c d e | xargs -n 1 | echo $[ $(tr '\n' '+') 0 ]
            0

            将输出结果小写字母都转为大写
            [llllljian@llllljian-virtual-machine 20180530 14:11:55 #42]$ echo HEllo llllljian | tr '[:lower:]' '[:upper:]'
            HELLO LLLLLJIAN

            [llllljian@llllljian-virtual-machine 20180530 14:13:53 #43]$ echo HEllo llllljian | tr '[a-z]' '[A-Z]'
            HELLO LLLLLJIAN
        ```
- col
    * 命令格式
        * col(选项)
    * 命令功能
        * 多数情况下简单的处理将tab按键换成空格键
    * 命令参数
        * -x: 将tab键转换成对等的空格键
        * -b：过滤掉所有的控制字符,包括RLF和HRLF；
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180530 14:30:37 #52]$ cat 1.txt | cat -A
            1^I2^I3^I4$
            5^I6^I7^I8$

            [llllljian@llllljian-virtual-machine 20180530 14:30:39 #53]$ cat 1.txt | col -x | cat -A
            1       2       3       4$
            5       6       7       8$
        ```
- join
    * 命令格式
        * join(选项)(参数)
    * 命令功能
        * 用来将两个文件中,制定栏位内容相同的行连接起来.找出两个文件中,指定栏位内容相同的行,并加以合并,再输出到标准输出设备
    * 命令参数
        * 选项
            * -a<1或2>：除了显示原来的输出内容之外,还显示指令文件中没有相同栏位的行；
            * -e<字符串>：若[文件1]与[文件2]中找不到指定的栏位,则在输出中填入选项中的字符串；
            * -i或--ignore-case：比较栏位内容时,忽略大小写的差异；
            * -o<格式>：按照指定的格式来显示结果；
            * -t<字符>：使用栏位的分割字符；
            * -v<1或2>：更-a相同,但是只显示文件中没有相同栏位的行；
            * -1<栏位>：连接[文件1]指定的栏位；
            * -2<栏位>：连接[文件2]指定的栏位.
        * 参数
            * 文件1：要进行合并操作的第1个文件参数；
            * 文件2：要进行合并操作的第2个文件参数.
- paste
    * 命令格式
        * paste(选项)(参数)
    * 命令功能
        * 将多个文件按照列队列进行合并
    * 命令参数
        * 选项
            * -d<间隔字符>或--delimiters=<间隔字符>：用指定的间隔字符取代跳格字符；
            * -s或——serial串列进行而非平行处理.
        * 参数
            * 文件列表：指定需要合并的文件列表
- expand
    * 命令格式
        * expand(选项)(参数)
    * 命令功能
        * 将文件的制表符(TAB)转换为空白字符(space),将结果显示到标准输出设备
    * 命令参数
        * 选项
            * -t<数字>：指定制表符所代表的空白字符的个数,而不使用默认的8.
        * 参数
            * 文件：指定要转换制表符为空白的文件.
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180530 14:58:07 #61]$ cat -A 1.txt
            1^I2^I3^I4$
            5^I6^I7^I8$

            [llllljian@llllljian-virtual-machine 20180530 14:58:20 #62]$ cat 1.txt
            1	2	3	4
            5	6	7	8

            [llllljian@llllljian-virtual-machine 20180530 14:58:24 #63]$ expand -t 3 1.txt 
            1  2  3  4
            5  6  7  8
        ```

#### 关于减号-的用途
    代表标准输出/标准输入, 视命令而定. “-”代替stdin和stdout的用法
- 为程序指定参数
    ```bash
        ps -aux

        tar -zxf test.tar
    ```
- 一个减号和两个减号
    ```bash
        一个减号后面跟的参数必须是单字符参数,可以多个参数写在同一个减号后面
        ls -l
        ls -al

        两个减号后面跟的参数必须是多字符参数
        --help
    ```
- 表示上一级工作目录
    ```
        cd -
    ```
- 普通用户切换到root
    ```bash
        su -
        相当于  su - root
    ```
