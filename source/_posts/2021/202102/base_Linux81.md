---
title: Linux_基础 (81)
date: 2021-02-07
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 让文本飞

##### 实战演练
1. 按列合并多个文件
    ```bash
        [root@xxxxx test_code_dir]# cat 1.txt
        1
        2
        3
        4
        5

        [root@xxxxx test_code_dir]# cat 2.txt
        a
        b
        c
        d
        e

        [root@xxxxx test_code_dir]# paste 1.txt 2.txt
        1	a
        2	b
        3	c
        4	d
        5	e

        [root@xxxxx test_code_dir]# paste 1.txt 2.txt -d "="
        1=a
        2=b
        3=c
        4=d
        5=e
    ```
2. 以逆序形式打印行
    ```bash
        [root@xxxxx test_code_dir]# seq 5 | tac
        5
        4
        3
        2
        1

        [root@xxxxx test_code_dir]# tac 1.txt 2.txt
        5
        4
        3
        2
        1
        e
        d
        c
        b
        a

        # \ 可以很方便地将单行命令拆解成多行.
        [root@xxxxx test_code_dir]# seq 9 | \
        > awk '{ lifo[NR]=$0 }
        > END{ for(lno=NR;lno>-1;lno--){ print lifo[lno]; } }'
        9
        8
        7
        6
        5
        4
        3
        2
        1
    ```
3. 在文件中移除包含某个单词的句子
    ```bash
        [root@xxxxx test_code_dir]# cat 3.txt
        Linux refers to the family of Unix-like computer operating systems that use the Linux kernel. Linux can be installed on a wide variety of computer hardware, ranging from mobile phones, tablet computers and video game consoles, to mainframes and supercomputers. Linux is predominantly known for its use in servers.
        [root@xxxxx test_code_dir]# sed 's/ [^.]*mobile phones[^.]*\.//g' 3.txt
        Linux refers to the family of Unix-like computer operating systems that use the Linux kernel. Linux is predominantly known for its use in servers.
    ```
4. 对目录中的所有文件进行文本替换
    ```bash
        # 将所有.cpp文件中的Copyright替换成Copyleft
        # 1. 使用find在当前目录下查找所有的.cpp文件,然后使用print0打印出以null字符(\0)作为分隔符的文件列表(避免文件名中的空格所带来的麻烦)
        # 2. 使用通道将列表传递给xargs,后者将对应的文件作为sed的参数,由sed对文件内容进行修改
        find . -name *.cpp -print0 | xargs -I{} -0 sed -i 's/Copyright/Copyleft/g' {}

        # 为每个查找到的文件调用一次sed
        find . -name *.cpp -exec sed -i 's/Copyright/Copyleft/g' \{\} \;

        # 将多个文件名一并传递给sed
        find . -name *.cpp -exec sed -i 's/Copyright/Copyleft/g' \{\} \+
    ```


