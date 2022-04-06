---
title: Python_基础 (130)
date: 2021-09-27
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### *arg和**kwarg作用
```
    # 他们是一种动态传参, 一般不确定需要传入几个参数时, 可以使用其定义参数, 然后从中取参

    '*args': 按照位置传参, 将传入参数打包成一个‘元组’(打印参数为元组-- tuple)
    '**kwargs': 按照关键字传参, 将传入参数打包成一个‘字典’(打印参数为字典-- dict)
```

#### is和==的区别
```
    ==: 判断某些值是否一样, 比较的是值
    is: 比较的是内存地址(引用的内存地址不一样, 唯一标识: id)
```

#### 简述Python的深浅拷贝以及应用场景
```
    #浅拷贝: 
    不管多么复杂的数据结构, 只copy对象最外层本身, 该对象引用的其他对象不copy, 内存里两个变量的地址是一样的, 一个改变另一个也改变.
    #深拷贝: 
    完全复制原变量的所有数据, 内存中生成一套完全一样的内容；只是值一样, 内存地址不一样, 一方修改另一方不受影响
```

#### Python垃圾回收机制
```
    # Python垃圾回收机制
    Python垃圾回收机制,主要使用'引用计数'来跟踪和回收垃圾.
    在'引用计数'的基础上, 通过'标记-清除'(mark and sweep)解决容器对象可能产生的循环引用问题.
    通过'分代回收'以空间换时间的方法提高垃圾回收效率.

    '引用计数'
    PyObject是每个对象必有的内容, 其中ob_refcnt就是做为引用计数.
    当一个对象有新的引用时, 它的ob_refcnt就会增加, 当引用它的对象被删除, 
    它的ob_refcnt就会减少.引用计数为0时, 该对象生命就结束了.
        \优点:1.简单 2.实时性
        \缺点:1.维护引用计数消耗资源 2.循环引用

    '标记-清楚机制'
    基本思路是先按需分配, 等到没有空闲内存的时候从寄存器和程序栈上的引用出发, 
    遍历以对象为节点、以引用为边构成的图, 把所有可以访问到的对象打上标记, 
    然后清扫一遍内存空间, 把所有没标记的对象释放.

    '分代技术'
    分代回收的整体思想是: 
    将系统中的所有内存块根据其存活时间划分为不同的集合, 每个集合就成为一个“代”, 
    垃圾收集频率随着“代”的存活时间的增大而减小, 存活时间通常利用经过几次垃圾回收来度量.
```

#### 巧用内置函数
```
    # map:遍历序列, 为每一个序列进行操作, 返回一个结果列表
    l = [1, 2, 3, 4, 5, 6, 7]
    def pow2(x):
    return x * x
    res = map(pow2, l)
    print(list(res)) #[1, 4, 9, 16, 25, 36, 49]
    --------------------------------------------------------------
    # reduce: 对于序列里面的所有内容进行累计操作
    from functools import reduce
    def add(x, y):
    return x+y
    print(reduce(add, [1,2,3,4])) #10
    --------------------------------------------------------------
    # filter: 对序列里面的元素进行筛选, 最终获取符合条件的序列.
    l = [1, 2, 3, 4, 5]
    def is_odd(x):  # 求奇数
    return x % 2 == 1
    print(list(filter(is_odd, l))) #[1, 3, 5]
    --------------------------------------------------------------
    #zip用于将可迭代的对象作为参数, 将对象中对应的元素打包成一个个元组, 然后返回由这些元组组成的列表
    a = [1,2,3]
    b=[4,5,6]
    c=[4,5,6,7,8]
    ziped1 = zip(a,b)
    print('ziped1>>>',list(ziped1)) #[(1, 4), (2, 5), (3, 6)]
    ziped2 = zip(a,c)
    print('ziped2>>>',list(ziped2)) #[(1, 4), (2, 5), (3, 6)],以短的为基准
```

#### python单例模式
> 单例模式是一种常用的软件设计模式.在它的核心结构中只包含一个被称为单例类的特殊类.通过单例模式可以保证系统中一个类只有一个实例而且该实例易于外界访问, 从而方便对实例个数的控制并节约系统资源.
如果希望在系统中某个类的对象只能存在一个, 单例模式是最好的解决方案.
- func1
    ```python
        # 1、使用__new__方法
        class Singleton(object):
            def __new__(cls, *args, **kw):
                if not hasattr(cls, '_instance'):
                    orig = super(Singleton, cls)
                    cls._instance = orig.__new__(cls, *args, **kw)
                return cls._instance

        class MyClass(Singleton):
            pass
    ```
- func2
    ```python
        # 2、共享属性
        # 创建实例时把所有实例的__dict__指向同一个字典,这样它们具有相同的属性和方法.
        class Borg(object):
            _state = {}
            def __new__(cls, *args, **kw):
                ob = super(Borg, cls).__new__(cls, *args, **kw)
                ob.__dict__ = cls._state
                return ob

        class MyClass2(Borg):
            pass
    ```
- func3
    ```python
        # 3、装饰器版本
        def singleton(cls, *args, **kw):
            instances = {}
            def getinstance():
                if cls not in instances:
                    instances[cls] = cls(*args, **kw)
                return instances[cls]
            return getinstance

        @singleton
        class MyClass:
            pass
    ```
- func4
    ```python
        # 4、import方法
        # 作为python的模块是天然的单例模式
        # mysingleton.py
        class My_Singleton(object):
            def foo(self):
                pass
        my_singleton = My_Singleton()

        # to use
        from mysingleton import my_singleton
        my_singleton.foo()
    ```


