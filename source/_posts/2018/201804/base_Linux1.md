---
title: Linux_基础 (1)
date: 2018-04-10
tags: Linux
toc: true
---

### Linux基础
    LAMP/LNMP的L.

<!-- more -->

#### 是什么
- Linux是操作系统
    * Linux是一套免费使用和自由传播的类Unix操作系统,是一个基于POSIX和UNIX的多用户、多任务、支持多线程和多CPU的操作系统.
    * Linux能运行主要的UNIX工具软件、应用程序和网络协议.它支持32位和64位硬件.Linux继承了Unix以网络为核心的设计思想,是一个性能稳定的多用户网络操作系统.
- 发行版
    * Ubuntu、RedHat、CentOS、Debian、Fedora、SuSE、OpenSUSE、Arch Linux、SolusOS 等.

#### 做什么
- 目前主要用作服务端

#### 命令模板
- 说明
    * 严格区分大小写
    * 一行指令中第一个输入的部分绝对是指令(command)或可执行文件案
    * command为指令的名称
    * 中括号[]并不存在于实际的指令中,而加入选项设定时,通常选项前会带-号,有时会使用选项完整全名,带--
    * parameter1 parameter2为依附在选项后边的参数,或者是command的参数
    * 指令 选项 参数这几项中间以空格区分,不论空几个,shell都视为一个
    * 按下回车,该指令就立即执行
    * 指令太长的时候,可以使用反斜杠(\)来断掉回车,使指令连续到下一行.注意:反斜杠之后要立刻接特殊字符
    ```bash
        cd /data/file1/file1.1\
        /file1.1.1

        command [-options] parameter1 parameter1
        指令      选项      参数1         参数2
    ```

#### 今天学到的命令
- locale
    * 查看现有语言环境
    * 相关命令
        * locale -a 查看所有可用的语言环境
        * export LANG=en_US或LANG=en_US 临时修改语言环境
        * /etc/sysconfig/i18n 永久修改系统字符集
- date
    * 根据参数输出时间相关内容
    * 相关命令
        * date +%Y-%m-%d 2018-04-10
        * date +%t  20:34:27
        * date +%Y-%m-%d%t%T --date "2016-05-01 11:59:59"  2016-05-01   11:59:59
        * 剩下的参数可以看手册
- cal
    * 命令格式 ：cal [参数][月份][年份]
    * 命令功能 ：用于查看日历等时间信息,如只有一个参数,则表示年份(1-9999),如有两个参数,则表示月份和年份
    * 命令参数：
        * -1 显示一个月的月历
        * -3 显示系统前一个月,当前月,下一个月的月历
        * -s  显示星期天为一个星期的第一天,默认的格式
        * -m 显示星期一为一个星期的第一天
        * -j  显示在当年中的第几天(一年日期按天算,从1月1号算起,默认显示当前月在一年中的天数)
        * -y  显示当前年份的日历
    * 使用实例：
        * cal 显示当前月份日历
        * cal 9 2017 显示指定月份的日历
        * cal -y 2017 显示2017年日历
        * cal -j 显示自1月1日的天数
        * cal -m 星期一显示在第一列
- \--help
    * 指令 --help
    * 将该指令的用法列出来
- man
    * man 指令
    * 清楚知道该指令的用法
    * man page说明
        * 第一行指令后边的数字: 1代表一般账号可用指令,8代表系统管理员常用指令,5代表系统配置文件格式
        * NAME : 剪短的指令 数据名称说明
        * SYNOPSIS : 简短的指令下达语法syntax简介
        * DESCRIPTION : 较为完整的说明
        * OPTIONS : 针对SYNOPSIS部分中,有列举的所有可用的选项说明
        * COMMANDS : 当这个程序(软件)在执行的时候,可以在此程序(软件)中下达的指令
        * FILES : 这个程序或数据所使用或参考或连接到的某些文件
        * SEE ALSO : 可以参考的,跟这个指令或数据有相关的其他说明
        * EXAMPLE : 一些可以参考的范例
    * man page操作
        * 空格|Page Down 向下翻一页
        * Page Up 向上翻一页
        * Home 去第一页
        * End 去最后一页
        * /string 向下搜索string这个字符串
        * ?string 向上搜索string这个字符串
        * n|N 搜索结果的下一个
        * q 结束这次的man page
- info 
    * info 指令
    * 类似man的帮助指令
    * info page说明
        * File : 代表这个info page的资料是来自哪个文件
        * Node : 代表目前这个页面的节点
        * Next : 下一个节点的名称
        * Up : 回到上一层节点的总揽画面
        * Prev : 前一个节点
    * info page操作
        * 翻页类似man
        * tab 在node之间移动,有node的地方通常会以*展示
        * Enter 当光标在node上面的时候,按下Enter进入该node
        * b 移动光标到该info画面当中的第一个node处
        * e 移动光标到该info画面当中的最后一个node处
        * n 前往下一个node处
        * p 前往上一个node处
        * u 向上移动一层
        * s|/ 在info page中进行搜索
        * h|? 显示求助菜单
        * q 结束本次info page

#### 重要快捷键
- Tab
    * Tab接在一串指令的第一个字的后面,则为命令补全
    * Tab接在一串指令的第二个字以后时,则为文件补齐
    * 若安装bash-completion软件,则在某些指令后面使用tab按键时,可以进行[选项/参数补齐]
    * 避免很多输入错误的机会
- ctrl+c
    * 立即终止当前命令
- ctrl+d
    * 相当于输入exit