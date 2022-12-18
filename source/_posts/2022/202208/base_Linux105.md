---
title: Linux_基础 (105)
date: 2022-08-19
tags: Linux
toc: true
---

### Linux积累
    关于grep

<!-- more -->

#### 前情提要
> Linux公社学习笔记

#### 如何在一个文件中搜索多个模式

需要对多个字符串进行模式匹配

```bash
    cat kotlin.txt 
    name
    globs

    fgrep -f kotlin.txt linuxmi.txt
```

#### 如何限制文件中的匹配数

默认情况下, fgrep 命令会继续执行模式匹配, 直到处理完整个文件.但是, 有时我们需要限制匹配的数量

```bash
    # 匹配到第一次之后就停止
    fgrep -m 1 file linuxmi.txt
```

#### 查找模式时如何打印文件名

只需要找到存在特定模式的文件的名称

```bash
    fgrep -l file linuxmi.txt
```

#### 模式匹配失败时如何打印文件名

针对上一条的取反

```bash
    fgrep -L non-existing-word linuxmi.txt
```




