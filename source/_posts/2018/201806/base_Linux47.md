---
title: Linux_基础 (47)
date: 2018-06-08
tags: Linux
toc: true
---

### 遇到的问题
    Ubuntu系统编译.sh文件报错 “[: XXXX: unexpected operator”

<!-- more -->

#### 问题原因和现象
- 问题现象
    1.之前是在公司学习shell脚本.今天在自己电脑上编译之前练习的.sh文件发生错误之前的shell脚本都不能正常编译,报错为“[: XXXX: unexpected operator”
    2.用$(())在.sh文件中执行的时候输出为空
- 原因
    因为Ubuntu默认的sh是连接到dash的,又因为dash跟bash的不兼容所以出错了.执行时可以把sh换成bash文件名.sh来执行.成功
- 改正方法
    ```bash
        sudo dpkg-reconfigure dash
        选择no 即可！
    ```
- 结果
    之前的.sh文件都编译成功,没有再报错
    结果都正常展示
- 实例
    ```bash
        # 修改前
        [llllljian@llllljian-virtual-machine 20180608 22:00:02 #1]$ cat 2.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 2.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月08日 星期五 21时58分02秒
        # 更新时间: 2018年06月08日 星期五 21时58分43秒
        # 注释: 算数运算符
        #########################################################################

        a=10
        b=20
        echo "a : $a"
        echo "b : $b\n"

        val=`expr $a + $b`
        echo "a + b : $val"

        var1=$((${a} + ${b}))
        echo "a + b : ${var1} \n"

        val=`expr $a - $b`
        echo "a - b : $val"

        echo "a - b : $((${a} - ${b})) \n"

        val=`expr $a \* $b`
        echo "a * b : $val"

        echo "a * b : $((${a} * ${b})) \n"

        val=`expr $b / $a`
        echo "b / a : $val"

        echo "b / a : $((${b} / ${a})) \n"

        val=`expr $b % $a`
        echo "b % a : $val"

        echo "b % a : $((${b} % ${a})) \n"

        if [ $a == $b ]; then
            echo "a is equal to b"
        fi

        if [ $a != $b ]; then
            echo "a is not equal to b"
        fi

        [llllljian@llllljian-virtual-machine 20180608 22:01:15 #2]$ sh 2.sh
        a : 10
        b : 20

        a + b : 30
        a + b : 

        a - b : -10
        a - b : 

        a * b : 200
        a * b : 

        b / a : 2
        b / a : 

        b % a : 0
        b % a : 

        2.sh: 42: [: false: unexpected operator
        a is not equal to b

        # 修改后
        [llllljian@llllljian-virtual-machine 20180608 22:07:44 #12]$ cat 2.sh
        #!/bin/bash
        #########################################################################
        # 文件名: 2.sh
        # 作者: llllljian
        # 邮箱: 18634678077@163.com
        # 创建时间: 2018年06月08日 星期五 21时58分02秒
        # 更新时间: 2018年06月08日 星期五 22时07分25秒
        # 注释: 算数运算符
        #########################################################################

        a=10
        b=20
        echo -e "a : $a"
        echo -e "b : $b\n"

        val=`expr $a + $b`
        echo -e "a + b : $val"

        var1=$((${a} + ${b}))
        echo -e "a + b : ${var1} \n"

        val=`expr $a - $b`
        echo -e "a - b : $val"

        echo -e "a - b : $((${a} - ${b})) \n"

        val=`expr $a \* $b`
        echo -e "a * b : $val"

        echo -e "a * b : $((${a} * ${b})) \n"

        val=`expr $b / $a`
        echo -e "b / a : $val"

        echo -e "b / a : $((${b} / ${a})) \n"

        val=`expr $b % $a`
        echo -e "b % a : $val"

        echo -e "b % a : $((${b} % ${a})) \n"

        if [ $a == $b ]; then
            echo "a is equal to b"
        fi

        if [ $a != $b ]; then
            echo "a is not equal to b"
        fi
        
        [llllljian@llllljian-virtual-machine 20180608 22:07:46 #13]$ sh 2.sh
        a : 10
        b : 20

        a + b : 30
        a + b : 30

        a - b : -10
        a - b : -10

        a * b : 200
        a * b : 200

        b / a : 2
        b / a : 2

        b % a : 0
        b % a : 0

        a is not equal to b
    ```
