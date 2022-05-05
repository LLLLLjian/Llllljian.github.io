---
title: Interview_总结 (157)
date: 2022-04-26
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 把数字翻译成字符串
- 问题描述
    * 给定一个数字,我们按照如下规则把它翻译为字符串：0 翻译成 “a” ,1 翻译成 “b”,……,11 翻译成 “l”,……,25 翻译成 “z”.一个数字可能有多个翻译.请编程实现一个函数,用来计算一个数字有多少种不同的翻译方法.
- 思路
    * 可以理解为有条件的 爬台阶问题
    * num = x(1) x(2) x(3) ..x(i-2) x(i-1) x(i).. x(n-1) x(n)
    * 设 x(1) x(2) x(3) ..x(i-2) 的翻译解决方案为f(i-2)
    * 设 x(1) x(2) x(3) ..x(i-2) x(i-1) 的翻译解决方案为f(i-1)
    * 当 x(i-1)到x(i) 不能为被翻译 f(i) = f(i-1)
    * 当 x(i-1)到x(i) 可以被翻译 f(i) = f(i-2) + f(i-1)
- 代码实现
    ```python
        class Solution:
            def translateNum(self, num: int) -> int:
                """
                可以理解为有条件的 爬台阶问题
                """
                numStr = str(num)
                n = len(numStr)
                dp = [1 for _ in range(n + 1)] 
                for i in range(2, n+1):
                    temp = numStr[i-2:i]
                    if (temp >= "10") and (temp <= "25"):
                        dp[i] = dp[i-1] + dp[i-2]
                    else:
                        dp[i] = dp[i-1]
                return dp[n]
    ```

#### 最长不含重复字符的子字符串
- 问题描述
    * 
- 思路
    * 
- 代码实现
    ```python
        class Solution:
            def lengthOfLongestSubstring(self, s: str) -> int:
                """
                动态规划 + 哈希表
                """
                dic = {}
                res = tmp = 0
                for j in range(len(s)):
                    i = dic.get(s[j], -1) # 获取索引 i
                    dic[s[j]] = j # 更新哈希表
                    tmp = tmp + 1 if tmp < j - i else j - i # dp[j - 1] -> dp[j]
                    res = max(res, tmp) # max(dp[j - 1], dp[j])
                return res

            def lengthOfLongestSubstring(self, s: str) -> int:
                """
                动态规划 + 线性遍历
                """
                res = tmp = i = 0
                for j in range(len(s)):
                    i = j - 1
                    while i >= 0 and s[i] != s[j]: i -= 1 # 线性查找 i
                    tmp = tmp + 1 if tmp < j - i else j - i # dp[j - 1] -> dp[j]
                    res = max(res, tmp) # max(dp[j - 1], dp[j])
                return res

            def lengthOfLongestSubstring(self, s: str) -> int:
                """
                双指针 + 哈希表
                """
                dic, res, i = {}, 0, -1
                for j in range(len(s)):
                    if s[j] in dic:
                        i = max(dic[s[j]], i) # 更新左指针 i
                    dic[s[j]] = j # 哈希表记录
                    res = max(res, j - i) # 更新结果
                return res
    ```


