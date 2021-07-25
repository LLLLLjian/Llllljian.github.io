---
title: Linux_基础 (94)
date: 2021-06-15
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### shell文本操作

##### find的使用
1. 在当前目录下查找以txt结尾的文件
    * find . –name “*.txt”
2. 查找名字是小写字母的文件/文件夹
    * find –name “[a-z]*”
3. 精准查找文件名是ifcfg-eth0的
    * find /etc –name ifcfg-eth0
4. 查看属性为775的文件
    * find –perm 775 
5. 用户user的文件
    * find / -user user1 
6. 5天以内更改的文件
    * find /var –mtime -5
7. 3天以前更改的文件
    * find /var –mtime +3
8. etc目录下的文件夹
    * find /etc –type d 
9. etc目录下的连接文件
    * find /etc –type l
10. 大于10000字节的文件
    * find –size +10000C
11. 找到属性为700的文件并把它的属性更改为777
    * find –perm 700|xargs chmod 777 
12. 找到以.file结尾的文件并删除
    * find –name “*.file”|xargs rm –rf
13. 找到类型为文件的并展示
    * find –type f|xargs ls –l 

##### grep结合正则表达式的使用
1. file内包含linux的多少行
    * grep –c “linux” file 
2. file内包含linux的标记行号输出
    * grep –n “linux” file 
3. file内包括linux的输出 –i不区分大小写
    * grep –i “liunx” file 
4. 不区分大小写且带有行号
    * grep –in “linux” file 
5. 不包括linux的输出【-v】不包括
    * grep –vin “linux” file 
6. 以linux开头的输出【-E】匹配正则
    * grep –E “^linux” file 

##### awk编程的使用(主要针对于列的操作)
- eg
    ```bash
        # awk 默认一空格分割开
        # 【NR==3】代表第三行
        # $0代表这一行的所有内容
        # $1代表着一行的第一列内容
        cat /etc/passed | awk –F:’{print $1}’
        df | awk ‘{print $3}’
    ```

##### sed行定位的使用(主要针对于行的操作)
- eg
    ```bash
        # 不会删除真正的文件内容
        cat /home|sed –n “5”p

        # 列出文件的第五行
        sed –n “5”p file 

        # 列出文件的第三到六行
        sed –n “3,6”p file

        # 删除文件的三到六行
        sed –n “3,6”d file

        # 打印匹配/los/的行
        sed –n ‘/los/’p file

        # 打印从第四行到匹配/los的行
        sed –n ‘4,/los’p file

        # 打印从第四行到最后一行的内容
        sed –n ‘4,$’ p file

        # 打印从第一行到匹配/los行的内容
        sed –n ‘1,/los’ p file
    ```

##### uniq的使用
1. 打印紧挨着的重复行出现的次数
    * uniq –c file
2. 只打印重复出现的行(连续出现超过一次的)
    * uniq –d file 

##### sort的使用
1. 排序, 默认为升序
    * sort file 
2. 降序排列
    * sort –r
3. 进行分割后以第一列倒序排列
    * cat file|sort –t: -k1 –r

##### split的使用
1. 每五个一分割并将结果放入spt中
    * split -5 file2 spt



