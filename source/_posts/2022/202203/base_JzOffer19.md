---
title: 剑指Offer_基础 (19)
date: 2022-03-31
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 求两个乘积最小的数
- 题目描述
    * 输入一个递增排序的数组和一个数字 S,在数组中查找两个数,是的他们的和正好是 S,如果有多对数字的和等于 S,输出两个数的乘积最小的
- 思路
    * 定义两个指针,分别从前面和后面进行遍历.间隔越远乘积越小,所以是最先出现的两个数乘积最小
- 代码实现
    ```python
        class Solution:
            def twoSum(self, nums: List[int], target: int) -> List[int]:
                res = []
                if not nums:
                    return res
                l, r = 0, len(nums)-1
                while l < r:
                    if nums[l] + nums[r] == target:
                        res.append(nums[l])
                        res.append(nums[r])
                        break
                    elif nums[l] + nums[r] > target:
                        r -= 1
                    else:
                        l += 1
                return res
    ```

#### 反转字符串
- 题目描述
    * 输入一个英文句子,翻转句子中单词的顺序,但单词内字符的顺序不变
- 思路
    * 字符串转列表 然后双指针替换就可以了
- 代码实现
    ````python
        class Solution:
            def reverseWords(self, s: str) -> str:
                if not s:
                    return s
                tempList = s.split(" ")
                tempList = list(filter(None, tempList))
                l, r = 0, len(tempList) - 1
                while l < r:
                    tempList[l], tempList[r] = tempList[r], tempList[l]
                    l += 1
                    r -= 1
                return " ".join(tempList)
        class Solution:
            def reverseWords(self, s: str) -> str:
                s = s.strip() # 删除首尾空格
                i = j = len(s) - 1
                res = []
                while i >= 0:
                    while i >= 0 and s[i] != ' ': i -= 1 # 搜索首个空格
                    res.append(s[i + 1: j + 1]) # 添加单词
                    while s[i] == ' ': i -= 1 # 跳过单词间空格
                    j = i # j 指向下个单词的尾字符
                return ' '.join(res) # 拼接并返回
    ```

#### 将字符串循环左移K位
- 问题描述
    * 对于一个给定的字符序列S,请你把其循环左移K位后的序列输出
- 思路
    * 拼接或反转三次字符串
- 代码实现
    ```python
        class Solution:
            def reverseLeftWords(self, s: str, n: int) -> str:
                return "%s%s" % (s[n:], s[:n])
    ```
