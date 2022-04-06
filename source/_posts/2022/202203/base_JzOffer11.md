---
title: 剑指Offer_基础 (11)
date: 2022-03-14
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 所有子集
- 题目描述
    * 给定一个整数数组 nums ,数组中的元素 互不相同 .返回该数组所有可能的子集(幂集).解集 不能 包含重复的子集.你可以按 任意顺序 返回解集.
- 思路
    * 来了一个新的,和所有大哥握手,排在最后面,答案长度变成原来的2倍
- 代码实现
    ```python
        class Solution:
            def subsets(self, nums: List[int]) -> List[List[int]]:
                ans=[[]]
                for i in nums:
                    k=len(ans)
                    for j in range(k):
                        c = ans[j] + [i]
                        ans.append(c)
                return ans
    ```


#### 打印字符串中所有字符的排列
- 题目描述
    * 输入一个字符串,按字典序打印出该字符串中字符的所有排列.例如输 入字符串 abc,则打印出由字符 a,b,c 所能排列出来的所有字符串 abc,acb,bac,bca,cab 和 cba.
- 思路
    * 将当前位置的字符和前一个字符位置交换,递归
- 代码实现
    ```python
        class Solution:
            def permutation(self, s: str) -> List[str]:
                c, res = list(s), []
                def dfs(x):
                    if x == len(c) - 1:
                        res.append(''.join(c))   # 添加排列方案
                        return
                    dic = set()
                    for i in range(x, len(c)):
                        if c[i] in dic: continue # 重复,因此剪枝
                        dic.add(c[i])
                        c[i], c[x] = c[x], c[i]  # 交换,将 c[i] 固定在第 x 位
                        dfs(x + 1)               # 开启固定第 x + 1 位字符
                        c[i], c[x] = c[x], c[i]  # 恢复交换
                dfs(0)
                return res
    ```

#### 
- 题目描述
    * 数组中有一个数字出现的次数超过数组长度的一半,请找出这个数 字.如果不存在则输出 0.
- 思路
    * 将首次出现的数 count+1,与之后的数进行比较,相等则+1,否则—1,最 后进行校验是否超过长度的一半.
    * 极限一换一
- 代码实现
    ```python
        class Solution:
            def majorityElement(self, nums: List[int]) -> int:
                v = 0
                for num in nums:
                    if v == 0:
                        x = num
                    if x == num:
                        v += 1
                    else:
                        v -= 1
                return x
    ```

