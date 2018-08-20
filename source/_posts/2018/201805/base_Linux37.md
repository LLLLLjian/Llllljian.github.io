---
title: Linux_基础 (37)
date: 2018-05-29
tags: Linux
toc: true
---

### 管线命令pipe
    管道就是用 | 连接两个命令,以前面一个命令的标准输出作为后面命令的标准输入,与连续执行命令是有区别的,值得注意的管道对于前一条命令的标准错误输出没事有处理能力的

<!-- more -->

#### 双向重导向
- tee
    * 命令格式
       * tee(选项)(参数)
    * 命令功能
        * 将数据重定向到文件,另一方面还可以提供一份重定向数据的副本作为后续命令的stdin.简单的说就是把数据重定向到给定文件和屏幕上.
    * 命令参数
    	* -a：向文件中重定向时使用追加模式；
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180529 21:42:19 #18]$ ls -al /home/llllljian/study/201805 | tee1.txt
            总用量 44
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 .
            drwxrwxr-x  3 llllljian llllljian 4096 5月  27 13:46 ..
            drwxrwxrwx  2 root      root      4096 5月  16 23:48 20180502
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180503
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180504
            drwxrwxrwx  3 root      root      4096 5月  14 21:45 20180513
            drwxrwxrwx  3 root      root      4096 5月  14 20:31 20180514
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:26 20180525
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:01 20180527
            drwxrwxr-x  2 llllljian llllljian 4096 5月  28 21:42 20180528
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 21:40 20180529

            [llllljian@llllljian-virtual-machine 20180529 21:42:53 #19]$ cat 1.txt
            总用量 44
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 .
            drwxrwxr-x  3 llllljian llllljian 4096 5月  27 13:46 ..
            drwxrwxrwx  2 root      root      4096 5月  16 23:48 20180502
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180503
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180504
            drwxrwxrwx  3 root      root      4096 5月  14 21:45 20180513
            drwxrwxrwx  3 root      root      4096 5月  14 20:31 20180514
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:26 20180525
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:01 20180527
            drwxrwxr-x  2 llllljian llllljian 4096 5月  28 21:42 20180528
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 21:40 20180529

            [llllljian@llllljian-virtual-machine 20180529 21:43:19 #20]$ ls -al /home/llllljian/study/201805 | tee -a 1.txt
            总用量 44
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 .
            drwxrwxr-x  3 llllljian llllljian 4096 5月  27 13:46 ..
            drwxrwxrwx  2 root      root      4096 5月  16 23:48 20180502
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180503
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180504
            drwxrwxrwx  3 root      root      4096 5月  14 21:45 20180513
            drwxrwxrwx  3 root      root      4096 5月  14 20:31 20180514
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:26 20180525
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:01 20180527
            drwxrwxr-x  2 llllljian llllljian 4096 5月  28 21:42 20180528
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 21:42 20180529

            [llllljian@llllljian-virtual-machine 20180529 21:44:25 #21]$ cat 1.txt
            总用量 44
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 .
            drwxrwxr-x  3 llllljian llllljian 4096 5月  27 13:46 ..
            drwxrwxrwx  2 root      root      4096 5月  16 23:48 20180502
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180503
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180504
            drwxrwxrwx  3 root      root      4096 5月  14 21:45 20180513
            drwxrwxrwx  3 root      root      4096 5月  14 20:31 20180514
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:26 20180525
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:01 20180527
            drwxrwxr-x  2 llllljian llllljian 4096 5月  28 21:42 20180528
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 21:40 20180529
            总用量 44
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 .
            drwxrwxr-x  3 llllljian llllljian 4096 5月  27 13:46 ..
            drwxrwxrwx  2 root      root      4096 5月  16 23:48 20180502
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180503
            drwxrwxrwx  2 root      root      4096 5月  16 22:15 20180504
            drwxrwxrwx  3 root      root      4096 5月  14 21:45 20180513
            drwxrwxrwx  3 root      root      4096 5月  14 20:31 20180514
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:26 20180525
            drwxrwxr-x  2 llllljian llllljian 4096 5月  27 21:01 20180527
            drwxrwxr-x  2 llllljian llllljian 4096 5月  28 21:42 20180528
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 21:42 20180529
        ```

#### 分区命令
- split
    * 命令格式
        * split [-bl] file PREFIX
    * 命令功能
        * 将一个大文件分割成很多个小文件,有时需要将文件分割成更小的片段,比如为提高可读性,生成日志等
    * 命令参数
        * -b：值为每一输出档案的大小,单位为 byte.
        * -C：每一输出档中,单行的最大 byte 数.
        * -d：使用数字作为后缀.
        * -l：值为每一输出档的列数大小.
        * PREFIX 代表前导符的意思.可作为分区文件的前导文字
    * 命令实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180529 21:58:46 #34]$ ls -al /etc/services
            -rw-r--r-- 1 root root 19183 12月 26  2016 /etc/services

            按文件大小分
            [llllljian@llllljian-virtual-machine 20180529 21:59:41 #35]$ split -b 1k /etc/services split_test

            [llllljian@llllljian-virtual-machine 20180529 21:59:51 #36]$ ll
            总用量 88
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 21:57 .
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 ..
            -rw-rw-r--  1 llllljian llllljian 1386 5月  29 21:44 1.txt
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testaa
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testab
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testac
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testad
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testae
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testaf
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testag
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testah
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testai
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testaj
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testak
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testal
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testam
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testan
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testao
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testap
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testaq
            -rw-rw-r--  1 llllljian llllljian 1024 5月  29 21:59 split_testar
            -rw-rw-r--  1 llllljian llllljian  751 5月  29 21:59 split_testas

            llllljian@llllljian-virtual-machine 20180529 22:09:13 #77]$ wc -l 1.txt
            24 1.txt

            按行分 前缀为1_ 后缀为数字 长度为3
            [llllljian@llllljian-virtual-machine 20180529 22:09:26 #78]$ split -l 5 1.txt 1_ -d -a 3

            [llllljian@llllljian-virtual-machine 20180529 22:09:48 #79]$ ls -al 1*
            -rw-rw-r-- 1 llllljian llllljian  252 5月  29 22:09 1_000
            -rw-rw-r-- 1 llllljian llllljian  315 5月  29 22:09 1_001
            -rw-rw-r-- 1 llllljian llllljian  252 5月  29 22:09 1_002
            -rw-rw-r-- 1 llllljian llllljian  315 5月  29 22:09 1_003
            -rw-rw-r-- 1 llllljian llllljian  252 5月  29 22:09 1_004
            -rw-rw-r-- 1 llllljian llllljian 1386 5月  29 21:44 1.txt
        ```

#### 参数代换
- xargs
    * 命令格式
        * xargs [参数] command
    * 命令功能
        * 用作替换工具,读取输入数据重新格式化后输出
    * 命令参数
        * -0： 如果输入的stdin含有特殊字符,例如`, \, 空格键等字符时,这个参数可以将它还原成一般字符.这个参数可以用于特殊状态.
	    * -e：这个是EOF(end of file）的意思.后面可以接一个字符串,当xargs分析到这个字符串时,就会停止工作.
	    * -p：在执行每个命令的参数时,都会询问用户.
	    * -n：后面接次数,每次command命令执行时,要使用几个参数.
	    * -d：使用自己的定义的定界符来分隔参数.
	    * -I：大写i,将xargs的每项名称,一般是一行一行赋值给{},可以{}代替.使用-i的时候,命令以循环的方式执行.如果有3个参数,那么命令就会连同{}一起被执行3次.在每一次执行中{}都会被替换为相应的参数
    * 命令实例
        ```bash
            1.使用-0选项删除test文件夹中文件名含空格的文件"file 1.log" "file 2.log"
            [llllljian@llllljian-virtual-machine 20180529 22:20:08 #87]$ touch "file 1.log" "file 2.log"

            [llllljian@llllljian-virtual-machine 20180529 22:32:30 #88]$ ls -l *.log
            -rw-rw-r-- 1 llllljian llllljian 0 5月  29 22:32 file 1.log
            -rw-rw-r-- 1 llllljian llllljian 0 5月  29 22:32 file 2.log

            [llllljian@llllljian-virtual-machine 20180529 22:32:36 #89]$ find -name '*.log' | xargs rm
            rm: 无法删除'./file': 没有那个文件或目录
            rm: 无法删除'2.log': 没有那个文件或目录
            rm: 无法删除'./file': 没有那个文件或目录
            rm: 无法删除'1.log': 没有那个文件或目录

            [llllljian@llllljian-virtual-machine 20180529 22:32:52 #90]$ find -name '*.log' -print0 | xargs -0  rm

            [llllljian@llllljian-virtual-machine 20180529 22:33:22 #91]$ ls -l *.log
            ls: 无法访问'*.log': 没有那个文件或目录

            2.使用-e选项只打印"a bc d e rf f"中字符e之前的字符串
            [llllljian@llllljian-virtual-machine 20180529 22:33:30 #92]$ echo a bc d e rf f | xargs -ee
            a bc d

            3.使用-p选项
            [llllljian@llllljian-virtual-machine 20180529 22:35:43 #94]$ ls 1_*
            总用量 108
            drwxrwxr-x  2 llllljian llllljian 4096 5月  29 22:33 .
            drwxrwxr-x 11 llllljian llllljian 4096 5月  29 21:42 ..
            -rw-rw-r--  1 llllljian llllljian  252 5月  29 22:09 1_000
            -rw-rw-r--  1 llllljian llllljian  315 5月  29 22:09 1_001
            -rw-rw-r--  1 llllljian llllljian  252 5月  29 22:09 1_002
            -rw-rw-r--  1 llllljian llllljian  315 5月  29 22:09 1_003
            -rw-rw-r--  1 llllljian llllljian  252 5月  29 22:09 1_004

            [llllljian@llllljian-virtual-machine 20180529 22:35:44 #95]$ ls 1_* | xargs -p rm
            rm 1_000 1_001 1_002 1_003 1_004 ?...y

            [llllljian@llllljian-virtual-machine 20180529 22:36:03 #96]$ ls 1_*
            ls: 无法访问'1_*': 没有那个文件或目录

            4.将多行输入转换成单行输出
            [llllljian@llllljian-virtual-machine 20180529 22:40:20 #105]$ cat 2.txt
            1 2 3 4 5 6
            7 8 9 10

            [llllljian@llllljian-virtual-machine 20180529 22:40:23 #106]$ cat 2.txt | xargs
            1 2 3 4 5 6 7 8 9 10

            5.将单行输入转换成多行输出
            [llllljian@llllljian-virtual-machine 20180529 22:40:43 #107]$ cat 2.txt | xargs -n 3
            1 2 3
            4 5 6
            7 8 9
            10

            6.使用-d选项分隔字符串成单行或多行
            [llllljian@llllljian-virtual-machine 20180529 22:43:12 #109]$ echo "splitXsplitXsplitXsplit" | xargs -d X
            split split split split

            [llllljian@llllljian-virtual-machine 20180529 22:43:13 #110]$ echo "splitXsplitXsplitXsplit" | xargs -d X -n 2
            split split
            split split

            [llllljian@llllljian-virtual-machine 20180529 22:44:01 #112]$ echo This is file1.txt > file1.txt

            [llllljian@llllljian-virtual-machine 20180529 22:44:03 #113]$ echo This is file2.txt > file2.txt

            [llllljian@llllljian-virtual-machine 20180529 22:44:11 #114]$ echo This is file3.txt > file3.txt

            [llllljian@llllljian-virtual-machine 20180529 22:44:17 #115]$ vim files.txt
            
            [llllljian@llllljian-virtual-machine 20180529 22:44:33 #116]$ cat files.txt
            file1.txt
            file2.txt
            file3.txt

            [llllljian@llllljian-virtual-machine 20180529 22:44:43 #117]$ cat files.txt | xargs -I {} cat {}
            This is file1.txt
            This is file2.txt
            This is file3.txt

            [llllljian@llllljian-virtual-machine 20180529 22:47:53 #125]$ cat files.txt | ( while read arg ; do cat $arg; done )
            This is file1.txt
            This is file2.txt
            This is file3.txt
        ```
