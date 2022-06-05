---
title: Interview_总结 (176)
date: 2022-06-01
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP100

<!-- more -->

#### 不同的二叉搜索树
- 问题描述
    * 给你一个整数 n ,求恰由 n 个节点组成且节点值从 1 到 n 互不相同的 二叉搜索树 有多少种？返回满足题意的二叉搜索树的种数.
- 思路
    * 假设给算法输入 n = 5,也就是说用 {1,2,3,4,5} 这些数字去构造 BST.如果固定 3 作为根节点,左子树节点就是 {1,2} 的组合,右子树就是 {4,5} 的组合
    ![不同的二叉搜索树](/img/20220601_1.png)
    * 那么 {1,2} 和 {4,5} 的组合有多少种呢？只要合理定义递归函数,这些可以交给递归函数去做.
- 代码实现
    ```python
        class Solution:
            def numTrees(self, n: int) -> int:
                if n == 1:
                    return 1
                # 因为可能存在重复的值 所以要有一个备忘录
                memo = [[0] * (n+1) for _ in range(n+1)]
                def count(lo, hi):
                    if lo > hi:
                        return 1
                    # 查备忘录
                    if memo[lo][hi] != 0:
                        return memo[lo][hi]
                    res = 0
                    for i in range(lo, hi+1):
                        left = count(lo, i-1)
                        right = count(i+1, hi)
                        res += left * right
                    # 将结果存入备忘录
                    memo[lo][hi] = res
                    return res
                return count(1, n)
    ```




#### 验证二叉搜索树
- 问题描述
    * 给你一个二叉树的根节点 root ,判断其是否是一个有效的二叉搜索树.
    * 有效 二叉搜索树定义如下：
        * 节点的左子树只包含 小于 当前节点的数.
        * 节点的右子树只包含 大于 当前节点的数.
        * 所有左子树和右子树自身必须也是二叉搜索树.
- 思路
    * 不能简单的判断 左节点的值小于根节点 右节点的值大于根节点
    * 而是要将最大值和最小值当成参数在递归中一直传递
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def isValidBST(self, root: Optional[TreeNode]) -> bool:
                def isValid(root, minTree, maxTree):
                    """
                    限定以 root 为根的子树节点必须满足 max.val > root.val > min.val
                    """
                    # base case
                    if not root:
                        return True
                    if (minTree != None) and (root.val <= minTree.val):
                        return False
                    if (maxTree != None) and (root.val >= maxTree.val):
                        return False
                    # 限定左子树的最大值是 root.val,右子树的最小值是 root.val
                    return isValid(root.left, minTree, root) and isValid(root.right, root, maxTree)
                    
                return isValid(root, None, None)
    ```


#### 最长连续序列
- 问题描述
    * 给定一个未排序的整数数组 nums ,找出数字连续的最长序列(不要求序列元素在原数组中连续)的长度.请你设计并实现时间复杂度为 O(n) 的算法解决此问题.
- 思路
    * 如果已知有一个x,x+1,x+2,⋯,x+y 的连续序列,而我们却重新从 x+1,x+2 或者是 x+y 处开始尝试匹配,那么得到的结果肯定不会优于枚举 x 为起点的答案,因此我们在外层循环的时候碰到这种情况跳过即可.
    * 那么怎么判断是否跳过呢？由于我们要枚举的数 x 一定是在数组中不存在前驱数 x−1 的,不然按照上面的分析我们会从 x−1 开始尝试匹配,因此我们每次在哈希表中检查是否存在 x−1 即能判断是否需要跳过了.
- 代码实现
    ```python
        class Solution:
            def longestConsecutive(self, nums: List[int]) -> int:
                longest_streak = 0
                num_set = set(nums)
                for num in num_set:
                    if num - 1 not in num_set:
                        current_num = num
                        current_streak = 1
                        while current_num + 1 in num_set:
                            current_num += 1
                            current_streak += 1
                        longest_streak = max(longest_streak, current_streak)
                return longest_streak
    ```


#### 乘积最大子数组
- 问题描述
    * 给你一个整数数组 nums ,请你找出数组中乘积最大的非空连续子数组(该子数组中至少包含一个数字),并返回该子数组所对应的乘积.测试用例的答案是一个 32-位 整数.子数组 是数组的连续子序列.
- 思路
    * 方法1:
        * 需要维护两个中间值, 一个是最大 一个是最小
        * nums[i] 是正数,当前的最大乘积 = 前面的最大乘积 * nums[i]
        * nums[i] 是负数,当前的最大乘积 = 前面的最小乘积 * nums[i]
        * maxDp[i] = Math.max(nums[i], Math.max(maxDp[i - 1] * nums[i], minDp[i - 1] * nums[i]))
        * minDp[i] = Math.min(nums[i], Math.min(maxDp[i - 1] * nums[i], minDp[i - 1] * nums[i]))
    * 方法2:
        * 需要判断负数的个数
        * 如果是偶数个, 那所有数乘起来就是最大值
        * 如果是奇数个, x y z三个负数, 那就要看是选xy还是yz了, 这里可以直接从左乘和从右开始乘, 一直取最大值即可
        * 如果有0 就要从0开始取
- 代码实现
    ```python
        class Solution:
            def maxProduct(self, nums: List[int]) -> int:
                length = len(nums)
                if length == 0:
                    return 0
                elif length == 1:
                    return nums[0]
                dp = max_dp = min_dp = nums[0]
                for i in range(1,len(nums)):
                    # 需要备份一下 max_dp, 因为下一行会将 max_dp 更新成当前的值, 计算 min_dp 时用的 max_dp 应当是前面的最大乘积
                    temp = max_dp
                    max_dp = max(max_dp * nums[i], nums[i], min_dp * nums[i])
                    min_dp = min(temp * nums[i], nums[i], min_dp * nums[i])
                    dp = max(dp, max_dp)
                return dp
            def maxProduct(self, nums: List[int]) -> int:
                length = len(nums)
                if length == 0:
                    return 0
                elif length == 1:
                    return nums[0]
                res = nums[0]
                maxNum = 1
                # 从前往后乘积最大值
                for num in nums:
                    if maxNum == 0:
                        maxNum = num
                    else:
                        maxNum = maxNum * num
                    res = max(maxNum, res)
                maxNum = 1
                # 从后往前乘积最大值
                for num in nums[::-1]:
                    if maxNum == 0:
                        maxNum = num
                    else:
                        maxNum = maxNum * num
                    res = max(maxNum, res)
            return res
    ```
