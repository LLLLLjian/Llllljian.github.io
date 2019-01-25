---
title: Python_基础 (20)
date: 2019-01-03
tags: Python
toc: true
---

### Python3错误和异常
    Python3学习笔记

<!-- more -->

#### 语法错误
    Python的语法错误或者称之为解析错
    语法分析器指出了出错的一行，并且在最先找到的错误的位置标记了一个小小的箭头

#### 异常
    即便Python程序的语法是正确的，在运行它的时候，也有可能发生错误。运行期检测到的错误被称为异常
    大多数的异常都不会被程序处理，都以错误信息的形式展现

#### 异常处理
    try: except语句
- 运行步骤
    * 执行try子句(在关键字try和关键字except之间的语句)
    * 如果没有异常发生，忽略except子句，try子句执行后结束
    * 如果在执行try子句的过程中发生了异常，那么try子句余下的部分将被忽略。如果异常的类型和 except 之后的名称相符，那么对应的except子句将被执行。最后执行 try 语句之后的代码
    * 如果一个异常没有与任何的except匹配，那么这个异常将会传递给上层的try中
- 需要注意的点
    * 一个 try 语句可能包含多个except子句，分别来处理不同的特定的异常。最多只有一个分支会被执行
    * 处理程序将只针对对应的try子句中的异常进行处理，而不是其他的 try 的处理程序中的异常。
    * 一个except子句可以同时处理多个异常，这些异常将被放在一个括号里成为一个元组

#### 用户自定义异常
- eg
    ```python
        class MyError(Exception):
            def __init__(self, value):
                self.value = value
            def __str__(self):
                return repr(self.value)
        
        try:
            raise MyError(2*2)
        except MyError as e:
            print('My exception occurred, value:', e.value)
    ```

#### 定义清理行为
- eg
    ```python
        >>>def divide(x, y):
        try:
            result = x / y
        except ZeroDivisionError:
            print("division by zero!")
        else:
            print("result is", result)
        finally:
            print("executing finally clause")
   
        >>> divide(2, 1)
        result is 2.0
        executing finally clause
        >>> divide(2, 0)
        division by zero!
        executing finally clause
        >>> divide("2", "1")
        executing finally clause
        Traceback (most recent call last):
        File "<stdin>", line 1, in ?
        File "<stdin>", line 3, in divide
        TypeError: unsupported operand type(s) for /: 'str' and 'str'
    ```



