---
title: Linux_基础 (34)
date: 2018-05-24
tags: Linux
toc: true
---

### 数据流重导向
    数据流重导向就是将某个指令执行后的应该出现在屏幕上的数据传输到其它地方

<!-- more -->

#### 是什么


#### 怎么做
- standard input
    * 标准输入 : 
    * 代码为0,使用 < 或 <<
    * 将原本需要由键盘输入的数据,改由文件内容来取代
- standard output
    * 标准输出 : 指令执行所回传的正确的信息
    * 代码为1,使用 > 或 >>
    * 1> : 以覆盖的方式将正确的数据输出到指定的文件或装置上
    * 1>> : 以追加的方式将正确的数据输出到指定的文件或装置上
- standard error output
    * 标准错误输出 : 指令执行失败后所回传的错误信息
    * 代码为2,使用 2> 或 2>>
    * 2> : 以覆盖的方式将错误的数据输出到指定的文件或装置上
    * 2>> : 以追加的方式将错误的数据输出到指定的文件或装置上
```bash
    列举/(根目录)目录下的文件信息,> 输出到 ./log文件中
    ls -l / > ./log 

    将错误输出到log_false文件中 -将正确输出到log_true文件
    cat /etc/crontab 2>./log_false 1>./log_true  

    将错误信息和正确信息同时写入一个文档
    find / -name .bashrc &>5.txt
    find / -name .bashrc >6.txt 2>&1

    解释 : 首先将标准输出重定向到6.txt中,然后2>表示把标准错误也重定向,重定向到1所指的那个文件中
    find / -name .bashrc >6.txt 2>&1
```

```bash
    思考1 
    find / -name .bashrc 1>&2 2> 7.txt
    只会将标准错误输出写入到7.txt中,标准输出未写入而是直接输出

    思考2
    find / -name .bashrc 2> 8.txt 1>8.txt
    写入文件的内容混乱,没有按一定的顺序
```

#### 命令运行的判断依据
- 列表
    <table><tr><th>指令下达情况</th><th>说明</th></tr><tr><td>cmd1 ; cmd2</td><td>不考虑命令相关性的连续命令下达</td></tr><tr><td>cmd1 && cmd2</td><td>(1)若 cmd1 运行完毕且正确运行($?=0),则开始运行cmd2.<br />(2)若cmd1运行完毕且为错误($?≠0),则cmd2不执行</td></tr><tr><td>cmd1 || cmd2</td><td>(1)若 cmd1 运行完毕且正确运行(?=0),则cmd2不执行.<br />(2)若cmd1运行完毕且为错误(?≠0),则开始执行cmd2. </td></tr></table>
- 实例
    ```bash
        假设/tmp/llllljian不存在,下边三种情况运行的结果
        
        ls /tmp/llllljian ; echo "exist" ; echo "not exist"
        ls: 无法访问'/tmp/llllljian': 没有那个文件或目录
        exist
        not exist

        ls /tmp/llllljian && echo "exist" || echo "not exist"
        ls: 无法访问'/tmp/llllljian': 没有那个文件或目录
        not exist

        ls /tmp/vbirding || echo "not exist" && echo "exist"
        ls: 无法访问'/tmp/vbirding': 没有那个文件或目录
        not exist
        exist
    ```
