---
title: Interview_总结 (186)
date: 2022-06-17 12:00:00
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 计算器
- 问题描述
    * 给定一个包含正整数、加(+)、减(-)、乘(*)、除(/)的算数表达式(括号除外)，计算其结果。表达式仅包含非负整数，+， - ，*，/ 四种运算符和空格  。 整数除法仅保留整数部分。
- 思路
    * 遇到数字记录数字，遇到符号记录符号，遇到下一个符号时，对当前记录的数字和符号进行运算，对于各符号的处理见其它人的解析。
    * 由于是由下一个符号驱动，因此需要注意最后一个运算的处理。
    * 我的代码中增加了括号的功能，遇到左括号就开始递归，遇到右括号处理运算并break出循环返回结果。
    * 值得注意的是，为了保持s在递归中不断被改变，应避免对s进行赋值（这样在内层递归中的s就不是外层传递进来的s了，而是绑定到了新值，即shadow）
- 代码实现
    ```python
        class Solution:
        def calculate(self, s):
            stack = []
            symbol_list = ["+", "-", "*", "/"]
            pre_symbol = "+"
            num = 0
            for i in range(len(s)):
                if s[i].isdigit() and s[i] != " ":
                    num = num*10+int(s[i])
                if s[i] in symbol_list or i == len(s)-1:
                    if pre_symbol == "+":
                        stack.append(num)
                    elif pre_symbol == "-":
                        stack.append(-1*num)
                    elif pre_symbol == '*':
                        stack.append(stack.pop()*num)
                    elif pre_symbol == "/":
                        num_s = stack.pop()
                        if num_s < 0:
                            num_s = -num_s
                            stack.append(-(num_s//num))
                        else:
                            stack.append(num_s//num)
                    pre_symbol = s[i]
                    num = 0
                    #print(stack)
            print(stack)
            return sum(stack)
    ```





