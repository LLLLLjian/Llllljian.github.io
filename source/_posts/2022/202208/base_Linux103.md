---
title: Linux_基础 (103)
date: 2022-08-17
tags: Linux
toc: true
---

### Linux积累
    关于awk

<!-- more -->

#### 前情提要
> Linux公社学习笔记

#### awk
> 一种处理文本文件的语言, 是一个强大的文本分析工具
1. 语法
    ```bash
        awk [选项参数] 'script' var=value file(s)
        或
        awk [选项参数] -f scriptfile var=value file(s)
    ```
2. awk+if
    ```bash
        awk '{if (condition) {statement} }' [input_file]
        # 如果第一列等于100 输出二三四列
        awk '{ if ($1=="100")  { print "............... \n"; print "Name : " ,$2; print "Age : ",$3; print "Department : " ,$4; } }' linuxmi.txt
    ```
3. awk+if+else
    ```bash
        awk '{
        if (condition) 
            {command1} 
        else 
            {command2}
        }' [input_file]

        # 年龄小于或等于 20 岁的所有学生的姓名和所在部门
        awk '{

        if ($3<20)
        {
            print "Student "$2,"of department", $4, "is less than 20 years old"
        } 
        else
        {
            print "Student "$2,"of department", $4, "is more than 20 years old"
        }
    ```
4. awk文件
    ```bash
        cat linuxmi.awk
        {
            if (! ($3 ~ /[0-9]+$/))
            {
                print "Age is just a number but you do not have a number"
            } 
            else if ($3<20)
            {
                print "Student "$2,"of department", $4, "is less than 20 years old"
            } 
            else
            {
                print "Student "$2,"of department", $4, "is more than 20 years old"
            }
        }
        awk -f linuxmi.awk linuxmi.txt
    ```
5. awk+三元运算符
    ```bash
        # (condition) ? Command1:Command2
        awk '{print ($3 <=20)? "Age less than 20: " $2: "Age over 20: " $2}' linuxmi.txt
    ```


