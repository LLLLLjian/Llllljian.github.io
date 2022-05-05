---
title: 剑指Offer_基础 (21)
date: 2022-04-02
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 顺时针打印矩阵
- 问题描述
    * 输入一个矩阵,按照从外向里以顺时针的顺序依次打印出每一个数字
- 思路
    * 从左到右 从上到下 从右往左 从下往上
- 代码实现
    ```python
        class Solution:
            def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
                # l->r t->b r->l b->t
                res = []
                if not matrix:
                    return res
                l, r, t, b = 0, len(matrix[0])-1, 0, len(matrix)-1
                while True:
                    # l->r
                    for i in range(l, r+1):
                        res.append(matrix[t][i])
                    t += 1
                    if t > b:
                        break
                    # t->b
                    for i in range(t, b+1):
                        res.append(matrix[i][r])
                    r -= 1
                    if r < l:
                        break
                    # r->l
                    for i in range(r, l-1, -1):
                        res.append(matrix[b][i])
                    b -= 1
                    if b < t:
                        break
                    # b->t
                    for i in range(b, t-1, -1):
                        res.append(matrix[i][l])
                    l += 1
                    if l > r:
                        break
                return res
    ```

#### 约瑟夫环
- 问题描述
    * 招聘/猴子找大王/杀人游戏
- 代码实现
    * 数组(模拟)
        ```python
            # 共n人 数到m就杀掉
            def lastRemain(n, m):
                a = [0] * n
                # 当前出局人数
                cnt = 0
                i, k = 0, 0
                while (cnt != n):
                    i += 1
                    if i > n:
                        i = 1
                    if a[i] == 0:
                        k += 1
                        if k == m:
                            a[i] = 1
                            cnt += 1
                            print(i)
                            k = 0
            # 3 6 9 2 7 1 8 5 10 4 None
            # 1 2 3 4 5 6 7 8 9 10
            # 1 2 4 5 6 7 8 9 10       3
            # 1 2 4 5 7 8 9 10         6
            # 1 2 4 5 7 8 10           9
            # 1 4 5 7 8 10             2
            # 1 4 5 8 10               7
            # 4 5 8 10                 1
            # 4 5 10                   8
            # 4 10                     5
            # 4                        10
            #                          4
        ```
    * 循环链表
        ```python
            class ListNode:
                def __init__(self, val=0, next=None):
                    self.val = val
                    self.next = next
            # 链表头插法
            def headInsert(n):
                res = ListNode(0)
                for i in range(n):
                    temp = ListNode(i)
                    temp.next = res
                    res = temp
                return res
            # 链表尾插法
            def rearInsert(n):
                head = rear = ListNode(0)
                for i in range(n):
                    temp = ListNode(i)
                    rear.next = temp
                    rear = temp
                rear.next = None
                return head.next
        ```
    * 递归
        ```python
            # 有N个人,报到数字M时出局,求第i个人出局的编号 
            # ysf(int N,int M,int i)
            # ysf(10, 3, 1) = 2
            # ysf(10, 3, 2) = 5 = ysf(9, 3, 1) + 3
            # ysf(10, 6, 1) = 5
            # ysf(10, 6, 2) = 1 = (ysf(9, 6, 1) + 6) % 10
            # 当i != 1时, ysf(N, M, i) = (ysf(N-1, M, i-1) + M) % N
            # 当i = 1 时, ysf(N, M, 1) = (M - 1 + N) % N
            def ysf(n, m, i):
                if i == 1:
                    return (n-1+m) % n
                else:
                    return (ysf(n-1, m, i-1) + m) % n
            def lastRemain(n, m):
                for i in range(1, n):
                    print("第%s次出环的人是%s" % (i, ysf(n, m, i)))
        ```



