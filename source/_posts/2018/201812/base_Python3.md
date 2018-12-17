---
title: Python_基础 (3)
date: 2018-12-10
tags: Python
toc: true
---

### Python3基础语法
    Python学习笔记

<!-- more -->

#### 数字类型
- int (整数)
    * 如 1, 只有一种整数类型 int，表示为长整型，没有python2中的Long
- bool (布尔)
    * 如 True
- float (浮点数)
    * 1.23、3E-2
- complex (复数)
    * 如 1 + 2j、 1.1 + 2.2j

#### 字符串
- python中单引号和双引号使用完全相同
- 使用三引号('''或""")可以指定一个多行字符串
- 转义符 '\'
- 反斜杠可以用来转义，使用r可以让反斜杠不发生转义
    * 如 r"this is a line with \n" 则\n会显示，并不是换行
- 按字面意义级联字符串
    * 如"this " "is " "string"会被自动转换为this is string
- 字符串可以用 + 运算符连接在一起，用 * 运算符重复
- Python 中的字符串有两种索引方式，从左往右以 0 开始，从右往左以 -1 开始
- Python中的字符串不能改变
- Python 没有单独的字符类型，一个字符就是长度为 1 的字符串。
- 字符串的截取的语法格式如下：变量[头下标:尾下标:步长]
- eg
    ```python
        word = '字符串'
        sentence = "这是一个句子。"
        paragraph = """这是一个段落，
        可以由多行组成"""

        print(type(word), word)
        print(type(sentence), sentence)
        print(type(paragraph), paragraph)

        # 输出结果
        E:\python>py stringTest.py
        <class 'str'> 字符串
        <class 'str'> 这是一个句子。
        <class 'str'> 这是一个段落，
        可以由多行组成
    ```
- eg1
    ```python
        # 输出结果
        str='llllljian'
 
        print(str)                 # 输出字符串
        print(str[0:-1])           # 输出第一个到倒数第二个的所有字符
        print(str[0])              # 输出字符串第一个字符
        print(str[2:5])            # 输出从第三个开始到第五个的字符
        print(str[2:])             # 输出从第三个开始的后的所有字符
        print(str * 2)             # 输出字符串两次
        print(str + '你好')        # 连接字符串
        
        print('------------------------------')
        
        print('hello\nllllljian')      # 使用反斜杠(\)+n转义特殊字符
        print(r'hello\nllllljian')     # 在字符串前面添加一个 r，表示原始字符串，不会发生转义

        E:\python>py stringTest.py
        llllljian
        llllljia
        l
        lll
        llljian
        llllljianllllljian
        llllljian你好
        ------------------------------
        hello
        llllljian
        hello\nllllljian
    ```

#### 空行
    函数之间或类的方法之间用空行分隔，表示一段新的代码的开始。类和函数入口之间也用一行空行分隔，以突出函数入口的开始。
    空行与代码缩进不同，空行并不是Python语法的一部分。书写时不插入空行，Python解释器运行也不会出错。但是空行的作用在于分隔两段不同功能或含义的代码，便于日后代码的维护或重构

#### 等待用户输入
- eg
    ```python
        #!/usr/bin/python3
 
        input("\n\n按下 enter 键后退出。")
    ```

#### 同一行显示多条语句
- Python可以在同一行中使用多条语句，语句之间使用分号(;)分割
- eg
    ```python
        # 脚本执行
        #!/usr/bin/python3
        import sys; x = 'llllljian'; sys.stdout.write(x + '\n')

        # 输出结果
        llllljian

        # 命令行交互
        >>> import sys; x = 'llllljian'; sys.stdout.write(x + '\n')
        llllljian
        10
    ```

#### 多个语句构成代码组
    缩进相同的一组语句构成一个代码块，我们称之代码组。
    像if、while、def和class这样的复合语句，首行以关键字开始，以冒号( : )结束，该行之后的一行或多行代码构成代码组

#### Print 输出
- print 默认输出是换行的，如果要实现不换行需要在变量末尾加上 end=""
- eg
    ```python
        #!/usr/bin/python3
        
        x="a"
        y="b"
        # 换行输出
        print( x )
        print( y )
        
        print('---------')
        # 不换行输出
        print( x, end=" " )
        print( y, end=" " )
        print()

        # 输出结果
        a
        b
        ---------
        a b
    ```

#### import 与 from...import
- 在 python 用 import 或者 from...import 来导入相应的模块
- 将整个模块(somemodule)导入，格式为： import somemodule
- 从某个模块中导入某个函数,格式为： from somemodule import somefunction
- 从某个模块中导入多个函数,格式为： from somemodule import firstfunc, secondfunc, thirdfunc
- 将某个模块中的全部函数导入，格式为： from somemodule import *


