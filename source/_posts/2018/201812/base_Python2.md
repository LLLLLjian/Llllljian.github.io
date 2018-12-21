---
title: Python_基础 (2)
date: 2018-12-07
tags: Python
toc: true
---

### Python3基础语法
    Python学习笔记

<!-- more -->

#### 解释器
- 只适用于Linux
    ```python
        #脚本语言的第一行,目的就是指出,你想要你的这个文件中的代码用什么可执行程序去运行它

        #!/usr/bin/python3 是告诉操作系统执行这个脚本的时候,调用 /usr/bin 下的 python3 解释器

        #!/usr/bin/env python3 这种用法是为了防止操作系统用户没有将 python3 装在默认的 /usr/bin 路径里.当系统看到这一行的时候,首先会到 env 设置里查找 python3 的安装路径,再调用对应路径下的解释器程序完成操作
    ```

#### 编码
- 默认情况下,Python3源码文件以UTF-8编码,所有字符串都是unicode字符串
- 设置编码
    ```python
        # -*- coding: cp-1252 -*-
        # -*- coding: utf-8 -*-  
    ```

#### 标识符
- 第一个字符必须是字母表中字母或下划线 _ 
- 标识符的其他的部分由字母、数字和下划线组成
- 标识符对大小写敏感

#### Python保留字
- 保留字即关键字,我们不能把它们用作任何标识符名称
- 关键字列表
    ```python
        >>> import keyword
        >>> keyword.kwlist
        ['False', 'None', 'True', 'and', 'as', 'assert', 'async', 'await', 'break', 'class', 'continue', 'def', 'del', 'elif', 'else', 'except', 'finally', 'for', 'from', 'global', 'if', 'import', 'in', 'is', 'lambda', 'nonlocal', 'not', 'or', 'pass', 'raise', 'return', 'try', 'while', 'with', 'yield']
    ```

#### 注释
- 单行注释
    * #开头
    * eg
        ```python
            #! /usr/bin/python3
            # -*- coding: utf-8 -*-  

            # 第一个注释
            print ("Hello, Python!") # 第二个注释

            # 输出结果
            Hello, Python!
        ```
- 多行注释
    * 多个#
    * '''
    * """
    * eg
        ```python
            #! /usr/bin/python3
            # -*- coding: utf-8 -*- 

            # 第一个注释
            # 第二个注释
            
            '''
            第三注释
            第四注释
            '''
            
            """
            第五注释
            第六注释
            """
            print ("Hello, Python!")

            # 输出结果
            Hello, Python!
        ```

#### 行与缩进
- 使用缩进来表示代码块,不需要使用大括号 {}
- 缩进的空格数是可变的,但是同一个代码块的语句必须包含相同的缩进空格数
- eg
    ```python
        if True:
            print ("True")
        else:
            print ("False")
    ```

#### 多行语句
- 如果语句很长,可以使用反斜杠(\\)来实现多行语句
- 在 [], {}, 或 () 中的多行语句,不需要使用反斜杠(\\)
- eg
    ```python
        total = item_one + \
                item_two + \
                item_three

        total = ['item_one', 'item_two', 'item_three',
                 'item_four', 'item_five']
    ```

