---
title: Python_基础 (109)
date: 2021-08-11
tags: Python
toc: true
---

### 快来跟我一起学装饰器
    python之装饰器

<!-- more -->

#### 装饰器

由于函数也是一个对象, 而且函数对象可以被赋值给变量, 所以, 通过变量也能调用该函数. 

```python
    >>> def now():
    ...     print('2021-08-11')
    ...
    >>> f = now
    >>> f()
    2021-08-11
```

函数对象有一个__name__属性, 可以拿到函数的名字: 

```python
    >>> now.__name__
    'now'
    >>> f.__name__
    'now'
```

现在, 假设我们要增强now()函数的功能, 比如, 在函数调用前后自动打印日志, 但又不希望修改now()函数的定义, 这种在代码运行期间动态增加功能的方式, 称之为“装饰器”(Decorator). 

本质上, decorator就是一个返回函数的高阶函数. 所以, 我们要定义一个能打印日志的decorator, 可以定义如下: 

```python
    def log(func):
        def wrapper(*args, **kw):
            print('before call %s():' % func.__name__)
            return func(*args, **kw)
        return wrapper
```

观察上面的log, 因为它是一个decorator, 所以接受一个函数作为参数, 并返回一个函数. 我们要借助Python的@语法, 把decorator置于函数的定义处: 

```python
    @log
    def now():
        print('2021-08-11')
```

调用now()函数, 不仅会运行now()函数本身, 还会在运行now()函数前后打印日志: 

```python
    >>> now()
    before call now():
    2021-08-11
```

把@log放到now()函数的定义处, 相当于执行了语句: 

```python
    now = log(now)
```

由于log()是一个decorator, 返回一个函数, 所以, 原来的now()函数仍然存在, 只是现在同名的now变量指向了新的函数, 于是调用now()将执行新函数, 即在log()函数中返回的wrapper()函数. 

wrapper()函数的参数定义是(*args, **kw), 因此, wrapper()函数可以接受任意参数的调用. 在wrapper()函数内, 首先打印日志, 再紧接着调用原始函数. 

如果decorator本身需要传入参数, 那就需要编写一个返回decorator的高阶函数, 写出来会更复杂. 比如, 要自定义log的文本: 

```python
    def log(text):
        def decorator(func):
            def wrapper(*args, **kw):
                print('%s %s():' % (text, func.__name__))
                return func(*args, **kw)
            return wrapper
        return decorator

    >>> now()
    execute now():
    2021-08-11
```

和两层嵌套的decorator相比, 3层嵌套的效果是这样的: 

```python
    >>> now = log('execute')(now)
```

我们来剖析上面的语句, 首先执行log('execute'), 返回的是decorator函数, 再调用返回的函数, 参数是now函数, 返回值最终是wrapper函数. 

以上两种decorator的定义都没有问题, 但还差最后一步. 因为我们讲了函数也是对象, 它有__name__等属性, 但你去看经过decorator装饰之后的函数, 它们的__name__已经从原来的'now'变成了'wrapper': 

```python
    >>> now.__name__
    'wrapper'
```

因为返回的那个wrapper()函数名字就是'wrapper', 所以, 需要把原始函数的__name__等属性复制到wrapper()函数中, 否则, 有些依赖函数签名的代码执行就会出错. 

不需要编写wrapper.\__name__ = func.__name__这样的代码, Python内置的functools.wraps就是干这个事的, 所以, 一个完整的decorator的写法如下: 

```python
    import functools

    def log(func):
        @functools.wraps(func)
        def wrapper(*args, **kw):
            print('call %s():' % func.__name__)
            return func(*args, **kw)
        return wrapper
```


```python
    import functools

    def log(text):
        def decorator(func):
            @functools.wraps(func)
            def wrapper(*args, **kw):
                print('%s %s():' % (text, func.__name__))
                return func(*args, **kw)
            return wrapper
        return decorator

    >>> now.__name__
    'now'
```

- 作业1
    * 请设计一个decorator, 它可作用于任何函数上, 并打印该函数的执行时间: 
    * code
        ```python
            import time
            import functools
            def metric(func):
                @functools.wraps(func)
                def wrapper(*args, **kw):
                    sTime = int(time.time())
                    res = func(*args, **kw)
                    eTime = int(time.time())
                    print('%s executed in %s s' % (fn.__name__, eTime - sTime))
                    return res
                return wrapper

            # 测试
            @metric
            def fast(x, y):
                time.sleep(2)
                return x + y;

            @metric
            def slow(x, y, z):
                time.sleep(5)
                return x * y * z;

            f = fast(11, 22)
            s = slow(11, 22, 33)
            if f != 33:
                print('测试失败!')
            elif s != 7986:
                print('测试失败!')
        ```
- 作业2
    * 请编写一个decorator, 能在函数调用的前后打印出'begin call'和'end call'的日志, 同时支持@log和@log("execute")
    * code
        ```python
            import functools
            from collections.abc import Iterable

            def log(*arg):
                # 如果arg不为空
                if arg != ():
                    # 如果arg[0]存在并且是一个数组或字符串或列表
                    if isinstance(arg[0],Iterable):
                        def decorator(func):
                            @functools.wraps(func)
                            def wrapper(*args, **kw):
                                # 参照方法f()
                                print('begin %s %s():' % (arg[0], func.__name__))
                                func(*args, **kw)
                                print('end')
                                return
                            return wrapper
                        return decorator
                    else:
                        # arg[0]就是方法名
                        func = arg[0]
                        @functools.wraps(func)
                        def wrapper(*args, **kw):
                            # 参照f1()
                            print('begin %s():' % (func.__name__))
                            func(*args, **kw)
                            print('end')
                            return
                        return wrapper
                else:
                    def decorator(func):
                        @functools.wraps(func)
                        def wrapper(*args, **kw):
                            # 参照f2()
                            print('begin %s():' % (func.__name__))
                            func(*args, **kw)
                            print('end')
                            return
                        return wrapper
                    return decorator

            @log("execute")
            def f():    
                print('execute')

            @log()
            def f1():    
                print('execute1')

            @log
            def f2():    
                print('execute2')

            >>> f()
            begin execute f():
            execute
            end
            >>> f1()
            begin f1():
            execute1
            end
            >>> f2()
            begin f2():
            execute2
            end
        ```


