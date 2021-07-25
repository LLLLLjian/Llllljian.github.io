---
title: Linux_基础 (80)
date: 2021-02-05
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 让文本飞

##### 使用awk进行高级文本处理
> 基本结构 awk ' BEGIN{  print "start" } pattern { commands } END{ print "end" } file
1. 工作原理
    * awk 'BEGIN { statement1 } { statement2 } END { end statement3 }'
    1. 执行BEGIN { statement1 } 语句块中的语句.
    2. 从文件或stdin中读取一行,然后执行pattern { statement2 }.重复这个过程,直到文件全部被读取完毕.
    3. 当读至输入流末尾时,执行END { statement3 } 语句块
2. eg
    ```bash
        # 1. i=0
        # 2. 读filename中一行内容 i++
        # 3. 读完整个文件 输出i
        awk "BEGIN { i=0 } { i++ } END{ print i }" filename

        # 当print的参数是以逗号进行分隔时,参数打印时则以空格作为定界符
        echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1,var2,var3 ; }'
        v1 v2 v3

        # 拼接
        echo | awk '{ var1="v1"; var2="v2"; var3="v3";  print var1 "-" var2 "-" var3 ; }'
        v1-v2-v3
    ```
3. awk特殊变量
    * NR:表示记录数量,在执行过程中对应于当前行号
    * NF:表示字段数量,在执行过程中对应于当前行的字段数
    * $0:这个变量包含执行过程中当前行的文本内容
    * $1:这个变量包含第一个字段的文本内容
    * $2:这个变量包含第二个字段的文本内容
4. eg
    ```bash
        [root@gzns-store-sandbox009 master]# echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{ print "Line no:"NR",No of fields:"NF, "$0="$0, "$1="$1,"$2="$2,"$3="$3}'
        Line no:1,No of fields:3 $0=line1 f2 f3 $1=line1 $2=f2 $3=f3
        Line no:2,No of fields:3 $0=line2 f4 f5 $1=line2 $2=f4 $3=f5
        Line no:3,No of fields:3 $0=line3 f6 f7 $1=line3 $2=f6 $3=f7
    ```
5. eg
    ```bash
        # 打印每一行的第2和第3个字段
        [root@xxxxxx test_code_dir]# echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7"
        line1 f2 f3
        line2 f4 f5
        line3 f6 f7
        [root@xxxxxx test_code_dir]# echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{ print $3,$2 }'
        f3 f2
        f5 f4
        f7 f6

        # 统计文件中的行数
        [root@xxxxxx test_code_dir]# echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk 'END{ print NR }'
        3

        [root@xxxxxx test_code_dir]# seq 5 | awk 'BEGIN{ sum=0; print "Summation:" } { print $1"+"; sum+=$1 } END { print "=="; print sum }'
        Summation:
        1+
        2+
        3+
        4+
        5+
        ==
        15
    ```
6. 用getline读取行
    ```bash
        [root@xxxxxx test_code_dir]# seq 5 | awk 'BEGIN { print "each line" } { print "line content:"$0}'
        each line
        line content:1
        line content:2
        line content:3
        line content:4
        line content:5

        [root@xxxxxx test_code_dir]# seq 5 | awk 'BEGIN { getline; print "Read ahead first line", $0 } { print $0 }'
        Read ahead first line 1
        2
        3
        4
        5
    ```
7. 使用过滤模式对awk处理的行进行过滤
    ```bash
        awk 'NR < 5' # 行号小于5的行
        [root@xxxxxx test_code_dir]# seq 10 | awk 'NR < 5'
        1
        2
        3
        4

        awk 'NR==1,NR==4' # 行号在1到5之间的行
        [root@xxxxxx test_code_dir]# seq 10 | awk 'NR==1,NR==7'
        1
        2
        3
        4
        5
        6
        7

        awk '/linux/' # 包含样式linux的行(可以用正则表达式来指定模式) $ awk '!/linux/' # 不包含包含模式为linux的行
    ```
8. 设置字段定界符
    ```bash
        # 用 -F "delimiter"明确指定一个定界符
        [root@xxxxxx test_code_dir]# echo -e "line1:f2:f3\nline2:f4:f5\nline3:f6:f7" | awk -F: '{ print $1 }'
        line1
        line2
        line3

        [root@xxxxxx test_code_dir]# awk -F: '{ print $NF }' /etc/passwd
        /bin/bash
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /bin/sync
        /sbin/shutdown
        /sbin/halt
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /bin/bash
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin

        # 用OFS="delimiter"设置输出字段的定界符
        [root@xxxxxx test_code_dir]# awk 'BEGIN { FS=":" } { print $NF }' /etc/passwd
        /bin/bash
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /bin/sync
        /sbin/shutdown
        /sbin/halt
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /bin/bash
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
        /sbin/nologin
    ```
9. 从awk中读取命令输出
    ```bash
        # 将命令的输出结果读入变量output的语法如下: "command" | getline output ;
        [root@xxxxxx test_code_dir]# echo | awk '{ "grep root /etc/passwd" | getline cmdout ; print cmdout }'
        root:x:0:0:root:/root:/bin/bash
    ```


