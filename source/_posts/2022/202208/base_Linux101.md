---
title: Linux_基础 (101)
date: 2022-08-15
tags: Linux
toc: true
---

### Linux积累
    关于tr和fmt

<!-- more -->

#### 前情提要
> Linux公社学习笔记

#### tr
> Linux tr 命令用于转换或删除文件中的字符.
> tr 指令从标准输入设备读取数据, 经过字符串转译后, 将结果输出到标准输出设备.
1. 基本语法
    ```bash
        tr [-cdst][--help][--version][第一字符集][第二字符集]  
    tr [OPTION]…SET1[SET2] 
    ```
2. 参数说明
    * -c, --complement：反选设定字符.也就是符合 SET1 的部份不做处理, 不符合的剩余部份才进行转换
    * -d, --delete：删除指令字符
    * -s, --squeeze-repeats：缩减连续重复的字符成指定的单个字符
    * -t, --truncate-set1：削减 SET1 指定范围, 使之与 SET2 设定长度相等
    * --help：显示程序用法信息
    * --version：显示程序本身的版本信息
3. 字符集合的范围
    * \NNN 八进制值的字符 NNN (1 to 3 为八进制值的字符)
    * \\\ 反斜杠
    * \a Ctrl-G 铃声
    * \b Ctrl-H 退格符
    * \f Ctrl-L 走行换页
    * \n Ctrl-J 新行
    * \r Ctrl-M 回车
    * \t Ctrl-I tab键
    * \v Ctrl-X 水平制表符
    * CHAR1-CHAR2 ：字符范围从 CHAR1 到 CHAR2 的指定, 范围的指定以 ASCII 码的次序为基础, 只能由小到大, 不能由大到小.
    * \[CHAR] ：这是 SET2 专用的设定, 功能是重复指定的字符到与 SET1 相同长度为止
    * \[CHAR*REPEAT] ：这也是 SET2 专用的设定, 功能是重复指定的字符到设定的 REPEAT 次数为止(REPEAT 的数字采 8 进位制计算, 以 0 为开始)
    * \[:alnum:] ：所有字母字符与数字
    * \[:alpha:] ：所有字母字符
    * \[:blank:] ：所有水平空格
    * \[:cntrl:] ：所有控制字符
    * \[:digit:] ：所有数字
    * \[:graph:] ：所有可打印的字符(不包含空格符)
    * \[:lower:] ：所有小写字母
    * \[:print:] ：所有可打印的字符(包含空格符)
    * \[:punct:] ：所有标点字符
    * \[:space:] ：所有水平与垂直空格符
    * \[:upper:] ：所有大写字母
    * \[:xdigit:] ：所有 16 进位制的数字
    * \[=CHAR=] ：所有符合指定的字符(等号里的 CHAR, 代表你可自订的字符)
4. 实例
    * 小写转大写
        ```bash
            cat linuxmi.txt | tr a-z A-Z
            cat linuxmi.txt | tr [:lower:] [:upper:]
        ```
    * 制表符替换所有空格
        ```bash
            cat linuxmi.txt | tr [:space:] '\t'
        ```
    * 删除特定字符
        ```bash
            cat linuxmi.txt | tr -d 'e'
        ```
    * 删除所有标点符号
        ```bash
            cat linuxmi.txt | tr -d [:punct:]
        ```
    * 删除所有数字
        ```bash
            cat linuxmi.txt | tr -d [:digit:]
        ```

#### fmt
> 简单的文本格式化工具
1. 语法
    ```bash
        fmt [-cstu][-p<列起始字符串>][-w<每列字符数>][--help][--version][文件...]
    ```
2. 参数说明：
    * -c或--crown-margin 每段前两列缩排.
    * -p<列起始字符串>或-prefix=<列起始字符串> 仅合并含有指定字符串的列, 通常运用在程序语言的注解方面.
    * -s或--split-only 只拆开字数超出每列字符数的列, 但不合并字数不足每列字符数的列.
    * -t或--tagged-paragraph 每列前两列缩排, 但第1列和第2列的缩排格式不同.
    * -u或--uniform-spacing 每个字符之间都以一个空格字符间隔, 每个句子之间则两个空格字符分隔.
    * -w<每列字符数>或--width=<每列字符数>或-<每列字符数> 设置每列的最大字符数.
    * --help 在线帮助.
    * --version 显示版本信息.
3. 实例
    * 默认
        ```bash
            cat linuxmi.txt
            Linux fan www.linuxmi.com shares open source news, tutorials on Linux, programming, big data, operations, and databases. 
            I was a big brother back then, the webmaster of Linux fanatics, and a Linux enthusiast using the desktop version. I write in my spare time and hope to share some useful tips with Linux beginners and enthusiasts.
            
            fmt linuxmi.txt
            Linux fan www.linuxmi.com shares open source news, tutorials on Linux, 
            programming, big data, operations, and databases. 
            I was a big brother back then, the webmaster of Linux 
            fanatics, and a Linux enthusiast using the desktop version.
            I write in my spare time and hope to share some 
            useful tips with Linux beginners and enthusiasts.
        ```
    * 每行展示85个字符
        ```bash
            fmt -w 85 linuxmi.txt
        ```
    * 缩进每个段落的第一行
        ```bash
            fmt -t linuxmi.txt
        ```




