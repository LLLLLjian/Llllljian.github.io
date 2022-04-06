---
title: Python_基础 (114)
date: 2021-08-19
tags: Python
toc: true
---

### python中的*args和**kw
    最近在看装饰器, 然后就看到了python中的*args和**kw

<!-- more -->

#### 概念
在python中定义函数, 可以使用一般参数、默认参数、非关键字参数和关键字参数. 

一般参数和默认参数在前面的学习中我们都遇到过了, 而*args和**kw分别属于非关键字参数和关键字参数, 后两者也都是可变参数. 

非关键字参数的特征是一个星号*加上参数名, 比如*number, 定义后, number可以接收任意数量的参数, 并将它们储存在一个tuple中. 

关键字参数的特征是两个星号**加上参数名, 比如**kw, 定义后, kw将接收到的任意数量参数存到一个dict中. 关键字参数是在传递构成中不必按照顺序传递(因为dict内的key-value是没有顺序的), 但必须要提供”传递参数名=传递参数值”形式的参数. 

- demo1
    ```python
        def try_it(*args, **kw): 
            print 'args:',args 
            print 'kw:',kw

        try_it(1,2,3,4, a=1,b=2,c=3)
        try_it('a', 1, None, a=1, b='2', c=3)

        # 输出结果
        args: (1, 2, 3, 4) 
        kw: {'a': 1, 'c': 3, 'b': 2} 

        args: ('a', 1, None) 
        kw: {'a': 1, 'c': 3, 'b': '2'}

        # python中的一般参数、默认参数、非关键字参数和关键字参数可以一起使用, 或者只用其中某些, 但是请注意, 参数定义的顺序必须是: 一般参数、默认参数、可变参数和关键字参数, 先后顺序不能颠倒. 即: 
        def func(a, b, c=0, *args, **kw):
            pass
    ```
- demo2
    ```python
        def calculate_sum(*args):
            return sum(args)

        def ignore_first_calculate_sum(a,*iargs):
            required_sum = calculate_sum(*iargs)
            print ("sum is ", required_sum)

        ignore_first_calculate_sum(12, 1,4,5)
    ```



