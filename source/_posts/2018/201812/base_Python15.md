---
title: Python_基础 (15)
date: 2018-12-26
tags: Python
toc: true
---

### Python3迭代器与生成器
    Python3学习笔记

<!-- more -->

#### 迭代器
    迭代器是一个可以记住遍历的位置的对象
    迭代器对象从集合的第一个元素开始访问,直到所有的元素被访问完结束.迭代器只能往前不会后退
    迭代器有两个基本的方法: iter() 和 next()
    字符串,列表或元组对象都可用于创建迭代器

#### demo1
    ```python
        #!/usr/bin/python3

        import sys 

        list=[1,2,3,4]
        it = iter(list)    # 创建迭代器对象
        
        while True:
            try:
                print (next(it))
            except StopIteration:
                print ("看什么看！遍历完了")
                sys.exit()
    ```

#### 生成器
    在 Python 中,使用了 yield 的函数被称为生成器
    跟普通函数不同的是,生成器是一个返回迭代器的函数,只能用于迭代操作

#### demo2
    ```python
        #!/usr/bin/python3
 
        import sys
        
        def fibonacci(n): # 生成器函数 - 斐波那契
            a, b, counter = 0, 1, 0
            while True:
                if (counter > n): 
                    return
                yield a
                a, b = b, a + b
                counter += 1
        f = fibonacci(10) # f 是一个迭代器,由生成器返回生成
        
        while True:
            try:
                print (next(f), end=" ")
            except StopIteration:
                sys.exit()
    ```

#### demo3
    ```python
        # 先生成f,然后再循环输出f
        # f如果很大的话就很消耗内存
        def fab(max): 
            n, a, b = 0, 0, 1 
            L = [] 
            while n < max: 
                L.append(b) 
                a, b = b, a + b 
                n = n + 1 
            return L

        f = iter(fab(1000))
        while True:
            try:
                print (next(f), end=" ")
            except StopIteration:
                sys.exit()
    ```








