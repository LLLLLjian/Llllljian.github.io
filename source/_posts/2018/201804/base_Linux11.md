---
title: Linux_基础 (11)
date: 2018-04-24
tags: Linux
toc: true
---

### alias命令
    通过设置指令的别名将一些较长的命令进行简化

<!-- more -->

#### 命令格式
    alias(选项)(参数)
    文件内设置别名时 alias=''
    说明 : 要有引号,=左右不能有空格

#### 命令功能
    设置指令的别名

#### 命令参数
- -p: 打印已经设置的命令别名
- 若不加任何参数,则列出目前所有的别名设置

#### 使用实例
- 临时设置列名
    ```bash
        关闭了ssh终端再登录就失效

        show123
        show123: 未找到命令

        alias show123='ls -Al'
        
        show123
        总用量 4
        drwxrwxrwx 3 root root 4096 4月  24 20:32 0424_1
    ```
- 个人目录永久设置
    ```bash
        ~ 代表当前用户目录 
        .bashrc 表示个人配置
        source ~/.bashrc 是一定要写,初始化.bashrc文件,使其生效

        sudo vim ~/.bashrc

        ...
        #llllljian add
        alias vi='vim'
        alias Show='ls -Al'
        alias cd0424='cd /home/0424test/0424_1/0424_1_1'
        ...

        pwd
        /home/llllljian

        source ~/.bashrc

        cd0424

        pwd
        /home/0424test/0424_1/0424_1_1
    ```
- 环境目录永久设置
    ```bash
        /etc/bashrc 表示环境配置
        source /etc/bashrc 是一定要写,初始化/etc/bashrc文件,使其生效

        sudo vim /etc/bashrc

        ...
        #llllljian add
        alias cd0424_1='cd /home/0424test/0424_1'
        ...

        cd0424_1
        cd0424_1: 未找到命令

        source /etc/bashrc

        pwd
        /home/llllljian

        cd0424_1

        pwd
        /home/0424test/0424_1
    ```
- 展示当前所有别名
    ```bash
        alias
        alias -p
        ...
        alias Show='ls -Al'
        alias cd0424='cd /home/0424test/0424_1/0424_1_1'
        alias cd0424_1='cd /home/0424test/0424_1'
        alias show123='ls -Al'
        alias vi='vim'
        ...
    ```