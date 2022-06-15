---
title: 读书笔记 (47)
date: 2022-05-31
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-归并排序及应用

<!-- more -->

#### 归并排序模板
- 代码实现
    ```python
        def sort(nums):
            return help_sort(nums, 0, len(nums) - 1)
        
        def help_sort(nums, left, right):
            """
            定义：将子数组 nums[lo..hi] 进行排序
            """
            if left == right:
                # 单个元素不用排序
                return
            # 防止溢出
            mid = left + (right - left) // 2
            # 先对左半部分数组 nums[lo..mid] 排序
            help_sort(nums, left, mid)
            # 再对右半部分数组 nums[mid+1..hi] 排序
            help_sort(nums, mid+1, right)
            # 将两部分有序数组合并成一个有序数组
            return help_merge(nums, left, mid, right)
        
        def help_merge(nums, l, mid, r):
            """
            将 nums[lo..mid] 和 nums[mid+1..hi] 这两个有序数组合并成一个有序数组
            """
            # 数组双指针技巧,合并两个有序数组
            i, j = l, mid + 1
            tmp = []
            while i <= mid or j <= r:
                if i > mid or (j <= r and nums[j] < nums[i]):
                    tmp.append(nums[j])
                    j += 1
                else:
                    tmp.append(nums[i])
                    i += 1
            nums[l: r + 1] = tmp
            return nums
    ```












#### 排序数组
- 问题描述
    * 给你一个整数数组 nums,请你将该数组升序排列
- 思路
    * 直接归并排序就可以了
- 代码实现
    ```python
        class Solution:
            def sortArray(self, nums: List[int]) -> List[int]:
                def help_sort(nums, left, right):
                    if left == right:
                        return nums
                    mid = left + (right - left) //2
                    help_sort(nums, left, mid)
                    help_sort(nums, mid+1, right)
                    return help_merge(nums, left, mid, right)
                def help_merge(nums, l, mid, r):
                    i, j = l, mid + 1
                    tmp = []
                    while i <= mid or j <= r:
                        if i > mid or (j <= r and nums[j] < nums[i]):
                            tmp.append(nums[j])
                            j += 1
                        else:
                            tmp.append(nums[i])
                            i += 1
                    nums[l: r + 1] = tmp
                    return nums
                return help_sort(nums, 0, len(nums)-1)
    ```











#### 数组中的逆序对
- 问题描述
    * 在数组中的两个数字,如果前面一个数字大于后面的数字,则这两个数字组成一个逆序对.输入一个数组,求出这个数组中的逆序对的总数.
- 思路
    * 归并排序
    * 方法1: 数出每一个数前边有几个数比它大
    ![方法1](/img/20220531_2.png)
    * 方法2: 数出每一个数后边有几个数比它小
    ![方法2](/img/20220531_1.png)
- 代码实现
    ```python
        class Solution:
            def reversePairs(self, nums: List[int]) -> int:
                """
                方法1: 数出每一个数前边有几个数比它大
                """
                length = len(nums)
                if length < 2:
                    return 0
                def help_sort(nums, left, right):
                    if left == right:
                        # 只剩下一个元素
                        return 0
                    mid = left + (right - left) // 2
                    # 左逆序对
                    leftPairs = help_sort(nums, left, mid)
                    # 右逆序对
                    rightPairs = help_sort(nums, mid+1, right)
                    # 如果 左数组的最后一个元素 小于 右数组的第一个元素,就不用合并了
                    if nums[mid] <= nums[mid+1]:
                        return leftPairs + rightPairs
                    # 跨越左右逆序对
                    crossPairs = help_merge(nums, left, mid, right)
                    return leftPairs + rightPairs + crossPairs
                def help_merge(nums, left, mid, right):
                    temp = []
                    i, j = left, mid+1
                    count = 0
                    for k in range(left, right+1):
                        if i == mid + 1:
                            temp.append(nums[j])
                            j += 1
                        elif j == right + 1:
                            temp.append(nums[i])
                            i += 1
                        elif nums[i] <= nums[j]:
                            temp.append(nums[i])
                            i += 1
                        else:
                            temp.append(nums[j])
                            j += 1
                            count += (mid - i + 1)
                    nums[left:right+1] = temp
                    return count
                return help_sort(nums, 0, length-1)
            def reversePairs(self, nums: List[int]) -> int:
                """
                方法2: 数出每一个数后边有几个数比它小
                """
                length = len(nums)
                if length < 2:
                    return 0
                def help_sort(nums, left, right):
                    if left == right:
                        # 只剩下一个元素
                        return 0
                    mid = left + (right - left) // 2
                    # 左逆序对
                    leftPairs = help_sort(nums, left, mid)
                    # 右逆序对
                    rightPairs = help_sort(nums, mid+1, right)
                    # 如果 左数组的最后一个元素 小于 右数组的第一个元素,就不用合并了
                    if nums[mid] <= nums[mid+1]:
                        return leftPairs + rightPairs
                    # 跨越左右逆序对
                    crossPairs = help_merge(nums, left, mid, right)
                    return leftPairs + rightPairs + crossPairs
                def help_merge(nums, left, mid, right):
                    temp = []
                    i, j = left, mid+1
                    count = 0
                    for k in range(left, right+1):
                        if i == mid + 1:
                            temp.append(nums[j])
                            j += 1
                        elif j == right + 1:
                            temp.append(nums[i])
                            i += 1
                            # count += (j - mid -1)
                            # j == right + 1
                            # count += right - mid
                            count += (right - mid)
                        elif nums[i] <= nums[j]:
                            temp.append(nums[i])
                            i += 1
                            # (j-1) - (mid+1) + 1 = j - mid - 1
                            count += (j - mid -1)
                        else:
                            temp.append(nums[j])
                            j += 1
                    nums[left:right+1] = temp
                    return count
                return help_sort(nums, 0, length-1)
    ```



#### 计算右侧小于当前元素的个数
- 问题描述
    * 你一个整数数组 nums ,按要求返回一个新数组 counts .数组 counts 有该性质： counts[i] 的值是  nums[i] 右侧小于 nums[i] 的元素的数量.
- 思路
    * 比之前多了一步 索引数组的操作,因为我们要判断k在索引数组中的位置
- 代码实现
    ```python
        class Solution:
            def countSmaller(self, nums: List[int]) -> List[int]:
                # 归并排序
                length = len(nums)
                if length == 0:
                    return []
                if length == 1:
                    return [0]
                # 结果数组
                res = [0] * length
                temp = [None for _ in range(length)]
                # 索引数组
                index_list = [i for i in range(length)]

                def help_sort(nums, left, right):
                    if left == right:
                        return 0
                    mid = left + (right - left) // 2
                    # 左
                    help_sort(nums, left, mid)
                    # 右
                    help_sort(nums, mid+1, right)
                    # 如果左边最后一个数小于等于后边第一个数 就直接返回了
                    if nums[index_list[mid]] <= nums[index_list[mid + 1]]:
                        return
                    # 左和右
                    return help_merge(nums, left, mid, right)
                def help_merge(nums, left, mid, right):
                    # 先拷贝,再合并
                    for i in range(left, right + 1):
                        temp[i] = index_list[i]
                    i = left
                    j = mid + 1
                    for k in range(left, right + 1):
                        if i > mid:
                            index_list[k] = temp[j]
                            j += 1
                        elif j > right:
                            index_list[k] = temp[i]
                            i += 1
                            res[index_list[k]] += (right - mid)
                        elif nums[temp[i]] <= nums[temp[j]]:
                            index_list[k] = temp[i]
                            i += 1
                            res[index_list[k]] += (j - mid - 1)
                        else:
                            index_list[k] = temp[j]
                            j += 1
                help_sort(nums, 0, length-1)
                return res
    ```

#### 翻转对
- 问题描述
    * 给定一个数组 nums ,如果 i < j 且 nums[i] > 2*nums[j] 我们就将 (i, j) 称作一个重要翻转对.你需要返回给定数组中的重要翻转对的数量.
- 思路
    * 先计数再归并
    * 方法1: 如果左边数组中的某一个比右边数组中的2倍还大的话 那么从它到mid都会比右边数组中的这个值大
    ![方法1](/img/20220531_2.png)
    * 方法2: 如果右边数组中的某个数的两倍比左边某个数还小的话, 那右边这个数往前直到mid部分, 两倍也都比左边这个数小
    ![方法2](/img/20220531_1.png)
- 代码思路
    ```python
        class Solution:
            def reversePairs(self, nums: List[int]) -> int:
                """
                方法1
                """
                # 长度
                length = len(nums)
                temp = [0 for _ in range(length)]
                if length == 1:
                    return 0
                def help_sort(nums, left, right):
                    if left == right:
                        return 0
                    mid = left + (right - left) // 2
                    # 左边的翻转对
                    leftLength = help_sort(nums, left, mid)
                    # 右边的翻转对
                    rightLength = help_sort(nums, mid+1, right)
                    # 左+右的翻转对
                    corssLength = help_merge(nums, left, mid, right)
                    return leftLength + rightLength + corssLength
                def help_merge(nums, left, mid, right):
                    count = 0
                    for i in range(left, right+1):
                        temp[i] = nums[i]
                    # 先计数
                    i, j = left, mid+1
                    while (i <= mid) and (j <= right):
                        if temp[i] > 2*temp[j]:
                            j += 1
                            # 如果左边数组中的某一个比右边数组中的2倍还大的话 那么从它到mid都会比右边数组中的这个值大
                            count += mid - i + 1
                        else:
                            i += 1
                    # 再合并
                    i, j = left, mid+1
                    for k in range(left, right+1):
                        if i == mid+1:
                            nums[k] = temp[j]
                            j += 1
                        elif j == right + 1:
                            nums[k] = temp[i]
                            i += 1
                        elif temp[i] <= temp[j]:
                            nums[k] = temp[i]
                            i += 1
                        else:
                            nums[k] = temp[j]
                            j += 1
                    return count
                return help_sort(nums, 0, length-1)
        class Solution:
            def reversePairs(self, nums: List[int]) -> int:
                """
                方法2
                """
                # 长度
                length = len(nums)
                temp = [0 for _ in range(length)]
                if length == 1:
                    return 0
                def help_sort(nums, left, right):
                    if left == right:
                        return 0
                    mid = left + (right - left) // 2
                    # 左边的翻转对
                    leftLength = help_sort(nums, left, mid)
                    # 右边的翻转对
                    rightLength = help_sort(nums, mid+1, right)
                    # 左+右的翻转对
                    corssLength = help_merge(nums, left, mid, right)
                    return leftLength + rightLength + corssLength
                def help_merge(nums, left, mid, right):
                    count = 0
                    for i in range(left, right+1):
                        temp[i] = nums[i]
                    # 先计数
                    i, j = left, mid+1
                    while (i <= mid) and (j <= right):
                        if temp[i] > 2*temp[j]:
                            j += 1
                        else:
                            i += 1
                            count += j - mid - 1
                    while i <= mid:
                        i += 1
                        count += right - mid
                    # 再合并
                    i, j = left, mid+1
                    for k in range(left, right+1):
                        if i == mid+1:
                            nums[k] = temp[j]
                            j += 1
                        elif j == right + 1:
                            nums[k] = temp[i]
                            i += 1
                        elif temp[i] <= temp[j]:
                            nums[k] = temp[i]
                            i += 1
                        else:
                            nums[k] = temp[j]
                            j += 1
                    return count
                return help_sort(nums, 0, length-1)
    ```




#### 快速幂Pow(x, n)
- 问题描述
    * 实现 pow(x, n) ,即计算 x 的 n 次幂函数(即,xn ).
- 思路
    * 负数要用1除
    * 偶数的话 n变成原先的1/2 底数变成原来的平方
    * 奇数的话 n变成n-1 底数变成 底数 * 递归
- 代码实现
    ```python
        class Solution:
            def myPow(self, x: float, n: int) -> float:
                if x == 1:
                    return 1
                if n == 0:
                    return 1
                if n == 1:
                    return x
                if n < 0:
                    return 1 / self.myPow(x, -n)
                elif (n % 2 == 0):
                    # 偶数
                    return self.myPow(x * x, n//2)
                else:
                    # 奇数
                    return x * self.myPow(x, n-1)
    ```