---
title: Linux_基础 (72)
date: 2021-01-26
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    Linux Shell脚本攻略

<!-- more -->

#### 命令之乐

##### find
1. 根据文件名或正则表达式进行搜索
    ```bash
        # 选项–name的参数指定了文件名所必须匹配的字符串.我们可以将通配符作为参数使用. *.txt能够匹配所有以.txt结尾的文件名.选项 -print在终端中打印出符合条件(例如 -name) 的文件名或文件路径,这些匹配条件通过find命令的选项给出
        # -iname忽略大小写 
        find /home/slynux -name "*.txt" -print

        # find or
        find . \( -name "*.txt" -o -name "*.pdf" \) -print
    ```
2. 否定参数
    ```bash
        # 匹配所有不以.txt结尾的文件名
        find . ! -name "*.txt" -print
    ```
3. 基于目录深度的搜索
    ```bash
        # 列出当前目录下的所有文件名以f打头的文件.即使有子目录,也不会被打印或遍历
        # -maxzdepth指定最大深度
        find . -maxdepth 1 -name "f*" -print

        # 打印出深度距离当前目录至少两个子目录的所有文件
        # -mindepth开始遍历的最小深度
        find . -mindepth 2 -name "f*" -print
    ```
4. 根据文件类型搜索
    ```bash
        # 只列出所有的目录s
        find . -type d -print
        # 只列出普通文件
        find . -type f -print
    ```
5. 根据文件时间进行搜索
    * 访问时间(-atime, 天):用户最近一次访问文件的时间
    * 修改时间(-mtime, 天):文件内容最后一次被修改的时间
    * 变化时间(-ctime, 天):文件元数据(例如权限或所有权)最后一次改变的时间
    * -amin(访问时间, 分钟)
    * -mmin(修改时间, 分钟)
    * -cmin(变化时间, 分钟)
    * \- 表示小于,+ 表示大于
    ```bash
        # 打印出在最近7天内被访问过的所有文件
        find . -type f -atime -7 -print
        # 打印出恰好在7天前被访问过的所有文件
        find . -type f -atime 7 -print
        # 打印出访问时间超过7天的所有文件
        find . -type f -atime +7 -print
        # 打印出访问时间超过7分钟的所有文件:
        find . -type f -amin +7 -print
        # 找出比file.txt修改时间更近的所有文件
        find . -type f -newer file.txt -print
    ```
6. 基于文件大小的搜索
    ```bash
        find . -type f -size +2k # 大于2KB的文件
        find . -type f -size -2k # 小于2KB的文件
        find . -type f -size 2k  # 大小等于2KB的文件
    ```
7. 删除匹配的文件
    ```bash
        # 删除当前目录下所有的 .swp文件:
        find . -type f -name "*.swp" -delete
    ```
8. 基于文件权限和所有权的匹配
    ```bash
        # 打印出权限为644的文件
        find . -type f -perm 644 -print
    ```
9. 利用find执行命令或动作
    ```bash
        # 找出当前文件夹下所有拥有者为root用户的文件夹, 并将它的所有者改为work
        # 1. find . -type f -user root 找到1.txt 2.txt
        # 2. chown work test1.txt和chown work test2.txt
        find . -type f -user root -exec chown work {} \;

        # 查询当前文件夹下所有.c结尾的文件, 并查看文件内容输出到all_c_files.txt文件中
        find . -type f -name "*.c" -exec cat {} \;>all_c_files.txt

        # 查询当前文件夹下10天前的txt文档并复制到OLD中
        find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD \;
    ```




