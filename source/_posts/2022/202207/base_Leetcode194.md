---
title: Leetcode_基础 (194)
date: 2022-07-27
tags: Leetcode
toc: true
---

### 坚持学习系列
    二分查找-二分查找的前提是数组有序

<!-- more -->

#### 搜索二维矩阵 II
> https://leetcode.cn/problems/search-a-2d-matrix-ii/
- 思路
    * 直接从右上角开始, 大就往下,小就往左
- 代码实现
    ```python
        class Solution:
            def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
                i, j = 0, len(matrix[0])-1
                while (i < len(matrix)) and (j >= 0):
                    if matrix[i][j] == target:
                        return True
                    elif matrix[i][j] > target:
                        j -= 1
                    elif matrix[i][j] < target:
                        i += 1
                return False
    ```

#### 寻找两个正序数组的中位数
> https://leetcode.cn/problems/median-of-two-sorted-arrays/
- 思路
    * 直接复制的
- 代码实现
    ```python
        class Solution:
            def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
                def getKthElement(k):
                    """
                    - 主要思路：要找到第 k (k>1) 小的元素,那么就取 pivot1 = nums1[k/2-1] 和 pivot2 = nums2[k/2-1] 进行比较
                    - 这里的 "/" 表示整除
                    - nums1 中小于等于 pivot1 的元素有 nums1[0 .. k/2-2] 共计 k/2-1 个
                    - nums2 中小于等于 pivot2 的元素有 nums2[0 .. k/2-2] 共计 k/2-1 个
                    - 取 pivot = min(pivot1, pivot2),两个数组中小于等于 pivot 的元素共计不会超过 (k/2-1) + (k/2-1) <= k-2 个
                    - 这样 pivot 本身最大也只能是第 k-1 小的元素
                    - 如果 pivot = pivot1,那么 nums1[0 .. k/2-1] 都不可能是第 k 小的元素.把这些元素全部 "删除",剩下的作为新的 nums1 数组
                    - 如果 pivot = pivot2,那么 nums2[0 .. k/2-1] 都不可能是第 k 小的元素.把这些元素全部 "删除",剩下的作为新的 nums2 数组
                    - 由于我们 "删除" 了一些元素(这些元素都比第 k 小的元素要小),因此需要修改 k 的值,减去删除的数的个数
                    """
                    
                    index1, index2 = 0, 0
                    while True:
                        # 特殊情况
                        if index1 == m:
                            return nums2[index2 + k - 1]
                        if index2 == n:
                            return nums1[index1 + k - 1]
                        if k == 1:
                            return min(nums1[index1], nums2[index2])

                        # 正常情况
                        newIndex1 = min(index1 + k // 2 - 1, m - 1)
                        newIndex2 = min(index2 + k // 2 - 1, n - 1)
                        pivot1, pivot2 = nums1[newIndex1], nums2[newIndex2]
                        if pivot1 <= pivot2:
                            k -= newIndex1 - index1 + 1
                            index1 = newIndex1 + 1
                        else:
                            k -= newIndex2 - index2 + 1
                            index2 = newIndex2 + 1
                
                m, n = len(nums1), len(nums2)
                totalLength = m + n
                if totalLength % 2 == 1:
                    return getKthElement((totalLength + 1) // 2)
                else:
                    return (getKthElement(totalLength // 2) + getKthElement(totalLength // 2 + 1)) / 2
    ```

#### 搜索旋转排序数组
> https://leetcode.cn/problems/search-in-rotated-sorted-array/
- 思路
    * 看见O(log n)就选二分, 然后判断mid值就可以了
    * 这里比普通二分多一步 判断序列是否为递增
- 代码实现
    ```python
        class Solution:
            def search(self, nums: List[int], target: int) -> int:
                if not nums:
                    return -1
                left, right = 0, len(nums) - 1
                while left <= right:
                    mid = (left + right) // 2
                    if target == nums[mid]:
                        return mid
                    if nums[left] <= nums[mid]:
                        if nums[left] <= target <= nums[mid]:
                            right = mid - 1
                        else:
                            left = mid + 1
                    else:
                        if nums[mid] <= target <= nums[right]:
                            left = mid + 1
                        else:
                            right = mid - 1
                return -1
    ```


