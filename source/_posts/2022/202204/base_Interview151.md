---
title: Interview_总结 (151)
date: 2022-04-13
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    python

<!-- more -->

#### Python生成器

通过列表生成式,我们可以直接创建一个列表.但是,受到内存限制,列表容量肯定是有限的.而且,创建一个包含100万个元素的列表,不仅占用很大的存储空间,如果我们仅仅需要访问前面几个元素,那后面绝大多数元素占用的空间都白白浪费了.

所以,如果列表元素可以按照某种算法推算出来,那我们是否可以在循环的过程中不断推算出后续的元素呢？这样就不必创建完整的list,从而节省大量的空间.在Python中,这种一边循环一边计算的机制,称为生成器：generator.

要创建一个generator,有很多种方法.第一种方法很简单,只要把一个列表生成式的[]改成(),就创建了一个generator

- eg
    ```python
        >>> L = [x * x for x in range(10)]
        >>> L
        [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
        >>> g = (x * x for x in range(10))
        >>> g
        <generator object <genexpr> at 0x1022ef630>
        >>> g = (x * x for x in range(10))
        >>> for n in g:
        ...     print(n)
        ... 
        0
        1
        4
        9
        16
        25
        36
        49
        64
        81
    ```

创建L和g的区别仅在于最外层的[]和(),L是一个list,而g是一个generator.

第二种创建generator的方法
- 传统斐波那契数列
    ```python
        def fib(max):
            n, a, b = 0, 0, 1
            while n < max:
                print(b)
                """
                a, b = b, a + b
                相当于：
                t = (b, a + b) # t是一个tuple
                a = t[0]
                b = t[1]
                """
                a, b = b, a + b
                n = n + 1
            return 'done'
        >>> fib(6)
        1
        1
        2
        3
        5
        8
        'done'
    ```
- generator斐波那契数列
    ```python
        def fib(max):
            n, a, b = 0, 0, 1
            while n < max:
                yield b
                a, b = b, a + b
                n = n + 1
            return 'done'
        >>> for n in fib(6):
        ...     print(n)
        ...
        1
        1
        2
        3
        5
        8
    ```
- 示例
    * generator函数和普通函数的执行流程不一样.普通函数是顺序执行,遇到return语句或者最后一行函数语句就返回.而变成generator的函数,在每次调用next()的时候执行,遇到yield语句返回,再次执行时从上次返回的yield语句处继续执行
    ```python
        def odd():
            print('step 1')
            yield 1
            print('step 2')
            yield(3)
            print('step 3')
            yield(5)
        >>> o = odd()
        >>> next(o)
        step 1
        1
        >>> next(o)
        step 2
        3
        >>> next(o)
        step 3
        5
        >>> next(o)
        Traceback (most recent call last):
        File "<stdin>", line 1, in <module>
        StopIteration
    ```


#### Python迭代器

我们已经知道,可以直接作用于for循环的数据类型有以下几种：

一类是集合数据类型,如list、tuple、dict、set、str等；

一类是generator,包括生成器和带yield的generator function.

这些可以直接作用于for循环的对象统称为可迭代对象：Iterable.

可以使用isinstance()判断一个对象是否是Iterable对象：

- code
    ```python
        >>> from collections.abc import Iterable
        >>> isinstance([], Iterable)
        True
        >>> isinstance({}, Iterable)
        True
        >>> isinstance('abc', Iterable)
        True
        >>> isinstance((x for x in range(10)), Iterable)
        True
        >>> isinstance(100, Iterable)
        False
    ```

而生成器不但可以作用于for循环,还可以被next()函数不断调用并返回下一个值,直到最后抛出StopIteration错误表示无法继续返回下一个值了.

可以被next()函数调用并不断返回下一个值的对象称为迭代器：Iterator.

可以使用isinstance()判断一个对象是否是Iterator对象：

- code
    ```python
        >>> from collections.abc import Iterator
        >>> isinstance((x for x in range(10)), Iterator)
        True
        >>> isinstance([], Iterator)
        False
        >>> isinstance({}, Iterator)
        False
        >>> isinstance('abc', Iterator)
        False
    ```

生成器都是Iterator对象,但list、dict、str虽然是Iterable,却不是Iterator.

把list、dict、str等Iterable变成Iterator可以使用iter()函数：

- code
    ```python
        >>> isinstance(iter([]), Iterator)
        True
        >>> isinstance(iter('abc'), Iterator)
        True
    ```

- 小结
    * 凡是可作用于for循环的对象都是Iterable类型；
    * 凡是可作用于next()函数的对象都是Iterator类型,它们表示一个惰性计算的序列；
    * 集合数据类型如list、dict、str等是Iterable但不是Iterator,不过可以通过iter()函数获得一个Iterator对象.
    * Python的for循环本质上就是通过不断调用next()函数实现的
        ```python
            for x in [1, 2, 3, 4, 5]:
                pass

            # 完全等价于

            # 首先获得Iterator对象:
            it = iter([1, 2, 3, 4, 5])
            # 循环:
            while True:
                try:
                    # 获得下一个值:
                    x = next(it)
                except StopIteration:
                    # 遇到StopIteration就退出循环
                    break
        ```

#### Python 中使用多线程可以达到多核CPU一起使用吗？

Python中有一个被称为Global Interpreter Lock(GIL)的东西,它会确保任何时候你的多个线程中,只有一个被执行.线程的执行速度非常之快,会让你误以为线程是并行执行的,但是实际上都是轮流执行.经过GIL这一道关卡处理,会增加执行的开销.

可以通过多进程实现多核任务.

#### GIL(Global Interpreter Lock)
> 全局解释器锁

全局解释器锁(Global Interpreter Lock)是计算机程序设计语言解释器用于同步线程的一种机制,它使得任何时刻仅有一个线程在执行.即便在多核处理器上,使用 GIL 的解释器也只允许同一时间执行一个线程,常见的使用 GIL 的解释器有CPython与Ruby MRI.可以看到GIL并不是Python独有的特性,是解释型语言处理多线程问题的一种机制而非语言特性.

#### GIL的设计初衷

单核时代高效利用CPU, 针对解释器级别的数据安全(不是thread-safe 线程安全). 首先需要明确的是GIL并不是Python的特性,它是在实现Python解析器(CPython)时所引入的一个概念.当Python虚拟机的线程想要调用C的原生线程需要知道线程的上下文,因为没有办法控制C的原生线程的执行,所以只能把上下文关系传给原生线程,同理获取结果也是线 程在python虚拟机这边等待.那么要执行一次计算操作,就必须让执行程序的线程组串行执行.

#### 为什么要加在解释器,而不是在其他层

GIL锁加在解释器一层,也就是说Python调用的Cython解释器上加了GIL锁,因为你python调用的所有线程都是原生线程.原生线程是通过C语言提供原生接口,相当于C语言的一个函数.你一调它,你就控制不了了它了,就必须等它给你返回结果.只要已通过python虚拟机 ,再往下就不受python控制了,就是C语言自己控制了.加在Python虚拟机以下加不上去,只能加在Python解释器这一层.

#### 什么是深拷贝和浅拷贝

赋值(=),就是创建了对象的一个新的引用,修改其中任意一个变量都会影响到另一个.

浅拷贝 copy.copy：创建一个新的对象,但它包含的是对原始对象中包含项的引用(如果用引用的方式修改其中一个对象,另外一个也会修改改变)

深拷贝：创建一个新的对象,并且递归的复制它所包含的对象(修改其中一个,另外一个不会改变){copy模块的deep.deepcopy()函数}

#### 什么是 lambda 表达式

简单来说,lambda表达式通常是当你需要使用一个函数,但是又不想费脑袋去命名一个函数的时候使用,也就是通常所说的匿名函数.

lambda表达式一般的形式是：关键词lambda后面紧接一个或多个参数,紧接一个冒号“：”,紧接一个表达式

#### 双等于和 is 有什么区别

==比较的是两个变量的 value,只要值相等就会返回True

is比较的是两个变量的 id,即id(a) == id(b),只有两个变量指向同一个对象的时候,才会返回True



