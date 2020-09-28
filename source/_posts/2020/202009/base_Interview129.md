---
title: Interview_总结 (129)
date: 2020-09-14
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-我为啥不会查看文件了

<!-- more -->

#### 先说遇到的问题
>A: 我看你简历上的写的熟悉常见的shell命令, 你能给我说一下你平时是怎么查看文件的吗
B: 哦 查看文件的话用cat head tail, 切割文件用awk, 匹配内容用grep
A: 那你能详细给我说一下head和tail吗
A: 还有文件追加的方式
A: 还有查看端口的

#### cat
> cat(英文全拼：concatenate)命令用于连接文件并打印到标准输出设备上.
- 使用权限
    * 所有使用者
- 语法格式
    ```bash
        cat [-AbeEnstTuv] [--help] [--version] fileName
    ```
- 参数说明
    * -n 或 --number：由 1 开始对所有输出的行数编号.
    * -b 或 --number-nonblank：和 -n 相似,只不过对于空白行不编号.
    * -s 或 --squeeze-blank：当遇到有连续两行以上的空白行,就代换为一行的空白行.
    * -v 或 --show-nonprinting：使用 ^ 和 M- 符号,除了 LFD 和 TAB 之外.
    * -E 或 --show-ends : 在每行结束处显示 $.
    * -T 或 --show-tabs: 将 TAB 字符显示为 ^I.
    * -A, --show-all：等价于 -vET.
    * -e：等价于"-vE"选项；
    * -t：等价于"-vT"选项；
- 实例
    ```bash
        # 把 textfile1 的文档内容加上行号后输入 textfile2 这个文档里
        cat -n textfile1 > textfile2

        # 把 textfile1 和 textfile2 的文档内容加上行号(空白行不加)之后将内容附加到 textfile3 文档里
        cat -b textfile1 textfile2 >> textfile3

        # 清空 /etc/test.txt 文档内容
        cat /dev/null > /etc/test.txt
    ```

#### head
> head 命令可用于查看文件的开头部分的内容,有一个常用的参数 -n 用于显示行数,默认为 10,即显示 10 行的内容
- 命令格式：
    ```bash
        head [参数] [文件]
    ```
- 参数
    * -q 隐藏文件名
    * -v 显示文件名
    * -c<数目> 显示的字节数
    * -n<行数> 显示的行数
- 实例
    ```bash
        # 要显示 runoob_notes.log 文件的开头 10 行,请输入以下命令
        head runoob_notes.log

        # 显示 notes.log 文件的开头 5 行,请输入以下命令
        head -n 5 runoob_notes.log

        # 显示文件前 20 个字节
        head -c 20 runoob_notes.log
    ```

#### tail
> tail 命令可用于查看文件的内容,有一个常用的参数 -f 常用于查阅正在改变的日志文件.
tail -f filename 会把 filename 文件里的最尾部的内容显示在屏幕上,并且不断刷新,只要 filename 更新就可以看到最新的文件内容.
- 命令格式
    ```bash
        tail [参数] [文件]
    ```
- 参数
    * -f 循环读取
    * -q 不显示处理信息
    * -v 显示详细的处理信息
    * -c<数目> 显示的字节数
    * -n<行数> 显示文件的尾部 n 行内容
    * --pid=PID 与-f合用,表示在进程ID,PID死掉之后结束
    * -q, --quiet, --silent 从不输出给出文件名的首部
    * -s, --sleep-interval=S 与-f合用,表示在每次反复的间隔休眠S秒
- 实例
    ```bash
        # 要显示 notes.log 文件的最后 10 行,请输入以下命令
        tail notes.log

        # 要跟踪名为 notes.log 的文件的增长情况,请输入以下命令
        tail -f notes.log

        # 显示文件 notes.log 的内容,从第 20 行至文件末尾
        tail +20 notes.log
        
        # 显示文件 notes.log 的最后 10 个字符
        tail -c 10 notes.log
    ```

#### head与tail区别
![head与tail区别](/img/20200914_1.png)

#### netstat
> netstat 命令用于显示网络状态.利用 netstat 指令可让你得知整个 Linux 系统的网络情况.
- 语法
    ```bash
        netstat [-acCeFghilMnNoprstuvVwx][-A<网络类型>][--ip]
    ```
- 参数说明
    * -a或--all 显示所有连线中的Socket.
    * -A<网络类型>或--<网络类型> 列出该网络类型连线中的相关地址.
    * -c或--continuous 持续列出网络状态.
    * -C或--cache 显示路由器配置的快取信息.
    * -e或--extend 显示网络其他相关信息.
    * -F或--fib 显示FIB.
    * -g或--groups 显示多重广播功能群组组员名单.
    * -h或--help 在线帮助.
    * -i或--interfaces 显示网络界面信息表单.
    * -l或--listening 显示监控中的服务器的Socket.
    * -M或--masquerade 显示伪装的网络连线.
    * -n或--numeric 直接使用IP地址,而不通过域名服务器.
    * -N或--netlink或--symbolic 显示网络硬件外围设备的符号连接名称.
    * -o或--timers 显示计时器.
    * -p或--programs 显示正在使用Socket的程序识别码和程序名称.
    * -r或--route 显示Routing Table.
    * -s或--statistics 显示网络工作信息统计表.
    * -t或--tcp 显示TCP传输协议的连线状况.
    * -u或--udp 显示UDP传输协议的连线状况.
    * -v或--verbose 显示指令执行过程.
    * -V或--version 显示版本信息.
    * -w或--raw 显示RAW传输协议的连线状况.
    * -x或--unix 此参数的效果和指定"-A unix"参数相同.
    * --ip或--inet 此参数的效果和指定"-A inet"参数相同.
- 实例
    ```bash
        # 查看端口是否被占用
        netstat -anp | grep 3306
    ```



