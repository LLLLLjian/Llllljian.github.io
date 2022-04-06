---
title: Python_基础 (128)
date: 2021-12-30
tags: Python
toc: true
---

### python列表
    列表我会的太基础了, 多看一点吧

<!-- more -->

#### 列表解析
>  根据已有列表, 高效创建新列表的方式.
   列表解析是Python迭代机制的一种应用, 它常用于实现创建新的列表, 因此用在[]中.

#### 语法
- code
    ```
        [expression for iter_val in iterable]
        [expression for iter_val in iterable if cond_expr]
    ```

#### 实例展示
1. 列出1~10所有数字的平方
    ```python
        L = []
        for i in range(1,11):
            L.append(i**2)
        print(L)
        # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

        L = [ i**2 for i in range(1,11)]
        print(L)
        # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
    ```
2. 列出1~10中大于等于4的数字的平方
    ```python
        L = []
        for i in range(1,11):
            if i >= 4:
                L.append(i**2)
        print(L)
        # [16, 25, 36, 49, 64, 81, 100]

        L = [ i**2 for i in range(1,11) if i >= 4 ]
        print(L)
        # [16, 25, 36, 49, 64, 81, 100]
    ```
3. 列出1~10所有数字的平方除以2的值
    ```python
        L = []
        for i in range(1,11):
            L.append(i**2/2)
        print(L)
        # [0, 2, 4, 8, 12, 18, 24, 32, 40, 50]

        L = [i**2/2 for i in range(1,11) ]
        print(L)
        # [0, 2, 4, 8, 12, 18, 24, 32, 40, 50]
    ```
4. 列出"/var/log"中所有已'.log'结尾的文件
    ```python
        import os
        file_list = []
        for file in os.listdir("/var/log"):
            if file.endswith('.log'):
                file_list.append(file)
        print(file_list)
        # ['spice-vdagent.log', 'anaconda.program.log']

        import os
        file_list = [ file for file in os.listdir("/var/log") if file.endswith('.log') ]
        print(file_list)
        # ['spice-vdagent.log', 'anaconda.program.log']
    ```
5. 实现两个列表中的元素逐一配对
    ```python
        L1 = ['x', 'y', 'z']
        L2 = [1, 2, 3]
        L3 = []
        for a in L1:
            for b in L2:
                L3.append((a, b))
        print(L3)
        # [('x', 1), ('x', 2), ('x', 3), ('y', 1), ('y', 2), ('y', 3), ('z', 1), ('z', 2), ('z', 3)]

        L1 = ['x', 'y', 'z']
        L2 = [1, 2, 3]
        L3 = [ (a, b) for a in L1 for b in L2 ]
        print(L3)
        # [('x', 1), ('x', 2), ('x', 3), ('y', 1), ('y', 2), ('y', 3), ('z', 1), ('z', 2), ('z', 3)]
    ```
6. 使用列表解析生成 9*9 乘法表
    ```python
        print('\n'.join([''.join(['%s*%s=%-2s '%(y,x,x*y)for y in range(1,x+1)])for x in range(1,10)]))
    ```












