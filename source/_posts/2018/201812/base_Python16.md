---
title: Python_基础 (16)
date: 2018-12-27
tags: Python
toc: true
---

### Python3自定义函数
    Python3学习笔记

<!-- more -->

#### 自定义函数规则
- 函数代码块以 def 关键词开头,后接函数标识符名称和圆括号 ().
- 任何传入参数和自变量必须放在圆括号中间,圆括号之间可以用于定义参数.
- 函数的第一行语句可以选择性地使用文档字符串—用于存放函数说明.
- 函数内容以冒号起始,并且缩进.
- return \[表达式] 结束函数,选择性地返回一个值给调用方.不带表达式的return相当于返回 None.

#### 自定义函数语法
- eg
    ```python
        def 函数名（参数列表）:
            函数体
    ```

#### 自定义函数参数传递
- 不可变类型
    * 整数
    * 字符串
    * 元组
    * eg
        ```python
            #!/usr/bin/python3
 
            def ChangeInt( a ):
                a = 10
            
            b = 2
            ChangeInt(b)
            print( b ) # 结果是 2
        ```
- 可变类型
    * 列表
    * 字典
    * eg
        ```python
            #!/usr/bin/python3

            # 可写函数说明
            def changeme( mylist ):
                "修改传入的列表"
                mylist.append([1,2,3,4])
                print ("函数内取值: ", mylist)
                return
            
            # 调用changeme函数
            mylist = [10,20,30]
            changeme( mylist )
            print ("函数外取值: ", mylist)
        ```


#### 自定义函数参数
- 必需参数
    * 必需参数须以正确的顺序传入函数.调用时的数量必须和声明时的一样
    * eg
        ```python
            #!/usr/bin/python3

            #可写函数说明
            def printme( str ):
                "打印任何传入的字符串"
                print (str)
                return
            
            #调用printme函数
            printme( str = "llllljian")
        ```
- 关键字参数
    * 使用关键字参数允许函数调用时参数的顺序与声明时不一致
    * eg
        ```python
            #!/usr/bin/python3

            #可写函数说明
            def printinfo( name, age ):
            "打印任何传入的字符串"
            print ("名字: ", name)
            print ("年龄: ", age)
            return
            
            #调用printinfo函数
            printinfo( age=50, name="llllljian" )
        ```
- 默认参数
    * 调用函数时,如果没有传递参数,则会使用默认参数
    * eg
        ```python
            #!/usr/bin/python3

            #可写函数说明
            def printinfo( name, age = 35 ):
            "打印任何传入的字符串"
            print ("名字: ", name)
            print ("年龄: ", age)
            return
            
            #调用printinfo函数
            printinfo( age=24, name="llllljian" )
            print ("------------------------")
            printinfo( name="llllljian" )
        ```
- 不定长参数
    * 一个星号*的参数会以元组的形式导入
    * 语法
        ```python
            def functionname([formal_args,] *var_args_tuple ):
                "函数_文档字符串"
                function_suite
                return [expression]
        ```
    * 两个星号**的参数会以字典的形式导入
    * 语法
        ```python
            def functionname([formal_args,] **var_args_dict ):
                "函数_文档字符串"
                function_suite
                return [expression]
        ```

#### 匿名函数
- lambda 只是一个表达式,函数体比 def 简单很多.
- lambda的主体是一个表达式,而不是一个代码块.仅仅能在lambda表达式中封装有限的逻辑进去.
- lambda 函数拥有自己的命名空间,且不能访问自己参数列表之外或全局命名空间里的参数.
- 虽然lambda函数看起来只能写一行,却不等同于C或C++的内联函数,后者的目的是调用小函数时不占用栈内存从而增加运行效率
- 语法
    ```python
        lambda [arg1 [,arg2,.....argn]]:expression
    ```
- eg
    ```python
        #!/usr/bin/python3

        # 可写函数说明
        sum = lambda arg1, arg2: arg1 + arg2
        
        # 调用sum函数
        print ("相加后的值为 : ", sum( 10, 20 ))
        print ("相加后的值为 : ", sum( 20, 20 ))
    ```

#### return语句
    return [表达式] 语句用于退出函数,选择性地向调用方返回一个表达式.不带参数值的return语句返回None

#### 变量作用域
- L
    * 局部作用域
    * 优先查找\[优先级为1]
- E
    * 闭包函数外的函数中
    * 仅次于局部作用域\[优先级为2]
- G
    * 全局作用域
    * 仅次于闭包函数外的函数中\[优先级为3]
- B
    * 内建作用域
    * 仅次于全局作用域\[优先级为4]
- eg
    ```python
        x = int(2.9)  # 内建作用域
 
        g_count = 0  # 全局作用域
        def outer():
            o_count = 1  # 闭包函数外的函数中
            def inner():
                i_count = 2  # 局部作用域
    ```
- 注意
    * Python 中只有模块（module）,类（class）以及函数（def、lambda）才会引入新的作用域,其它的代码块（如 if/elif/else/、try/except、for/while等）是不会引入新的作用域的,也就是说这些语句内定义的变量,外部也可以访问
    * eg
        ```python
            if True:
                msg = 'test'

            # 输出 test
            print(msg)

            def test():
                msg_inner = 'test1'

            # 会报错
            print(msg_inner)
        ```









