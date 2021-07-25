---
title: Linux_基础 (70)
date: 2021-01-22
tags: Linux
toc: true
---

### Linux积累
    Linux积累之我用到的命令

<!-- more -->

#### 积累1
- 查询哪些文件中有指定内容
- command
    ```bash
        grep -r "查询内容"  文件目录
    ```

#### 积累2
- 根据时间查询日志
- command
    ```bash
        grep '2020-02-27 17:5[6,9]' xinyar-erp-auto.log
    ```

#### 积累3
- 查询制定时间段内的日志
- command
    ```bash
        grep -E '2020-02-27 14:5[5-9]|2020-02-28 15:0[0-5]' xinyar-erp-auto.log
    ```

#### 积累4
- 查找关键字
- command
    ```bash
        grep -C 10 'aaaa' nohup.out
    ```

#### 积累5
- 只显示包含内容的文件名
- command
    ```bash
        grep -r -l "查询内容"  文件目录
    ```

#### 积累6
- 查找文件目录并查询文件内容
- command
    ```bash
        find 文件目录  -type f |xargs grep "查询内容"; 
    ```

#### 积累7
- 统计某个目录下所有文件的总行数
- command
    ```bash
        find . -name "*.java" | xargs wc -l
    ```

#### 积累8
- 查看所有文件内容
- command
    ```bash
        ll | xargs cat
    ```


