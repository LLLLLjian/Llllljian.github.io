---
title: Python_基础 (17)
date: 2018-12-28
tags: Python
toc: true
---

### Python3模块
    Python3学习笔记

<!-- more -->

#### 模块简介
    模块是一个包含所有你定义的函数和变量的文件,其后缀名是.py.模块可以被别的程序引入,以使用该模块中的函数等功能
    自己对模块的理解:像是一个已经封装好的文件,文件中有许多可以直接使用的方法

#### import语句
- 语法
    ```python
        import module1[, module2[,... moduleN]
    ```
- 文件的路径
    ```python
        llllljian@llllljian-virtual-machine ~ 19:05:39 #42]$ python3.5
        Python 3.5.3 (default, Jan 19 2017, 14:11:04) 
        [GCC 6.3.0 20170118] on linux
        Type "help", "copyright", "credits" or "license" for more information.
        >>> import sys
        >>> sys.path
        ['', '/usr/lib/python35.zip', '/usr/lib/python3.5', '/usr/lib/python3.5/plat-i386-linux-gnu', '/usr/lib/python3.5/lib-dynload', '/usr/local/lib/python3.5/dist-packages', '/usr/lib/python3/dist-packages']
    ```
- 文件路径解析
    * 第一项是空串,代表当前目录
    * 其余的就是Python的搜索路径,Python解释器就依次从这些目录中去寻找所引入的模块
- eg
    ```bash
        [llllljian@llllljian-virtual-machine 20181228 19:43:19 #71]$ cat testModeule.py
        # 斐波那契(fibonacci)数列模块
        
        def fib(n):    # 定义到 n 的斐波那契数列
            a, b = 0, 1
            while b < n:
                print(b, end=' ')
                a, b = b, a+b
            print()
        [llllljian@llllljian-virtual-machine 20181228 19:43:49 #75]$ cat testModeule1.py
        import testModeule

        testModeule.fib(1000)

        print("------")

        print(testModeule.__name__)
        [llllljian@llllljian-virtual-machine 20181228 19:43:55 #76]$ python3.5 testModeule1.py
        1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 
        ------
        testModeule
    ```

#### from … import * 语句
    把一个模块的所有内容全都导入到当前的命名空间,需要注意的是这种方法不能被过多的使用,因为涉及到方法名重复的话,后引入的方法会覆盖之前的

#### __name__属性
    可以指明某程序块是否在自身运行时执行
- eg
    ```python
        #!/usr/bin/python3
        # Filename: using_name.py

        if __name__ == '__main__':
            print('程序自身在运行')
        else:
            print('我来自另一模块')

        #!/usr/bin/python3
        # Filename: importUsing_name.py
        import using_name
    ```
    ```bash
        python3.5 using_name.py
        程序自身在运行

        python3.5 importUsing_name.py
        我来自另一模块
    ```

#### 导入包的方式
- 方式1
    * import sound.effects.echo
    * 说明echo.py位于当前目录或系统环境目录下sound目录下effects目录中
    * 使用
        * sound.effects.echo.echofilter(input, output, delay=0.7, atten=4)
- 方式2
    * from sound.effects import echo
    * 位置同上
    * 使用
        * echo.echofilter(input, output, delay=0.7, atten=4)
- 方式3
    * from sound.effects.echo import echofilter
    * 位置同上
    * 使用
        * echofilter(input, output, delay=0.7, atten=4)

