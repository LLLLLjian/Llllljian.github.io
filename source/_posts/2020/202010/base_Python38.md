---
title: Python_基础 (38)
date: 2020-10-22
tags: Python
toc: true
---

### 重新开始学Python
    之前学都是业务的, 现在要用到工作中了！！！

<!-- more -->

#### Python3 错误和异常
> Python 有两种错误很容易辨认：语法错误和异常
- 语法错误
    * Python 的语法错误或者称之为解析错
    ```python
        >>> while True print('Hello world')
        File "<stdin>", line 1, in ?
            while True print('Hello world')
                        ^
        SyntaxError: invalid syntax
    ```
- 异常
    * 即便 Python 程序的语法是正确的, 在运行它的时候, 也有可能发生错误.运行期检测到的错误被称为异常
    ```python
        >>> 10 * (1/0)             # 0 不能作为除数, 触发异常
        Traceback (most recent call last):
        File "<stdin>", line 1, in ?
        ZeroDivisionError: division by zero
        >>> 4 + spam*3             # spam 未定义, 触发异常
        Traceback (most recent call last):
        File "<stdin>", line 1, in ?
        NameError: name 'spam' is not defined
        >>> '2' + 2               # int 不能与 str 相加, 触发异常
        Traceback (most recent call last):
        File "<stdin>", line 1, in <module>
        TypeError: can only concatenate str (not "int") to str
    ```
- 异常处理
    ![异常处理](/img/20201022_1.png)
    ```python
        # 异常处理顺序
        try:
            runoob()
        except AssertionError as error:
            print(error)
        else:
            try:
                with open('file.log') as file:
                    read_data = file.read()
            except FileNotFoundError as fnf_error:
                print(fnf_error)
        finally:
            print('这句话, 无论异常是否发生都会执行.')
    ```
> Python 使用 raise 语句抛出一个指定的异常

#### 实战
- 捕获多个异常
    ```python
        def model_exception(x,y):
        try:
            b = name
            a =x/y
        except(ZeroDivisionError,NameError,TypeError):
            print('one of ZeroDivisionError or NameError or TypeError happend')

        #调用函数结果
        model_exception(2,0)
        # 输出结果
        # one of ZeroDivisionError or NameError or TypeError happend
    ```
- 捕获所有异常
    ```python
        try:
            ...
        except Exception as e:
            ...
        log('Reason:', e)       # Important!
        # 这个将会捕获除了 SystemExit 、 KeyboardInterrupt 和 GeneratorExit 之外的所有异常. 如果你还想捕获这三个异常, 将 Exception 改成 BaseException 即可
    ```

#### Python3 内置异常类型的结构
BaseException
 +-- SystemExit
 +-- KeyboardInterrupt
 +-- GeneratorExit
 +-- Exception
      +-- StopIteration
      +-- StopAsyncIteration
      +-- ArithmeticError
      |    +-- FloatingPointError
      |    +-- OverflowError
      |    +-- ZeroDivisionError
      +-- AssertionError
      +-- AttributeError
      +-- BufferError
      +-- EOFError
      +-- ImportError
      |    +-- ModuleNotFoundError
      +-- LookupError
      |    +-- IndexError
      |    +-- KeyError
      +-- MemoryError
      +-- NameError
      |    +-- UnboundLocalError
      +-- OSError
      |    +-- BlockingIOError
      |    +-- ChildProcessError
      |    +-- ConnectionError
      |    |    +-- BrokenPipeError
      |    |    +-- ConnectionAbortedError
      |    |    +-- ConnectionRefusedError
      |    |    +-- ConnectionResetError
      |    +-- FileExistsError
      |    +-- FileNotFoundError
      |    +-- InterruptedError
      |    +-- IsADirectoryError
      |    +-- NotADirectoryError
      |    +-- PermissionError
      |    +-- ProcessLookupError
      |    +-- TimeoutError
      +-- ReferenceError
      +-- RuntimeError
      |    +-- NotImplementedError
      |    +-- RecursionError
      +-- SyntaxError
      |    +-- IndentationError
      |         +-- TabError
      +-- SystemError
      +-- TypeError
      +-- ValueError
      |    +-- UnicodeError
      |         +-- UnicodeDecodeError
      |         +-- UnicodeEncodeError
      |         +-- UnicodeTranslateError
      +-- Warning
           +-- DeprecationWarning
           +-- PendingDeprecationWarning
           +-- RuntimeWarning
           +-- SyntaxWarning
           +-- UserWarning
           +-- FutureWarning
           +-- ImportWarning
           +-- UnicodeWarning
           +-- BytesWarning
           +-- ResourceWarning
