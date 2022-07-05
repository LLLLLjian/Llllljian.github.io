---
title: ACwing挑战 (03)
date: 2022-06-15 12:00:00
tags: ACwing
toc: true
---

### ACwing挑战
    AC saber训练模式-基础知识-归并排序

<!-- more -->

#### 数的范围
- 问题描述
    ```
        给定一个按照升序排列的长度为 n 的整数数组，以及 q 个查询。

        对于每个查询，返回一个元素 k 的起始位置和终止位置（位置从 0 开始计数）。

        如果数组中不存在该元素，则返回 -1 。

        输入格式

        第一行包含整数 n 和 q，表示数组长度和询问个数。

        第二行包含 n 个整数（均在 1∼10000 范围内），表示完整数组。

        接下来 q 行，每行包含一个整数 kk，表示一个询问元素。

        输出格式

        共 q 行，每行包含两个整数，表示所求元素的起始位置和终止位置。

        如果数组中不存在该元素，则返回 -1。

        数据范围

        1≤n≤100000
        1≤q≤10000
        1≤k≤10000
    ```
- 代码实现
    ```python
        m, n = map(int, input().split())
        nums = list(map(int, input().split()))r
        res_list = []
        for _ in range(n):
            res_list.append(int(input()))

        def left_func(target):
            n = len(nums)-1
            left = 0
            right = n
            while(left<=right):
                mid = (left+right)//2
                if nums[mid] >= target:
                    right = mid-1
                if nums[mid] < target:
                    left = mid+1
            return left

        for res in res_list:
            a =  left_func(res)
            b = left_func(res+1)
            if  a == len(nums) or nums[a] != res:
                print(-1, -1)
            else:
                print(a, b-1)
    ```




