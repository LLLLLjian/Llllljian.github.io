---
title: Leetbook_基础 (5)
date: 2021-12-20
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-数组和字符串

<!-- more -->

#### 字符串
- 翻转字符串里的单词
    * Q
        ```
            给你一个字符串 s , 逐个翻转字符串中的所有 单词 .

            单词 是由非空格字符组成的字符串.s 中使用至少一个空格将字符串中的 单词 分隔开.

            请你返回一个翻转 s 中单词顺序并用单个空格相连的字符串.

            说明：

            输入字符串 s 可以在前面、后面或者单词间包含多余的空格.
            翻转后单词间应当仅用一个空格分隔.
            翻转后的字符串中不应包含额外的空格.

            示例 1：

            输入：s = "the sky is blue"
            输出："blue is sky the"
            示例 2：

            输入：s = "  hello world  "
            输出："world hello"
            解释：输入字符串可以在前面或者后面包含多余的空格, 但是翻转后的字符不能包括.
            示例 3：

            输入：s = "a good  example"
            输出："example good a"
            解释：如果两个单词间有多余的空格, 将翻转后单词间的空格减少到只含一个.
            示例 4：

            输入：s = "  Bob    Loves  Alice   "
            输出："Alice Loves Bob"
            示例 5：

            输入：s = "Alice does not even like bob"
            输出："bob like even not does Alice"
        ```
    * T
        * 不想直接用系统函数. 先去除两端空格 再去除字符串中多余的空格, 然后整体字符串反转, 然后再单个单词反转
    * A
        ```python
            class Solution:
                # 去除多余空格
                def removeSpaces(self, s):
                    # 初始化双指针
                    left, right = 0, len(s) - 1

                    # 去除开头的空格
                    while left < right and s[left] == ' ':
                        left += 1
                    # 去除结尾的空格
                    while left < right and s[right] == ' ':
                        right -= 1
                    # new_s 存储去掉多余空格剩下的东西
                    new_s = []
                    # 去除单词间多余的空格
                    while left <= right:
                        if s[left] != ' ':
                            new_s.append(s[left])
                        # 如果当前是空格, 且前一个字符不是空格, 则添加
                        elif s[left] == ' ' and new_s[-1] != ' ':
                            new_s.append(s[left])
                        left += 1

                    return new_s

                # 反转字符串
                def reverseString(self, s):
                    # 初始化双指针
                    left, right = 0, len(s) - 1

                    # 这种方法可以不用判断元素奇偶
                    while left < right:
                        s[left], s[right] = s[right], s[left]
                        # 交换后, 左指针右移, 右指针左移
                        left += 1
                        right -= 1
                    return s

                # 反转每个单词
                def reverseEachword(self, s):
                    # 初始化指向每个单词前后的指针
                    left, right = 0, 0
                    n = len(s)

                    while left < n:
                        while right < n and s[right] != ' ':
                            right += 1
                        s[left : right] = self.reverseString(s[left : right])
                        # 反转完一个单词, 该反转下个单词了
                        left = right + 1
                        right += 1
                    return s

                def reverseWords(self, s: str) -> str:
                    # 第 1 步：去除空格
                    s = self.removeSpaces(s)
                    # 第 2 步：反转字符串
                    s = self.reverseString(s)
                    # 第 3 步：反转每个单词
                    s = self.reverseEachword(s)
                    # 第 4 步：输出翻转后的字符串
                    return ''.join(s)
        ```
- 实现 strStr()
    * Q
        ```
            实现 strStr() 函数.

            给你两个字符串 haystack 和 needle , 请你在 haystack 字符串中找出 needle 字符串出现的第一个位置(下标从 0 开始).如果不存在, 则返回  -1 .

            说明：

            当 needle 是空字符串时, 我们应当返回什么值呢？这是一个在面试中很好的问题.
            对于本题而言, 当 needle 是空字符串时我们应当返回 0 .这与 C 语言的 strstr() 以及 Java 的 indexOf() 定义相符.

            示例 1：
            输入：haystack = "hello", needle = "ll"
            输出：2
            示例 2：
            输入：haystack = "aaaaa", needle = "bba"
            输出：-1
            示例 3：
            输入：haystack = "", needle = ""
            输出：0
        ```
    * T
        * KMP 我觉得有点难, 最后再看吧
        * 步骤一: 判断传入第2个字符串是否为空, 若为空返回0, 否则执行步骤二;
        * 步骤二: 遍历第1个字符串, 与第2个字符串中首字母比较, 若不存在返回-1, 若存在执行步骤三;
        * 步骤三: 在第1个字符串中, 找到相同字母位置处开始切片, 大小为第2个字符串长度；将第2个字符串与切片后的字符串进行比较, 若相等, 返回首字母在第1个字符串中的下标, 否则跳出本次循环, 在后续字符串中重复执行步骤三, 直至找到.
    * A
        ```python
            class Solution:
                def strStr(self, haystack: str, needle: str) -> int:
                    if needle == '':
                        return 0
                    else:
                        for i in range(len(haystack)):
                            if haystack[i] == needle[0]:
                                if haystack[i:i+len(needle)] == needle:
                                    return i
                                else:
                                    continue
                        return -1
        ```
