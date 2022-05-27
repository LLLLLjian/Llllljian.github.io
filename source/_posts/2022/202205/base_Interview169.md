---
title: Interview_总结 (169)
date: 2022-05-13
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 装饰器
> 装饰器可以做什么: 插入日志、性能测试、事务处理、缓存、权限校验等
由于函数也是一个对象,而且函数对象可以被赋值给变量,所以,通过变量也能调用该函数.

```python
    >>> def now():
    ...     print('2015-3-25')
    ...
    >>> f = now
    >>> f()
    2015-3-25
```

函数对象有一个__name__属性,可以拿到函数的名字

```python
    >>> now.__name__
    'now'
    >>> f.__name__
    'now'
```

现在,假设我们要增强now()函数的功能,比如,在函数调用前后自动打印日志,但又不希望修改now()函数的定义,这种在代码运行期间动态增加功能的方式,称之为“装饰器”(Decorator).

本质上,decorator就是一个返回函数的高阶函数.所以,我们要定义一个能打印日志的decorator,可以定义如下：

```python
    def log(func):
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper
```

观察上面的log,因为它是一个decorator,所以接受一个函数作为参数,并返回一个函数.我们要借助Python的@语法,把decorator置于函数的定义处：

```python
    @log
    def now():
        print('2015-3-25')
```

调用now()函数,不仅会运行now()函数本身,还会在运行now()函数前打印一行日志：

```python
    >>> now()
    call now():
    2015-3-25
```

把@log放到now()函数的定义处,相当于执行了语句：

```
    now = log(now)
```

由于log()是一个decorator,返回一个函数,所以,原来的now()函数仍然存在,只是现在同名的now变量指向了新的函数,于是调用now()将执行新函数,即在log()函数中返回的wrapper()函数.

wrapper()函数的参数定义是(*args, **kw),因此,wrapper()函数可以接受任意参数的调用.在wrapper()函数内,首先打印日志,再紧接着调用原始函数.

如果decorator本身需要传入参数,那就需要编写一个返回decorator的高阶函数,写出来会更复杂.比如,要自定义log的文本：

```python
    def log(text):
        def decorator(func):
            def wrapper(*args, **kw):
                print('%s %s():' % (text, func.__name__))
                return func(*args, **kw)
            return wrapper
        return decorator
```

这个3层嵌套的decorator用法如下

```python
    @log('execute')
    def now():
        print('2015-3-25')
```

执行结果如下：

```python
    >>> now()
    execute now():
    2015-3-25
```

和两层嵌套的decorator相比,3层嵌套的效果是这样的

```python
    >>> now = log('execute')(now)
```

- detail
    ```python
        def metric(fn):
            def wrapper(*args,**kwargs):
                start=time.time();
                res=fn(*args,**kwargs)
                stop=time.time()
                print('%s executed in %s ms' % (fn.__name__, stop-start))
                return res;
            return wrapper
        """
        f=fast(11,22).
        1. 首先执行metric(fast)得到一个wrapper对象.
        2. 此时可以看作：f=wrapper(11,22),此时就按照上面的代码wrapper部分执行.首先计算当前时间为start,然后执行res=fn(*args,**kwargs),因为fn为fast,所以这行代码具体化后即为：res=fast(11,22).
        3. 然后按照fast函数的定义执行可以算出res=33,然后执行stop=time.time()计算当前时间,然后执行printf()打印时间,最后返回res=33
        4. 返回值res赋值给f

        同理s=slow(11,22,33)
        1. 首先执行metric(slow)得到一个wrapper对象.
        2. 此时可以看作：s=wrapper(11,22,33),此时就按照上面的代码wrapper部分执行.首先计算当前时间为start,然后执行res=fn(*args,**kwargs),因为fn为slow,所以这行代码具体化后即为：res=slow(11,22,33).
        3. 然后按照fast函数的定义执行可以算出res=11*22*33,然后执行stop=time.time()计算当前时间,然后执行printf()打印时间,最后返回res=11*22*33
        4. 返回值res赋值给s.
        """
    ```
- 模版
    ```python
        def outter(func):
            def wrapper(*args, **kwargs):
                # 1、调用原函数
                # 2、为其增加新功能
                res = func(*args, **kwargs)  //这里就是调用原函数
                return res
            return wrapper
    ```

#### 可变参数和关键字参数
- *args

在Python函数中,还可以定义可变参数.顾名思义,可变参数就是传入的参数个数是可变的,可以是1个、2个到任意个,还可以是0个.

我们以数学题为例子,给定一组数字a,b,c……,请计算a2 + b2 + c2 + …….

要定义出这个函数,我们必须确定输入的参数.由于参数个数不确定,我们首先想到可以把a,b,c……作为一个list或tuple传进来,这样,函数可以定义如下：

```python
    def calc(numbers):
        sum = 0
        for n in numbers:
            sum = sum + n * n
        return sum
```

但是调用的时候,需要先组装出一个list或tuple：

```python
    >>> calc([1, 2, 3])
    14
    >>> calc((1, 3, 5, 7))
    84
```

如果利用可变参数,调用函数的方式可以简化成这样

```python
    def calc(*numbers):
        sum = 0
        for n in numbers:
            sum = sum + n * n
        return sum
    >>> calc(1, 2, 3)
    14
    >>> calc(1, 3, 5, 7)
    84
```

- **kw

可变参数允许你传入0个或任意个参数,这些可变参数在函数调用时自动组装为一个tuple.而关键字参数允许你传入0个或任意个含参数名的参数,这些关键字参数在函数内部自动组装为一个dict.请看示例：

```python
    def person(name, age, **kw):
        print('name:', name, 'age:', age, 'other:', kw)
    >>> person('Michael', 30)
    name: Michael age: 30 other: {}
    >>> person('Bob', 35, city='Beijing')
    name: Bob age: 35 other: {'city': 'Beijing'}
    >>> person('Adam', 45, gender='M', job='Engineer')
    name: Adam age: 45 other: {'gender': 'M', 'job': 'Engineer'}
```

#### 垃圾回收
- 引用计数
    * Python在内存中存储每个对象的引用计数,如果计数变成0,该对象就会消失,分配给该对象的内存就会释放出来
- 标记清除
    * 一些容器对象,比如list、dict、tuple,instance等可能会出现引用循环,对于这些循环,垃圾回收器会定时回收这些循环(对象之间通过引用(指针)连在一起,构成一个有向图,对象构成这个有向图的节点,而引用关系构成这个有向图的边)
- 分代清除
    * Python把内存根据对象存活时间划分为三代,对象创建之后,垃圾回收器会分配它们所属的代.每个对象都会被分配一个代,而被分配更年轻的代是被优先处理的,因此越晚创建的对象越容易被回收.
