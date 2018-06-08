---
title: Linux_基础 (44)
date: 2018-06-06
tags: Linux
toc: true
---

### 循环loop
    不断地执行某个程序段落,直到达成用户设定的条件为止

<!-- more -->

#### 不定循环
- while do done
    * 语法
        ```bash
            while [ condition ]
            do
                程序段落
            done
        ```
    * 说明
        * 一直执行，直到条件不符合，才停止
        * 当condition条件成立时就进行循环,直到condition条件不成立才停止
    * 实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180606 20:26:34 #30]$ cat 1.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 1.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月06日 星期三 20时25分54秒
            # 更新时间: 2018年06月06日 星期三 20时25分54秒
            # 注释: loop-while
            #########################################################################

            while [ "$yn" != "yes" -a "$yn" != "YES" ]   
            do   
                read -p "Please input yes/YES to stop : " yn  
            done  
            
            echo "OK"

            [llllljian@llllljian-virtual-machine 20180606 20:26:37 #31]$ sh 1.sh
            Please input yes/YES to stop : y
            Please input yes/YES to stop : yse
            Please input yes/YES to stop : yes
            OK

            [llllljian@llllljian-virtual-machine 20180606 20:54:46 #91]$ cat 2.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 2.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月06日 星期三 20时35分42秒
            # 更新时间: 2018年06月06日 星期三 20时48分48秒
            #########################################################################

            read -p "输入一个数,计算出1到这个数的和" num

            isnum=$(echo ${num}|grep '[0-9]')

            if [ "${isnum}" == "" ]; then
                echo "请你输入一个数字"
                exit 1
            fi

            sum=0  
            i=0  
            
            while [ $i -lt ${num} ]  
            do  
                i=$(($i+1));  
                sum=$(($sum+$i))  
            done  
            
            echo "From 1 to ${num}, sum is : " $sum 
            [llllljian@llllljian-virtual-machine 20180606 20:54:49 #92]$ sh 2.sh
            输入一个数,计算出1到这个数的和10
            From 1 to 10, sum is :  55

            [llllljian@llllljian-virtual-machine 20180606 20:55:01 #93]$ sh 2.sh
            输入一个数,计算出1到这个数的和a
            请你输入一个数字

            [llllljian@llllljian-virtual-machine 20180606 20:55:04 #94]$ sh 2.sh
            输入一个数,计算出1到这个数的和 
            请你输入一个数字
        ```
- until do done
    * 语法
        ```bash
            until [ condition ]
            do
                程序段落
            done
        ```
    * 说明
        * 当condition条件成立时就终止循环,否则就持续循环的程序段
    * 实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180606 21:00:40 #98]$ cat 3.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 3.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月06日 星期三 21时00分22秒
            # 更新时间: 2018年06月06日 星期三 21时00分22秒
            # 注释: loop until 
            #########################################################################

            until [ "$yn" == "yes" -o "$yn" == "YES" ]  
            do  
                read -p "Please input yes/YES to stop : " yn  
            done  
            echo "OK"  
            [llllljian@llllljian-virtual-machine 20180606 21:00:45 #99]$ sh 3.sh
            Please input yes/YES to stop : 1
            Please input yes/YES to stop : a
            Please input yes/YES to stop : yes
            OK

            [llllljian@llllljian-virtual-machine 20180606 21:07:30 #106]$ cat 4.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 4.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月06日 星期三 21时02分31秒
            # 更新时间: 2018年06月06日 星期三 21时05分29秒
            # 注释: loop 1-最大的数的和的值 
            #########################################################################

            read -p "输入一个数,计算出1到这个数的和" num

            isnum=$(echo ${num}|grep '[0-9]')

            if [ "${isnum}" == "" ]; then
                echo "请你输入一个数字"
                    exit 1
            fi

            sum=0  
            i=0  
                        
            while [ "${i}" != "${num}" ]  
            do  
                i=$(($i+1));  
                    sum=$(($sum+$i))  
            done  
                        
            echo "From 1 to ${num}, sum is : " $sum
            [llllljian@llllljian-virtual-machine 20180606 21:07:45 #107]$ sh 4.sh
            输入一个数,计算出1到这个数的和a
            请你输入一个数字

            [llllljian@llllljian-virtual-machine 20180606 21:07:57 #108]$ sh 4.sh
            输入一个数,计算出1到这个数的和10
            From 1 to 10, sum is :  55
        ```

#### 固定循环
- for do done
    * 语法
        ```bash
            for var in con1 con2 ..
            do
                程序段
            done

            for 变量名 in 列表;do 
                循环体 
            done
        ```
    * 说明
        * 第一次循环时,$var的内容为con1
        * 第二次循环时,$var的内容为con2
        * 第三次循环时,$var的内容为con3
        * 列表生成方式： 
            * 直接给出列表 
            * 整数列表： 
                * {start..end}
                * $(seq [start [step]] end) 
            * 返回列表的命令 $(COMMAND) 
            * 使用glob，如：*.sh 
            * 变量引用； $@, $*
    * 实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180606 21:11:32 #114]$ cat 5.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 5.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月06日 星期三 21时11分17秒
            # 更新时间: 2018年06月06日 星期三 21时11分17秒
            # 注释: loop for 
            #########################################################################

            filelist=$(ls)  
            for filename in $filelist  
            do  
                echo $filename  
            done
            [llllljian@llllljian-virtual-machine 20180606 21:11:38 #115]$ sh 5.sh
            1.sh
            2.sh
            3.sh
            4.sh
            5.sh
        ```

#### 数值循环
- for do done
    * 语法
        ```bash
            for (( 初始值; 限制值; 步长))
            do
                程序段
            done
        ```
    * 说明
        * 初始值 : 某个变量在循环当中的起始值,直接以类似i=1设定好
        * 限制值 : 当变量的值在这个限制值的范围内就继续进行循环.例如i<=100
        * 步长 : 没执行一次循环时,变量的变化值.例如i=i+1
    * 实例 
        ```bash
            [llllljian@llllljian-virtual-machine 20180606 21:22:07 #130]$ cat 6.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 6.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月06日 星期三 21时19分56秒
            # 更新时间: 2018年06月06日 星期三 21时20分40秒
            # 注释: loop for 
            #########################################################################

            read -p "输入一个数,计算出1到这个数的和" num

            isnum=$(echo ${num}|grep '[0-9]')

            if [ "${isnum}" == "" ]; then
                echo "请你输入一个数字"
                exit 1
            fi

            sum=0  
            for (( i=0; i<=${num}; i++ ))  
            do  
                echo ${i}
                sum=$(($sum+$i))  
            done  
            echo "sum is : " $sum  
            [llllljian@llllljian-virtual-machine 20180606 21:22:17 #131]$ sh 6.sh 
            输入一个数,计算出1到这个数的和5
            0
            1
            2
            3
            4
            5
            sum is :  15
        ```
