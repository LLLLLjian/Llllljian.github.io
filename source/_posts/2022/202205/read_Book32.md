---
title: 读书笔记 (32)
date: 2022-05-16
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-滑动窗口

<!-- more -->

#### 滑动窗口模版
- base
    ```
        int left = 0, right = 0;
        while (right < s.size()) {
            // 增大窗口
            window.add(s[right]);
            right++;
            
            while (window needs shrink) {
                // 缩小窗口
                window.remove(s[left]);
                left++;
            }
        }
    ```
- demo
    ```
        /* 滑动窗口算法框架 */
        void slidingWindow(string s, string t) {
            unordered_map<char, int> need, window;
            for (char c : t) need[c]++;
            
            int left = 0, right = 0;
            int valid = 0; 
            while (right < s.size()) {
                // c 是将移入窗口的字符
                char c = s[right];
                // 增大窗口
                right++;
                // 进行窗口内数据的一系列更新
                ...

                /*** debug 输出的位置 ***/
                printf("window: [%d, %d)\n", left, right);
                /********************/
                
                // 判断左侧窗口是否要收缩
                while (window needs shrink) {
                    // d 是将移出窗口的字符
                    char d = s[left];
                    // 缩小窗口
                    left++;
                    // 进行窗口内数据的一系列更新
                    ...
                }
            }
        }
    ```
- 现在开始套模板,只需要思考以下四个问题
1. 当移动 right 扩大窗口,即加入字符时,应该更新哪些数据
2. 什么条件下,窗口应该暂停扩大,开始移动 left 缩小窗口
3. 当移动 left 缩小窗口,即移出字符时,应该更新哪些数据
4. 我们要的结果应该在扩大窗口时还是缩小窗口时进行更新

#### 最小覆盖子串
- 问题描述
    * 给你一个字符串s、一个字符串t.返回s中涵盖t所有字符的最小子串.如果s中不存在涵盖t所有字符的子串,则返回空字符串""
- 思路
    * 我们在字符串 S 中使用双指针中的左右指针技巧,初始化 left = right = 0,把索引左闭右开区间 [left, right) 称为一个「窗口」
        * 设计为左闭右开区间是最方便处理的.因为这样初始化 left = right = 0 时区间 [0, 0) 中没有元素,但只要让 right 向右移动(扩大)一位,区间 [0, 1) 就包含一个元素 0 了
    * 我们先不断地增加 right 指针扩大窗口 [left, right),直到窗口中的字符串符合要求(包含了 T 中的所有字符)
    * 此时,我们停止增加 right,转而不断增加 left 指针缩小窗口 [left, right),直到窗口中的字符串不再符合要求(不包含 T 中的所有字符了).同时,每次增加 left,我们都要更新一轮结果.
    * 重复第 2 和第 3 步,直到 right 到达字符串 S 的尽头
- 图片解析
    * 初始状态
    ![初始状态](/img/20220516_1.png)
    * 步骤2
    ![步骤2](/img/20220516_2.png)
    * 步骤3
    ![步骤3](/img/20220516_3.png)
- 代码实现
    ```python
        import collections
        import sys
        class Solution:
            def minWindow(self, s: str, t: str) -> str:
                if len(s) < len(t):
                    return ""
                need, window = collections.defaultdict(int), collections.defaultdict(int)
                # 统计需要的字符和对应的数量
                for c in t:
                    need[c] += 1
                valid = 0
                left, right = 0, 0
                start, length = 0, sys.maxsize # sys.maxsize 此处代表最大的int
                while right < len(s):
                    # 增大窗口
                    c = s[right]
                    right += 1
                    # 判断当前进入窗口的字符是否是需要的字符 如果是则更新window中的对应情况
                    if need.get(c):
                        window[c] += 1
                        # 若window中的这个字符数量已经满足需求 合法的字符数量valid增加1
                        if window[c] == need[c]:
                            valid += 1
                    # 合法的字符数量 == 需要的字符个数 满足收缩窗口的条件
                    while valid == len(need):
                        # 更新结果 优化可行解
                        if right - left < length:
                            start = left
                            # 由于每次扩大窗口都对right+1了 所以此时right是目标区间的后一个元素下标 对应切片左闭右开 此处不用+1
                            length = right - left
                        # 缩小窗口
                        d = s[left]
                        left += 1
                        if need.get(d):
                            if window[d] == need[d]:
                                valid -= 1
                            window[d] -= 1
                return "" if length == sys.maxsize else s[start:start+length]
    ```

#### 字符串排列
- 问题描述
    * 给你两个字符串 s1 和 s2 ,写一个函数来判断 s2 是否包含 s1 的排列.如果是,返回 true ；否则,返回 false .换句话说,s1 的排列之一是 s2 的 子串
- 思路
    * 移动 left 缩小窗口的时机是窗口大小大于 t.size() 时,应为排列嘛,显然长度应该是一样的.
    * 当发现 valid == need.size() 时,就说明窗口中就是一个合法的排列,所以立即返回 true.
- 代码实现
    ```python
        import collections
        class Solution:
            def checkInclusion(self, s1: str, s2: str) -> bool:
                # 记录子串中字符出现次数
                need = collections.defaultdict(int)
                # 「窗口」中的相应字符的出现次数
                window = collections.defaultdict(int)
                for temp in s1:
                    need[temp] += 1
                left, right, valid = 0, 0, 0
                while right < len(s2):
                    c = s2[right]
                    right += 1
                    # 进行窗口内数据的一系列更新
                    if need.get(c):
                        window[c] += 1
                        if window[c] == need[c]:
                            valid += 1
                    print("window: [%s, %s), %s" % (left, right, valid));
                    # 判断左侧窗口是否要收缩
                    while (right - left) >= len(s1):
                        # 在这里判断是否找到了合法的子串
                        if (valid == len(need)):
                            return True
                        d = s2[left]
                        left += 1
                        # 进行窗口内数据的一系列更新
                        if need.get(d):
                            if window[d] == need[d]:
                                valid -= 1
                            window[d] -= 1
                return False
    ```

#### 找所有字母异位词
- 问题描述
    * 给定两个字符串 s 和 p,找到 s 中所有 p 的 异位词 的子串,返回这些子串的起始索引.不考虑答案输出的顺序.异位词 指由相同字母重排列形成的字符串(包括相同的字符串).
- 思路
    * 相当于,输入一个串 S,一个串 T,找到 S 中所有 T 的排列,返回它们的起始索引
- 代码实现
    ```python
        class Solution:
            def findAnagrams(self, s: str, p: str) -> List[int]:
                need = {}
                window = {}
                for temp in p:
                    need[temp] = need.get(temp, 0) + 1
                left, right, valid = 0, 0, 0
                res = []
                while right < len(s):
                    c = s[right]
                    right += 1
                    if need.get(c):
                        window[c] = window.get(c, 0) + 1
                        if window[c] == need[c]:
                            valid += 1
                    print(left, right)
                    while (right - left) >= len(p):
                        if valid == len(need):
                            res.append(left)
                        d = s[left]
                        left += 1
                        if need.get(d):
                            if window[d] == need[d]:
                                valid -= 1
                            window[d] -= 1
                return res
    ```


#### 最长无重复子串
- 问题描述
    * 给定一个字符串 s ,请你找出其中不含有重复字符的 最长子串 的长度. 
- 思路
    * 只要更新窗口信息, 当window中的某个元素出现次数大于2时就滑动
- 代码实现
    ```python
        class Solution:
            def lengthOfLongestSubstring(self, s: str) -> int:
                # 1. 定义需要维护的变量
                left, right, res = 0, 0, 0
                window = {}
                # 2. 定义窗口的首尾端 (left, right), 然后滑动窗口
                while right < len(s):
                    # 3. 更新需要维护的变量
                    c = s[right]
                    right += 1
                    # 进行窗口内数据的一系列更新
                    window[c] = window.get(c, 0) + 1
                    # 4. 不断移动窗口左指针直到窗口再次合法, 同时提前更新需要维护的变量
                    while window[c] > 1:
                        d = s[left]
                        left += 1
                        # 进行窗口内数据的一系列更新
                        window[d] -= 1
                    res = max(res, right - left)
                return res
    ```

