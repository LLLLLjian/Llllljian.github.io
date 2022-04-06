---
title: Leetbook_基础 (4)
date: 2021-12-17
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 字符串
- 字符串的定义
    * 字符串是由零个或多个字符组成的有限序列.一般记为 s = a1a2...an.它是编程语言中表示文本的数据类型
- 字符串和数组异同
    * 同
        * 都可以使用名称\[下标]获取一个字符
    * 异
        * 字符串的基本操作对象通常是字符串整体或者其子串
            * 例如 I like leetcode 的反转如果是 edocteel ekil I 是没有意义的, 我们希望它翻转的结果是 Leetcode like I
        * 符串操作比其他数据类型更复杂(例如比较、连接操作)
- 最长公共前缀
    * Q
        ```
            编写一个函数来查找字符串数组中的最长公共前缀.
            如果不存在公共前缀, 返回空字符串 "".
            示例 1：
            输入：strs = ["flower","flow","flight"]
            输出："fl"
            示例 2：
            输入：strs = ["dog","racecar","car"]
            输出：""
            解释：输入不存在公共前缀.
        ```
    * T
        * 首先明确一点, 最长公共前缀一定取决于最短的字符串, 那我就先找到最短的字符串, 然后循环最短字符串
    * A
        ```python
            class Solution:
                def longestCommonPrefix(self, strs: List[str]) -> str:
                    result = []
                    min_str = strs[0]
                    min_len = len(min_str)
                    for i in strs:
                        if len(i) >= min_len:
                            pass
                        else:
                            min_str = i
                            min_len = len(min_str)
                    for i in range(min_len):
                        flag = False
                        for str in strs:
                            if (str[i] == min_str[i]):
                                flag = True
                            else:
                                flag = False
                                break
                        if flag:
                            result.append(min_str[i])
                        else:
                            break
                    return "".join(result)
        ```
- 最长回文子串
    * Q
        ```
            给你一个字符串 s, 找到 s 中最长的回文子串.
            示例 1：

            输入：s = "babad"
            输出："bab"
            解释："aba" 同样是符合题意的答案.
            示例 2：

            输入：s = "cbbd"
            输出："bb"
            示例 3：

            输入：s = "a"
            输出："a"
            示例 4：

            输入：s = "ac"
            输出："a"
        ```
    * T
        * 选个中心点, 如果他的左右两边有值相等, 就继续往两边扩, 需要注意的是 中心点可能是一个(bab) 也可能是两个(baab)
    * A
        ```python
            class Solution:
                def longestPalindrome(self, s: str) -> str:
                    size = len(s) #首先得到字符串的长度, 方便逐个点遍历
                    res = [] #因为要返回一个最长子串, 所以初始化一个返回参数
                    max_val = 0
                    def num(loc_left, loc_right): #定义一个以某个点为中心, 寻找最长子串的函数
                        while loc_left >= 0 and loc_right < size:#因为要找到最长子串, 所以要利用while函数不停的往两个方向寻找
                            if s[loc_left] == s[loc_right]: #如果左边点与右边点的元素相同, 则继续往两边遍历
                                loc_left -= 1 #往两边遍历, 自然就是左边角标减1
                                loc_right += 1 #往两边遍历, 自然就是右边角标加1
                            else: #如果发现不一样的, 直接跳出, 说明不是回文串
                                break
                        return s[loc_left + 1: loc_right] #函数的返回值即为我们找到的以当前点为中心的最常子串
                    for i in range(size): #因为要以每个点为中心寻找, 自然要逐个遍历
                        res1 = num(i, i) #此时为奇数情况, 以一个点为中心
                        res2 = num(i, i + 1) #此时为偶数情况, 以相邻两个点为中心
                        if max(len(res1), len(res2)) > max_val: #比较两种情况为中心返回的最长子串的长度
                            max_val = max(len(res1), len(res2))#如果当前返回长度比之前的大, 则更新max_val, 即最长子串的长度
                            if len(res1) > len(res2): #此时判断是哪种情况的子串长, 更新返回函数
                                res = res1
                            else:
                                res = res2
                    return res #返回的即为最长子串
        ```
