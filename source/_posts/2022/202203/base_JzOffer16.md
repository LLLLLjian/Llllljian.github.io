---
title: 剑指Offer_基础 (16)
date: 2022-03-28
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 第一个出现一次的字符
- 题目描述
    * 在一个字符串(1<=字符串长度<=10000,全部由字母组成)中找到第一个只出现一次的字符,并返回它的位置
- 思路
    * 利用 LinkedHashMap 保存字符和出现次数
- 代码实现
    ```python
        class Solution:
            def firstUniqChar(self, s: str) -> str:
                if not s:
                    return " "
                res = {}
                count = len(s)
                for i in range(count):
                    if s[i] in res:
                        res[s[i]] += 1
                    else:
                        res[s[i]] = 0
                for k, v in res.items():
                    if v == 0:
                        return k
                return " "
    ```

#### 数组中逆序对的个数
- 题目描述
    * 在数组中的两个数字,如果前面一个数字大于后面的数字,则这两个数字组成一个逆序对.输入一个数组,求出这个数组中的逆序对的总数 P
- 思路
    * 归并排序
- 代码实现
    ```python
        class Solution:
            def reversePairs(self, nums: List[int]) -> int:
                def merge_sort(l, r):
                    # 终止条件
                    if l >= r: return 0
                    # 递归划分
                    m = (l + r) // 2
                    res = merge_sort(l, m) + merge_sort(m + 1, r)
                    # 合并阶段
                    i, j = l, m + 1
                    tmp[l:r + 1] = nums[l:r + 1]
                    for k in range(l, r + 1):
                        if i == m + 1:
                            nums[k] = tmp[j]
                            j += 1
                        elif j == r + 1 or tmp[i] <= tmp[j]:
                            nums[k] = tmp[i]
                            i += 1
                        else:
                            nums[k] = tmp[j]
                            j += 1
                            res += m - i + 1 # 统计逆序对
                    return res
                
                tmp = [0] * len(nums)
                return merge_sort(0, len(nums) - 1)
    ```


