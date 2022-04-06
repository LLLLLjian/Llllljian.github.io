---
title: Python_基础 (139)
date: 2021-10-21
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 文件关闭可以用with 锁也可以用with with到底是个啥

#### 总结
> with表达式其实是try-finally的简写形式. 但是又不是全相同

#### 格式
- eg
    ```python
        """
        格式
        # context是一个表达式, 返回的是一个对象, var用来保存context表达式返回的对象, 可以有单个或者多个返回值
        with context [as var]:
            pass
        """
    ```

#### 原理
>with 语句实质是上下文管理. 
1. 上下文管理协议. 包含方法__enter__() 和 __exit__(), 支持该协议对象要实现这两个方法
2. 上下文管理器, 定义执行with语句时要建立的运行时上下文, 负责执行with语句块上下文中的进入与退出操作
3. 进入上下文的时候执行__enter__方法, 如果设置as var语句, var变量接受__enter__()方法返回值
4. 如果运行时发生了异常, 就退出上下文管理器. 调用管理器__exit__方法

#### 自定义类验证
- code
    ```python
        class Mycontex(object):
            def __init__(self,name):
                self.name=name
            def __enter__(self):
                print("进入enter")
                return self
            def do_self(self):
                print(self.name)
            def __exit__(self,exc_type,exc_value,traceback):
                print("退出exit")
                print(exc_type,exc_value)
        if __name__ == '__main__':
            with Mycontex('test') as mc:
                mc.do_self()

        # 运行结果
        进入enter
        test
        退出exit
        None None
    ```
- code1
    ```python
        class Mycontex(object):
            def __init__(self,name):
                self.name=name
            def __enter__(self):
                print("进入enter")
                return self
            def do_self(self):
                print(self.name)
                a
            def __exit__(self,exc_type,exc_value,traceback):
                print("退出exit")
                print(exc_type,exc_value)
        if __name__ == '__main__':
            with Mycontex('test') as mc:
                mc.do_self()

        # 运行结果
        进入enter
        test
        退出exit
        <class 'NameError'> name 'a' is not defined
        Traceback (most recent call last):
        File "test_with.py", line 15, in <module>
            mc.do_self()
        File "test_with.py", line 9, in do_self
            a
        NameError: name 'a' is not defined
    ```

#### 应用场景
1. 文件操作
2. 进程线程之间互斥对象
3. 支持上下文其他对象

