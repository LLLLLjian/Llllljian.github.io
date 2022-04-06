---
title: Leetcode_基础 (186)
date: 2022-01-05
tags: Leetcode
toc: true
---

### 今日被问傻系列
    leetcode

<!-- more -->

#### 上台阶
- Q
    * 一只青蛙一次可以跳上1级台阶, 也可以跳上2级台阶.求该青蛙跳上一个 n 级的台阶总共有多少种跳法.
- T
    * 1 2 3 5 8 13 21
- A
    ```python
        record = {0: 1, 1: 1}
        class Solution:
            def numWays(self, n: int) -> int:
                if n in record.keys():
                    return record[n]
                res = self.numWays(n-1) + self.numWays(n-2)
                record[n] = res
                return res % 1000000007
    ```

#### 数组形式的整数加法
- Q
    ```
        输入：A = [1,2,0,0], K = 34
        输出：[1,2,3,4]
        解释：1200 + 34 = 1234
    ```
- T
    * 数组从后往前 数字每次除10取余 进位相加
- A
    ```python
        class Solution:
            def addToArrayForm(self, num: List[int], k: int) -> List[int]:
                res = []
                i, carry = len(num) - 1, 0
                while i >= 0 or k != 0:
                    x = num[i] if i >= 0 else 0
                    y = k % 10 if k != 0 else 0

                    sum = x + y + carry
                    res.append(sum % 10)
                    carry = sum // 10

                    i -= 1
                    k //= 10
                if carry != 0: res.append(carry)
                return res[::-1]
    ```

#### 加一
- Q
    * 给定一个由 整数 组成的 非空 数组所表示的非负整数, 在该数的基础上加一
    * digits = [1,2,3] => [1,2,4]
- T
    *
- A
    ```python
        class Solution:
            def plusOne(self, digits: List[int]) -> List[int]:
                for i in range(len(digits) - 1, -1, -1):
                    digits[i] += 1
                    digits[i] = digits[i] % 10
                    if digits[i] != 0: return digits

                # 如果循环结束了还没有返回 说明新增了一位
                res = [0] * (len(digits) + 1)
                res[0] = 1
                return res
    ```

