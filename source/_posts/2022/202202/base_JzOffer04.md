---
title: 剑指Offer_基础 (04)
date: 2022-02-10
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 斐波那契数列的应用

##### 输出斐波那契数列的第n项
- 题目描述
    * 现在要求输入一个整数 n, 请你输出斐波那契数列的第 n 项.n<=39
- 思路
    * 递归的效率低, 使用循环方式.
- 代码实现
    ```python
        class Solution:
            def fib(self, n: int) -> int:
                a, b = 0, 1
                for _ in range(n):
                    a, b = b, a + b
                return a % 1000000007

            def fib1(self, n: int) -> int:
                if n == 0:
                    return 0
                if n == 1:
                    return 1
                dp = dict()
                dp[0] = 0
                dp[1] = 1
                for i in range(2, n+1):
                    dp[i] = (dp[i-1] + dp[i-2]) % 1000000007
                return dp[n]
    ```

##### 青蛙跳台阶(1 或 2 级)
- 题目描述
    * 一只青蛙一次可以跳上 1 级台阶, 也可以跳上 2 级.求该青蛙跳上一个 n 级的台阶总共有多少种跳法.
- 思路
    * 斐波那契数列
- 代码实现
    ```python
        class Solution:
            def numWays(self, n: int) -> int:
                a, b = 0, 1
                for _ in range(n+1):
                    a, b = b, a + b
                return a % 1000000007

            def numWays1(self, n: int) -> int:
                if n in record.keys():
                    return record[n]
                res = self.numWays(n-1) + self.numWays(n-2)
                record[n] = res
                return res % 1000000007
    ```

##### 青蛙跳台阶(n 级)
- 题目描述
    * 一只青蛙一次可以跳上 1 级台阶, 也可以跳上 2 级......它也可以跳上 n级.求该青蛙跳上一个 n 级的台阶总共有多少种跳法
- 思路
    * 2^(n-1)
- 代码实现
    ```java
        public int JumpFloor2(int target)
        {
            return (int) Math.pow(2,target-1);
        }
    ```


