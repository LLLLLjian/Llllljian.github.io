---
title: Linux_基础 (104)
date: 2022-08-18
tags: Linux
toc: true
---

### Linux积累
    关于花括号

<!-- more -->

#### 前情提要
> Linux公社学习笔记

#### 花括号
> 花括号扩展 {..} 是 Linux 中最未被充分利用但又非常棒的 Shell 特性之一.

```bash
    echo {1..10}
    1 2 3 4 5 6 7 8 9 10

    echo {7..1}
    7 6 5 4 3 2 1

    echo {01..10}
    01 02 03 04 05 06 07 08 09 10

    # {x..y..z}生成从 x 到 y 的值, 同时增加 z
    echo {0..15..2}
    0 2 4 6 8 10 12 14

    echo {3..-4}
    3 2 1 0 -1 -2 -3 -4

    echo {A..H}
    A B C D E F G H

    # 创建具有相似名称的多个文件
    touch aaa_{1..9}.txt
    
    ls
    aaa_1.txt aaa_2.txt aaa_3.txt ... aaa_9.txt

    # 批量备份 (cp -p 保留文件属性, 如所有权、时间戳)
    cp -p linuxmi_2.txt{,.bak}

    # 使用多个花括号
    touch {a,b,c}.{hpp,cpp}

    ls
    a.cpp  a.hpp  b.cpp  b.hpp  c.cpp  c.hpp

    # 在路径中使用花括号扩展 
    mv project/{new,old}/dir/file # 相当于mv project/new/dir/file project/old/dir/file
```


