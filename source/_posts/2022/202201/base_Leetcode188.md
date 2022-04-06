---
title: Leetcode_基础 (188)
date: 2022-01-07
tags: Leetcode
toc: true
---

### 今日被问傻系列
    leetcode

<!-- more -->

#### 两数相加II
- Q
    * 给你两个 非空 链表来代表两个非负整数.数字最高位位于链表开始位置.它们的每个节点只存储一位数字.将这两数相加会返回一个新的链表
    * 输入：l1 = [7,2,4,3], l2 = [5,6,4]
    * 输出：[7,8,0,7]
- T
    * 链表压入栈中, 然后从栈中往出取, 然后就和 两数相加 一样了
- A
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def addTwoNumbers(self, l1: ListNode, l2: ListNode) -> ListNode:
                carry = 0
                tem = None
                list1, list2 = [], []
                while l1:
                    list1.append(l1.val)
                    l1 = l1.next
                while l2:
                    list2.append(l2.val)
                    l2 = l2.next
                while list1 or list2:
                    if list1:
                        val1 = list1.pop()
                    else:
                        val1 = 0
                    if list2:
                        val2 = list2.pop()
                    else:
                        val2 = 0
                    tmp = val1 + val2 + carry
                    if tmp > 9:
                        tmp -= 10
                        carry = 1
                    else:
                        carry = 0
                    res = ListNode(tmp)
                    res.next = tem
                    tem = res
                if carry == 1:
                    res = ListNode(1)
                    res.next = tem   
                return res
    ```

#### 将一维数组转变成二维数组
- Q
    ```
        给你一个下标从 0 开始的一维整数数组 original 和两个整数 m 和  n .你需要使用 original 中 所有 元素创建一个 m 行 n 列的二维数组.
        original 中下标从 0 到 n - 1 (都 包含 )的元素构成二维数组的第一行, 下标从 n 到 2 * n - 1 (都 包含 )的元素构成二维数组的第二行, 依此类推.
        请你根据上述过程返回一个 m x n 的二维数组.如果无法构成这样的二维数组, 请你返回一个空的二维数组.

        输入：original = [1,2,3,4], m = 2, n = 2
        输出：[[1,2],[3,4]]
        解释：
        构造出的二维数组应该包含 2 行 2 列.
        original 中第一个 n=2 的部分为 [1,2] , 构成二维数组的第一行.
        original 中第二个 n=2 的部分为 [3,4] , 构成二维数组的第二行.

        输入：original = [3], m = 1, n = 2
        输出：[]
        解释：
        original 中只有 1 个元素.
        无法将 1 个元素放满一个 1x2 的二维数组, 所以返回一个空的二维数组.
    ```
- T
    * original的长度不等于m*n的话 直接返回
    * 双重循环, 外层行, 内层列, 循环就好了
- A
    ```python
        class Solution:
            def construct2DArray(self, original: List[int], m: int, n: int) -> List[List[int]]:
                result = []
                if len(original) != m * n:
                    return result
                for i in range(m):
                    tmp = list(range(n))
                    result.append(tmp)
                index = 0
                for line in range(m):
                    for row in range(n):
                        result[line][row] = original[index]
                        index += 1
                return result

            def construct2DArray(self, original: List[int], m: int, n: int) -> List[List[int]]:
                length = len(original)
                if length/m!=n:
                    return []
                res = [[0]*n for _ in range(m)]
                for i in range(m):
                    res[i][:]=original[i*n:i*n+n]
                return res
    ```

#### 按键持续时间最长的键
- Q
    ```
        LeetCode 设计了一款新式键盘, 正在测试其可用性.测试人员将会点击一系列键(总计 n 个), 每次一个.

        给你一个长度为 n 的字符串 keysPressed , 其中 keysPressed[i] 表示测试序列中第 i 个被按下的键.releaseTimes 是一个升序排列的列表, 其中 releaseTimes[i] 表示松开第 i 个键的时间.字符串和数组的 下标都从 0 开始 .第 0 个键在时间为 0 时被按下, 接下来每个键都 恰好 在前一个键松开时被按下.

        测试人员想要找出按键 持续时间最长 的键.第 i 次按键的持续时间为 releaseTimes[i] - releaseTimes[i - 1] , 第 0 次按键的持续时间为 releaseTimes[0] .

        注意, 测试期间, 同一个键可以在不同时刻被多次按下, 而每次的持续时间都可能不同.

        请返回按键 持续时间最长 的键, 如果有多个这样的键, 则返回 按字母顺序排列最大 的那个键.

         

        示例 1：

        输入：releaseTimes = [9,29,49,50], keysPressed = "cbcd"
        输出："c"
        解释：按键顺序和持续时间如下：
        按下 'c' , 持续时间 9(时间 0 按下, 时间 9 松开)
        按下 'b' , 持续时间 29 - 9 = 20(松开上一个键的时间 9 按下, 时间 29 松开)
        按下 'c' , 持续时间 49 - 29 = 20(松开上一个键的时间 29 按下, 时间 49 松开)
        按下 'd' , 持续时间 50 - 49 = 1(松开上一个键的时间 49 按下, 时间 50 松开)
        按键持续时间最长的键是 'b' 和 'c'(第二次按下时), 持续时间都是 20
        'c' 按字母顺序排列比 'b' 大, 所以答案是 'c'
        示例 2：

        输入：releaseTimes = [12,23,36,46,62], keysPressed = "spuda"
        输出："a"
        解释：按键顺序和持续时间如下：
        按下 's' , 持续时间 12
        按下 'p' , 持续时间 23 - 12 = 11
        按下 'u' , 持续时间 36 - 23 = 13
        按下 'd' , 持续时间 46 - 36 = 10
        按下 'a' , 持续时间 62 - 46 = 16
        按键持续时间最长的键是 'a' , 持续时间 16
    ```
- T
    * 先算出每个键的时间 然后比较
- A
    ```python
        class Solution:
            def slowestKey(self, releaseTimes: List[int], keysPressed: str) -> str:
                resultList = []
                for i in range(len(releaseTimes)):
                    if i == 0:
                        resultList.append(releaseTimes[i])
                    else :
                        resultList.append(releaseTimes[i] - releaseTimes[i-1])
                maxKey = 0
                maxValue = keysPressed[maxKey]
                for key, value in enumerate(resultList):
                    if value > maxKey:
                        maxKey = value
                        maxValue = keysPressed[key]
                    elif value == maxKey:
                        if keysPressed[key] > maxValue:
                            maxKey = value
                            maxValue = keysPressed[key]
                        else:
                            pass
                    else:
                        pass
                return maxValue
    
            def slowestKey(self, releaseTimes: List[int], keysPressed: str) -> str:
                ans, m = keysPressed[0], releaseTimes[0]
                for i in range(1, len(releaseTimes)):
                    if (diff := releaseTimes[i] - releaseTimes[i-1]) > m:
                        ans, m = keysPressed[i], diff
                    elif diff == m:
                        ans = max(ans, keysPressed[i])
                return ans
    ```



