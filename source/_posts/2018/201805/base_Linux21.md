---
title: Linux_基础 (21)
date: 2018-05-08
tags: Linux
toc: true
---

### 指令与文件搜寻
    查找文件的基础知识

<!-- more -->

#### 脚本文件名的搜索
- which
    * 命令格式
        * which 可执行文件名称
    * 命令功能
        * which指令会在PATH变量指定的路径中,搜索某个系统命令的位置,并且返回第一个搜索结果
    * 命令参数
        * -n 　指定文件名长度,指定的长度必须大于或等于所有文件中最长的文件名.
        * -p 　与-n参数相同,但此处的包括了文件的路径.
        * -w 　指定输出时栏位的宽度.
        * -V 　显示版本信息
    * 使用范例
        ```bash
            which realdel
            alias realdel='llllljiandel'

            which chmod
            /bin/chmod
        ```

#### 文件档名的搜寻
- whereis 
    * 命令格式
        * whereis [-bmsu] [BMS 目录名 -f ] 文件名
    * 命令功能
        * whereis命令可定位可执行文件、源代码文件、帮助文件在文件系统中的位置
        * 这些文件的属性应属于原始代码,二进制文件,或是帮助文件
        * whereis还具有搜索源代码、指定备用搜索路径和搜索不寻常项的能力
    * 命令参数
        * -b: 只查找二进制文件
        * -B<目录>: 只在设置的目录下查找二进制文件
        * -f: 不显示文件名前的路径名称
        * -m: 只查找说明文件
        * -M<目录>: 只在设置的目录下查找说明文件
        * -s: 只查找原始代码文件
        * -S<目录>只在设置的目录下查找原始代码文件
        * -u: 查找不包含指定类型的文件.
    * 使用范例
        ```bash
            whereis php
            php: /usr/bin/php /usr/lib64/php /etc/php.ini /etc/php.d /usr/local/bin/php /usr/local/php /usr/share/php

            whereis ls
            ls: /usr/bin/ls /usr/share/man/man1p/ls.1p.gz /usr/share/man/man1/ls.1.gz
        ```
- locate
    * 命令格式
        * locate [选择参数] [样式]
    * 命令功能
        * 定位的意思,作用是让使用者可以快速的搜寻系统中是否有指定的文件
    * 命令特点
        * "locate"的速度比"find"快,因为它并不是真的查找文件,而是查数据库.
        * 新建的文件,我们立即用"locate"命令去查找,一般是找不到的, 因为数据库的更新不是实时的,数据库的更新时间由系统维护.需要updatedb
    * 命令参数
    	* -c 查询指定文件的数目.(c为count的意思)
        * -e 只显示当前存在的文件条目.(e为existing的意思)
        * -h 显示locate命令的帮助信息.(h为help的意思)
        * -i 查找时忽略大小写区别.(i为ignore的意思)
        * -n 最大显示条数 至多显示最大显示条数条查询到的内容.
        * -r 使用正则运算式做寻找的条件.(r为regexp的意思)
    * 使用范例
        ```bash
            查找etc目录下的所有sh开头的文件
            locate /etc/sh
            /etc/shadow
            /etc/shadow-
            /etc/shells

            查找etc目录下所有sh开头的文件的数目
            locate -c /etc/sh
            3

            查找新建的文件
            touch 4.txx

            sudo updatedb
        ```
