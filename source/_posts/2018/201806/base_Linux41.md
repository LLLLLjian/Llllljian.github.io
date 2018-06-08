---
title: Linux_基础 (41)
date: 2018-06-02
tags: Linux
toc: true
---

### 学习Shell script
    Shell : 是一个文字接口底下让我们与系统沟通的一个工具接口
    script : 脚本、剧本
    Shell script : 利用shell的功能所写的一个程序,这个程序使用纯文本文件,将一些shell的语法与指令写在里面,搭配正则表示法、管线命令与数据流重导向等功能,以达到我们所想要的处理目的

<!-- more -->

#### 优劣
- 优
    * 自动化管理的重要依据
    * 追踪与管理系统的重要工作
    * 简单入侵测试功能
    * 连续指令单一化
    * 简易的数据处理
    * 跨平台支持与学习历程较短
- 劣
    * 处理大量数值运算的时候,速度比较慢且使用的CPU资源较多,造成主机资源的分配不良

#### 注意事项
- 备注
    ```bash
        写shell脚本的时候要写好注释让大家知道这个文件是干嘛的

        vim ~/.vimrc

        "新建.sh文件,自动插入文件头 
        autocmd BufNewFile *.sh exec ":call SetTitle1()" 
        ""定义函数SetTitle1,自动插入文件头 
        func SetTitle1() 
            "如果文件类型为.sh文件 
            if &filetype == 'sh' 
                call setline(1,"\#!/bin/bash") 
                call append(line("."), "\#########################################################################") 
                call append(line(".")+1, "\# File Name: ".expand("%")) 
                call append(line(".")+2, "\# Author: llllljian") 
                call append(line(".")+3, "\# mail: 18634678077@163.com")
                call append(line(".")+4, "\# Created Time: ".strftime("%c")) 
                call append(line(".")+5, "\#########################################################################") 
                call append(line(".")+6, "")
            endif
        endfunc 

        "新建文件后,自动定位到文件末尾
        autocmd BufNewFile * normal G
    ```
- 内容
    * 指令的执行是从上而下、从左而右的分析与执行
    * 指令、选项与参数间的多个空白都会被忽略掉
    * 空白行也被忽略掉,而且tab按键所推开的空白也视为空格键
    * 如果读取到一个Enter符号,就尝试开始执行该行(该串)命令
    * 如果一行的内容太多,可以使用 \Enter 来进行换行
    * #可以进行注释,任何加在#后面的文字都会被忽略
- 执行
    * 直接指令下达
        * shell.sh文件必须具备可读可执行[rx]的权限
        * 绝对路径 : 使用/工作路径/shell.sh来下达指令
        * 相对路径 : ./shell.sh来执行指令
        * 环境变量$PATH : 将shell.sh放在PATH指定目录内
    * 以bash程序来执行 : bash shell.sh 或者 sh shell.sh

#### Hello world
    ```bash
        cat 3.sh
        #!/bin/bash
        #########################################################################
        # File Name: 3.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月02日 星期六 15时29分18秒
        #########################################################################
        echo -e "Hello World! \a \n"
        echo "\n"
        echo "Hello World! \a \n"

        [llllljian@llllljian-virtual-machine 20180602 15:32:34 #60]$ ./3.sh
        -bash: ./3.sh: 权限不够

        [llllljian@llllljian-virtual-machine 20180602 15:33:17 #61]$ bash 3.sh
        Hello World!  
        \n
        Hello World! \a \n

        [llllljian@llllljian-virtual-machine 20180602 15:33:43 #62]$ sh 3.sh
        Hello World!  
        \n
        Hello World! \a \n

        [llllljian@llllljian-virtual-machine 20180602 15:34:09 #63]$ chmod +x 3.sh;./3.sh
        Hello World! 
        \n
        Hello World! \a \n
    ```

#### demo
- 变量内容由用户决定
    ```bash
        [llllljian@llllljian-virtual-machine 20180602 16:03:36 #73]$ cat 4.sh
        #!/bin/bash
        #########################################################################
        # File Name: 4.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月02日 星期六 16时01分13秒
        #########################################################################

        read -p "请输入你想说的话: " content

        echo -e "\n 你想说的话是: ${content}"

        [llllljian@llllljian-virtual-machine 20180602 16:03:40 #74]$ sh 4.sh
        请输入你想说的话: 你好

        你想说的话是: 你好
    ```
- 利用date进行文件的建立
    ```bash
        [llllljian@llllljian-virtual-machine 20180602 16:16:24 #77]$ cat 5.sh
        #!/bin/bash
        #########################################################################
        # File Name: 5.sh
        # Author: llllljian
        # mail: 18634678077@163.com
        # Created Time: 2018年06月02日 星期六 16时08分41秒
        #########################################################################

        read -p "请输入你想创建的文件名前缀" filename

        # 前两天的日期
        date1=$(date --date='2 days ago' +%Y%m%d)

        # 前一天的日期
        date2=$(date --date='1 days ago' +%Y%m%d)

        # 当天的日期
        date3=$(date +%Y%m%d)

        file1=${filename}${date1}
        file2=${filename}${date2}
        file3=${filename}${date3}

        touch "${file1}"
        touch "${file2}"
        touch "${file3}"

        [llllljian@llllljian-virtual-machine 20180602 16:16:29 #78]$ sh 5.sh
        请输入你想创建的文件名前缀llllljian

        [llllljian@llllljian-virtual-machine 20180602 16:17:22 #79]$ ll llllljian*
        -rw-rw-r-- 1 llllljian llllljian 0 6月   2 16:17 llllljian20180531
        -rw-rw-r-- 1 llllljian llllljian 0 6月   2 16:17 llllljian20180601
        -rw-rw-r-- 1 llllljian llllljian 0 6月   2 16:17 llllljian20180602
    ```
