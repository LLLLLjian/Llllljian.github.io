---
title: Linux_基础 (18)
date: 2018-05-04
tags: Linux
toc: true
---

### 文件与目录管理
    有关文件与目录的一些基础管理部分

<!-- more -->

#### rm
- 命令格式
    * rm [选项]文件
- 命令功能
    * 删除一个目录中的一个或多个文件或目录,如果没有使用-r选项,则rm不会删除目录.如果使用rm来删除文件,通常可以将该文件恢复原状.\
- 命令参数
	* -d: 直接把欲删除的目录的硬连接数据删除成0,删除该目录；
	* -f: 强制删除文件或目录；
	* -i: 删除已有文件或目录之前先询问用户；
	* -r或-R: 递归处理,将指定目录下的所有文件与子目录一并处理；
	* --preserve-root: 不对根目录进行递归操作；
	* -v: 显示指令的详细执行过程.

- 命令实例
    * 批量删除文件
        ```bash
            llllljian@llllljian-virtual-machine:/home/0502test$ rm -f 1*

            llllljian@llllljian-virtual-machine:/home/0502test$ ls -al 1*
            ls: 无法访问'1*': 没有那个文件或目录

            llllljian@llllljian-virtual-machine:/home/0502test$ ls -Al
            -rwxrwxrwx 1 root      root         0 5月  16 22:13 2_1.txt
            -rwxrwxrwx 1 root      root         0 5月  16 21:49 2.txt
            -rwxrwxrwx 1 root      root         0 5月  16 22:20 3_1.txt
            lrwxrwxrwx 1 llllljian llllljian    5 5月  16 22:28 3_2.txt -> 3.txt
            -rwxrwxrwx 1 root      root         0 5月  16 21:49 3.txt
        ```
    * 自定义回收站1
        ```bash
            ~/.bashrc

            ## 伪删除 start

            #创立一个目录作为回收站,这里运用的是用户家目录下的.trash目录
            mkdir -p ~/.trash

            #命令别名 rm改动为trash,经过将rm命令别名值trash来完成把rm改形成删除文件至回收站
            alias rm=trash

            # showdel命令显现回收站中的文件
            alias showdel='ls -Al ~/.trash'

            alias realdel=cleartrash

            #将指定的文件挪动到指定的目录下,经过将rm命令别名值trash来完成把rm改形成删除文件至回收站
            trash()
            {
                mv $@ ~/.trash/
            }

            #这个函数的作用是清空回收站目录下的一切文件
            cleartrash()
            {
                read -p "clear sure?[n]" confirm
                [ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf ~/.trash/*
            }
            ## 伪删除 end

            删除文件用rm
            删除之后可以看到~/.trash/中有刚删除的问题
            查看删除文件用showdel
            realdel清空回收站
        ```
    * 自定义回收站2
        ```bash
            ~/.bashrc

            ## 伪删除 start

            # 重新定义rm
            alias rm=lllllljianrm
            
            # 展示删除的文件内容
            alias showdel='ls -al /tmp/$(date +%Y%m%d)'

            # 清空伪删除的文件
            alias realdel=llllljiandel

            # 清空全部伪删除的文件及文件夹
            alias realdel=llllljiandelAll

            lllllljianrm()
            {
                D=/tmp/$(date +%Y%m%d);
                mkdir -m 777 -p $D;
                U=$(basename ~);
                F=$(basename ~)_$(date +%s)_$@;
                mv $@ $D/$F && echo "moved to $D ok, new filename is $F, the updater is $U"
            }

            llllljiandel()
            {
                read -p "确认删除吗?" confirm
                [ $confirm == 'y' ] || [ $confirm == 'Y' ] && /bin/rm /tmp/$(date +%Y%m%d)/$(basename ~)*
            }

            llllljiandelAll()
            {
                read -p "确认删除全部吗?" confirm
                [ $confirm == 'y' ] || [ $confirm == 'Y' ] && /bin/rm /tmp/$(date +%Y%m%d)/* && /bin/rmdir /tmp/$(date +%Y%m%d)
            }

            ## 伪删除 end

            删除文件rm
            查看所有删除文件showdel
            清空自己的伪删除文件realdel
            清空所有的伪删除文件和文件夹realdelAll
        ```


