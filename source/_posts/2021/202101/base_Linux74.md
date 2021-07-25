---
title: Linux_基础 (74)
date: 2021-01-28
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 命令之乐

##### sort
> sort命令能够帮助我们对文本文件和stdin进行排序操作. 它通常会配合其他命令来生成所需要的输出. uniq是一个经常与sort一同使用的命令. 它的作用是从文本或stdin中提取唯一(或重复)的行
1.  对一组文件(例如file1.txt和file2.txt)进行排序: 
    ```bash
        sort file1.txt file2.txt > sorted.txt
        # 或是 sort file1.txt file2.txt -o sorted.txt
    ```
2. 按照数字顺序进行排序
    ```bash
        sort -n file.txt
    ```
3. 按照逆序进行排序
    ```bash
        sort -r file.txt
    ```
4. 按照月份进行排序(依照一月,二月,三月......)
    ```bash
        sort -M months.txt
    ```
5. 合并两个已排序过的文件
    ```bash
        sort -m sorted1 sorted2
    ```
6. 找出已排序文件中不重复的行:
    ```bash
        sort file1.txt file2.txt | uniq
    ```
7. 检查文件是否已经排序过
    ```bash
        #!/bin/bash #功能描述:排序
        sort -C filename ;
        if [ $? -eq 0 ]; then
            echo Sorted;
        else
            echo Unsorted;
        fi
    ```
8. 依据键或列进行排序
    ```bash
         $ cat datas.txt
        1 mac 2000
        2 winxp 4000
        3 bsd 1000
        4 linux 1000

        cat datas.txt | sort
        1 mac 2000
        2 winxp 4000
        3 bsd 1000
        4 linux 1000

        cat datas.txt | sort -k 3
        3 bsd 1000
        4 linux 1000
        1 mac 2000
        2 winxp 4000

        sort -nrk 1 datas.txt
        4 linux 1000
        3 bsd 1000
        2 winxp 4000
        1 mac 2000
    ```




