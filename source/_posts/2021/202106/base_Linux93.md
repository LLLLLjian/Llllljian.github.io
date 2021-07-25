---
title: Linux_基础 (93)
date: 2021-06-11
tags: Linux
toc: true
---

### Linux积累
    读T代码知识记录

<!-- more -->

#### 重定向的使用
- \>:只能保存最新的内容, 覆盖式的写入(默认为1>)
- \>>:可以保存历史的内容, 追加式的写入(默认为1>>)
- 2>:错误重定向到文件中, 覆盖式的写入
- 2>>:错误重定向到文件中, 追加式的写入
- &>:正确的错误的都可以追加到文件中, 但只能追加一个
- eg
    ```bash
        # 将正确的输出覆盖式写入到net.txt文件中
        bash red.sh >net.txt 

        # 将正确的错误的都追加到net.txt文件中, 但只能覆盖式写入 不能追加式写入
        bash red.sh &>net.txt

        # 正确的错误的都可以写入到net.txt文件中, 也是只能覆盖式写入
        bash red.sh &>net.txt 2>&1

        # 追加式写入 正确的错误的都可以可以
        bash red.sh 1>>net.txt 2>&1
    ```

#### 管道操作符的使用
> | 将前面执行的结果交给后面继续加工
- eg
    ```bash
        ps aux

        ps aux | grep nginx
    ```

#### 测试文件状态
- 常用的操作符
    * -d 是否为目录directory
    * -e 目录或文件是否存在exist
    * -f 是否为文件file
    * -r 当前用户对目录/文件是否有读权限
    * -w 当前用户对目录/文件是否有写权限
    * -x 当前用户对目录/文件是否有执行权限
    * -L 测试是否为连接符号
- eg
    ```bash
        #!/bin/bash

        if [-f /file]
        then
            echo “file 存在”
        else
            echo “file不存在”
        if
    ```

#### 整数值判断
- 常用操作符
    * -eq 等于equal
    * -ne 不等于 not equal
    * -gt 大于 greater than
    * -lt 小于 lesser than
    * -le 小于或等于 lesser or equal
    * -ge 大于或等于 greater or equal


