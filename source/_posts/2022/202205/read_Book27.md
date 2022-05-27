---
title: 读书笔记 (27)
date: 2022-05-09
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二分查找

<!-- more -->

#### 二分查找
> 思路很简单,细节是魔鬼
- 二分查找框架
    ```
        int binarySearch(int[] nums, int target) {
            int left = 0, right = ...;
            while(...) {
                // 防止溢出
                int mid = left + (right - left) / 2;
                if (nums[mid] == target) {
                    ...
                } else if (nums[mid] < target) {
                    left = ...
                } else if (nums[mid] > target) {
                    right = ...
                }
            }
            return ...;
        }
    ```
- 技巧
    * 不要出现 else,而是把所有情况用 else if 写清 楚,这样可以清楚地展现所有细节
- 常见场景
    * 寻找一个数
    * 寻找左侧边界
    * 寻找右侧边界

#### 寻找一个数
- 问题描述
    * 搜索一个数,如果存在, 返回其索引,否则返回 -1
- 思路
    * 第一个..., 因为right=len-1, 因为要两端都闭[left, right], right=len的话会越界
    * 第二个..., 相等的时候就直接返回mid, mid就是nums中的索引
    * 第三个..., 当发现nums[mid]!=target的时候, 应该要去搜索[left, mid-1] [mid-1, right]了, 所以right=mid-1, left=mid+1
- 代码实现
    ```python
        def binarySearch(nums, target):
            left = 0
            right = len(nums) - 1
            # [left, right]
            while (left <= right):
                mid = left + (right - left) // 2
                if nums[mid] == target:
                    return mid
                elif nums[mid] > target:
                    right = mid - 1
                elif nums[mid] < target:
                    left = mid + 1
            return -1
    ```
- 算法缺陷
    * 当nums=[1, 2, 2, 2, 3], target=2时, return为2, 但此时我想返回左侧边界1或者右侧边界3的话是没有办法处理的

#### 寻找左侧边界的二分搜索
- 思路
    * 第一个..., 因为right=len, 所以是左闭右开[left, right)
    * 第四个..., 为什么没有返回-1, 左侧边界在这里可以理解为在nums中小于target的数量
        * nums=[1, 2, 2, 2, 3] target=2 return=1
        * nums=[2, 3, 5, 7] target=1 return=0
        * nums=[2, 3, 5, 7] target=8 return=4
    * 第三个..., 因为当nums[mid]被检查之后, 下一个检查的应该是[left, mid) [mid+1, right)
    * 第二个..., 找到target的时候不要立即返回, 而是要缩小搜索区间的上界right, 继续在[left, right)中查找, 让搜索区间不断往左, 从而达到锁定左侧边界的目的
    * 第四个..., 为什么返回的是left, 因为此时left=right, 那就返回哪个都可以了
- 代码实现
    ```python
        def left_bound(nums, target):
            left = 0
            right = len(nums)
            while (left < right):
                mid = left + (right - left) // 2
                if nums[mid] == target:
                    right = mid
                elif nums[mid] > target:
                    right = mid
                elif nums[mid] < target:
                    left = mid + 1
            # target 比所有数都大
            if (left = right):
                return -1
            return left if nums[left] == target else -1
    ```
- 思考
    * 能不能按照1去实现查找左侧边界
- 代码实现
    ```python
        def left_bound(nums, target):
            left, right = 0, len(nums) - 1
            while (left <= right):
                mid = left + (right - left) // 2
                if nums[mid] == target:
                    # 因为此时要搜索的是[left, mid-1]
                    right = mid - 1
                elif nums[mid] > target:
                    # 此时搜索的是[left, mid-1]
                    right = mid - 1
                elif nums[mid] < target:
                    # 此时搜索的是[mid+1, right]
                    left = mid + 1
            # 检查出界情况
            if (left >= len(nums)) or (nums[left] != target):
                return -1
            return left
    ```

#### 寻找右侧边界的二分查找
- 思路
    * 当target==nums[mid]时, 我们需要做的是往右靠, 而且mid已经用过了, 所以下一个区间是[mid+1, right)
- 代码实现
    ```python
        def right_bound(nums, target):
            left, right = 0, len(nums)
            while left < right:
                mid = left + (right - left) // 2
                if nums[mid] == target:
                    # 这里要搜索的是[mid+1, right)
                    left = mid + 1
                elif nums[mid] < target:
                    # 搜索的是[mid+1, right)
                    left = mid + 1
                elif nums[mid] > target:
                    # 搜索的是[left, mid)
                    right = mid
            if left == 0:
                return -1
            return left - 1 if nums[left-1] == target else -1
    ```
- 思考
    * 是否可以写成两端都闭的呢
- 代码实现
    ```python
        def right_bound(nums, target):
            left, right = 0, len(nums)-1
            while left <= target:
                mid = left + (right - left) // 2
                if (nums[mid] == target):
                    # 搜索区间为[mid+1, right]
                    left = mid + 1
                elif nums[mid] < target:
                    # 搜索区间为[mid+1, right]
                    left = mid + 1
                elif nums[mid] > target:
                    # 搜索区间为[left, mid-1]
                    right = mid - 1
            # 检查越界情况
            if (right < 0) or (nums[right] != target):
                return -1
            return right
    ```

#### 逻辑统一
- 最基本的二分查找算法
    
    因为我们初始化 right = nums.length - 1 所以决定了我们的「搜索区间」是 [left, right] 所以决定了 while (left <= right) 同时也决定了 left = mid+1 和 right = mid-1
    因为我们只需找到一个 target 的索引即可 所以当 nums[mid] == target 时可以立即返回

- 寻找左侧边界的二分查找

    因为我们初始化 right = nums.length
    所以决定了我们的「搜索区间」是 [left, right) 所以决定了 while (left < right) 同时也决定了 left = mid + 1 和 right = mid
    因为我们需找到 target 的最左侧索引
    所以当 nums[mid] == target 时不要立即返回 而要收紧右侧边界以锁定左侧边界

- 寻找右侧边界的二分查找

    因为我们初始化 right = nums.length 所以决定了我们的「搜索区间」是 [left, right) 所以决定了 while (left < right) 同时也决定了 left = mid + 1 和 right = mid
    因为我们需找到 target 的最右侧索引
    所以当 nums[mid] == target 时不要立即返回 而要收紧左侧边界以锁定右侧边界
    又因为收紧左侧边界时必须 left = mid + 1 所以最后无论返回 left 还是 right,必须减一



