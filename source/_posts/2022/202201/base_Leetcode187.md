---
title: Leetcode_基础 (187)
date: 2022-01-06
tags: Leetcode
toc: true
---

### 今日被问傻系列
    leetcode

<!-- more -->

#### 字符串相加
- Q
    * 给定两个字符串形式的非负整数 num1 和num2 , 计算它们的和并同样以字符串形式返回.
    * 你不能使用任何內建的用于处理大整数的库(比如 BigInteger),  也不能直接将输入的字符串转换为整数形式.
- T
    * 和之前的思路一样 从后往前加 超过10就加1
- A
    ```python
        class Solution:
            def addStrings(self, num1: str, num2: str) -> str:
                result = ""
                carry = 0
                count1, count2 = len(num1) - 1, len(num2) - 1
                while (count1 >= 0) or (count2 >= 0):
                    val1 = num1[count1] if count1 >= 0 else 0
                    val2 = num2[count2] if count2 >= 0 else 0
                    tmp = int(val1) + int(val2) + carry
                    if tmp > 9:
                        tmp -= 10
                        carry = 1
                    else:
                        carry = 0
                    result = "%s%s" % (tmp, result)
                    count1 -= 1
                    count2 -= 1
                if carry == 1:
                    result = "%s%s" % (carry, result)
                return result

            def addStrings1(self, num1: str, num2: str) -> str:
                res = ''
                i1, i2, carry = len(num1) - 1, len(num2) - 1, 0
                while i1 >= 0 or i2 >= 0:
                    x = ord(num1[i1]) - ord('0') if i1 >= 0 else 0
                    y = ord(num2[i2]) - ord('0') if i2 >= 0 else 0

                    sum = x + y + carry
                    res += str(sum % 10)
                    carry = sum // 10

                    i1, i2 = i1 - 1, i2 - 1
                if carry != 0: res += str(carry)
                return res[::-1]
    ```

#### 二进制求和
- Q
    * 给你两个二进制字符串, 返回它们的和(用二进制表示).输入为 非空 字符串且只包含数字 1 和 0
- T
    * 和上边一样
- A
    ```python
        class Solution:
            def addBinary(self, a: str, b: str) -> str:
                result = ""
                carry = 0
                a_len, b_len = len(a)-1, len(b)-1
                while (a_len >= 0) or (b_len >= 0):
                    val_a = a[a_len] if a_len >=0 else 0
                    val_b = b[b_len] if b_len >=0 else 0
                    tmp = carry + int(val_a) + int(val_b)
                    if tmp >= 2:
                        tmp -= 2
                        carry = 1
                    else:
                        carry = 0
                    result = "%s%s" % (tmp, result)
                    a_len, b_len = a_len - 1, b_len - 1
                if carry == 1:
                    result = "%s%s" % (carry, result)
                return result
    ```

#### 两数相加
- Q
    ```
        2->4->3 5->6->4
        输入：l1 = [2,4,3], l2 = [5,6,4]
        输出：[7,0,8]
        解释：342 + 465 = 807.
    ```
- T
    * 因为链表的顺序为 个位 十位 百位, 符合数学计算, 主要有一个不为空, 链表就继续往下走, 有进位就加1
- A
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
                    re = ListNode(0)
                    r=re
                    carry=0
                    while(l1 or l2):
                        x= l1.val if l1 else 0
                        y= l2.val if l2 else 0
                        s=carry+x+y
                        carry=s//10
                        r.next=ListNode(s%10)
                        r=r.next
                        if(l1!=None):l1=l1.next
                        if(l2!=None):l2=l2.next
                    if(carry>0):
                        r.next=ListNode(1)
                    return re.next
    ```


