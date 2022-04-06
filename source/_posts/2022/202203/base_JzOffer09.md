---
title: 剑指Offer_基础 (09)
date: 2022-03-08
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 顺时针打印矩阵
- 题目描述
    * 输入一个矩阵,按照从外向里以顺时针的顺序依次打印出每一个数 字,例如,如果输入如下 4X4 矩阵: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 则依次 打印出数字 1,2,3,4,8,12,16,15,14,13,9,5,6,7,11,10.
- 思路
    * 按层模拟:终止行号大于起始行号,终止列号大于起始列号
- 代码实现
    * 时间复杂度:O(n),空间复杂度:O(n),其中 n 表示矩阵元素个数
    ```python
        class Solution:
            def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
                if not matrix or not matrix[0]:
                    return []
                rows, columns = len(matrix), len(matrix[0])
                order = []
                left, right, top, bottom = 0, columns - 1, 0, rows - 1
                while left <= right and top <= bottom:
                    for column in range(left, right + 1):
                        # 从左往右
                        order.append(matrix[top][column])
                    for row in range(top + 1, bottom + 1):
                        # 从上往下
                        order.append(matrix[row][right])
                    if left < right and top < bottom:
                        for column in range(right - 1, left, -1):
                            # 从右往左
                            order.append(matrix[bottom][column])
                        for row in range(bottom, top, -1):
                            # 从下往上
                            order.append(matrix[row][left])
                    left, right, top, bottom = left + 1, right - 1, top + 1, bottom - 1
                return order
    ```

#### 包含main函数的栈
- 题目描述
    * 定义栈的数据结构,请在该类型中实现一个能够得到栈最小元素的 min函数
- 思路
    * 定义两个栈,一个存放入的值.另一个存最小值
- 代码实现
    ```python
        class MinStack:
            def __init__(self):
                self.A, self.B = [], []

            def push(self, x: int) -> None:
                """
                将 x 压入栈 A (即 A.add(x) )；
                若 ① 栈 B 为空 或 ② x 小于等于 栈 B 的栈顶元素,则将 x 压入栈 B (即 B.add(x) ).
                """
                self.A.append(x)
                if not self.B or self.B[-1] >= x:
                    self.B.append(x)

            def pop(self) -> None:
                """
                执行栈 A 出栈(即 A.pop() ),将出栈元素记为 y ；
                若 y 等于栈 B 的栈顶元素,则执行栈 B 出栈(即 B.pop() ).
                """
                if self.A.pop() == self.B[-1]:
                    self.B.pop()

            def top(self) -> int:
                """
                直接返回栈 A 的栈顶元素即可,即返回 A.peek() .
                """
                return self.A[-1]

            def min(self) -> int:
                """
                直接返回栈 BB 的栈顶元素即可,即返回 B.peek() .
                """
                return self.B[-1]


        # Your MinStack object will be instantiated and called as such:
        # obj = MinStack()
        # obj.push(x)
        # obj.pop()
        # param_3 = obj.top()
        # param_4 = obj.min()
    ```

#### 判断一个栈是否是另一个栈的弹出序列
- 题目描述:输入两个整数序列,第一个序列表示栈的压入顺序,请判断第二个序 列是否为该栈的弹出顺序.假设压入栈的所有数字均不相等.例如序列 1,2,3,4,5 是某栈的压入顺序,序列 4,5,3,2,1 是该压栈序列对应的一个弹出序列,但 4,3,5,1,2 就不可能是该压栈序列的弹出序列.(注意:这两个序列的长度是相等 的)
- 思路:用栈来压入弹出元素,相等则出栈
- 代码实现
    ```python
        class Solution:
            def validateStackSequences(self, pushed: List[int], popped: List[int]) -> bool:
                """
                用栈来压入弹出元素,相等则出栈.
                """
                stack, i = [], 0
                for num in pushed:
                    stack.append(num) # num 入栈
                    while stack and stack[-1] == popped[i]: # 循环判断与出栈
                        stack.pop()
                        i += 1
                return not stack
    ```






