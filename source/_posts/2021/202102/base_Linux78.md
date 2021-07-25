---
title: Linux_基础 (78)
date: 2021-02-03
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 让文本飞

##### grep实战演练
1. 搜索包含特定模式的文本行
    ```bash
        $ grep pattern filename
        this is the line containing pattern
        # 或者
        $ grep "pattern" filename
        this is the line containing pattern
    ```
2. 单个grep命令也可以对多个文件进行搜索
    ```bash
        grep "match_text" file1 file2 file3 ...
    ```
3. 用--color选项可以在输出行中着重标记出匹配到的单词
    ```bash
        grep word filename --color=auto
    ```
4. 正则+grep
    ```bash
        grep -E "[a-z]+" filename
        egrep "[a-z]+" filename
    ```
5. 只输出文件中匹配到的文本部分,可以使用选项-o
    ```bash
        echo this is a line. | egrep -o "[a-z]+\."
        line.
    ```
6. 要打印除包含match_pattern行之外的所有行
    ```bash
        # 选项-v可以将匹配结果进行反转(invert)
        grep -v match_pattern file
    ```
7. 统计文件或文本中包含匹配字符串的行数
    ```bash
        # -c只是统计匹配行的数量,并不是匹配的次数
        grep -c "text" filename 10

        echo -e "1 2 3 4\nhello\n5 6" | egrep -c "[0-9]"
        2
    ```
8. 要文件中统计匹配项的数量
    ```bash
        echo -e "1 2 3 4\nhello\n5 6" | egrep -o "[0-9]" | wc -l
        6
    ```
9. 打印出包含匹配字符串的行号
    ```bash
        [root@home ~]# cat sample1.txt
        gnu is not unix 
        linux is fun
        bash is art
        [root@home ~]# grep linux -n sample1.txt
        2:linux is fun
        [root@home ~]# cat sample1.txt | grep linux -n
        2:linux is fun
        [root@home ~]# grep linux -n sample*
        sample1.txt:2:linux is fun
        sample2.txt:1:planetlinux
        [root@home ~]# grep linux -n sample1.txt sample2.txt
        sample1.txt:2:linux is fun
        sample2.txt:1:planetlinux
    ```
9. 搜索多个文件并找出匹配文本位于哪个文件中
    ```bash
        [root@home ~]# grep -l linux sample1.txt sample2.txt
        sample1.txt
        sample2.txt
        [root@home ~]# grep -l bash sample1.txt sample2.txt
        sample1.txt
        [root@home ~]# grep -L bash sample1.txt sample2.txt
        sample2.txt
    ```
10. 递归搜索文件
    ```bash
        # 想完整匹配text的话 可以直接加参数-w
        grep "text" . -R -n
    ```
11. grep的静默输出
    ```bash
        grep -q "text" filename
        echo $?
        # 返回值为0就是成功, 非0就是失败
    ```
12. 打印出匹配文本之前或之后的行
    ```bash
        # -A 打印匹配某个结果之后的行
        # -B 打印匹配某个结果之前的行
        # -C 打印匹配某个结果之前和后的行
    ```





