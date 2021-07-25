---
title: Linux_基础 (73)
date: 2021-01-27
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 命令之乐

##### xargs
> 将标准输入数据转换成命令行参数. xargs能够处理stdin并将其转换为特定命令的命令行参数.xargs也可以将单行或多行文本输入转换成其他格式,例如单行变多行或是多行变单行
1. 将多行输入转换成单行输出
    ```bash
        cat example.txt
        1 2 3 4 5 6
        7 8 9 10
        11 12

        cat example.txt | xargs
        1 2 3 4 5 6 7 8 9 10 11 12
    ```
2. 将单行输入转换成多行输出
    ```bash
        # 指定每行最大的参数数量n,我们可以将任何来自stdin的文本划分成多行,每行n个参数. 每一个参数都是由" "(空格)隔开的字符串.空格是默认的定界符 
        cat example.txt | xargs -n 3
        1 2 3
        4 5 6
        7 8 9
        10 11 12
    ```
3. 自定义分隔符分割stdin
    ```bash
        echo "splitXsplitXsplitXsplit" | xargs -d X 
        split split split split

        echo "splitXsplitXsplitXsplit" | xargs -d X -n 2
        split split
        split split
    ```
4. 读取stdin, 将格式化参数传递给命令
    * 文件args.txt中每一行是一个参数, 需要作为唯一参数传递到cecho.sh文件中
    ```bash
        cat args.txt
        arg1
        arg2
        arg3

        cat cecho.sh
        # !/bin/bash
        # 文件名: cecho.sh
        echo $*'#'

        cat args.txt | xargs -n 1 ./cecho.sh
        arg1#
        arg2#
        arg3#
    ```
5. 4的优化: 每次执行需要X个参数的命令
    ```bash
        cat args.txt | xargs -n 2 ./cecho.sh
        arg1 arg2#
        arg3#
    ```
6. 结合find使用xargs
    ```bash
        # 用find匹配并列出所有的 .txt文件,然后用xargs将这些文件删除
        find . -type f -name "*.txt" -print0 | xargs -0 rm -f
    ```
7. 统计当前文件夹中所有python程序文件的行数
    ```bash
        # find . -name "*.py" | xargs wc -l 相同效果 
        find . -type f -name "*.py" -print0 | xargs -0 wc -l
        15 ./20201224_2.py
        15 ./20201224_3.py
        24 ./20201023_2.py
        10 ./20201221_1.py
        41 ./20201023_6.py
        42 ./20201023_7.py
        10 ./20201109_1.py
        22 ./20201023_3.py
        12 ./20201023_4.py
        13 ./20201109_2.py
        10 ./20201023_1.py
        6 ./arithmetic/add.py
        13 ./arithmetic/__init__.py
        6 ./arithmetic/mul.py
        6 ./arithmetic/sub.py
        6 ./arithmetic/dev.py
        75 ./20201023_5.py
        18 ./20201109_3.py
        5 ./helloWorld.py
        27 ./main.py
        19 ./20201224_1.py
        395 total
    ```
8. 结合stdin,巧妙运用while语句和子shell
    ```bash
        cat files.txt
        20201023_1.py
        20201023_3.py
        20201023_5.py
        20201023_7.py
        
        cat files.txt | ( while read arg; do cat $arg; done ) 
        # 等同于cat files.txt | xargs -I {} cat {}
    ```

##### tr
> tr可以对来自标准输入的内容进行字符替换、字符删除以及重复字符压缩
它可以将一组字符变成另一组字符, 因而通常也被称为转换(translate)命令
- 命令格式
    * tr \[options] set1 set2
    * 将来自stdin的输入字符从set1映射到set2, 然后将输出写入stdout(标准输出). set1 和set2是字符类或字符集
- 需要注意的事
    * 如果两个字符集的长度不相等,那么set2会不断重复其最后一个字 符,直到长度与set1相同.如果set2的长度大于set1,那么在set2中超出set1长度的那部分 字符则全部被忽略
- eg1
    ```bash
        echo "HELLO WHO IS THIS" | tr 'A-Z' 'a-z'
        ello who is this
    ```
- eg2
    ```bash
        echo 12345 | tr 1 9999
        92345

        echo 12345 | tr "123" "9"
        99945
    ```
- eg3
    * 还可以用来加密解密
    ```bash
        # 加密
        echo 12345 | tr '0-9' '9876543210'
        87654

        # 解密
        echo 87654 | tr '9876543210' '0-9'
        12345
    ```
- ROT13
    * 是一个著名的加密算法. 在ROT13算法中, 文本加密和解密都使用同一个函数. ROT13 按照字母表排列顺序执行13个字母的转换
    ```bash
        echo "tr came, tr saw, tr conquered." | tr 'a-zA-Z' 'n-za-mN-ZA-M'
        ge pnzr, ge fnj, ge pbadhrerq.

        echo "ge pnzr, ge fnj, ge pbadhrerq." | tr 'a-zA-Z' 'n-za-mN-ZA-M'
        tr came, tr saw, tr conquered.
    ```
1. 用tr删除字符
    ```bash
        echo "Hello 123 world 456" | tr -d '0-9' 
        Hello world
    ```
2. 字符集补集
    ```bash
        echo hello 1 char 2 next 4 | tr -d -c '0-9 \n' 
        1 2 4
    ```
3. 用tr压缩字符
    ```bash
        1
    ```
4. 字符类
    ```bash
        echo "aaaaa" | tr '[:lower:]' '[:upper:]'
        AAAAA
    ```
