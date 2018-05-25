---
title: Linux_基础 (33)
date: 2018-05-23
tags: Linux
toc: true
---

### 变量键盘读取与定义
    read 通过用户的输入对变量进行读取.
    declare[别名typeset]用于申明shell变量并设置变量属性，或查看已定义的shell变量和函数

<!-- more -->

#### read
- 命令格式
    * read(选项)(参数)
- 命令功能
    * 从键盘读取变量的值，通常用在shell脚本中与用户进行交互的场合。该命令可以一次读取多个变量的值，变量和输入的值都需要使用空格隔开。在read命令后面，如果没有指定变量名，读取的数据将被自动赋值给特定的变量REPLY
- 命令参数
    * -p：指定读取值时的提示符
    * -t：指定读取值时等待的时间（秒）
- 命令实例
    ```bash
        read yourname
        llllljian
        
        echo ${yourname}
        llllljian
       
        env | grep yourname
        set | grep yourname
        yourname=llllljian
        export | grep yourname

        read -p "请输入当前日期" -t 30 date
        请输入当前日期20180523
        echo ${date}
        20180523
    ```

#### declare[typeset]
- 命令格式
    * declare [-aAfFilurtx] [-p] [name[=value] ...]
    * typeset [-aAfFilurtx] [-p] [name[=value] ...]
- 命令功能
    * 用于申明shell变量并设置变量属性，或查看已定义的shell变量和函数。若不加上任何参数，则会显示全部的shell变量与函数
- 命令参数
    * -a：申明数组变量
	* -A：申明关联数组，可以使用字符串作为数组索引
	* -f：仅显示已定义的函数
	* -F：不显示函数定义
	* -i：声明整型变量
	* -l：将变量值的小写字母变为小写
	* -u：变量值的大写字母变为大写
	* -r：设置只读属性
	* -t：设置变量跟踪属性，用于跟踪函数进行调试，对于变量没有特殊意义
	* -x：将指定的shell变量换成环境变量
	* -p：显示变量定义的方式和值
	* +：取消变量属性，但是+a和+r无效,无法删除数组和只读属性，可以使用unset删除数组，但是unset不能删除只读变量AX
- 命令实例
    ```bash
        定义关联数组并访问
        declare -A tempArray=([aK]=aV [bK]=bV)

        echo ${tempArray[aK]}
        aV

        echo ${tempArray[*]}
        bV aV

        echo ${tempArray[@]}
        bV aV

        echo ${!tempArray[@]}
        bK aK

        定义只读变量
        declare -r name=llllljian

        echo ${name}
        llllljian

        name=llllljian1
        -bash: name: 只读变量

        查看已定义函数
        declare -f ljdelAll
        ljdelAll () 
        { 
            read -p "确认删除全部吗?" confirm;
            [ $confirm == 'y' ] || [ $confirm == 'Y' ] && /bin/rm /tmp/$(date +%Y%m%d)/* && /bin/rmdir /tmp/$(date +%Y%m%d)
        }
    ```