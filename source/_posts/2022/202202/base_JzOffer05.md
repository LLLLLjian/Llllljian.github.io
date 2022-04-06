---
title: 剑指Offer_基础 (05)
date: 2022-02-11
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 二进制中1的个数
- 题目描述
    * 输入一个整数, 输出该数二进制表示中 1 的个数.其中负数用补码表示.
- 思路
    * a&(a-1)的结果会将 a 最右边的 1 变为 0, 直到 a = 0, 还可以先将 a&1 !=0, 然后右移 1 位, 但不能计算负数的值, 
    * n & (n - 1) 的技巧可以消除二进制中最后一个 1
- 代码实现
    ```python
        class Solution:
            def hammingWeight(self, n: int) -> int:
                ret = 0
                while n:
                    n &= n - 1
                    ret += 1
                return ret
    ```

#### 数值的整数次方
- 问题描述
    * 实现 pow(x, n) , 即计算 x 的 n 次幂函数(即, xn).不得使用库函数, 同时不需要考虑大数问题
- 思路
    * 递归就挺好的,  用下边注释里的规律就可以了
- 代码实现
    ```python
        class Solution:
            """
            递归
            如果n == 0, 返回1
            如果n < 0, 最终结果为 1/pow(x, -n)
            如果n为奇数, 最终结果为 x * pow(x, n-1) 
            如果n为偶数, 最终结果为 pow(x, 2*(n/2))
            """
            def myPow(self, x: float, n: int) -> float:
                if n == 0:
                    return 1
                elif n < 0:
                    return 1/self.myPow(x, -n)
                elif n & 1:
                    return x * self.myPow(x, n - 1)
                else:
                    return self.myPow(x*x, n // 2)

            def myPow(self, x: float, n: int) -> float:
                """
                迭代
                """
                if n < 0:
                    x = 1 / x
                    n = - n
                res = 1
                while n:
                    if n & 1:
                        res *= x
                    n >>= 1
                    x *= x
                return res
    ```

#### 求1到最大的n位数
- 题目描述
    * 输入数字 n, 按顺序打印从 1 到最大的 n 位数十进制数, 比如:输入3, 打印出 1 到 999
- 思路
    * 考虑大数问题, 使用字符串或数组表示
- 代码实现
    ```python
        class Solution:
            def printNumbers(self, n: int) -> List[int]:
                max = pow(10, n)
                res = []
                for i in range(1, max):
                    res.append(i)
                return res

        class Solution:
            def printNumbers(self, n: int) -> [int]:
                def dfs(x):
                    if x == n:
                        s = ''.join(num[self.start:])
                        if s != '0': res.append(int(s))
                        if n - self.start == self.nine: self.start -= 1
                        return
                    for i in range(10):
                        if i == 9: self.nine += 1
                        num[x] = str(i)
                        dfs(x + 1)
                    self.nine -= 1
                
                num, res = ['0'] * n, []
                self.nine = 0
                self.start = n - 1
                dfs(0)
                return res
    ```

