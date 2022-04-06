---
title: Linux_基础 (83)
date: 2021-03-26
tags: Linux
toc: true
---

### Linux积累
    Linux积累之读书笔记
    求两个文件的交集、差集、并集

<!-- more -->

#### 交集
> sort a.txt b.txt | uniq -d

#### 并集
> sort a.txt b.txt | uniq

#### 差集
> a.txt-b.txt:
sort a.txt b.txt b.txt | uniq -u
b.txt - a.txt:
sort b.txt a.txt a.txt | uniq -u

#### 相关解释
1. 使用sort可以将文件进行排序(sort排序是为了管道交给uniq进行处理, uniq只能处理相邻的行), 可以使用sort后面的参数, 例如 -n 按照数字格式排序, 例如 -i 忽略大小写, 例如使用-r 为逆序输出等
2. uniq为删除文件中重复的行, 得到文件中唯一的行, 参数-d 表示的是输出出现次数大于1的内容；参数-u表示的是输出出现次数为1的内容；那么对于上述的求交集并集差集的命令做如下的解释: 
3. sort a.txt b.txt | uniq -d: 将两个文件进行排序, uniq使得两个文件中的内容为唯一的, 使用-d输出两个文件中次数大于1的内容, 即是得到交集
4. sort a.txt b.txt | uniq : 将两个文件进行排序, uniq使得两个文件中的内容为唯一的, 即可得到两个文件的并集
5. sort a.txt b.txt b.txt | uniq -u: 将两个文件排序, 最后输出a.txt b.txt b.txt文件中只出现过一次的内容, 因为有两个b.txt所以只会输出只在a.txt出现过一次的内容(b.txt的内容至少出现两次), 即是a.txt-b.txt差集；对于b.txt-a.txt同理.

#### 实例
1. a.hosts
    ```bash
        [root(0)@thatsit 11:40:46 ~/scripts]# cat a.hosts
        10.10.1.101
        10.10.1.102
        10.10.1.103
        10.10.1.104
    ```
2. b.hosts
    ```bash
        [root(0)@thatsit 11:40:46 ~/scripts]# cat a.hosts
        10.10.1.101
        10.10.1.103
        10.10.1.105
    ```
3. a.hosts ∩ b.hosts
    ```bash
        [root(0)@thatsit 11:40:49 ~/scripts]# sort a.hosts b.hosts | uniq -d
        10.10.1.101
        10.10.1.103
    ```

4. a.hosts ∪ b.hosts
    ```bash
        [root(0)@thatsit 11:41:10 ~/scripts]# sort a.hosts b.hosts | uniq
        10.10.1.101
        10.10.1.102
        10.10.1.103
        10.10.1.104
        10.10.1.105
    ```

5. a.hosts - b.hosts
    ```bash
        [root(0)@thatsit 11:41:25 ~/scripts]# sort a.hosts b.hosts b.hosts | uniq -u
        10.10.1.102
        10.10.1.104
    ```

6. b.hosts - a.hosts 
    ```bash
        [root(0)@thatsit 11:41:47 ~/scripts]# sort a.hosts a.hosts b.hosts | uniq -u
        10.10.1.105
    ```

