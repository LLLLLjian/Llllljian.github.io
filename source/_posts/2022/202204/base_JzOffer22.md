---
title: 剑指Offer_基础 (22)
date: 2022-04-06
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 圆圈中最后剩下的数
- 题目描述
    * 圆圈中最后剩下的数字(约瑟夫环)
- 思路
    * 利用公式法:f[n] = (f[n-1] + k) % n,或使用循环链表实现
- 代码实现
    ```python
        def lastRemain(n, m):
            last = 0
            for i in range(2, n+1):
                # i 个人时删除数的索引等于 i-1 个人时删除数的索引+k(再对 i 取余)
                last = (last + m) % i
            return last
    ```

#### 求1到n的和
- 题目描述
    * 求 1+2+3+...+n,要求不能使用乘除法、for、while、if、else、switch、case 等关键字及条件判断语句(A?B:C)
- 思路
    * 巧用递归(返回值类型为 Boolean)
- 代码实现
    ```python
        class Solution:
            def __init__(self):
                self.res = 0
            def sumNums(self, n: int) -> int:
                n > 1 and self.sumNums(n - 1)
                self.res += n
                return self.res
    ```

#### 不用加减乘除做加法
- 题目描述
    * 写一个函数,求两个整数之和,要求在函数体内不得使用+、-、*、/四则运算符号
- 思路
    * 利用位运算
    * 可以理解为 进位+无进位
    * 00=>00 01=>01 10=>01 11=>10
    * 无进位 和 异或运算 规律相同
    * 进位 和 与运算 规律相同(并需左移一位)
- 代码实现
    ```python
        # 递归
        class Solution:
            def add(self, a: int, b: int) -> int:
                x = 0xffffffff
                if b == 0:
                    return a if a <= 0x7fffffff else ~(a ^ x)
                return add(a ^ b, (a & b) << 1)
        # 迭代
        class Solution:
            def add(self, a: int, b: int) -> int:
                x = 0xffffffff
                a, b = a & x, b & x
                while b != 0:
                    a, b = (a ^ b), (a & b) << 1 & x
                return a if a <= 0x7fffffff else ~(a ^ x)
    ```

#### 将字符串转换为整数
- 题目描述
    * 将一个字符串转换成一个整数,要求不能使用字符串转换整数的库函数. 数值为 0 或者字符串不是一个合法的数值则返回 0
- 思路
    * 若为负数,则输出负数,字符 0 对应 48,9 对应 57,不在范围内则返回false
- 代码实现
    ```python
        def StrToInt(str):
            if not str:
                return 0
            mark = 0
            chars = str.split()
            if chars[0] == "-1":
                mark = 1
            for i in range(mark, len(chars)):
                if chars[i] == "+":
                    continue
            if (char[i] < 48) or (chars[i] > 57):
                return 0
            number = number * 10 + chars[i] - 48
            return number if mark == 0 else -number
    ```

