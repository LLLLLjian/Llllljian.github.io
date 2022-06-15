---
title: Interview_总结 (183)
date: 2022-06-08 18:00:00
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP100

<!-- more -->

#### 数组中的第K个最大元素
- 问题描述
    * 给定整数数组 nums 和整数 k,请返回数组中第 k 个最大的元素.请注意,你需要找的是数组排序后的第 k 个最大的元素,而不是第 k 个不同的元素.
- 思路
    * 直接归并排序或者快速排序就可以了
- 代码实现
    ```python
        class Solution:
            def findKthLargest(self, nums: List[int], k: int) -> int:
                """
                我的写法, 想利用滑动窗口, 并且是个有序的滑动窗口
                暴力了 直接超时了
                """
                length = len(nums)
                if k > length:
                    return 0
                res = []
                for num in nums:
                    if len(res) == k:
                        if res[0] > num:
                            # 如果滑动窗口的第一个值大于num, 那他就没必要进入窗口里
                            pass
                        else:
                            temp = []
                            res.pop(0)
                            while res and res[0] < num:
                                temp.append(res.pop(0))
                            res = temp + [num] + res
                    else:
                        temp = []
                        while res and res[0] < num:
                            temp.append(res.pop(0))
                        res = temp + [num] + res
                return res[0]
        
        class Solution:
            def findKthLargest(self, nums: List[int], k: int) -> int:
                """
                不想动脑子了 直接归并排序 然后获取吧
                """
                length = len(nums)
                def help_sort(nums, left, right):
                    if left == right:
                        return
                    mid = left + (right - left) // 2
                    help_sort(nums, left, mid)
                    help_sort(nums, mid+1, right)
                    help_merge(nums, left, mid, right)
                    
                def help_merge(nums, left, mid, right):
                    temp = []
                    i, j = left, mid+1
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
                    nums[left:right+1] = temp
                help_sort(nums, 0, length-1)
                return nums[-k]
    ```

#### 寻找重复数
- 问题描述
    * 给定一个包含 n + 1 个整数的数组 nums ,其数字都在 [1, n] 范围内(包括 1 和 n),可知至少存在一个重复的整数.假设 nums 只有 一个重复的整数 ,返回 这个重复的数 .你设计的解决方案必须 不修改 数组 nums 且只用常量级 O(1) 的额外空间.
- 思路
    * 二分法, 利用抽屉原理
    * 双指针, 模拟快慢指针判断链表是否有环
- 代码实现
    ```python
        class Solution:
            def findDuplicate(self, nums: List[int]) -> int:
                n = len(nums)
                left, right = 0, n
                while left < right:
                    mid = (left + right) // 2
                    for num in nums:
                        if (num <= mid):
                            cnt += 1
                    # 根据抽屉原理,小于等于 4 的个数如果严格大于 4 个,此时重复元素一定出现在 [1..4] 区间里
                    if (cnt > mid):
                        # 重复元素位于区间 [left..mid]
                        right = mid
                    else:
                        # if 分析正确了以后,else 搜索的区间就是 if 的反面区间 [mid + 1..right]
                        left = mid + 1
                return left
            def findDuplicate(self, nums: List[int]) -> int:
                slow, fast = 0, 0
                while True:
                    slow = nums[slow]           # 类比链表slow=slow.next
                    fast = nums[nums[fast]]     # 类比链表fast=fast.next.next
                    if fast == slow:    # 首次相遇点
                        break
                fast = 0                # fast回到起点
                while slow != fast:     # 再次相遇点即为重复数字
                    slow = nums[slow]
                    fast = nums[fast]
                return fast
    ```

#### 前K个高频元素
- 问题描述
    * 给你一个整数数组 nums 和一个整数 k ,请你返回其中出现频率前 k 高的元素.你可以按 任意顺序 返回答案.
- 思路
    * 计算每个元素出现了几次,然后把次数当key, 循环够k个元素的时候直接返回
- 代码实现
    ```python
        class Solution:
            def topKFrequent(self, nums: List[int], k: int) -> List[int]:
                # n_f计算每个元素出现了几次
                n_f = {}
                # f_n 出现几次的有哪些元素
                f_n = {}
                for i in nums:
                    if i not in n_f:
                        n_f[i] = 1
                    else:
                        n_f[i] += 1
                for n,f in n_f.items():
                    if f not in f_n:
                        f_n[f] = [n]
                    else:
                        f_n[f].append(n)

                arr = []
                # 最多一个元素出现 len(nums)次
                # 往下循环找到k个元素就返回
                for x in range(len(nums),0,-1):
                    if x in f_n:
                        for i in f_n[x]:
                            arr.append(i)
                            if len(arr) == k:
                                return arr
    ```

#### 完全平方数
- 问题描述
    * 给你一个整数 n ,返回 和为 n 的完全平方数的最少数量 .完全平方数 是一个整数,其值等于另一个整数的平方；换句话说,其值等于一个整数自乘的积.例如,1、4、9 和 16 都是完全平方数,而 3 和 11 不是.
- 思路
    * 先找到小于等于这个数的所有平方数集合
    * 用最少的平方和的数字来凑 n
- 代码实现
    ```python
        class Solution:
            def numSquares(self, n):
                if n <= 3:
                    return n
                dp = [0]*(n+1)
                dp[1] = dp[2] = dp[3] = 1
                # 先对12开方再加1, 然后把每个数的平方放到square_nums里
                square_nums = [i*i for i in range(1,int(n**0.5)+1)]
                for i in range(1,n+1):
                    tmp = []
                    for num in square_nums:
                        if i - num < 0:
                            break
                        tmp.append(dp[i-num])
                    dp[i] = min(tmp)+1
                return dp[n]
    ```

#### 零钱兑换
- 问题描述
    * 给你一个整数数组 coins ,表示不同面额的硬币；以及一个整数 amount ,表示总金额.计算并返回可以凑成总金额所需的 最少的硬币个数 .如果没有任何一种硬币组合能组成总金额,返回 -1 .你可以认为每种硬币的数量是无限的.
- 思路
    * 确定 base case,这个很简单,显然目标金额 amount 为 0 时算法返回 0,因为不需要任何硬币就已经凑出目标金额了.
    * 确定「状态」,也就是原问题和子问题中会变化的变量.由于硬币数量无限,硬币的面额也是题目给定的,只有目标金额会不断地向 base case 靠近,所以唯一的「状态」就是目标金额 amount.
    * 确定「选择」,也就是导致「状态」产生变化的行为.目标金额为什么变化呢,因为你在选择硬币,你每选择一枚硬币,就相当于减少了目标金额.所以说所有硬币的面值,就是你的「选择」.
    * 明确 dp 函数/数组的定义.我们这里讲的是自顶向下的解法,所以会有一个递归的 dp 函数,一般来说函数的参数就是状态转移中会变化的量,也就是上面说到的「状态」；函数的返回值就是题目要求我们计算的量.就本题来说,状态只有一个,即「目标金额」,题目要求我们计算凑出目标金额所需的最少硬币数量.
- 代码实现
    ```python
        class Solution:
            def coinChange(self, coins: List[int], amount: int):
                # 备忘录
                memo = dict()
                def dp(n):
                    # 查备忘录,避免重复计算
                    if n in memo: return memo[n]
                    # base case
                    if n == 0: return 0
                    if n < 0: return -1
                    res = float('INF')
                    for coin in coins:
                        subproblem = dp(n - coin)
                        if subproblem == -1: continue
                        res = min(res, 1 + subproblem)
                    # 记入备忘录
                    memo[n] = res if res != float('INF') else -1
                    return memo[n]
                return dp(amount)
    ```
