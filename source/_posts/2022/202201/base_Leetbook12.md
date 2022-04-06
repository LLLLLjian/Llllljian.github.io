---
title: Leetbook_基础 (12)
date: 2022-01-24
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 删除排序数组中的重复项
- Q
    ```
        给你一个 升序排列 的数组 nums , 请你 原地 删除重复出现的元素, 使每个元素 只出现一次 , 返回删除后数组的新长度.元素的 相对顺序 应该保持 一致 .

        示例 1：
        输入：nums = [1,1,2]
        输出：2, nums = [1,2,_]
        解释：函数应该返回新的长度 2 , 并且原数组 nums 的前两个元素被修改为 1, 2 .不需要考虑数组中超出新长度后面的元素.

        示例 2：
        输入：nums = [0,0,1,1,1,2,2,3,3,4]
        输出：5, nums = [0,1,2,3,4]
        解释：函数应该返回新的长度 5 ,  并且原数组 nums 的前五个元素被修改为 0, 1, 2, 3, 4 .不需要考虑数组中超出新长度后面的元素.

        提示：
        0 <= nums.length <= 3 * 104
        -104 <= nums[i] <= 104
        nums 已按 升序 排列
    ```
- T
    * 双指针
- A
    ```python
        class Solution:
            def removeDuplicates(self, nums: List[int]) -> int:
                if not nums:
                    return 0
                
                n = len(nums)
                fast = slow = 1
                while fast < n:
                    if nums[fast] != nums[fast - 1]:
                        nums[slow] = nums[fast]
                        slow += 1
                    fast += 1
                
                return slow
    ```

#### 移动零
- Q
    ```
        给定一个数组 nums, 编写一个函数将所有 0 移动到数组的末尾, 同时保持非零元素的相对顺序.

        请注意 , 必须在不复制数组的情况下原地对数组进行操作.

        示例 1:
        输入: nums = [0,1,0,3,12]
        输出: [1,3,12,0,0]
        示例 2:
        输入: nums = [0]
        输出: [0]

        提示:
        1 <= nums.length <= 104
        -231 <= nums[i] <= 231 - 1
    ```
- T
    * 双指针, 先把非0前移, 然后把之后的所有元素置为0
- A
    ```python
        class Solution:
            def moveZeroes(self, nums: List[int]) -> None:
                """
                Do not return anything, modify nums in-place instead.
                """
                slow = 0
                for fast in range(len(nums)):
                    if nums[fast] != 0:
                        nums[slow] = nums[fast]
                        slow += 1
                for j in range(slow, len(nums)):
                    nums[j] = 0
    ```

#### 合并区间
- Q
    ```
        以数组 intervals 表示若干个区间的集合, 其中单个区间为 intervals[i] = [starti, endi] .请你合并所有重叠的区间, 并返回 一个不重叠的区间数组, 该数组需恰好覆盖输入中的所有区间 .

        示例 1：
        输入：intervals = [[1,3],[2,6],[8,10],[15,18]]
        输出：[[1,6],[8,10],[15,18]]
        解释：区间 [1,3] 和 [2,6] 重叠, 将它们合并为 [1,6].
        示例 2：
        输入：intervals = [[1,4],[4,5]]
        输出：[[1,5]]
        解释：区间 [1,4] 和 [4,5] 可被视为重叠区间.

        提示：
        1 <= intervals.length <= 104
        intervals[i].length == 2
        0 <= starti <= endi <= 104
    ```
- T
    * 按照每一项的第一个值先排一下序, 然后插入
    * 如果每一项的第一个值小于结果的最大值, 就直接插入该项, 否则就替换最大值
- A
    ```python
        class Solution:
            def merge(self, intervals: List[List[int]]) -> List[List[int]]:
                """
                方法：排序
                """
                intervals.sort(key = lambda x : x[0])
                merges = list()
                for interval in intervals:
                    if not merges or merges[-1][-1] < interval[0]:
                        merges.append(interval)
                    else:
                        merges[-1][-1] = max(merges[-1][-1], interval[1])
                return merges
    ```

