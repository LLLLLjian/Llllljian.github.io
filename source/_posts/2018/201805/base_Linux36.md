---
title: Linux_基础 (36)
date: 2018-05-28
tags: Linux
toc: true
---

### 管线命令pipe
    管道就是用 | 连接两个命令,以前面一个命令的标准输出作为后面命令的标准输入,与连续执行命令是有区别的,值得注意的管道对于前一条命令的标准错误输出没事有处理能力的

<!-- more -->

#### 排序命令
- sort
    * 命令格式
        * sort(选项)(参数)
    * 命令功能
        * 将文件进行排序,并将排序结果标准输出
    * 命令参数
    	* -b：忽略每行前面开始出的空格字符；
        * -c：检查文件是否已经按照顺序排序；
        * -d：排序时,处理英文字母、数字及空格字符外,忽略其他的字符；
        * -f：排序时,将小写字母视为大写字母；
        * -i：排序时,除了040至176之间的ASCII字符外,忽略其他的字符；
        * -m：将几个排序号的文件进行合并；
        * -M：将前面3个字母依照月份的缩写进行排序；
        * -n：依照数值的大小排序；
        * -o<输出文件>：将排序后的结果存入制定的文件；
        * -r：以相反的顺序来排序；
        * -t<分隔字符>：指定排序时所用的栏位分隔字符；
        * +<起始栏位>-<结束栏位>：以指定的栏位来排序,范围由起始栏位到结束栏位的前一栏位.
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180528 19:36:03 #151]$ cat 1.txt
            aaa:10:1.1
            ccc:30:3.3
            ddd:40:4.4
            bbb:20:2.2
            eee:50:5.5
            eee:50:5.5

            [llllljian@llllljian-virtual-machine 20180528 19:36:08 #152]$ sort 1.txt
            aaa:10:1.1
            bbb:20:2.2
            ccc:30:3.3
            ddd:40:4.4
            eee:50:5.5
            eee:50:5.5

            [llllljian@llllljian-virtual-machine 20180528 19:36:54 #153]$ sort -u 1.txt
            aaa:10:1.1
            bbb:20:2.2
            ccc:30:3.3
            ddd:40:4.4
            eee:50:5.5

            [llllljian@llllljian-virtual-machine 20180528 19:38:09 #155]$ cat 2.txt
            AAA:BB:CC
            aaa:30:1.6
            ccc:50:3.3
            ddd:20:4.2
            bbb:10:2.5
            eee:40:5.4
            eee:60:5.1

            [llllljian@llllljian-virtual-machine 20180528 19:38:14 #156]$ sort -nk 2 -t: 2.txt 
            AAA:BB:CC
            bbb:10:2.5
            ddd:20:4.2
            aaa:30:1.6
            eee:40:5.4
            ccc:50:3.3
            eee:60:5.1
            
            [llllljian@llllljian-virtual-machine 20180528 19:39:08 #158]$ sort -nrk 3 -t: 2.txt 
            eee:40:5.4
            eee:60:5.1
            ddd:20:4.2
            ccc:50:3.3
            bbb:10:2.5
            aaa:30:1.6
            AAA:BB:CC
        ```
- wc
    * 命令格式
        * wc(选项)(参数)
    * 命令功能
        * 计算文件的Byte数 字数或是列数
    * 命令参数
        * -c或--bytes或——chars：只显示Bytes数；
        * -l或——lines：只显示列数；
        * -w或——words：只显示字数.
- uniq
    * 命令格式
        * uniq(选项)(参数)
    * 命令功能
    	* 用于报告或忽略文件中的重复行,一般与sort命令结合使用
    * 命令参数
        * -c或——count：在每列旁边显示该行重复出现的次数；
        * -d或--repeated：仅显示重复出现的行列；
        * -f<栏位>或--skip-fields=<栏位>：忽略比较指定的栏位；
        * -s<字符位置>或--skip-chars=<字符位置>：忽略比较指定的字符；
        * -u或——unique：仅显示出一次的行列；
        * -w<字符位置>或--check-chars=<字符位置>：指定要比较的字符.
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180528 19:43:56 #166]$ cat 1.txt
            aaa:10:1.1
            ccc:30:3.3
            ddd:40:4.4
            bbb:20:2.2
            eee:50:5.5
            eee:50:5.5

            [llllljian@llllljian-virtual-machine 20180528 19:44:11 #167]$ uniq 1.txt
            aaa:10:1.1
            ccc:30:3.3
            ddd:40:4.4
            bbb:20:2.2
            eee:50:5.5

            [llllljian@llllljian-virtual-machine 20180528 19:44:50 #168]$ uniq -u 1.txt
            aaa:10:1.1
            ccc:30:3.3
            ddd:40:4.4
            bbb:20:2.2

            [llllljian@llllljian-virtual-machine 20180528 19:44:52 #169]$ sort 1.txt | uniq -c
            1 aaa:10:1.1
            1 bbb:20:2.2
            1 ccc:30:3.3
            1 ddd:40:4.4
            2 eee:50:5.5

            [llllljian@llllljian-virtual-machine 20180528 19:45:22 #170]$ sort 1.txt | uniq -d
            eee:50:5.5
        ```
