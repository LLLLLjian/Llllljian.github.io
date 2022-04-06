---
title: Leetbook_基础 (6)
date: 2021-12-21
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 双指针技巧
> 头尾指针
- 经典问题
    * Q
        ```
            反转数组中的元素.比如数组为 ['l', 'e', 'e', 't', 'c', 'o', 'd', 'e'], 反转之后变为 ['e', 'd', 'o', 'c', 't', 'e', 'e', 'l']
        ```
    * T
        * 双指针, 一个从前往后, 一个从后往前, 到中间就暂停
    * A
        ```python
            def reverseString(self, s):
                i, j = 0, len(s) - 1
                while i < j:
                    s[i], s[j] = s[j], s[i]
                    i += 1
                    j -= 1
        ```
- 反转字符串
    * Q
        ```
            编写一个函数, 其作用是将输入的字符串反转过来.输入字符串以字符数组 s 的形式给出.

            不要给另外的数组分配额外的空间, 你必须原地修改输入数组、使用 O(1) 的额外空间解决这一问题.

            示例 1：
            输入：s = ["h","e","l","l","o"]
            输出：["o","l","l","e","h"]
            示例 2：
            输入：s = ["H","a","n","n","a","h"]
            输出：["h","a","n","n","a","H"]
        ```
    * T
        * 思路和上边是一样的
    * A
        ```python
            class Solution:
                def reverseString(self, s: List[str]) -> None:
                    """
                    Do not return anything, modify s in-place instead.
                    """
                    start, end = 0, len(s) - 1
                    while (start < end):
                        s[start], s[end] = s[end], s[start]
                        start += 1
                        end -= 1
        ```

