---
title: Interview_总结 (168)
date: 2022-05-12
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 对角线翻转
- 问题描述
    * 给一个二维数组, 对角线翻转它
- 思路
    * 列一个二维数组, 找一下规律, 就是交换matrix[i][j]中的i, j
- 代码实现
    ```python
        def solution(matrix):
            # 如果matrix不存在
            if not matrix:
                return []
            # 获取行和列
            m, n = len(matrix[0]), len(matrix)
            # res要生成一个 n*m个0的list
            # res = [[0] * n for _ in range(m)]
            # 0,1 => 1,0
            # 0,2 => 2,0
            # 1,2 => 2,1
            for i in range(m):
                for j in range(n):
                    res[i][j] = matrix[j][i]
            return res
            """
            # 如果m=n, 直接原地翻转
            for i in range(n):
                for j in range(i):
                    matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
            return matrix
            """
    ```

#### 查找给定因子数量最小
- 问题描述
    ```
        12是第一个有六个因子的数,它们分别是：1、2、3、4、6和12.请实现一个函数solution(numDiv),返回拥有指定数量因子的最小的数字.
        solution()会接收一个指定数量因子个数的数字,并返回满足这一要求的最小的数字.
        注: numDiv < 80
        solution(10) = 48 # 因子分别是: 1, 2, 3, 4, 6, 8, 12, 16, 24 和 48
        solution(12) = 60 # 因子分别是: 1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30, 60
    ```
- 思路
    * 暴力, 从0开始分别求他的因子集合, 如果因子集合数量等于要求的值, 那它就是最小的
- 代码实现
    ```python
        def solution(num_div):
            if not num_div:
                return None
            if num_div == 1:
                return None
            while True:
                for i in range(2, 100000):
                    if len(func1(i)) == num_div:
                        return i
                return None


        def func1(num):
            res = []
            for i in range(1, num+1):
                if num % i == 0:
                    res.append(i)
            return res


        print(solution(6))
        print(solution(8))
        print(solution(10))
        print(solution(11))
        print(solution(12))
    ```

#### lambda

当我们在传入函数时,有些时候,不需要显式地定义函数,直接传入匿名函数更方便.

在Python中,对匿名函数提供了有限支持.还是以map()函数为例,计算f(x)=x2时,除了定义一个f(x)的函数外,还可以直接传入匿名函数：

```python
    >>> list(map(lambda x: x * x, [1, 2, 3, 4, 5, 6, 7, 8, 9]))
    [1, 4, 9, 16, 25, 36, 49, 64, 81]
```

通过对比可以看出,匿名函数lambda x: x * x实际上就是：

```python
    def f(x):
        return x * x
```

关键字lambda表示匿名函数,冒号前面的x表示函数参数.

匿名函数有个限制,就是只能有一个表达式,不用写return,返回值就是该表达式的结果.

用匿名函数有个好处,因为函数没有名字,不必担心函数名冲突.此外,匿名函数也是一个函数对象,也可以把匿名函数赋值给一个变量,再利用变量来调用该函数：

```python
    >>> f = lambda x: x * x
    >>> f
    <function <lambda> at 0x101c6ef28>
    >>> f(5)
    25
```

同样,也可以把匿名函数作为返回值返回,比如：

```python
    def build(x, y):
        return lambda: x * x + y * y
```

#### map

map()函数接收两个参数,一个是函数,一个是Iterable,map将传入的函数依次作用到序列的每个元素,并把结果作为新的Iterator返回.

举例说明,比如我们有一个函数f(x)=x2,要把这个函数作用在一个list [1, 2, 3, 4, 5, 6, 7, 8, 9]上,就可以用map()实现如下：

![map函数](/img/20220512_1.png)

```python
    >>> def f(x):
    ...     return x * x
    ...
    >>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    >>> list(r)
    [1, 4, 9, 16, 25, 36, 49, 64, 81]
```

map()传入的第一个参数是f,即函数对象本身.由于结果r是一个Iterator,Iterator是惰性序列,因此通过list()函数让它把整个序列都计算出来并返回一个list.

你可能会想,不需要map()函数,写一个循环,也可以计算出结果：

```python
    L = []
    for n in [1, 2, 3, 4, 5, 6, 7, 8, 9]:
        L.append(f(n))
    print(L)
```

的确可以,但是,从上面的循环代码,能一眼看明白“把f(x)作用在list的每一个元素并把结果生成一个新的list”吗？

所以,map()作为高阶函数,事实上它把运算规则抽象了,因此,我们不但可以计算简单的f(x)=x2,还可以计算任意复杂的函数,比如,把这个list所有数字转为字符串：

```python
    >>> list(map(str, [1, 2, 3, 4, 5, 6, 7, 8, 9]))
    ['1', '2', '3', '4', '5', '6', '7', '8', '9']
```

只需要一行代码.

#### reduce

reduce把一个函数作用在一个序列[x1, x2, x3, ...]上,这个函数必须接收两个参数,reduce把结果继续和序列的下一个元素做累积计算,其效果就是：

```
    reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)
```

比方说对一个序列求和,就可以用reduce实现：

```python
    >>> from functools import reduce
    >>> def add(x, y):
    ...     return x + y
    ...
    >>> reduce(add, [1, 3, 5, 7, 9])
    25
    >>> sum([1, 3, 5, 7, 9])
    25
```

但是如果要把序列[1, 3, 5, 7, 9]变换成整数13579,reduce就可以派上用场：

```python
    >>> from functools import reduce
    >>> def fn(x, y):
    ...     return x * 10 + y
    ...
    >>> reduce(fn, [1, 3, 5, 7, 9]) # (((1*10+3)*10+5)*10+7)*10+9
    13579
```

这个例子本身没多大用处,但是,如果考虑到字符串str也是一个序列,对上面的例子稍加改动,配合map(),我们就可以写出把str转换为int的函数

```python
    >>> from functools import reduce
    >>> def fn(x, y):
    ...     return x * 10 + y
    ...
    >>> def char2num(s):
    ...     digits = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}
    ...     return digits[s]
    ...
    >>> reduce(fn, map(char2num, '13579'))
    13579
```

整理成一个str2int的函数就是

```python
    from functools import reduce

    DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}

    def str2int(s):
        def fn(x, y):
            return x * 10 + y
        def char2num(s):
            return DIGITS[s]
        return reduce(fn, map(char2num, s))
```

还可以用lambda函数进一步简化成

```python
    from functools import reduce

    DIGITS = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9}

    def char2num(s):
        return DIGITS[s]

    def str2int(s):
        return reduce(lambda x, y: x * 10 + y, map(char2num, s))
```

