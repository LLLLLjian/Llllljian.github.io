---
title: Python_基础 (23)
date: 2019-01-08
tags: Python
toc: true
---

### 迭代
    Python3学习笔记

<!-- more -->

#### 迭代
    通过for循环来遍历这个list或tuple

#### 判断是否可迭代
    通过collections模块的Iterable类型判断
- eg
    ```python
        >>> from collections import Iterable
        >>> isinstance('abc', Iterable) # str是否可迭代
        True
        >>> isinstance([1,2,3], Iterable) # list是否可迭代
        True
        >>> isinstance(123, Iterable) # 整数是否可迭代
        False
    ```

#### 迭代dict
- 迭代key
    * for key in dict:
- 迭代value
    * for value in d.values()
- 同时迭代二者
    * for k, v in d.items()

#### 练习
    请使用迭代查找一个list中最小和最大值,并返回一个tuple
- 测试
    ```python
        # 测试
        if findMinAndMax([]) != (None, None):
            print('测试失败!')
        elif findMinAndMax([7]) != (7, 7):
            print('测试失败!')
        elif findMinAndMax([7, 1]) != (1, 7):
            print('测试失败!')
        elif findMinAndMax([7, 1, 3, 9, 5]) != (1, 9):
            print('测试失败!')
        else:
            print('测试成功!')
    ```
- eg
    ```python
        def findMinAndMax(L):
            min = None
            max = None
            if (L):
                min = L[0]
                max = L[0]
                for i in L:
                    if(i < min):
                        min = i
                    if(i > max):
                        max = i
            return (min, max)


        # 测试
        if findMinAndMax([]) != (None, None):
            print('测试失败!')
        elif findMinAndMax([7]) != (7, 7):
            print('测试失败!')
        elif findMinAndMax([7, 1]) != (1, 7):
            print('测试失败!')
        elif findMinAndMax([7, 1, 3, 9, 5]) != (1, 9):
            print('测试失败!')
        else:
            print('测试成功!')
    ```
