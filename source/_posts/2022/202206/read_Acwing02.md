---
title: ACwing挑战 (02)
date: 2022-06-13
tags: ACwing
toc: true
---

### ACwing挑战
    AC saber训练模式-基础知识-归并排序

<!-- more -->

#### 归并排序
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

        def help_sort(nums, l, r):
            if l >= r:
                return
            mid = l + (r - l) // 2
            help_sort(nums, l, mid)
            help_sort(nums, mid+1, r)
            help_merge(nums, l, mid, r)

        def help_merge(nums, l, mid, r):
            if l >= r:
                return
            i, j = l, mid+1
            temp = []
            for _ in range(l, r+1):
                if i == mid+1:
                    temp.append(nums[j])
                    j += 1
                elif j == r+1:
                    temp.append(nums[i])
                    i += 1
                elif nums[i] > nums[j]:
                    temp.append(nums[j])
                    j += 1
                else:
                    temp.append(nums[i])
                    i += 1
            nums[l:r+1] = temp

        help_sort(nums, 0, length-1)
        for num in nums:
            print(num, end=" ")
    ```



#### 逆序对的数量
- 问题描述
    ```
        给定一个长度为 nn 的整数数列,请你计算数列中的逆序对的数量.

        逆序对的定义如下：对于数列的第 ii 个和第 jj 个元素,如果满足 i<ji<j 且 a[i]>a[j]a[i]>a[j],则其为一个逆序对；否则不是.

        输入格式

        第一行包含整数 nn,表示数列的长度.

        第二行包含 nn 个整数,表示整个数列.

        输出格式

        输出一个整数,表示逆序对的个数.

        数据范围

        1≤n≤1000001≤n≤100000,
        数列中的元素的取值范围 [1,109][1,109].
    ```
- 代码实现
    ```python
        length = int(input())
        nums = list(map(int, input().split()))

        def help_sort(l, r):
            if l >= r:
                return 0
            mid = l + (r - l) // 2
            left = help_sort(l, mid)
            right = help_sort(mid+1, r)
            merge = help_merge(l, mid, r)
            return left + right + merge

        def help_merge(l, mid, r):
            i, j = l, mid+1
            temp = []
            res = 0
            for _ in range(l, r+1):
                if i == mid+1:
                    temp.append(nums[j])
                    j += 1
                elif j == r+1:
                    temp.append(nums[i])
                    i += 1
                elif nums[i] > nums[j]:
                    temp.append(nums[j])
                    j += 1
                    res += mid - i + 1
                else:
                    temp.append(nums[i])
                    i += 1
            nums[l:r+1] = temp
            return res
        res = help_sort(0, length-1)
        print(res)
    ```

#### 超快速排序
- 问题描述
    ```
        在这个问题中,您必须分析特定的排序算法----超快速排序.
        该算法通过交换两个相邻的序列元素来处理 n 个不同整数的序列,直到序列按升序排序.
        对于输入序列 9 1 0 5 4,超快速排序生成输出 0 1 4 5 9.
        您的任务是确定超快速排序需要执行多少交换操作才能对给定的输入序列进行排序.
    ```
- 思路
    * 题目就是在模拟冒泡排序,而交换的次数,就是冒泡排序的交换次数就是我们的逆序对个数
- 代码实现
    ```python
        def mergesort(A):
            n = len(A)
            if n <= 1:
                return 0, A
            mid = n // 2
            cnt1, left = mergesort(A[:mid])
            cnt2, right = mergesort(A[mid:])
            i, j = 0, 0
            cnt = cnt1 + cnt2
            ans = []
            while i < len(left) and j < len(right):
                if left[i] < right[j]:
                    ans.append(left[i])
                    i += 1
                else:
                    ans.append(right[j])
                    j += 1
                    cnt += len(left) - i
            if i < len(left):
                ans.extend(left[i:])
            else:
                ans.extend(right[j:])
            return cnt, ans



        while True:
            n = int(input())
            if not n:
                break
            A = []
            for _ in range(n):
                A.append(int(input()))
            cnt, B = mergesort(A)
            print(cnt)
    ```

