---
title: Python_基础 (1)
date: 2018-12-06
tags: Python
toc: true
---

### Python简介
    Python学习笔记

<!-- more -->

#### Python是什么
    Python是一种计算机程序设计语言[个人理解: 类似shell的脚本语言]

#### Python核心
    简单优雅,尽量写容易看明白的代码,尽量写少的代码

#### Python适合开发的应用
1. 首选是网络应用,包括网站、后台服务等等
2. 其次是许多日常需要的小工具,包括系统管理员需要的脚本任务等等
3. 把其他语言开发的程序再包装起来,方便使用

#### Python优点
1. 完善的基础代码库和第三方库
2. 代码尽量少且易懂
3. 常用于网络应用,包括网站、后台服务

#### Python缺点
1. 运行速度慢
2. 无法加密,只能开源

#### Python安装
- Linux
    * 我使用的是Ubuntu17.04,系统默认安装python2和python3.5
    * 没有安装的话可以按照下面的步骤来
        ```bash
            1. 下载Python3
            wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz

            2. 解压
            tar -zxvf Python-3.6.1.tgz

            3. 编译安装
            cd Python-3.6.1
            mkdir -p /usr/local/python3
            ./configure --prefix=/usr/local/python3
            make && make install

            4. 建立Python软链接[我的理解是Windows的快捷方式]
            ln -s /usr/local/python3/bin/python3 /usr/bin/python3
            ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3

            5. 检查安装结果
            python3 -V
            pip3 -V
        ```
- Windows
    * 首先,根据你的Windows版本（64位还是32位）从Python的官方网站下载Python 3.7对应的64位安装程序或32位安装程序,然后,运行下载的EXE安装包
    * ![Windows_python安装](/img/20181206_1.png)

