---
title: Linux_基础 (76)
date: 2021-02-01
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 命令之乐

##### expect
1. 先来个交互式输入的脚本
    ```bash
        cat interactive.sh
        # !/bin/bash
        # 文件名: interactive.sh

        read -p "Enter number:" no ;
        read -p "Enter name:" name
        echo You have entered $no, $name;

        sh interactive.sh
        Enter number:2
        Enter name:llllljian
        You have entered 2, llllljian
    ```
2. 自动化交互式脚本
    ```bash
        # spawn参数指定需要自动化哪一个命令; 
        # expect参数提供需要等待的消息;
        # send是要发送的消息;
        # expect eof指明命令交互结束

        cat automate_expect.sh
        # !/usr/bin/expect
        # 文件名: automate_expect.sh
        spawn ./interactive.sh
        expect "Enter number:" send "1\n"
        expect "Enter name:"
        send "hello\n"
        expect eof
    ```

##### 利用并行进程加速命令执行
> 利用Bash的操作符&, 它使得shell将命令置于后台并继续执行脚本. 这意味着一旦循环结束, 脚本就会退出,而md5sum命令仍在后台运行. 为了避免这种情况, 我们使用$!来获得进程的PID, 在Bash中, $!保存着最近一个后台进程的PID. 我们将这些PID放入数组, 然后使用wait命令等待这些进程结束
- eg
    ```bash
        # /bin/bash
        # 文件名: generate_checksums.sh 
        PIDARRAY=()
        for file in File1.iso File2.iso 
        do
            md5sum $file &
            PIDARRAY+=("$!")
        done
        wait ${PIDARRAY[@]}
    ```

