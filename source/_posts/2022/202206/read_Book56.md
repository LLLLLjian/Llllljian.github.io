---
title: 读书笔记 (56)
date: 2022-06-17 18::00:00
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-计算器问题

<!-- more -->

#### 问题梳理
我们最终要实现的计算器功能如下：
1. 输入一个字符串, 可以包含 + - * /、数字、括号以及空格, 你的算法返回运算结果.
2. 要符合运算法则, 括号的优先级最高, 先乘除后加减.
3. 除号是整数除法, 无论正负都向 0 取整(5/2=2, -5/2=-2).
4. 可以假定输入的算式一定合法, 且计算过程不会出现整型溢出, 不会出现除数为 0 的意外情况.

#### 字符串转整数
- 代码实现
    ```python
        s = "458"
        n = 0
        for i in range(len(s)):
            n = 10 * n + int(s[i])
        print(n)
    ```

#### 处理加减法
> 假设输入的这个算式只包含加减法, 而且不存在空格

思路:
1. 先给第一个数字加一个默认符号 +, 变成 +1-12+3.
2. 把一个运算符和数字组合成一对儿, 也就是三对儿 +1, -12, +3, 把它们转化成数字, 然后放到一个栈中.
3. 将栈中所有的数字求和, 就是原算式的结果.
- 代码实现
    ```python
        def calculate(s):
            stk = []
            # 记录算式中的数字
            num = 0
            # 记录 num 前的符号, 初始化为 +
            sign = "+"
            for i in range(len(s)):
                # 如果是数字, 连续读取到 num
                if s[i].isdigit():
                    num = num * 10 + int(s[i])
                # 如果不是数字, 就是遇到了下一个符号, 之前的数字和符号就要存进栈中
                # 不只是遇到新的符号会触发入栈, 当 i 走到了算式的尽头(i == s.size() - 1 ), 也应该将前面的数字入栈, 方便后续计算最终结果
                if (not s[i].isdigit() and s[i] != " ") or (i == len(s)-1):
                    if sign == "+":
                        stk.append(num)
                    elif sign == "-":
                        stk.append(-1 * num)
                    # 更新符号为当前符号, 数字清零
                    sign = s[i]
                    num = 0
            return sum(stk)
    ```
- 图片理解
    ![处理加减法](/img/20220617_1.PNG)

#### 处理乘除法
> 乘除法优先于加减法体现在, 乘除法可以和栈顶的数结合, 而加减法只能把自己放入栈
思路:
1. 只用在ifelse里加上乘除逻辑就可以了
- 代码实现
    ```python
        def calculate(s):
            stk = []
            # 记录算式中的数字
            num = 0
            # 记录 num 前的符号, 初始化为 +
            sign = "+"
            for i in range(len(s)):
                # 如果是数字, 连续读取到 num
                if s[i].isdigit():
                    num = num * 10 + int(s[i])
                # 如果不是数字, 就是遇到了下一个符号, 之前的数字和符号就要存进栈中
                # 不只是遇到新的符号会触发入栈, 当 i 走到了算式的尽头(i == s.size() - 1 ), 也应该将前面的数字入栈, 方便后续计算最终结果
                if (not s[i].isdigit() and s[i] != " ") or (i == len(s)-1):
                    if sign == "+":
                        stk.append(num)
                    elif sign == "-":
                        stk.append(-1 * num)
                    elif sign == "*":
                        stk[-1] = stk[-1] * num
                    elif sign == "/":
                        stk[-1] = int(stk[-1] / float(num)) 
                    # 更新符号为当前符号, 数字清零
                    sign = s[i]
                    num = 0
            return sum(stk)
    ```
- 图片理解
    ![处理乘除法](/img/20220617_2.PNG)

#### 处理括号
> 因为括号具有递归性质, 换句话说, 括号包含的算式, 我们直接视为一个数字就行了, 遇到 ( 开始递归, 遇到 ) 结束递归
- 代码实现
    ```python
        def calculate(s):
            stk = []
            # 记录算式中的数字
            num = 0
            # 记录 num 前的符号, 初始化为 +
            sign = "+"
            for i in range(len(s)):
                # 如果是数字, 连续读取到 num
                if s[i].isdigit():
                    num = num * 10 + int(s[i])
                # 遇到左括号开始递归计算 num
                if s[i] == '(':
                    num = calculate(s)
                # 如果不是数字, 就是遇到了下一个符号, 之前的数字和符号就要存进栈中
                # 不只是遇到新的符号会触发入栈, 当 i 走到了算式的尽头(i == s.size() - 1 ), 也应该将前面的数字入栈, 方便后续计算最终结果
                if (not s[i].isdigit() and s[i] != " ") or (i == len(s)-1):
                    if sign == "+":
                        stk.append(num)
                    elif sign == "-":
                        stk.append(-1 * num)
                    elif sign == "*":
                        stk[-1] = stk[-1] * num
                    elif sign == "/":
                        stk[-1] = int(stk[-1] / float(num)) 
                    # 更新符号为当前符号, 数字清零
                    sign = s[i]
                    num = 0
                # 遇到右括号返回递归结果
                if s[i] == ')':
                    break
            return sum(stk)
    ```
- 图片理解
    ![处理括号](/img/20220617_3.PNG)
    ![处理括号](/img/20220617_4.PNG)
    ![处理括号](/img/20220617_5.PNG)

#### 基本计算器
- 代码实现
    ```python
        class Solution:
            def calculate(self, s: str) -> int:
                def helper(s):
                    num = 0
                    stack = []
                    sign = "+"
                    while len(s) > 0:
                        c = s.popleft()
                        if c.isdigit():
                            num = 10 * num + int(c)
                        # 遇到左括号开始递归计算 num
                        if c == '(':
                            num = helper(s)

                        if (not c.isdigit() and c != ' ') or len(s) == 0:
                            if sign == '+':
                                stack.append(num)
                            elif sign == '-':
                                stack.append(-num)
                            elif sign == '*':
                                stack[-1] = stack[-1] * num
                            elif sign == '/':
                                # python 除法向 0 取整的写法
                                stack[-1] = int(stack[-1] / float(num))       
                            num = 0
                            sign = c
                        # 遇到右括号返回递归结果
                        if c == ')': break
                    return sum(stack)
                return helper(collections.deque(s))
    ```

#### 基本计算器II
- 代码实现
    ```python
        class Solution:
            def calculate(self, s: str) -> int:
                def helper(s):
                    num = 0
                    stack = []
                    sign = "+"
                    while len(s) > 0:
                        c = s.popleft()
                        if c.isdigit():
                            num = 10 * num + int(c)
                        if (not c.isdigit() and c != ' ') or len(s) == 0:
                            if sign == '+':
                                stack.append(num)
                            elif sign == '-':
                                stack.append(-num)
                            elif sign == '*':
                                stack[-1] = stack[-1] * num
                            elif sign == '/':
                                # python 除法向 0 取整的写法
                                stack[-1] = int(stack[-1] / float(num))       
                            num = 0
                            sign = c
                    return sum(stack)
                return helper(collections.deque(s))
    ```
