---
title: ACwing挑战 (01)
date: 2022-06-12
tags: ACwing
toc: true
---

### ACwing挑战
    AC saber训练模式-基础知识-快速排序

<!-- more -->

#### A+B
- 问题描述
    ```
        输入两个整数,求这两个整数的和是多少.

        输入格式
        输入两个整数A,B,用空格隔开

        输出格式
        输出一个整数,表示这两个数的和

        数据范围
        0≤A,B≤108
    ```
- 代码实现
    ```python
        nums = list(map(int, input().split()))

        print(sum(nums))
    ```





#### 快速排序
- 问题描述
    ```
        给定你一个长度为 n 的整数数列.
        请你使用快速排序对这个数列按照从小到大进行排序.
        并将排好序的数列按顺序输出.
    ```
- 代码实现1
    ```python
        length = int(input())
        nums = list(map(int, input().split()))

        def quick_sort(l, r):
            # 当区间只有0-1个元素
            if l >= r:
                return
            # 确定基准点
            temp = nums[l + (r - l) // 2]
            # 确定两个指针 因为会先移动再判断 所以指针在边界外
            i, j = l-1, r+1
            while i < j:
                while True:
                    i += 1
                    # 直到nums[i]比基准点大才停止
                    if nums[i] >= temp:
                        break
                while True:
                    j -= 1
                    # 直到nums[j]比基准点小才停止
                    if nums[j] <= temp:
                        break
                # 如果符合i在左j在右才进行交换
                if i < j:
                    nums[i], nums[j] = nums[j], nums[i]
            # 往左分治
            quick_sort(l, j)
            # 往右分治
            quick_sort(j+1, r)
        
        quick_sort(0, length-1)
        for num in nums:
            print(num, end=" ")
    ```
- 代码实现2
    ```python
        length = int(input())
        nums = list(map(int, input().split()))

        def quick_sort(nums):
            if len(nums) <= 1:
                return nums
            else:
                temp = nums[len(nums) // 2]
                left = [x for x in nums if x < temp]
                mid = [x for x in nums if x == temp]
                right = [x for x in nums if x > temp]
                return quick_sort(left) + mid + quick_sort(right)
        
        nums = quick_sort(nums)
        for num in nums:
            print(num, end=" ")
    ```

#### 第k个数
- 问题描述
    ```
        给定一个长度为 n 的整数数列,以及一个整数 k ,请用快速选择算法求出数列从小到大排序后的第 k 个数.

        输入格式
        第一行包含两个整数 n  和 k .

        第二行包含 n  个整数(所有整数均在 1∼109 范围内),表示整数数列.

        输出格式
        输出一个整数,表示数列的第 k  小数.

        数据范围
        1 ≤ n ≤ 100000
        1 ≤ k ≤ n
    ```
- 代码实现
    ```python
        n, k = list(map(int, input().split()))
        nums = list(map(int, input().split()))

        def quick_sort(l, r):
            if l >= r:
                return
            temp = nums[len(nums) // 2]
            i, j = l-1, j+1
            while i < j:
                while True:
                    i += 1
                    if nums[i] >= temp:
                        break
                while True:
                    j -= 1
                    if nums[j] <= temp:
                        break
                if i < j:
                    nums[i], nums[j] = nums[j], nums[i]
            quick_sort(l, j)
            quick_sort(j+1, r)
        
        quick_sort(nums)
        print(nums[k-1])
    ```



