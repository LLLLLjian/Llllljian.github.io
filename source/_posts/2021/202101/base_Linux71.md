---
title: Linux_基础 (71)
date: 2021-01-25
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 小试牛刀

##### 标准变量和环境变量的补充
1. 获得字符串长度
    ```bash
        length=${#var}
        var=12345678901234567890$
        echo ${#var}
        20
    ```
2. 识别当前所使用的shell
    ```bash
        echo $SHELL
        echo $0
    ```
3. 检查是否为超级用户
    ```bash
        If [ $UID -ne 0 ]; then
            echo Non root user. Please run as root.
        else
            echo Root user
        fi
    ```
4. 修改Bash提示字符串(username@hostname:~$)
    ```bash
        # 通过设置变量PS1来改变提示字符串
        PS1='[\[\e[31m\]\u\[\e[32m\]@\[\e[33m\]\h \[\e[34m\]\W \[\e[35m\]\t \[\e[37m\]#\#]\$ '
    ```

##### 将命令序列的输出读入变量的补充
1. 先从组合两个命令开始
    ```bash
        # ls的输出(当前目录内容的列表)被传给cat -n,后者将通过stdin所接收到输入 内容加上行号,然后将输出重定向到文件out.txt 
        ls | cat -n > out.txt
    ```
2. 读取由管道相连的命令序列的输出
    ```bash
        # 子shell cmd_output=$(COMMANDS)
        cmd_output=$(ls | cat -n)
        echo $cmd_output
        # 反引用 cmd_output=`COMMANDS`
        cmd_output=`ls | cat -n`
        echo $cmd_output
    ```
3. 利用子shell生成一个独立的进程
    ```bash
        # 子shell本身就是独立的进程.可以使用()操作符来定义一个子shell
        pwd;
            (cd /bin; ls);
        pwd;
    ```

##### 字段分隔符
> IFS的默认值为空白字符(换行符、制表符或者空格). 当IFS被设置为逗号时,shell将逗号视为一个定界符,因此变量$item在每次迭代中读取由逗号分隔的子串作为变量值. 如果没有把IFS设置成逗号,那么上面的脚本会将全部数据作为单个字符串打印出来
- eg
    ```bash
        # 将文件中的内容按逗号分割, 然后再输出
        data="name,sex,rollno,location"
        oldIFS=$IFS
        IFS=","
        for item in $data; do
            echo Item: $item
        done
        
        # 输出结果
        # Item: name
        # Item: sex
        # Item: rollno
        # Item: location
    ```
- eg1
    ```bash
        # 获取每个用户的uid和gid
        # !/bin/bash
        # 用途: 演示IFS的用法 
        list[0]="root:x:0:0:root:/root:/bin/bash"
        list[1]="work:x:1:5:root:/root:/bin/bash"

        for i in ${!list[*]};
        do
            IFS=":"
            count=0
            for item in ${list[$i]};
            do
                [ $count -eq 0 ] && user=$item;
                [ $count -eq 2 ] && uid=$item; 
                [ $count -eq 3 ] && gid=$item; 
                let count++
            done;
            echo $user\'s uid is $uid gid is $gid;
        done

        # 输出结果
        root's uid is 0 gid is 0
        work's uid is 1 gid is 5
    ```


