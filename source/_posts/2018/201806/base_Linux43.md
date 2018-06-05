---
title: Linux_基础 (43)
date: 2018-06-05
tags: Linux
toc: true
---

### 条件判断式
    if...then : 当符合某个条件就进行某个工作
    case....esac : 与if比较代码更为清晰
    function : 自定义执行指令的代码块

<!-- more -->

#### if...then
- 单层简单条件判断式
    * 语法
        ```bash
            if [ 条件判断式1 [-a][-o][&&][||] 条件判断式2 ];then
                中括号中为true时可以执行的语句
            fi

            [ 条件判断式1 -a 条件判断式2 ] 条件1 条件2 两真且为真
            [ 条件判断式1 && 条件判断式2 ] 条件1 条件2 两真且为真
            [ 条件判断式1 -o 条件判断式2 ] 条件1 条件2 有真或为真
            [ 条件判断式1 || 条件判断式2 ] 条件1 条件2 有真或为真
        ```
    * 实例
        ```bash
            vim ~/.bashrc

            ...
            # 家目录/study/年月/年月日 如果不存在就创建文件夹
            if [ ! -d ~/study/$(date +%Y%m)/$(date +%Y%m%d)/ ];then
                mkdir -p ~/study/$(date +%Y%m)/$(date +%Y%m%d)/
            fi

            # 针对伪删除操作 清空回收站[每天删除的文件会移动到 /tmp/年月日/ 文件夹中]
            dOne=$(date --date='1 days ago' +%Y%m%d)
            dTwo=$(date --date='2 days ago' +%Y%m%d)
            dThree=$(date --date='3 days ago' +%Y%m%d)
            if [ -d /tmp/$dOne/ ];then
                    #echo "${dOne} 存在";   
                    /bin/rm -rf /tmp/$dOne/;
            fi
            if [ -d /tmp/$dTwo/ ];then
                    #echo "${dTwo} 存在";
                    /bin/rm -rf /tmp/$dTwo;
            fi
            if [ -d /tmp/$dThree/ ];then
                    #echo "${dThree} 存在";
                    /bin/rm -rf /tmp/$dThree;
            fi
            ...
        ```
- 多重复杂条件判断式
    * 语法
        ```bash
            1. 一个条件判断
            if [ 条件判断式 ]; then
                当条件判断式成立时执行的命令
            else
                当条件判断式不成立时执行的命令
            fi

            2. 多个条件判断
            if [ 条件判断式1 ]; then
                当条件判断式1成立时执行的命令
            elif [ 条件判断式2 ]; then
                当条件判断式2成立时执行的命令
            else
                当条件判断式1与条件判断式2均不成立时执行的命令
            fi
        ```
    * 实例
        ```bash
            [llllljian@llllljian-virtual-machine 20180605 16:43:42 #196]$ cat 4.sh
            #!/bin/bash
            #########################################################################
            # 文件名: 4.sh
            # 作者: llllljian
            # 邮箱: 18634678077@163.com
            # 创建时间: 2018年06月05日 星期二 16时22分52秒
            # 更新时间: 2018年06月05日 星期二 16时41分04秒
            #########################################################################

            echo "参数个数为：$#,其中："  
            for i in $(seq 1 $#)  
            do
                #通过eval把i变量的值($i)作为变量j的名字  
                eval j=\$$i  
                echo "第$i个参数：$j"

                #echo $((j%3))

                if [ $((j%3)) == '0' ]; then
                    echo "${j} 是3的倍数"
                elif [ $((j%3)) == '1' ]; then 
                    echo "${j} 除3余1"
                else
                    echo "${j} 除3余2"
                fi
            done

            [llllljian@llllljian-virtual-machine 20180605 16:44:09 #197]$ sh 4.sh 11 12 13 14 15 16 17
            参数个数为：7,其中：
            第1个参数：11
            11 除3余2
            第2个参数：12
            12 是3的倍数
            第3个参数：13
            13 除3余1
            第4个参数：14
            14 除3余2
            第5个参数：15
            15 是3的倍数
            第6个参数：16
            16 除3余1
            第7个参数：17
            17 除3余2
        ```

#### case...esac
- 语法
    ```bash
        case $变量名称 in
            "第一个变量内容")
                程序段
                ;;
            "第二个变量内容")
                程序段
                ;;
            *)
                不包含第一个变量内容与第二个变量内容的其它程序执行段
                exit 1
                ;;
        esac

        $变量名称 大致有两种获得方式
        1. 直接下达式 ${1}
        2. 交互式 read -p "请输入" content;${content}
    ```
- 实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180605 19:10:48 #202]$ cat 5.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 5.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月05日 星期二 19时04分17秒
        # 更新时间: 2018年06月05日 星期二 19时04分17秒
        #########################################################################

        read -p "请随便输入1-9一个数字" num
        case ${num} in
            "1")
                echo "11111111111"
                ;;
            "2")
                echo "22222222222"
                ;;
            "3")
                echo "33333333333"
                ;;
            "4")
                echo "44444444444" 
                ;;
            "5")
                echo "55555555555"
                ;;
            "6")
                echo "66666666666"
                ;;
            "7")	
                echo "77777777777"
                ;;
            "8")
                echo "88888888888"
                ;;
            "9")
                echo "99999999999"
                ;;
            *)
                echo "请你输入1-9好吗"
                ;;
        esac
        [llllljian@llllljian-virtual-machine 20180605 19:10:53 #203]$ sh 5.sh
        请随便输入1-9一个数字8
        88888888888

        [llllljian@llllljian-virtual-machine 20180605 19:11:16 #204]$ sh 5.sh
        请随便输入1-9一个数字
        请你输入1-9好吗

        [llllljian@llllljian-virtual-machine 20180605 19:11:19 #205]$ sh 5.sh
        请随便输入1-9一个数字dfasdf
        请你输入1-9好吗
    ```

#### function
- 语法
    ```bash
        function fname() {
            程序段
        }
    ```
- 实例
    ```bash
        [llllljian@llllljian-virtual-machine 20180605 19:23:57 #209]$ cat 6.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 6.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月05日 星期二 19时21分53秒
        # 更新时间: 2018年06月05日 星期二 19时21分53秒
        #########################################################################

        #输出红色
        function rmsg() { 
            echo -e "\033[31;49m$*\033[0m"; 
        } 

        #输出绿色
        gmsg() { 
            echo -e "\033[32;49m$*\033[0m"; 
        }

        #输出蓝色
        bmsg() { 
            echo -e "\033[34;49m$*\033[0m"; 
        }

        rmsg 红色
        gmsg 绿色
        bmsg 蓝色

        [llllljian@llllljian-virtual-machine 20180605 19:24:00 #210]$ sh 6.sh
        红色
        绿色
        蓝色

        [llllljian@llllljian-virtual-machine 20180605 19:26:27 #215]$ cat 7.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 7.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月05日 星期二 19时25分19秒
        # 更新时间: 2018年06月05日 星期二 19时25分46秒
        #########################################################################

        #输出红色
        function rmsg() { 
            echo -e "\033[31;49m$*\033[0m"; 
        } 

        #输出绿色
        gmsg() { 
            echo -e "\033[32;49m$1\033[0m"; 
        }

        #输出蓝色
        bmsg() { 
            echo -e "\033[34;49m$2\033[0m"; 
        }

        rmsg 红色 红色1
        gmsg 绿色 绿色1
        bmsg 蓝色 蓝色1

        [llllljian@llllljian-virtual-machine 20180605 19:26:35 #216]$ sh 7.sh
        红色 红色1
        绿色
        蓝色1
    ```

#### function与case结合使用
    ```bash
        llllljian@llllljian-virtual-machine 20180605 19:41:43 #224]$ cat 8.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 8.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月05日 星期二 19时29分38秒
        # 更新时间: 2018年06月05日 星期二 19时29分38秒
        #########################################################################

        test1 ()
        {
            echo "这是方法test1,你输入的是a"
        }

        test2 ()
        {
                echo "这是方法test2,你输入的是b"
        }

        test3 ()
        {
                echo "这是方法test3,你输入的是c|d|e|f"
        }

        test4 ()
        {
                echo "这是方法test4,你输入的是g"
        }

        test5 ()
        {
            echo "这是方法test5,你输入的是其它字母"
        }

        case "$1" in
            a) test1 ;;
            b) test2 ;;
            c|d|e|f) test3 ;;
            g) test4 ;;
            *) test5 ;;
        esac

        [llllljian@llllljian-virtual-machine 20180605 19:42:09 #225]$ sh 8.sh a
        这是方法test1,你输入的是a

        [llllljian@llllljian-virtual-machine 20180605 19:42:14 #226]$ sh 8.sh b
        这是方法test2,你输入的是b

        [llllljian@llllljian-virtual-machine 20180605 19:42:19 #227]$ sh 8.sh D
        这是方法test5,你输入的是其它字母

        [llllljian@llllljian-virtual-machine 20180605 19:42:21 #228]$ sh 8.sh
        这是方法test5,你输入的是其它字母
    ```