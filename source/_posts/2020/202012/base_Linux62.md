---
title: Linux_基础 (62)
date: 2020-12-08
tags: Linux
toc: true
---

### Linux积累
    今日份学习linux状态码

<!-- more -->

#### linux状态码说明
> shell中运行的每个命令都使用退出状态码( exit status)告诉shell它已经运行完毕.退出状态码是一个0～255的整数值,在命令结束运行时由命令传给shell.可以捕获这个值并在脚本中使用.

#### 常见退出状态码
<table style="width: 587px; height: 192px" border="1"><tbody><tr><td style="width: 1px"><span style="font-size: 15px"><strong>状态码</strong></span></td><td style="width: 1px"><span style="font-size: 15px"><strong>描述</strong></span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">0</span></td><td style="width: 1px"><span style="font-size: 15px">命令成功结束</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">1</span></td><td style="width: 1px"><span style="font-size: 15px">通用未知错误　　</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">2</span></td><td style="width: 1px"><span style="font-size: 15px">误用Shell命令</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">126</span></td><td style="width: 1px"><span style="font-size: 15px">命令不可执行</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">127</span></td><td style="width: 1px"><span style="font-size: 15px">没找到命令</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">128</span></td><td style="width: 1px"><span style="font-size: 15px">无效退出参数</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">128+x</span></td><td style="width: 1px"><span style="font-size: 15px">Linux信号x的严重错误</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">130</span></td><td style="width: 1px"><span style="font-size: 15px">命令通过Ctrl+C控制码越界</span></td></tr><tr><td style="width: 1px"><span style="font-size: 15px">255</span></td><td style="width: 1px"><span style="font-size: 15px">退出码越界</span></td></tr></tbody></table>

#### 查看退出状态码
> Linux提供了一个专门的变量$?来保存上个已执行命令的退出状态码.对于需要进行检查的命令,必须在其运行完毕后立刻查看或使用$?变量.它的值会变成由shell所执行的最后一条命令的退出状态码.
- demo
    ```bash
        $ date
        2020年12月08日 星期二 15时41分20秒 CST
        $ echo $?
        0
    ```
- 修改退出状态码
    ```bash
        $ cat test13
        #!/bin/bash
        # testing the exit status
        var1=10
        var2=30
        var3=$[$var1 + $var2]
        echo The answer is $var3
        exit 5

        # 当查看脚本的退出码时,你会得到作为参数传给exit命令的值.
        $ chmod u+x test13
        $ ./test13
        The answer is 40
        $ echo $?
        5

        # 也可以在exit命令的参数中使用变量.
        $ cat test14
        #!/bin/bash
        # testing the exit status
        var1=10
        var2=30
        var3=$[$var1 + $var2]
        exit $var3
        $
        # 当你运行这个命令时,它会产生如下退出状态.
        $ chmod u+x test14
        $ ./test14
        $ echo $?
        40
    ```
    * 注意
        * 退出状态码被缩减到了0～ 255的区间.shell通过模运算得到这个结果.一个值的模就是被除后的余数.最终的结果是指定的数值除以256后得到的余数.

#### Shell符号规则
1. 方括号[]
    * 一般来说常用于test命令
    * demo
        ```bash
            # 如果给定的变量包含正常的文件路径或文件名,则返回真
            [ -f $file_var ]
            # 如果给定的变量包含的文件可执行,则返回真
            [ -x $var ]
            # 如果给定的变量包含的是目录,则返回真
            [ -d $var ]
            # 如果给定的变量包含的文件存在,则返回真
            [ -e $var ]
            # 如果给定的变量包含的是一个字符设备文件的路径,则返回真
            [ -c $var ]
            # 如果给定的变量包含的是一个块设备文件的路径,则返回真
            [ -b $var ]
            # 如果给定的变量包含的文件可写,则返回真
            [ -w $var ]
            # 如果给定的变量包含的文件可读,则返回真
            [ -r $var ]
            # 如果给定的变量包含的是一个符号链接,则返回真
            [ -L $var ]
        ```
2. 双圆括号(( expression ))
    * 作用：双圆括号允许你将高级数学表达式放入比较中
    <table border="1"><caption>双圆括号命令符号</caption><tbody><tr><td style="text-align: center"><strong><span style="font-size: 14px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 符号&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></strong></td><td style="text-align: center"><strong><span style="font-size: 14px">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 描述&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></strong></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">val++</span></td><td style="text-align: center"><span style="font-size: 14px">后增</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">val--</span></td><td style="text-align: center"><span style="font-size: 14px">后减</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">++val</span></td><td style="text-align: center"><span style="font-size: 14px">先加</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">--val</span></td><td style="text-align: center"><span style="font-size: 14px">先减</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">!</span></td><td style="text-align: center"><span style="font-size: 14px">逻辑求反</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">~</span></td><td style="text-align: center"><span style="font-size: 14px">位求反</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">**</span></td><td style="text-align: center"><span style="font-size: 14px">幂运算</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">&lt;&lt;</span></td><td style="text-align: center"><span style="font-size: 14px">左位移</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">&gt;&gt;</span></td><td style="text-align: center"><span style="font-size: 14px">&nbsp;右位移</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">&amp;</span></td><td style="text-align: center"><span style="font-size: 14px">&nbsp;位布尔和</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">|</span></td><td style="text-align: center"><span style="font-size: 14px">&nbsp;位布尔或</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">&amp;&amp;</span></td><td style="text-align: center"><span style="font-size: 14px">&nbsp;逻辑和</span></td></tr><tr><td style="text-align: center"><span style="font-size: 14px">||</span></td><td style="text-align: center"><span style="font-size: 14px">&nbsp;逻辑或</span></td></tr></tbody></table>
3. 双方括号[[ expression ]]
    * 作用：提供了针对字符串比较高级特性,除了可以像方括号使用test命令那样之外,还可以进行模式匹配
    * demo
        ```bash
            # 当str1等于str2时,返回真.也就是说,str1和str2包含 的文本是一模一样的
            [[ $str1 = $str2 ]]
            # 这是检查字符串是否相等的另一种写法. 也可以检查两个字符串是否不同
            [[ $str1 == $str2 ]]
            # 如果str1和str2不相同,则返回真
            [[ $str1 != $str2 ]]
            # 如果str1的字母序比str2大,则返回真
            [[ $str1 > $str2 ]]
            # 如果str1的字母序比str2小,则返回真
            [[ $str1 < $str2 ]]
            # 如果str1包含的是空字符串,则返回真
            [[ -z $str1 ]]
            # 如果str1包含的是非空字符串,则返回真
            [[ -n $str1 ]]
        ```
4. $单方括号$[ operation ]
    * 作用：执行数学表达式
    * demo
        ```bash
            var3=$[ $var1 / $var2 ]
        ```
5. 命令行参数
    * 手工处理方式
        - deatil
            * $0 : 文件名
            * $1 : 第一个参数.
            * $2 : 第二个参数
            * $3, $4 ... : 类推.
            * $# : 参数的个数,不包括命令本身
            * $@ : 参数本身的列表,也不包括命令本身
            * $* : 和$@相同,但"$*" 和 "$@"(加引号)并不同,"$*"将所有的参数解释成一个字符串,而"$@"是一个参数数组.
        - demo
            ```bash
                $ cat t1.sh
                #!/bin/bash
                # testing $* and $@

                # echo "Using the \$* method $*"
                # echo "Using the \$@ method $@"

                count=1

                for param in "$*"
                do
                    echo "\$* Parameter #$count = $param"
                    count=$[ $count + 1 ]
                done

                count=1
                for param in "$@"
                do
                    echo "\$@ Parameter #$count = $param"
                    count=$[ $count + 1 ]
                done

                $ sh t1.sh a b c d e f
                $* Parameter #1 = a b c d e f
                $@ Parameter #1 = a
                $@ Parameter #2 = b
                $@ Parameter #3 = c
                $@ Parameter #4 = d
                $@ Parameter #5 = e
                $@ Parameter #6 = f
            ```
    * getopts
    * getopt
6. Shell的输入与输出

#### 处理选项

##### 找出选项
1. 处理简单选项,
    * 在抽取每个参数是,使用case语句判断参数是否符合选项格式
    * case语句检查每个参数是否为有效的选项,当找到一个选项时,就在case语句中运行适当的命令
    * eg
        ```bash
            $ cat t3.sh
            #!/bin/bash
            # 此处的$1必须加且只能用双引号
            while [ -n "$1" ]
            do
                # 此处的$1可以加双引号或不加
                case $1 in
                # 此处的两个分号一定要加上
                -a)  echo "found the -a option";;
                -b)  echo "found the -b option";;
                -c)  echo "found the -c option";;
                *)  echo "$1 is not an option";;
                esac
                shift
            done

            $ sh t3.sh -a -b -c -d -g
            found the -a option
            found the -b option
            found the -c option
            -d is not an option
            -g is not an option
        ```
2. 从参数中分离选项
    * linux使用特殊字符码将选项和普通参数分开,这个字符码告诉脚本选项结束和普通参数开始的位置.所以发现双破折号后,脚本就能够安全的将剩余的命令行参数作为参数而不是选项来处理
    * eg
        ```bash
            $ cat t4.sh
            #!/bin/bash
            while [ -n "$1" ]
            do
                case $1 in
                -a) echo "found the -a option";;
                -b) echo "found the -b option";;
                -c) echo "found the -c option";;
                --) shift
                    break ;;
                *) echo "$1 is not an option";;
                esac
                shift
            done
            count=1
            for param in $@
            do
                echo "parameter #count:$param"
                count=$[ $count + 1 ]
            done

            $ sh t4.sh -a -b -c -d -e -- 1 2 3 4
            found the -a option
            found the -b option
            found the -c option
            -d is not an option
            -e is not an option
            parameter #count:1
            parameter #count:2
            parameter #count:3
            parameter #count:4
        ```
3. 处理带值的选项
    * eg
        ```bash
            $ cat t5.sh
            #!/bin/bash
            while [ -n "$1" ]
            do
                case $1 in
                    -a) echo "found the -a option";;
                    -b) param="$2"
                        echo "found the -b option,with parameter value $param"
                        shift 1;;
                    -c) echo "found the -c option";;
                    --) shift
                    break;;
                esac
                shift
            done

            count=1
            for param in "$@"
            do
                echo "parameter #count:$param"
                count=$[ $count + 1 ]
            done

            $ sh t5.sh -a -b 56 -c -- test1 test2 test3
            found the -a option
            found the -b option,with parameter value 56
            found the -c option
            parameter #count:test1
            parameter #count:test2
            parameter #count:test3
        ```

##### getopt
1. 命令格式
    * getopt options optstring parameters
    * 其中optstring是处理的关键,他定义命令行中有效的选项字母,然后,在每个需要参数值的选项字母后面放置一个冒号.
    * demo
        ```bash
            # 参数有-a -b -c -d 其中-b后面会有参数
            $ getopt ab:cd -a -b test1 -cd test2 test3
            -a -b test1 -c -d -- test2 test3

            # 如果指定的选项不包含在选项字符串内,getopt命令会默认生成一个错误信息
            $ getopt ab:cd -a -b test1 -cde test2 test3
            getopt: illegal option -- e
            -a -b test1 -c -d -- test2 test3

            # 如果希望忽略这个错误消息,可以再命令中使用-q选项
            $ getopt -q ab:cd -a -b test1 -cde test2 test3
            -- ab:cd -a -b test1 -cde test2 test3
        ```
2. 在脚本中使用getopt

##### getopts

