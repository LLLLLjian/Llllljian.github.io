---
title: DataStructure_基础 (46)
date: 2022-03-16
tags: DataStructure
toc: true
---

### 重学数据结构
    重学数据结构-常见算法

<!-- more -->

#### 冒泡排序
- 基本思想
    * 两两比较相邻记录的关键字,如果是反序则交换,直到没有反序为止
- 代码实现
    ```python
        def bubbleSort(arr):
            """
            冒泡排序
            """
            count = len(arr)
            # 标志位
            swap_flag = True
            for i in range(count):
                if not swap_flag:
                    continue
                # 如果没发生交换,则依旧为false,下次就会跳出循环
                swap_flag = False
                for j in range(count-i-1):
                    if arr[j] > arr[j+1]:
                        # 发生交换,则变为true,下次继续判断
                        swap_flag = True
                        arr[j], arr[j+1] = arr[j+1], arr[j]
            return arr
    ```
- 总结
    * 时间复杂度: O(n^2)
    * 空间复杂度: O(1)
    * 是否稳定: 是

#### 简单选择排序
- 基本思想
    * 每次循环找到最小的值, 然后交换
- 代码实现
    ```python
        def selectSort(arr):
            """
            简单选择排序
            """
            count = len(arr)
            for i in range(count):
                min_index = i
                for m in range(i+1, count):
                    if arr[m] < arr[min_index]:
                        min_index = m
                if min_index != i:
                    arr[min_index], arr[i] = arr[i], arr[min_index]
            return arr
    ```
- 总结
    * 时间复杂度: O(n^2)
    * 空间复杂度: O(1)
    * 是否稳定: 否

#### 直接插入排序
- 基本思想
    * 将一个记录插入到已经排好序的有序表中,从而得到一个新的有序表
- 代码实现
    ```python
        def insertSort(arr):
            """
            插入排序
            """
            count = len(arr)
            for i in range(count):
                tmp = arr[i]
                # 内层循环控制,比较并插入
                for m in range(i-1, -1, -1):
                    if tmp < arr[m]:
                        # 发现插入的元素要小,交换位置,将后边的元素与前面的元素互换
                        arr[m+1], arr[m] = arr[m], tmp
                    else:
                        # 如果碰到不需要移动的元素,由于是已经排序好是数组,则前面的就不需要再次比较了
                        break
            return arr
    ```
- 总结
    * 时间复杂度: O(n^2)
    * 空间复杂度: O(1)
    * 是否稳定: 是

#### 归并排序
- 基本思想
    * 将两个或两个以上的有序表合成一个新的有序表
- 代码实现
    ```python
        def mergeSort(arr):
            """
            归并排序
            """
            if len(arr) <= 1:
                return arr
            middle = len(arr)//2
            left = mergeSort(arr[:middle])
            right = mergeSort(arr[middle:])
            return merge(left, right)


        def merge(left_list, right_list):
            l_index, r_index = 0, 0
            merge_list = []
            # 判断列表里面是否还有元素可以用
            while l_index < len(left_list) and r_index < len(right_list):
                # 哪边的元素小于另外一边的的元素就把哪边的元素加入进去,对应的索引加一
                if left_list[l_index] < right_list[r_index]:
                    merge_list.append(left_list[l_index])
                    l_index += 1
                else:
                    merge_list.append(right_list[r_index])
                    r_index += 1
                # 下面的这两个就是,如果有一个列表全部添加了,另外一个列表直接添加到merge_list里面了
            merge_list += left_list[l_index:]
            merge_list += right_list[r_index:]
            return merge_list
    ```
- 总结
    * 时间复杂度: O(nlogn)
    * 空间复杂度: O(n)
    * 是否稳定: 是

#### 快速排序
- 基本思想
    * 利用基准数通过一趟排序将待排记录分割成独立的两部分,其中一部分记录的关键字均比基准数小,另一部分记录的关键字均比基准数大,然后分别对这两部分记录继续进行分割,进而达到有序
- 代码实现
    ```python
        def quickSort(arr):
            """
            快速排序
            """
            if len(arr) <= 1:
                return arr
            tmp = arr[0]
            left_list = []
            right_list = []
            for i in arr[1:]:
                if i > tmp:
                    right_list.append(i)
                else:
                    left_list.append(i)
            left_list = quickSort(left_list)
            right_list = quickSort(right_list)
            return left_list + [tmp] + right_list
    ```
- 总结
    * 时间复杂度: O(n^2)
    * 空间复杂度: O(n)
    * 是否稳定: 否

#### 计数排序
- 基本思想
    * 利用数组下标来确认元素的正确位置
- 代码实现
    ```python
        def counting_sort(array):
            if len(array) < 2:
                return array
            max_num = max(array)
            count = [0] * (max_num + 1)
            for num in array:
                count[num] += 1
            new_array = list()
            for i in range(len(count)):
                for j in range(count[i]):
                    new_array.append(i)
            return new_array
    ```
- 总结
    * 时间复杂度: O(n^2)
    * 空间复杂度: O(1)
    * 是否稳定: 否

