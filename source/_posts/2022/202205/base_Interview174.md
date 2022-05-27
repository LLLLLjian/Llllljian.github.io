---
title: Interview_总结 (174)
date: 2022-05-21
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 字符串的排列
- 问题描述
    * 输入一个字符串,打印出该字符串中字符的所有排列.
- 思路
    * 加一个排序, 加一个额外的剪枝
    * 新增了 not used[i - 1] 的逻辑判断
        * 考虑[1,1',1'',2]
        * 使用!used[i-1],递归过程中有一个情况是,已经选择了1,正在判定是否选择1'',但由于前一个1' 没有被使用(!used[i-1]) ,所以continue剪枝,所以最终只会有1,1',1''...的顺序排列
        * 使用used[i-1],递归过程中有一个情况是,已经选择了1,正在判定是否选择1'',但由于前一个1' 已经被使用(used[i-1]) ,所以continue剪枝,所以最终会有1,1'',1'...的乱序排列
- 代码实现
    ```python
        class Solution:
            def permutation(self, s: str) -> List[str]:
                res = []
                nums = list(s)
                nums.sort()
                used = {}
                def backtrack(path, nums, used):
                    # 先写条件
                    if len(path) == len(nums):
                        res.append("".join(path))
                        return
                    for i in range(len(nums)):
                        if i in used and used[i]:
                            continue
                        # 新添加的剪枝逻辑,固定相同的元素在排列中的相对位置
                        if (i > 0) and (nums[i] == nums[i-1]) and (not used[i-1]):
                            # 如果前面的相邻相等元素没有用过,则跳过
                            continue
                        path.append(nums[i])
                        used[i] = True
                        backtrack(path, nums, used)
                        path.pop()
                        used[i] = False
                backtrack([], nums, used)
                return res
    ```

#### K个一组翻转链表
- 问题描述
    * 给你链表的头节点 head ,每 k 个节点一组进行翻转,请你返回修改后的链表.
- 思路
    * 先反转前k个节点, 然后再递归就可以了
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def reverseKGroup(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
                if not head:
                    return head
                a, b = head, head
                # 1. 先反转前k个节点
                for _ in range(k):
                    if b:
                        b = b.next
                    else:
                        return head
                # 2. 反转部分节点
                newHead = self.reverse(a, b)
                # 3. 递归
                a.next = self.reverseKGroup(b, k)
                return newHead

            def reverse(self, head, head1):
                """
                翻转部分链表, 直到head1
                """
                if not head:
                    return head
                cur = head
                pre = None
                while cur != head1:
                    temp = cur.next
                    cur.next = pre
                    pre = cur
                    cur = temp
                return pre
    ```

#### 最长回文子串
- 问题描述
    * 给你一个字符串 s,找到 s 中最长的回文子串.
- 思路
    * 要考虑中心是奇数还是偶数, 然后就是查找最长回文串了
- 代码实现
    ```python
        class Solution:
            def longestPalindrome(self, s: str) -> str:
                res = ""
                def palindrome(s, l, r):
                    # 防止索引越界
                    while (l >= 0) and (r < len(s)) and (s[l] == s[r]):
                        # 双指针,向两边展开
                        l -= 1
                        r += 1
                    # 返回以 s[l] 和 s[r] 为中心的最长回文串
                    return s[l+1:r]
                for i in range(len(s)):
                    # 以 s[i] 为中心的最长回文子串
                    s1 = palindrome(s, i, i)
                    # 以 s[i] 和 s[i+1] 为中心的最长回文子串
                    s2 = palindrome(s, i, i+1)
                    res = s1 if len(s1) > len(res) else res
                    res = s2 if len(s2) > len(res) else res
                return res
    ```

#### 和为K的子数组
- 问题描述
    * 给你一个整数数组 nums 和一个整数 k ,请你统计并返回 该数组中和为 k 的子数组的个数 
- 思路
    * 直接开始累加, 后续操作可以参考两数之和
- 代码实现
    ```python
        class Solution:
            def subarraySum(self, nums: List[int], k: int) -> int:
                n = len(nums)
                ans = sumi = 0
                d = {0:1}
                for i in range(n):
                    sumi += nums[i]
                    sumj = sumi - k # 找另一半
                    if sumj in d: ans += d[sumj]
                    d[sumi] = d.get(sumi,0)+1 #更新dict
                return ans
    ```


