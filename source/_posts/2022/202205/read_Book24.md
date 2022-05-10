---
title: 读书笔记 (24)
date: 2022-05-06
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-动态规划

<!-- more -->

#### 动态规划问题(Dynamic Programming)
1. 明确 base case
2. 明确「状态」
3. 明确「选择」
4. 定义 dp 数组/函数的含义
5. 模板
    ```
        # 初始化 base case
        dp[0][0][...] = base
        # 进行状态转移
        for 状态1 in 状态1的所有取值：
            for 状态2 in 状态2的所有取值：
                for ...
                    dp[状态1][状态2][...] = 求最值(选择1,选择2...)
    ```

#### 斐波那契数列
- 问题描述
    * 斐波那契数 (通常用 F(n) 表示)形成的序列称为 斐波那契数列 .该数列由 0 和 1 开始,后面的每一项数字都是前面两项数字的和.也就是：F(0) = 0,F(1) = 1,F(n) = F(n - 1) + F(n - 2),其中 n > 1给定 n ,请计算 F(n) 
- 思路
    * dp
- 代码实现1(递归)
    ```python
        class Solution:
            def fib(self, n: int) -> int:
                if n in [1, 2]:
                    return 1
                return self.fib(n-1) + self.fib(n-2)
    ```
- 代码实现1
    * ![斐波那契数列递归](/img/20220506_1.png)
    * 存在大量重复计算,比如 f(18) 被计算了两次,而且你可以看到,以 f(18) 为根的这个递归树体量巨大,多算一遍,会耗费巨大的时间.更何况,还不止 f(18) 这一个节点被重复计算,所以这个算法及其低效.
    * 所以, 递归引入的问题就是**重叠子问题**
    * 解决方案: 像记备忘录一样把历史的计算过的结果保存下来
- 代码实现2(备忘录)
    ```python
        class Solution:
            def fib(self, n: int) -> int:
                memo = [0] * (n+2)
                def helper(memo, n):
                    if n in [0, 1]:
                        return n
                    if memo[n] != 0:
                        return memo[n]
                    memo[n] = helper(memo, n-1) + helper(memo, n-2)
                    return memo[n]
                return helper(memo, n)
    ```
- 代码实现2
    * ![斐波那契数列备忘录](/img/20220506_2.png)
    * 这种解法和常见的动态规划解法已经差不多了,只不过这种解法是「自顶向下」进行「递归」求解,我们更常见的动态规划代码是「自底向上」进行「递推」求解
- 代码实现3(dp)
    ```python
        class Solution:
            def fib(self, n: int) -> int:
                dp = [0] * (n+2)
                dp[0] = 0
                dp[1] = 1
                for i in range(2, n+1):
                    dp[i] = dp[i-1] + dp[i-2]
                return dp[n]
    ```
- 代码实现3
    * ![斐波那契数列dp](/img/20220506_3.png)
    * 那我们能不能把DP table 的大小从 n 缩小到 2
- 代码实现4(状态转移)
    ```python
        class Solution:
            def fib(self, n: int) -> int:
                a, b = 0, 1
                for i in range(n):
                    a, b = b, a+b
                return a
    ```

#### 凑零钱问题
- 问题描述
    * 给你 k 种面值的硬币,面值分别为 c1, c2 ... ck,每种硬币的数量无限,再给一个总金额 amount,问你最少需要几枚硬币凑出这个金额,如果不可能凑出,算法返回 -1 
- 思路
    * 确定 base case,这个很简单,显然目标金额 amount 为 0 时算法返回 0,因为不需要任何硬币就已经凑出目标金额了.
    * 确定「状态」,也就是原问题和子问题中会变化的变量.由于硬币数量无限,硬币的面额也是题目给定的,只有目标金额会不断地向 base case 靠近,所以唯一的「状态」就是目标金额 amount.
    * 确定「选择」,也就是导致「状态」产生变化的行为.目标金额为什么变化呢,因为你在选择硬币,你每选择一枚硬币,就相当于减少了目标金额.所以说所有硬币的面值,就是你的「选择」.
    * 明确 dp 函数/数组的定义.我们这里讲的是自顶向下的解法,所以会有一个递归的 dp 函数,一般来说函数的参数就是状态转移中会变化的量,也就是上面说到的「状态」；函数的返回值就是题目要求我们计算的量.就本题来说,状态只有一个,即「目标金额」,题目要求我们计算凑出目标金额所需的最少硬币数量.
- 伪代码
    ```python
        class Solution:
            def coinChange(self, coins: List[int], amount: int):
                def dp(coins, n):
                    # 定义：要凑出金额 n,至少要 dp(coins, n) 个硬币
                    for coin in coins:
                        # 做选择,选择需要硬币最少的那个结果
                        res = min(res, 1 + dp(n - coin))
                    return res
                # 题目要求的最终结果是 dp(amount)
                return dp(coins, amount)
    ```
- 代码实现1
    ```python
        class Solution:
            def coinChange(self, coins: List[int], amount: int):
                def dp(coins, amount):
                    # base case
                    if (amount == 0):
                        return 0
                    if (amount < 0):
                        return -1
                    # 定义：要凑出金额 n,至少要 dp(coins, n) 个硬币
                    res = 99999
                    for coin in coins:
                        # 计算子问题的结果
                        subProblem = dp(coins, amount - coin)
                        # 子问题无解则跳过
                        if (subProblem == -1):
                            continue
                        # 在子问题中选择最优解,然后加一
                        res = min(res, subProblem + 1)
                    return res if res != 99999 else -1
                # 题目要求的最终结果是 dp(amount)
                return dp(coins, amount)
    ```
- 代码实现1问题
    * ![凑零钱问题](/img/20220506_4.png)
    * 可以看到, f(9)计算了2次
    * [1, 2, 5] 100 会超时, 所以使用备忘录的方式
- 代码实现2
    ```python
        class Solution:
            def coinChange(self, coins: List[int], amount: int):
                memo = [-666] * (amount+2)
                def dp(coins, amount):
                    # base case
                    if (amount == 0):
                        return 0
                    if (amount < 0):
                        return -1
                    if memo[amount] != -666:
                        return memo[amount]
                    # 定义：要凑出金额 n,至少要 dp(coins, n) 个硬币
                    res = 99999
                    for coin in coins:
                        # 计算子问题的结果
                        subProblem = dp(coins, amount - coin)
                        # 子问题无解则跳过
                        if (subProblem == -1):
                            continue
                        # 在子问题中选择最优解,然后加一
                        res = min(res, subProblem + 1)
                    # 把计算结果存入备忘录
                    memo[amount] = res if res != 99999 else -1
                    return memo[amount]
                # 题目要求的最终结果是 dp(amount)
                return dp(coins, amount)
    ```
- 代码实现3(dp数组的迭代解法)
    ```python
        class Solution:
            def coinChange(self, coins: List[int], amount: int):
                # base case
                dp = [amount+1] * (amount+2)
                dp[0] = 0
                # 外层 for 循环在遍历所有状态的所有取值
                for i in range(amount+2):
                    # 内层 for 循环在求所有选择的最小值
                    for coin in coins:
                        # 子问题无解,跳过
                        if (i - coin) < 0:
                            continue
                        dp[i] = min(dp[i], 1 + dp[i - coin])
                return -1 if (dp[amount] == amount + 1) else dp[amount]
    ```

#### 最长递增子序列
- 问题描述
    * 给你一个整数数组 nums ,找到其中最长严格递增子序列的长度.子序列 是由数组派生而来的序列,删除(或不删除)数组中的元素而不改变其余元素的顺序.例如,[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列.
- 思路
    * dp[i] 表示以 nums[i] 这个数结尾的最长递增子序列的长度
    * base case dp[1] = 1
    * 确定状态
        * 1, 4, 3, 4, 2, 3
        * dp[3] = 3
        * dp[4] = 2
        * dp[5] = max(dp[0], dp[4]) + 1. 为什么取dp[0]和dp[4], 因为nums[5]只比nums[0]、nums[4]大
- 伪代码
    ```python
        dp[1] = 1
        for i in range(1, n):
            for j in range(i):
                if nums[i] > nums[j]:
                    dp[i] = max(dp[i], dp[j]+1)
    ```
- 代码实现
    ```python
        class Solution:
            def lengthOfLIS(self, nums: List[int]) -> int:
                if not nums:
                    return 0
                # dp[i] 表示以 nums[i] 这个数结尾的最长递增子序列的长度
                dp = [1] * (len(nums) + 1)
                for i in range(1, len(nums)):
                    for j in range(i):
                        # 寻找 nums[0..j-1] 中比 nums[i] 小的元素
                        if nums[i] > nums[j]:
                            # 把 nums[i] 接在后面,即可形成长度为 dp[j] + 1,且以 nums[i] 为结尾的递增子序列
                            dp[i] = max(dp[i], dp[j]+1)
                return max(dp)
    ```

#### 俄罗斯套娃信封问题
- 问题描述
    * 给你一个二维整数数组 envelopes ,其中 envelopes[i] = [wi, hi] ,表示第 i 个信封的宽度和高度.当另一个信封的宽度和高度都比这个信封大的时候,这个信封就可以放进另一个信封里,如同俄罗斯套娃一样.请计算 最多能有多少个 信封能组成一组“俄罗斯套娃”信封(即可以把一个信封放到另一个信封里面).
- 思路
    * 先对宽度 w 进行升序排序,如果遇到 w 相同的情况,则按照高度 h 降序排序；之后把所有的 h 作为一个数组,在这个数组上计算 LIS 的长度就是答案.
    * 首先,对宽度 w 从小到大排序,确保了 w 这个维度可以互相嵌套,所以我们只需要专注高度 h 这个维度能够互相嵌套即可.
    * 其次,两个 w 相同的信封不能相互包含,所以对于宽度 w 相同的信封,对高度 h 进行降序排序,保证 LIS 中不存在多个 w 相同的信封.
    * ![俄罗斯套娃信封问题1](/img/20220506_5.png)
    * ![俄罗斯套娃信封问题2](/img/20220506_6.png)
- 代码实现
    ```python
        class Solution:
            def maxEnvelopes(self, envelopes: List[List[int]]) -> int:
                if not envelopes:
                    return 0
                n = len(envelopes)
                envelopes.sort(key=lambda x: (x[0], -x[1]))
                f = [1] * n
                for i in range(n):
                    for j in range(i):
                        if envelopes[j][1] < envelopes[i][1]:
                            f[i] = max(f[i], f[j] + 1)
                return max(f)
    ```

#### 最大子数组和
- 问题描述
    * 给你一个整数数组 nums ,请你找出一个具有最大和的连续子数组(子数组最少包含一个元素),返回其最大和.子数组 是数组中的一个连续部分.
- 思路
    * 以 nums[i] 为结尾的「最大子数组和」为 dp[i]
    * 如何通过dp[i-1] 推断出 dp[i]
    * dp[i] 有两种「选择」,要么与前面的相邻子数组连接,形成一个和更大的子数组；要么不与前面的子数组连接,自成一派,自己作为一个子数组
    * dp[i] = max(nums[i], nums[i] + dp[i - 1]);
- 代码实现
    ```python
        class Solution:
            def maxSubArray(self, nums: List[int]) -> int:
                if not nums:
                    return 0
                dp = [nums[0]] * (len(nums) + 1)
                dp[0] = nums[0]
                for i in range(1, len(nums)):
                    dp[i] = max(nums[i], nums[i] + dp[i-1])
                return max(dp)
    ```