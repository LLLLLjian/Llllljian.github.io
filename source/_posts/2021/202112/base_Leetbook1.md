---
title: Leetbook_基础 (1)
date: 2021-12-14
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 数组和列表、集合之间有什么不同
- 集合
    * 由一个或多个确定的元素所构成的整体
    * 集合里的元素类型不一定相同
    * 集合里的元素没有顺序
- 列表
    * 是一种数据项构成的有限序列, 即按照一定的线性顺序, 排列而成的数据项的集合
- 数组
    * 数组是列表的实现方式
    * 列表中没有索引, 这是数组与列表最大的不同点
    * 数组中的元素在内存中是连续存储的, 且每个元素占用相同大小的内存

#### 如何理解数组的读取、查找、插入、删除等 基本操作
- 读取元素
    * 时间复杂度 O(1)
    * 通过索引可以直接读取到值
- 查找元素
    * 时间复杂度 O(N)
    * 无法直接查找 需要从头遍历
- 插入元素
    * 最优是在数组尾部插入 O(1)
    * 最劣势在数组头部插入 O(N)
- 删除
    * 时间复杂度 O(N) = O(1) + O(N-1)
    * 1为删除操作 n-1为移动其它元素的步骤数
- 寻找数组的中心索引
    * Q
        ```
            给你一个整数数组 nums , 请计算数组的 中心下标 .

            数组 中心下标 是数组的一个下标, 其左侧所有元素相加的和等于右侧所有元素相加的和.

            如果中心下标位于数组最左端, 那么左侧数之和视为 0 , 因为在下标的左侧不存在元素.这一点对于中心下标位于数组最右端同样适用.

            如果数组有多个中心下标, 应该返回 最靠近左边 的那一个.如果数组不存在中心下标, 返回 -1 .

            示例 1：

            输入：nums = [1, 7, 3, 6, 5, 6]
            输出：3
            解释：
            中心下标是 3 .
            左侧数之和 sum = nums[0] + nums[1] + nums[2] = 1 + 7 + 3 = 11 , 
            右侧数之和 sum = nums[4] + nums[5] = 5 + 6 = 11 , 二者相等.
            示例 2：

            输入：nums = [1, 2, 3]
            输出：-1
            解释：
            数组中不存在满足此条件的中心下标.
            示例 3：

            输入：nums = [2, 1, -1]
            输出：0
            解释：
            中心下标是 0 .
            左侧数之和 sum = 0 , (下标 0 左侧不存在元素), 
            右侧数之和 sum = nums[1] + nums[2] = 1 + -1 = 0 .

            提示：

            1 <= nums.length <= 104
            -1000 <= nums[i] <= 1000
        ```
    * T
        * 计算出数组和, 0和数组和分别加减, 求到相同的就返回
    * A
        ```python
            class Solution:
                def pivotIndex(self, nums: List[int]) -> int:
                    sums1 = sum(nums)
                    sums2 = 0
                    for i in range(len(nums)):
                        if sums1 - nums[i] == sums2:
                            return i
                        sums1 -= nums[i]
                        sums2 += nums[i]
                    return -1
        ```
- 搜索插入位置
    * Q
        ```
            给定一个排序数组和一个目标值, 在数组中找到目标值, 并返回其索引.如果目标值不存在于数组中, 返回它将会被按顺序插入的位置.

            请必须使用时间复杂度为 O(log n) 的算法

            示例 1:

            输入: nums = [1,3,5,6], target = 5
            输出: 2
            示例 2:

            输入: nums = [1,3,5,6], target = 2
            输出: 1
            示例 3:

            输入: nums = [1,3,5,6], target = 7
            输出: 4
            示例 4:

            输入: nums = [1,3,5,6], target = 0
            输出: 0
            示例 5:

            输入: nums = [1], target = 0
            输出: 0
        ```
    * T
        * 二分法, 一直往中间中 找到最后还找不到的话 就是中间值加1
    * A
        ```python
            class Solution:
                def searchInsert(self, nums: List[int], target: int) -> int:
                    if target < nums[0]:
                        return 0
                    if target > nums[len(nums) - 1]:
                        return len(nums)
                    low=0
                    high=len(nums)-1
                    while low<=high:
                        mid=(low+high)//2
                        guess=nums[mid]
                        if guess == target:
                            return mid
                        if guess > target:
                            high= mid - 1
                        else:
                            low= mid +1
                    #high=len(nums)-1
                    if target>nums[mid]:
                        mid+=1
                    return mid
        ```

