---
title: Linux_基础 (45)
date: 2018-06-07
tags: Linux
toc: true
---

### 实际应用
    简单列一下自己想的小例子

<!-- more --> 

#### demo1
- 用户输入一个日期,计算出当天零点到该日期的天数
    ```bash
        [llllljian@llllljian-virtual-machine 20180607 19:18:21 #60]$ cat 1.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 1.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月07日 星期四 17时11分43秒
        # 更新时间: 2018年06月07日 星期四 19时18分05秒
        # 注释: demo1 计算到指定日期的天数
        #########################################################################

        read -p "请输入一个日期(YYYYMMDD, ex>20180607),计算当天到指定日期的天数: " date

        if [[ "$date" =~ ^[0-9]{8\} ]] ;then
            nowDate=`date +%Y-%m-%d`
            time=`date +%s -d ${date}`
            now=`date --date=${nowDate} +%s`	

            if [ "${now}" -gt "${time}" ]; then
                diff=$[${now}-${time}]
            else
                diff=$[${time}-${now}]	
            fi
                
            i=0 
            until [ "$((${diff}-3600*24))" -lt "0" ]
            do
                diff=$((${diff}-86400))
                i=$((${i}+1))
            done

            if [ "${i}" -gt "0" ]; then
                echo "你输入的日期与 ${nowDate} 00:00:00之间有 ${i} 天"
            else
                echo "你输入的是当天"
            fi
            exit 0
        else
            echo "你输入的不是标准的日期格式(YYYYMMDD)"	
            exit 1
        fi

        [llllljian@llllljian-virtual-machine 20180607 19:18:23 #61]$ sh 1.sh
        请输入一个日期(YYYYMMDD, ex>20180607),计算当天到指定日期的天数: 20180605
        你输入的日期与 2018-06-07 00:00:00之间有 2 天

        [llllljian@llllljian-virtual-machine 20180607 19:20:54 #62]$ sh 1.sh
        请输入一个日期(YYYYMMDD, ex>20180607),计算当天到指定日期的天数: 20180607
        你输入的是当天

        [llllljian@llllljian-virtual-machine 20180607 19:21:05 #63]$ sh 1.sh
        请输入一个日期(YYYYMMDD, ex>20180607),计算当天到指定日期的天数: 20180609
        你输入的日期与 2018-06-07 00:00:00之间有 2 天
    ```

#### demo2
- 生成等腰三角形数字树
    ```bash
        [llllljian@llllljian-virtual-machine 20180607 20:03:22 #142]$ cat 2.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 2.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月07日 星期四 19时27分51秒
        # 更新时间: 2018年06月07日 星期四 20时02分05秒
        # 注释: 打印等腰三角形数字树 
        #########################################################################

        read -p "请输入一个正整数" s

        if [[ "$s" =~ ^[0-9]+$ ]] ;then
            if [ "${s}" -gt 100 ]; then
                echo "你输入的数字太大,无法生成数字树"
                exit 1
            fi

            if [ "${s}" == "0" ]; then
                echo "0不能生成数字树"
                exit 1
            fi

            for ((i = 1; i < ${s}; i++))
            do
                for ((j = ${s}; j > i+1; j--))
                do 
                    echo -n " "
                done
        
                for ((m = 1; m <= i; m++))
                do  
                    if [ "${i}" -lt 10 ]; then
                        echo -n "0${i} "
                    else
                        echo -n "${i} "
                    fi
                done
                
                echo ""
            done
            exit 0
        else 
            echo "请输入正整数"
            exit 1
        fi

        [llllljian@llllljian-virtual-machine 20180607 20:03:59 #143]$ sh 2.sh
        请输入一个正整数-5
        请输入正整数

        [llllljian@llllljian-virtual-machine 20180607 20:04:10 #144]$ sh 2.sh
        请输入一个正整数0
        0不能生成数字树

        [llllljian@llllljian-virtual-machine 20180607 20:04:13 #145]$ sh 2.sh
        请输入一个正整数120
        你输入的数字太大,无法生成数字树

        [llllljian@llllljian-virtual-machine 20180607 20:04:19 #146]$ sh 2.sh
        请输入一个正整数10
                01 
            02 02 
            03 03 03 
            04 04 04 04 
            05 05 05 05 05 
        06 06 06 06 06 06 
        07 07 07 07 07 07 07 
        08 08 08 08 08 08 08 08 
        09 09 09 09 09 09 09 09 09 

        [llllljian@llllljian-virtual-machine 20180607 20:04:25 #147]$ sh 2.sh
        请输入一个正整数20
                        01 
                        02 02 
                        03 03 03 
                    04 04 04 04 
                    05 05 05 05 05 
                    06 06 06 06 06 06 
                    07 07 07 07 07 07 07 
                08 08 08 08 08 08 08 08 
                09 09 09 09 09 09 09 09 09 
                10 10 10 10 10 10 10 10 10 10 
                11 11 11 11 11 11 11 11 11 11 11 
            12 12 12 12 12 12 12 12 12 12 12 12 
            13 13 13 13 13 13 13 13 13 13 13 13 13 
            14 14 14 14 14 14 14 14 14 14 14 14 14 14 
            15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 
        16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 
        17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 
        18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 
        19 19 19 19 19 19 19 19 19 19 19 19 19 19 19 19 19 19 19
    ```

#### demo3
- 九九乘法表
    ```bash
        [llllljian@llllljian-virtual-machine 20180607 20:25:26 #157]$ cat 3.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 3.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月07日 星期四 20时25分04秒
        # 更新时间: 2018年06月07日 星期四 20时25分04秒
        # 注释: 九九乘法表 
        #########################################################################

        q=1
        w=1
        while [ $q -le 9 ];do
            while [ $w -le 9 ];do
                e=0
                let e=q*w   
                if [ $w -le $q ];then
                echo  -n "  $w*$q=$e  "
                fi
        
            let w+=1
            done
            let q+=1
            w=1
            echo
        done

        [llllljian@llllljian-virtual-machine 20180607 20:25:35 #158]$ sh 3.sh
        1*1=1  
        1*2=2    2*2=4  
        1*3=3    2*3=6    3*3=9  
        1*4=4    2*4=8    3*4=12    4*4=16  
        1*5=5    2*5=10    3*5=15    4*5=20    5*5=25  
        1*6=6    2*6=12    3*6=18    4*6=24    5*6=30    6*6=36  
        1*7=7    2*7=14    3*7=21    4*7=28    5*7=35    6*7=42    7*7=49  
        1*8=8    2*8=16    3*8=24    4*8=32    5*8=40    6*8=48    7*8=56    8*8=64  
        1*9=9    2*9=18    3*9=27    4*9=36    5*9=45    6*9=54    7*9=63    8*9=72    9*9=81
    ```

#### vimrc说明
- autocmd
    * 命令功能
        * 自动执行的指令.自动命令所执行的命令是"命令行"命令
        * 想执行普通模式命令,可以使用normal命令
        * 创建新文件后将光标移动到第八行第六个字符处[eg : autocmd BufNewFile * normal 8G 6l]
    * 命令格式
        * autocmd [group] [events] {file_pattern} [nested] {command}
    * 命令格式解析 
        * group : 用来管理和调用命令的
        * events : 触发事件列表,多个事件用逗号隔开
            * BufNewFile : 开始编辑尚未存在的文件时
            * BufReadPre : 开始编辑一个已经存在的文件时,读入文件前
            * BufRead : 开始编辑一个已经存在的文件时,读入文件后
            * BufReadPost : 开始编辑一个已经存在的文件时,读入文件后
            * FilterReadPre : 用过滤命令读入文件前
            * FilterReadPost : 用过滤命令读入文件后
            * FileReadPre : ":read"命令读入文件前
            * FileReadPost : ":read"命令读入文件后
        * file_pattern : 文件命令,通常带有通配符.例如"*.sh"代表所有以".sh"结尾的文件
        * nested : 允许自动命令的嵌套
        * command : 要被执行的命令
        
- 实例
    ```bash
        vim ~/.vimrc

        ...
        "新建.sh文件,自动插入文件头
        autocmd BufNewFile *.sh exec ":call SetTitle1()"
        "定义函数SetTitle1,自动插入文件头
        func SetTitle1()
            "如果文件类型为.sh文件
            if &filetype == 'sh'
                call setline(1,"\#!/bin/bash")
                call append(line("."), "\#########################################################################")
                call append(line(".")+1, "\# 文件名: ".expand("%"))
                call append(line(".")+2, "\# 作者: llllljian")
                call append(line(".")+3, "\# 邮箱: 18634678077@163.com")
                call append(line(".")+4, "\# 创建时间: ".strftime("%c"))
                call append(line(".")+5, "\# 更新时间: ".strftime("%c"))
                call append(line(".")+6, "\# 注释: ")
                call append(line(".")+7, "\#########################################################################")
                call append(line(".")+8, "")
                call append(line(".")+9, "")
            endif
        endfunc

        "sh文件添加最后修改时间
        autocmd BufRead *.sh exec ":call ChangeTime()"
        "定义函数ChangeTime,修改最后更新时间
        func ChangeTime()
            "如果文件类型为.sh文件
                if &filetype == 'sh'
                        call setline(7, "\# 更新时间: ".strftime("%c"))
            endif
        endfunc

        "新建文件后,自动定位到文件末尾
        autocmd BufNewFile *.sh normal 8G 6l
        autocmd BufRead *.sh normal G
        ...
    ```
