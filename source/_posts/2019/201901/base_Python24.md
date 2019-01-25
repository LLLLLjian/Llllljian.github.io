---
title: Python_基础 (24)
date: 2019-01-09
tags: Python
toc: true
---

### 列表生成式
    Python3学习笔记[创建list的生成式]

<!-- more -->

#### list1
    生成list[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
- eg
    ```python
        >>> list(range(1, 11))
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ```

#### list2
    生成[1x1, 2x2, 3x3, ..., 10x10]
- eg
    ```python
        >>> L = []
        >>> for x in range(1, 11):
        ...    L.append(x * x)
        ...
        >>> L
        [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

        >>> [x * x for x in range(1, 11)]
        [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
    ```

#### list3
    类似list2,仅偶数的平方
- eg
    ```python
        >>> [x * x for x in range(1, 11) if x % 2 == 0]
        [4, 16, 36, 64, 100]
    ```

#### list4
    使用两层循环,生成全排列
- eg
    ```python
        >>> [m + n for m in 'ABC' for n in 'XYZ']
        ['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']
    ```

#### 练习
    L1 = ['Hello', 'World', 18, 'Apple', None]
    转换为
    L2 == ['hello', 'world', 'apple']
- eg
    ```python
        # -*- coding: utf-8 -*-
        L1 = ['Hello', 'World', 18, 'Apple', None]
        L2 = [s.lower() for s in L1 if isinstance(s, str)]

        # 测试:
        print(L2)
        if L2 == ['hello', 'world', 'apple']:
            print('测试通过!')
        else:
            print('测试失败!')
    ```







