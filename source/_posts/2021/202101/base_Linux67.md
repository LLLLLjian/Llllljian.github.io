---
title: Linux_基础 (67)
date: 2021-01-19
tags: Linux
toc: true
---

### Linux积累
    查看文件指定行号内容

<!-- more -->

#### tail
- eg
    ```bash
        # 输出文件末尾的内容,默认10行
        tail date.log

        # 输出最后20行的内容
        tail -20  date.log

        # 输出倒数第20行到文件末尾的内容
        tail -n -20  date.log

        # 输出第20行到文件末尾的内容
        tail -n +20  date.log

        # 实时监控文件内容增加,默认10行
        tail -f date.log
    ```

#### head
- eg
    ```bash
        # 输出文件开头的内容,默认10行
        head date.log

        # 输出开头15行的内容
        head -15  date.log

        # 输出开头到第15行的内容
        head -n +15 date.log

        # 输出开头到倒数第15行的内容
        head -n -15 date.log
    ```

#### sed
- eg
    ```bash
        # sed -n "开始行,结束行p" 文件名    

        # 输出第70行到第75行的内容
        sed -n '70,75p' date.log

        # 输出第6行 和 260到400行
        sed -n '6p;260,400p; ' date.log

        # 输出第5行
        sed -n 5p date.log
    ```

