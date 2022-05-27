---
title: 读书笔记 (42)
date: 2022-05-26
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-单调栈

<!-- more -->

#### 单调栈模板
- 问题描述
    * 输入一个数组 nums,请你返回一个等长的结果数组,结果数组中对应索引存储着下一个更大元素,如果没有更大的元素,就存 -1
- 思路
    * 把数组的元素想象成并列站立的人,元素大小想象成人的身高.这些人面对你站成一列,如何求元素「2」的下一个更大元素呢？很简单,如果能够看到元素「2」,那么他后面可见的第一个人就是「2」的下一个更大元素,因为比「2」小的元素身高不够,都被「2」挡住了,第一个露出来的就是答案
    ![单调栈模板](/img/20220526_1.png)
- 代码实现
    ```python
        def nextGreaterElement(nums):
            res = [0] * len(nums)
            s = []
            # 从后往前
            for i in range(len(nums)-1, -1, -1):
                # 判定个子高矮
                while (s and s[-1] <= nums[i]):
                    # 矮个起开,反正也被挡着了
                    s.pop()
                # nums[i] 身后的更大元素
                res[i] = -1 if not s else s[-1]
                s.append(nums[i])
            return res
        
        nums = [2,1,2,4,3]
        print(nextGreaterElement(nums))
        # [4, 2, 4, -1, -1]
    ```

#### 下一个更大元素I
- 问题描述
    * nums1 中数字 x 的 下一个更大元素 是指 x 在 nums2 中对应位置 右侧 的 第一个 比 x 大的元素.给你两个 没有重复元素 的数组 nums1 和 nums2 ,下标从 0 开始计数,其中nums1 是 nums2 的子集.对于每个 0 <= i < nums1.length ,找出满足 nums1[i] == nums2[j] 的下标 j ,并且在 nums2 确定 nums2[j] 的 下一个更大元素 .如果不存在下一个更大元素,那么本次查询的答案是 -1 .返回一个长度为 nums1.length 的数组 ans 作为答案,满足 ans[i] 是如上所述的 下一个更大元素 .
- 思路
    * 先把 nums2 中每个元素的下一个更大元素算出来存到一个映射里,然后再让 nums1 中的元素去查表即可
- 代码实现
    ```python
        class Solution:
            def nextGreaterElement(self, nums1: List[int], nums2: List[int]) -> List[int]:
                res = [0] * len(nums2)
                s = []
                for j in range(len(nums2)-1, -1, -1):
                    while s and s[-1] <= nums2[j]:
                        s.pop()
                    res[j] = -1 if not s else s[-1]
                    s.append(nums2[j])
                
                temp_res = []
                for num in nums1:
                    temp_res.append(res[nums2.index(num)])
                return temp_res
    ```

#### 每日温度
- 问题描述
    * 给定一个整数数组 temperatures ,表示每天的温度,返回一个数组 answer ,其中 answer[i] 是指在第 i 天之后,才会有更高的温度.如果气温在这之后都不会升高,请在该位置用 0 来代替.
- 思路
    * 和之前的单调栈思路一样, 只不过单调栈中多一个i
- 代码实现
    ```python
        class Solution:
            def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
                res = [0] * len(temperatures)
                s = []
                for i in range(len(temperatures)-1, -1, -1):
                    while s and s[-1][0] <= temperatures[i]:
                        s.pop()
                    if s:
                        res[i] = s[-1][1] - i
                    s.append((temperatures[i], i))
                return res
    ```

#### 下一个更大元素II
- 问题描述
    * 给定一个循环数组 nums ( nums[nums.length - 1] 的下一个元素是 nums[0] ),返回 nums 中每个元素的 下一个更大元素 .数字 x 的 下一个更大的元素 是按数组遍历顺序,这个数字之后的第一个比它更大的数,这意味着你应该循环地搜索它的下一个更大的数.如果不存在,则输出 -1 .
- 思路
    * 最简单的办法, nums直接乘2, 然后返回一般的结果就可以了
- 代码实现
    ```python
        class Solution:
            def nextGreaterElements(self, nums: List[int]) -> List[int]:
                nums = nums * 2
                res = [-1] * len(nums)
                s = []
                for i in range(len(nums)-1, -1, -1):
                    while s and s[-1] <= nums[i]:
                        s.pop()
                    if s:
                        res[i] = s[-1]
                    s.append(nums[i])
                return res[0:len(nums)//2]
    ```

#### 去除重复字母
- 问题描述
    * 给你一个字符串 s ,请你去除字符串中重复的字母,使得每个字母只出现一次.需保证 返回结果的字典序最小(要求不能打乱其他字符的相对位置).
- 思路
    * 利用单调栈, 实现去重和判断大小
    * 建立一个字典.其中 key 为 字符 c,value 为其出现的剩余次数.
    * 从左往右遍历字符串,每次遍历到一个字符,其剩余出现次数 - 1.
    * 对于每一个字符,如果其对应的剩余出现次数大于 1,我们可以选择丢弃(也可以选择不丢弃),否则不可以丢弃.
    * 是否丢弃的标准和上面题目类似.如果栈中相邻的元素字典序更大,那么我们选择丢弃相邻的栈中的元素.
- 代码实现
    ```python
        class Solution:
            def removeDuplicateLetters(self, s: str) -> str:
                """
                1. 要去重
                2. 去重字符串中的字符顺序不能打乱 s 中字符出现的相对顺序
                3. 在所有符合上一条要求的去重字符串中,字典序最小的作为最终结果
                """
                stack = []
                seen = set()
                remain_counter = collections.Counter(s)

                for c in s:
                    if c not in seen:
                        while stack and c < stack[-1] and  remain_counter[stack[-1]] > 0:
                            seen.discard(stack.pop())
                        seen.add(c)
                        stack.append(c)
                    remain_counter[c] -= 1
                return ''.join(stack)
    ```

#### 移掉K位数字
- 问题描述
    * 给你一个以字符串表示的非负整数 num 和一个整数 k ,移除这个数中的 k 位数字,使得剩下的数字最小.请你以字符串形式返回这个最小的数字.
- 思路
    * abcd > acbd的话, 1204 > 1024. 那么一定有 b>c, 所以只要从左往右找到一个 i>i+1的,移除i即可 104
    * 很简单的可以想到递归, 但是递归容易超时, 那不用递归的话 就想到了用单调栈去实现
- 代码实现
    ```python
        class Solution:
            def removeKdigits(self, num: str, k: int) -> str:
                """
                递归 会超时
                """
                if k == len(num):
                    return "0"
                if k == 0:
                    return str(int(num))
                for i in range(len(num)-1):
                    if num[i+1] < num[i]:
                        return self.removeKdigits(num[:i]+num[i+1:], k-1)
                    if i == len(num)-2:
                        return self.removeKdigits(num[:-1], k-1)

            def removeKdigits(self, num: str, k: int) -> str:
                """
                单调栈
                """
                stack = []
                num_list = list(num)
                remain = len(num) - k
                for temp in num_list:
                    while k and stack and stack[-1] > temp:
                        k -= 1
                        stack.pop()
                    stack.append(temp)
                # 由于已经变成单调递增的数字,所以如果还可以删除,则删除尾部的数字.
                return ''.join(stack[:remain]).lstrip('0') or '0'
    ```


