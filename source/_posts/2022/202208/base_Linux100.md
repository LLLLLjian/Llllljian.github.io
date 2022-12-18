---
title: Linux_基础 (100)
date: 2022-08-12
tags: Linux
toc: true
---

### Linux积累
    关于source

<!-- more -->

#### 前情提要
> Linux公社学习笔记

#### source
1. source命令是什么

source命令也称为“点命令”, 也就是一个点符号(.), 是bash的内部命令.
注意：该命令通常用命令“.”来替代

2. source命令 功能(能干什么)
source命令通常用于重新执行刚修改的初始化文件, 使之立即生效, 而不必注销并重新登录.因为linux所有的操作都会变成文件的格式存在.

示例：
当我修改了/etc/profile文件, 我想让它立刻生效, 而不用重新登录；这时就想到用source命令, 如:source /etc/profile

3. source命令用法

source filename		# filename必须是可执行的脚本文件
或者
. filename			# 注意“.”号后面还有一个空格

4. 比较

“source filename”与“sh filename”、“./filename”这三个命令都可以用于执行一个脚本文件, 那么它们之间的区别又如何呢？

(1)当shell脚本具有可执行权限时, 用sh filename与./filename是没有区别的../filename是因为当前目录没有在PATH中, 所以"."是用来表示当前目录的.

(2)sh filename会重新建立一个子shell, 在子shell中执行脚本里面的语句, 该子shell继承父shell的环境变量, 但子shell是新建的, 其改变的变量不会被带回父shell, 除非使用export.

(3)source filename读取脚本里面的语句依次在当前shell里面执行, 没有建立新的子shell.那么脚本里面所有新建、改变变量的语句都会保存在当前shell里面.








