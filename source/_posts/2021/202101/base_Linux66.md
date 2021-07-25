---
title: Linux_基础 (66)
date: 2021-01-18
tags: Linux
toc: true
---

### Linux积累
    文件/内容查找find

<!-- more -->

#### find
> find命令用来在指定目录下查找文件.任何位于参数之前的字符串都将被视为欲查找的目录名.如果使用该命令时,不设置任何参数,则 find 命令将在当前目录下查找子目录与文件.并且将查找到的子目录和文件全部进行显示
- 语法
    ```bash
        find path -option [ -print ] [ -exec -ok command ] {} \;
    ```
- 参数说明
    * find 根据下列规则判断 path 和 expression,在命令列上第一个 - ( ) , ! 之前的部份为 path,之后的是 expression.如果 path 是空字串则使用目前路径,如果 expression 是空字串则使用 -print 为预设 expression.
    * expression 中可使用的选项有二三十个之多,在此只介绍最常用的部份.
    * -mount, -xdev : 只检查和指定目录在同一个文件系统下的文件,避免列出其它文件系统中的文件
    * -amin n : 在过去 n 分钟内被读取过
    * -anewer file : 比文件 file 更晚被读取过的文件
    * -atime n : 在过去n天内被读取过的文件
    * -cmin n : 在过去 n 分钟内被修改过
    * -cnewer file :比文件 file 更新的文件
    * -ctime n : 在过去n天内被修改过的文件
    * -empty : 空的文件-gid n or -group name : gid 是 n 或是 group 名称是 name
    * -ipath p, -path p : 路径名称符合 p 的文件,ipath 会忽略大小写
    * -name name, -iname name : 文件名称符合 name 的文件.iname 会忽略大小写
    * -size 
        * n : 文件大小 是 n 单位
        * b 代表 512 位元组的区块
        * c 表示字元数
        * k 表示 kilo bytes
        * w 是二个位元组
    * -type 
        * c: 文件类型是 c 的文件.
        * d: 目录
        * c: 字型装置文件
        * b: 区块装置文件
        * p: 具名贮列
        * f: 一般文件
        * l: 符号连结
        * s: socket
    * -pid n : process id 是 n 的文件

#### 实例
1. 将当前目录及其子目录下所有文件后缀为 .c的文件列出来
    ```bash
        find . -name "*.c"
    ```
2. 将目前目录其其下子目录中所有一般文件列出
    ```bash
        find . -type f
    ```
3. 将当前目录及其子目录下所有最近 20天内更新过的文件列出
    ```bash
        find . -ctime -20
    ```
4. 查找 /var/log 目录中更改时间在 7日以前的普通文件,并在删除之前询问它们
    ```bash
        find /var/log -type f -mtime +7 -ok rm {} \;
    ```
5. 查找当前目录中文件属主具有读、写权限,并且文件所属组的用户和其他用户具有读权限的文件
    ```bash
        find . -type f -perm 644 -exec ls -l {} \;
    ```
6. 查找系统中所有文件长度为 0 的普通文件,并列出它们的完整路径
    ```bash
        find / -type f -size 0 -exec ls -l {} \;
    ```
7. 查找目录
    ```bash
        find ./ -type d
    ```
8. 查找名字为test的文件或目录
    ```bash
        find ./ -name test
    ```
9. 打印test文件名后,打印test文件的内容
    ```bash
        find ./ -name test -print -exec cat {} \;
    ```
10. 不打印test文件名,只打印test文件的内容
    ```bash
        find ./ -name test -exec cat {} \;
    ```
11. 查找文件size小于10M的文件或目录
    ```bash
        find ./ -size -10M
    ```


