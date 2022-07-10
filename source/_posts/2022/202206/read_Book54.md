---
title: 读书笔记 (54)
date: 2022-06-15 18:00:00
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-动态规划

<!-- more -->

#### 总结
> 做算法题的技巧就是, 把大的问题细化到一个点, 先研究在这个小的点上如何解决问题, 然后再通过递归/迭代的方式扩展到整个问题.

#### 两个字符串的删除操作
- 问题描述
    * 给定两个单词 word1 和 word2 , 返回使得 word1 和  word2相同所需的最小步数.每步 可以删除任意一个字符串中的一个字符.
- 思路
    * 思路1
        * 动态规划
        * 边界情况
            * 当i=0时, word1[0, i]为空, 空字符串和任何字符串要变相同, 只有将另一个字符串的字符全部删掉, 所以dp[0][j]=j
            * 同理可得dp[i][0]=i
        * 具体分析
            * 当字符word1[i - 1] == word2[j - 1]时, 增加一个系统字符, 最少删除操作次数不变, 所以dp[i][j] = dp[i - 1][j - 1]
            * 当二者不相等时
                * 使word1[0][i-1]和word2[0][j]相同的最少删除操作次数, 加上删除word1[i-1]的1次操作
                * 使word1[0][i]和word2[0][j-1]相同的最少删除操作次数, 加上删除word2[j-1]的1次操作
    * 思路2
        * 最长公共字符串
- 代码实现1
    ```python
        class Solution:
            def minDistance(self, word1: str, word2: str) -> int:
                m, n = len(word1), len(word2)
                # 其中 {dp}[i][j] 表示使 word1[0:i] word2[0:j]word 相同的最少删除操作次数
                dp = [[0] * (n + 1) for _ in range(m + 1)]
                for i in range(1, m + 1):
                    dp[i][0] = i
                for j in range(1, n + 1):
                    dp[0][j] = j
                for i in range(1, m + 1):
                    for j in range(1, n + 1):
                        if word1[i - 1] == word2[j - 1]:
                            dp[i][j] = dp[i - 1][j - 1]
                        else:
                            dp[i][j] = min(dp[i - 1][j], dp[i][j - 1]) + 1
                return dp[m][n]
    ```
- 代码实现2
    ```python
        class Solution:
            def minDistance(self, word1: str, word2: str) -> int:
                m, n = len(word1), len(word2)
                # 计算最长公共子串长度, 然后分别减去就可以了
                def longestCommonSubsequence():
                    """
                    计算最长公共子序列的长度
                    """
                    # 定义：word1[0..i-1] 和 word2[0..j-1] 的 lcs 长度为 dp[i][j]
                    dp = [[0] * (n+1) for _ in range(m+1)]
                    for i in range(1, m+1):
                        for j in range(1, n+1):
                            # 现在 i 和 j 从 1 开始, 所以要减一
                            if word1[i - 1] == word2[j - 1]:
                                # word1[i-1] 和 word2[j-1] 必然在 lcs 中
                                dp[i][j] = dp[i-1][j-1] + 1
                            else:
                                # word1[i-1] 和 word2[j-1] 至少有一个不在 lcs 中
                                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
                    return dp[m][n]
                lcs = longestCommonSubsequence()
                return m - lcs + n - lcs
    ```



#### 两个字符串的最小ASCII删除和
- 问题描述
    * 给定两个字符串s1 和 s2, 返回 使两个字符串相等所需删除字符的 ASCII 值的最小和 .
- 思路
    * 思路1
        * 动态规划
    * 思路2
        * 最长公共字符串
- 代码实现
    ```python
        class Solution:
            def minimumDeleteSum(self, s1: str, s2: str) -> int:
                m, n = len(s1), len(s2)
                # 备忘录
                memo = [[-1] * n for _ in range(m)]
                def dp(s1, i, s2, j):
                    """
                    定义：将 s1[i..] 和 s2[j..] 删除成相同字符串, 最小的 ASCII 码之和为 dp(s1, i, s2, j).
                    """
                    res = 0
                    # 如果s1到头了
                    if i == m:
                        for tmp_j in range(j, n):
                            res += ord(s2[tmp_j]) 
                        return res
                    # 如果s2到头了
                    if j == n:
                        for tmp_i in range(i, m):
                            res += ord(s1[tmp_i])
                        return res
                    if memo[i][j] != -1:
                        return memo[i][j]
                    if s1[i] == s2[j]:
                        # s1[i] 和 s2[j] 都是在 lcs 中的, 不用删除
                        memo[i][j] = dp(s1, i+1, s2, j+1)
                    else:
                        # s1[i] 和 s2[j] 至少有一个不在 lcs 中, 删一个
                        memo[i][j] = min(
                            ord(s1[i]) + dp(s1, i+1, s2, j),
                            ord(s2[j]) + dp(s1, i, s2, j+1)
                        )
                    return memo[i][j]
                return dp(s1, 0, s2, 0)
    ```
- 代码实现2
    ```python
        class Solution:
            '''
            问题等价: 求最长公共子序列的最大ASCII码值的和, 
            '''
            def minimumDeleteSum(self, s1: str, s2: str) -> int:
                dp = [[0]*(len(s2)+1) for _ in range(len(s1)+1)]
                for i in range(1,len(s1)+1):
                    for j in range(1,len(s2)+1):
                        if s1[i-1] == s2[j-1]:
                            dp[i][j]=dp[i-1][j-1]+ord(s1[i-1])
                        else:
                            dp[i][j]=max(dp[i-1][j],dp[i][j-1])
                ascSum = 0
                ascSum += sum([ord(char) for char in list(s1)])
                ascSum += sum([ord(char) for char in list(s2)])
                return ascSum - 2*dp[len(s1)][len(s2)]
    ```

#### 最长公共子序列
- 问题描述
    * 给定两个字符串 text1 和 text2, 返回这两个字符串的最长 公共子序列 的长度.如果不存在 公共子序列 , 返回 0 .
- 思路
    * 动态规划就可以了
- 代码实现
    ```python
        class Solution:
            def longestCommonSubsequence(self, text1: str, text2: str) -> int:
                l1, l2 = len(text1), len(text2)
                dp = [[0] * (l2+1) for _ in range(l1+1)]
                for i in range(1, l1+1):
                    for j in range(1, l2+1):
                        if text1[i-1] == text2[j-1]:
                            dp[i][j] = dp[i-1][j-1] + 1
                        else:
                            dp[i][j] = max(
                                dp[i-1][j],
                                dp[i][j-1]
                            )
                return dp[l1][l2]
    ```




