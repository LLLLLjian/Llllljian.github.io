---
title: Linux_基础 (48)
date: 2018-06-10
tags: Linux
toc: true
---

### 本周总结
    这周主要是学了shell脚本,编写了一些简单的例子.
    趁着周末总结一下

<!-- more -->

#### Shell简介
- shell是什么
    * 命令语言 : 交互式地解释和执行用户输入的命令
    * 程序设计语言 : 定义了各种变量和参数,并提供了许多在高级语言中才具有的控制结构,包括循环和分支
- 执行命令的方式
    * 交互式 : 解释执行用户的命令,用户输入一条命令,Shell就解释执行一条
    * 批处理 : 用户事先写一个Shell脚本(Script),其中有很多条命令,让Shell一次把这些命令执行完

#### 常见的shell
- bash : bash是Linux[Centos]标准默认的shell
    * 用方向键查阅和快速输入并修改命令
    * 自动通过查找匹配的方式给出以某字符串开头的命令
    * 包含了自身的帮助功能,你只要在提示符下面键入help就可以得到相关的帮助
- sh : 是Unix 标准默认的shell
- dash : 是ubuntu里默认的shell

#### 编译型语言和解释型语言的区别 
- 编译型语言
    * 需要编译才能运行,编写的源代码需要转换为目标代码
    * Java PHP
    * 执行效率高,多运作于底层
- 解释型语言
    * 脚本语言,编译器直接读取
    * shell Python
    * 轻易处理文件与目录之类的对象,但效率不如编译型语言

#### shell脚本输出
- echo
    * 命令功能
        * 用于在屏幕上打印出指定的字符串
    * 命令语法
        * echo arg
- printf
    * 命令功能
        * 格式化输出
    * 命令语法
        * printf  format-string  [arguments...]

#### if...else语句
- if ... fi 语句
    * 如果 expression 返回 true,then 后边的语句将会被执行；如果返回 false,不会执行任何语句.
    * 最后必须以 fi 来结尾闭合 if,fi 就是 if 倒过来拼写,后面也会遇见
    ```bash
        if [ expression ]; then
            Statement(s) to be executed if expression is true
        fi
    ```
- if ... else ... fi 语句
    * 如果 expression 返回 true,那么 then 后边的语句将会被执行；否则,执行 else 后边的语句
    ```bash
        if [ expression ]; then
            Statement(s) to be executed if expression is true
        else
            Statement(s) to be executed if expression is not true
        fi
    ```
- if ... elif ... else ... fi 语句
    * 哪一个 expression 的值为 true,就执行哪个 expression 后面的语句；如果都为 false,那么不执行任何语句
    ```bash
        if [ expression 1 ]; then
            Statement(s) to be executed if expression 1 is true
        elif [ expression 2 ]; then
            Statement(s) to be executed if expression 2 is true
        elif [ expression 3 ]; then
            Statement(s) to be executed if expression 3 is true
        else
            Statement(s) to be executed if no expression is true
        fi
    ```

#### case esac命令
- 与其他语言中的 switch ... case 语句类似,是一种多分枝选择结构.
- case 语句匹配一个值或一个模式,如果匹配成功,执行相匹配的命令
- case工作方式如上所示.取值后面必须为关键字 in,每一模式必须以右括号结束.取值可以为变量或常数.匹配发现取值符合某一模式后,其间所有命令开始执行直至 ;;
- ;; 与其他语言中的 break 类似,意思是跳到整个 case 语句的最后.
- 取值将检测匹配的每一个模式.一旦模式匹配,则执行完匹配模式相应命令后不再继续其他模式.如果无一匹配模式,使用星号 * 捕获该值,再执行后面的命令
```bash
    case 值 in
    模式1)
        command1
        command2
        command3
        ;;
    模式2)
        command1
        command2
        command3
        ;;
    *)
        command1
        command2
        command3
        ;;
    esac
```
#### for循环
- 列表是一组值(数字、字符串等)组成的序列,每个值通过空格分隔.每循环一次,就将列表中的下一个值赋给变量.
- in 列表是可选的,如果不用它,for 循环使用命令行的位置参数
```bash
    for 变量 in 列表
    do
        command1
        command2
        ...
        commandN
    done
```

#### while循环
- while循环用于不断执行一系列命令,也用于从输入文件中读取数据
- 命令通常为测试条件
- 命令执行完毕,控制返回循环顶部,从头开始直至测试条件为假
```bash
    while command
    do
        Statement(s) to be executed if command is true
    done
```

#### until命令
- until 循环执行一系列命令直至条件为 true 时停止
- command 一般为条件表达式,如果返回值为 false,则继续执行循环体内的语句,否则跳出循环
```bash
    until command
    do
        Statement(s) to be executed until command is true
    done
```

#### 跳出循环
- break命令
    * break命令允许跳出所有循环(终止执行后面的所有循环)
    * 在嵌套循环中,break 命令后面还可以跟一个整数,表示跳出第几层循环
- continue命令
    * 仅跳出当前循环
    * continue 后面也可以跟一个数字,表示跳出第几层循环

#### Shell函数
- 先定义后使用
- 函数返回值,可以显式增加return语句；如果不加,会将最后一条命令运行结果作为返回值.
- Shell 函数返回值只能是整数,一般用来表示函数执行成功与否,0表示成功,其他值表示失败.如果 return 其他数据,比如一个字符串,往往会得到错误提示: “numeric argument required”.
- 如果一定要让函数返回字符串,那么可以先定义一个变量,用来接收函数的计算结果,脚本在需要的时候访问这个变量来获得函数返回值
- 调用函数只需要给出函数名,不需要加括号
- 函数返回值在调用该函数后通过 $? 来获得
- 删除函数unset .f functionName
- 如果想在终端直接调用函数,可以将函数定义在主目录下的.profile文件中
```bash
    functionName () {
        list of commands
        [ return value ]
    }
    　　如果你愿意,也可以在函数名前加上关键字 function: 
    function functionName () {
        list of commands
        [ return value ]
    }
```

#### 文件包含
- 包含外部脚本,将外部脚本的内容合并到当前脚本
```bash
    . filename
    或
    source filename
```
