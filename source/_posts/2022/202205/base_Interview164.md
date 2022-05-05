---
title: Interview_总结 (164)
date: 2022-05-03
tags: 
    - Interview
    - Leetcode
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP 100

<!-- more -->

#### 两数相加
- 问题描述
    * 给你两个 非空 的链表,表示两个非负的整数.它们每位数字都是按照 逆序 的方式存储的,并且每个节点只能存储 一位 数字.请你将两个数相加,并以相同形式返回一个表示和的链表.你可以假设除了数字 0 之外,这两个数都不会以 0 开头.
- 思路
    * 虚拟节点
    * 链表1 or 链表2
    * cur.next = ListNode(temp) cur = cur.next
    * 进位carry的值也要追加到最后
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def addTwoNumbers(self, l1, l2):
                """
                :type l1: ListNode
                :type l2: ListNode
                :rtype: ListNode
                """
                carry = 0
                dummy = ListNode(0)
                cur = dummy
                while (l1 != None) or (l2 != None):
                    x = 0 if l1 == None else l1.val
                    y = 0 if l2 == None else l2.val

                    sum = x + y + carry
                    cur.next = ListNode(sum % 10)
                    cur = cur.next
                    carry = sum // 10

                    l1 = l1.next if l1 != None else None
                    l2 = l2.next if l2 != None else None
                if carry != 0: cur.next = ListNode(carry)
                return dummy.next
    ```

#### 子数组最大平均数I
- 问题描述
    * 你一个由 n 个元素组成的整数数组 nums 和一个整数 k .请你找出平均数最大且 长度为 k 的连续子数组,并输出该最大平均数.
- 思路
    * 定义需要维护的变量
    * 定义窗口的首尾端 (start, end), 然后滑动窗口
    * 更新需要维护的变量 (sum_, max_avg), 不断把当前值积累到sum_上
    * 窗口首指针前移一个单位保证窗口长度固定, 同时提前更新需要维护的变量 (sum_)
- 代码实现
    ```python
        class Solution:
            def findMaxAverage(self, nums: List[int], k: int) -> float:
                # Step 1
                # 定义需要维护的变量
                # 本题求最大平均值 (其实就是求最大和),所以需要定义sum_, 同时定义一个max_avg (初始值为负无穷)
                sum_, max_avg = 0, -math.inf

                # Step 2: 定义窗口的首尾端 (start, end), 然后滑动窗口
                start = 0
                for end in range(len(nums)):
                    # Step 3: 更新需要维护的变量 (sum_, max_avg), 不断把当前值积累到sum_上
                    sum_ += nums[end]
                    if end - start + 1 == k:
                        max_avg = max(max_avg, sum_ / k)

                    # Step 4
                    # 根据题意可知窗口长度固定,所以用if
                    # 窗口首指针前移一个单位保证窗口长度固定, 同时提前更新需要维护的变量 (sum_)
                    if end >= k - 1:
                        sum_ -= nums[start]
                        start += 1
                # Step 5: 返回答案
                return max_avg
    ```

#### 无重复字符的最长子串
- 问题描述
    * 给定一个字符串 s ,请你找出其中不含有重复字符的 最长子串 的长度.
- 思路
    * 滑动窗口 套公式 和上边一样
- 代码实现
    ```python
        class Solution:
            def lengthOfLongestSubstring(self, s: str) -> int:
                # Step 1: 定义需要维护的变量, 本题求最大长度,所以需要定义max_len, 该题又涉及去重,因此还需要一个哈希表
                max_len, hashmap = 0, {}

                # Step 2: 定义窗口的首尾端 (start, end), 然后滑动窗口
                start = 0
                for end in range(len(s)):
                    # Step 3
                    # 更新需要维护的变量 (max_len, hashmap)
                    # i.e. 把窗口末端元素加入哈希表,使其频率加1,并且更新最大长度
                    hashmap[s[end]] = hashmap.get(s[end], 0) + 1
                    if len(hashmap) == end - start + 1:
                        max_len = max(max_len, end - start + 1)
                    
                    # Step 4: 
                    # 根据题意,  题目的窗口长度可变: 这个时候一般涉及到窗口是否合法的问题
                    # 这时要用一个while去不断移动窗口左指针, 从而剔除非法元素直到窗口再次合法
                    # 当窗口长度大于哈希表长度时候 (说明存在重复元素),窗口不合法
                    # 所以需要不断移动窗口左指针直到窗口再次合法, 同时提前更新需要维护的变量 (hashmap)
                    while end - start + 1 > len(hashmap):
                        head = s[start]
                        hashmap[head] -= 1
                        if hashmap[head] == 0:
                            del hashmap[head]
                        start += 1
                # Step 5: 返回答案 (最大长度)
                return max_len
    ```

#### 最长回文子串
- 问题描述
    * 给你一个字符串 s,找到 s 中最长的回文子串.
- 思路
    * 以每个字符为中心点往左右两边进行查找, 要注意奇偶
- 代码实现
    ```python
        class Solution:
            def longestPalindrome(self, s: str) -> str:
                size = len(s) #首先得到字符串的长度,方便逐个点遍历
                res = [] #因为要返回一个最长子串,所以初始化一个返回参数
                max_val = 0
                def num(loc_left, loc_right): #定义一个以某个点为中心,寻找最长子串的函数
                    while loc_left >= 0 and loc_right < size:#因为要找到最长子串,所以要利用while函数不停的往两个方向寻找
                        if s[loc_left] == s[loc_right]: #如果左边点与右边点的元素相同,则继续往两边遍历
                            loc_left -= 1 #往两边遍历,自然就是左边角标减1
                            loc_right += 1 #往两边遍历,自然就是右边角标加1
                        else: #如果发现不一样的,直接跳出,说明不是回文串
                            break
                    return s[loc_left + 1: loc_right] #函数的返回值即为我们找到的以当前点为中心的最常子串
                for i in range(size): #因为要以每个点为中心寻找,自然要逐个遍历
                    res1 = num(i, i) #此时为奇数情况,以一个点为中心
                    res2 = num(i, i + 1) #此时为偶数情况,以相邻两个点为中心
                    if max(len(res1), len(res2)) > max_val: #比较两种情况为中心返回的最长子串的长度
                        max_val = max(len(res1), len(res2))#如果当前返回长度比之前的大,则更新max_val,即最长子串的长度
                        if len(res1) > len(res2): #此时判断是哪种情况的子串长,更新返回函数
                            res = res1
                        else:
                            res = res2
                return res #返回的即为最长子串
    ```

#### 盛最多水的容器
- 问题描述
    * 给定一个长度为 n 的整数数组 height .有 n 条垂线,第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) .找出其中的两条线,使得它们与 x 轴共同构成的容器可以容纳最多的水.返回容器可以储存的最大水量.
- 思路
    * 面积公式: S(i,j)=min(h[i],h[j])×(j−i)
    * 若向内 移动短板 ,水槽的短板 min(h[i], h[j])可能变大,因此下个水槽的面积 可能增大 .
    * 若向内 移动长板 ,水槽的短板 min(h[i], h[j])不变或变小,因此下个水槽的面积 一定变小 .
- 代码实现
    ```python
        class Solution:
            def maxArea(self, height: List[int]) -> int:
                res = 0
                if not height:
                    return res
                l, r = 0, len(height) - 1
                while l < r:
                    # S(i,j) = min(h[i],h[j]) × (j−i)
                    s = min(height[l], height[r]) * (r - l)
                    res = max(res, s)
                    if height[l] > height[r]:
                        r -= 1
                    else:
                        l += 1
                return res
    ```

#### 三数之和
- 问题描述
    * 给你一个包含 n 个整数的数组 nums,判断 nums 中是否存在三个元素 a,b,c ,使得 a + b + c = 0 ？请你找出所有和为 0 且不重复的三元组.
- 思路
    * 特判,对于数组长度 n,如果数组为 null 或者数组长度小于 3,返回 [].
    * 对数组进行排序.
    * 遍历排序后数组：
    * 若 nums[i]>0：因为已经排序好,所以后面不可能有三个数加和等于 0,直接返回结果.
    * 对于重复元素：跳过,避免出现重复解
    * 令左指针 L=i+1,右指针 R=n−1,当 L<R 时,执行循环：
    * 当 nums[i]+nums[L]+nums[R]==0,执行循环,判断左界和右界是否和下一位置重复,去除重复解.并同时将 L,R 移到下一位置,寻找新的解
    * 若和大于 0,说明 nums[R] 太大,R 左移
    * 若和小于 0,说明 nums[L] 太小,L 右移
- 代码实现
    ```python
        class Solution:
            def threeSum(self, nums: List[int]) -> List[List[int]]:
                
                n=len(nums)
                res=[]
                if(not nums or n<3):
                    return []
                nums.sort()
                res=[]
                for i in range(n):
                    if(nums[i]>0):
                        return res
                    if(i>0 and nums[i]==nums[i-1]):
                        continue
                    L=i+1
                    R=n-1
                    while(L<R):
                        if(nums[i]+nums[L]+nums[R]==0):
                            res.append([nums[i],nums[L],nums[R]])
                            while(L<R and nums[L]==nums[L+1]):
                                L=L+1
                            while(L<R and nums[R]==nums[R-1]):
                                R=R-1
                            L=L+1
                            R=R-1
                        elif(nums[i]+nums[L]+nums[R]>0):
                            R=R-1
                        else:
                            L=L+1
                return res
    ```

