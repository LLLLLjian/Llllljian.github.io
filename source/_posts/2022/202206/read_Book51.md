---
title: 读书笔记 (51)
date: 2022-06-09
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-队列实现栈以及栈实现队列

<!-- more -->

#### 用栈实现队列
- 问题描述
    * 
- 思路
    * 
- 代码实现
    ```python
        class MyQueue(object):
            def __init__(self):
                self.stack1 = []
                self.stack2 = []

            def push(self, x):
                self.stack1.append(x)

            def pop(self):
                if not self.stack2:
                    while self.stack1:
                        self.stack2.append(self.stack1.pop())
                return self.stack2.pop()

            def peek(self):
                if not self.stack2:
                    while self.stack1:
                        self.stack2.append(self.stack1.pop())
                return self.stack2[-1]

            def empty(self):
                return not self.stack1 and not self.stack2



        # Your MyQueue object will be instantiated and called as such:
        # obj = MyQueue()
        # obj.push(x)
        # param_2 = obj.pop()
        # param_3 = obj.peek()
        # param_4 = obj.empty()
    ```

#### 用队列实现栈
- 问题描述
    * 
- 思路
    * 
- 代码实现
    ```python
        class MyStack:
            def __init__(self):
                """
                Initialize your data structure here.
                """
                self.queue1 = collections.deque()
                self.queue2 = collections.deque()

            def push(self, x: int) -> None:
                """
                Push element x onto stack.
                """
                self.queue2.append(x)
                while self.queue1:
                    self.queue2.append(self.queue1.popleft())
                self.queue1, self.queue2 = self.queue2, self.queue1

            def pop(self) -> int:
                """
                Removes the element on top of the stack and returns that element.
                """
                return self.queue1.popleft()

            def top(self) -> int:
                """
                Get the top element.
                """
                return self.queue1[0]

            def empty(self) -> bool:
                """
                Returns whether the stack is empty.
                """
                return not self.queue1

        # Your MyStack object will be instantiated and called as such:
        # obj = MyStack()
        # obj.push(x)
        # param_2 = obj.pop()
        # param_3 = obj.top()
        # param_4 = obj.empty()
    ```






