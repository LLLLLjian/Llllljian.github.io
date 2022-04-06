---
title: DataStructure_基础 (48)
date: 2022-03-21
tags: DataStructure
toc: true
---

### 重学数据结构
    重学数据结构-常见数据结构

<!-- more -->

#### 跳表
> 跳表的产生就是为了解决链表过长的问题,通过增加链表的多级索引来加快原始链表的查询效率.这样的方式可以让查询的时间复杂度从O(n)提升至O(logn).

![跳表](/img/20220321_1.png)

索引级的指针域除了指向下一个索引位置的指针,还有一个down指针指向低一级的链表位置,这样才能实现跳跃查询的目的

跳表通过增加的多级索引能够实现高效的动态插入和删除,其效率和红黑树和平衡二叉树不相上下.目前redis和levelDB都有用到跳表.

#### 用栈实现队列
> 两个栈实现队列(栈A用于加入队尾操作,栈B用于将元素倒序)
- 代码
    ```python
        class CQueue:
            def __init__(self):
                self.A, self.B = [], []

            def appendTail(self, value: int) -> None:
                self.A.append(value)

            def deleteHead(self) -> int:
                if self.B: return self.B.pop()
                if not self.A: return -1
                while self.A:
                    self.B.append(self.A.pop())
                return self.B.pop()
    ```

#### 用队列实现栈
> 用两个队列实现栈(队列1保持栈的顺序, 入的话先入2,然后把1里的全出队列插入到2,交换12)
- 代码
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

#### 树
- 二叉查找树
    * 二叉查找树因为可能退化成链表, 同样不适合进行查找
- AVL树(平衡二叉树)
    * AVL树是为了解决可能退化成链表问题, 但是AVL树的旋转过程非常麻烦, 因此插入和删除很慢, 也就是构建AVL树比较麻烦
- 红黑树
    * 红黑树是平衡二叉树和AVL树的折中, 因此是比较合适的.集合类中的Map、关联数组具有较高的查询效率, 它们的底层实现就是红黑树.
- 多路查找树
    * 多路查找树是大规模数据存储中, 实现索引查询这样一个实际背景下, 树节点存储的元素数量是有限的(如果元素数量非常多的话, 查找就退化成节点内部的线性查找了), 这样导致二叉查找树结构由于树的深度过大而造成磁盘I/O读写过于频繁, 进而导致查询效率低下.
- B树
    * B树与自平衡二叉查找树不同, B树适用于读写相对大的数据块的存储系统, 例如磁盘.它的应用是文件系统及部分非关系型数据库索引.
- B+树
    * B+树在B树基础上, 为叶子结点增加链表指针(B树+叶子有序链表), 所有关键字都在叶子结点 中出现, 非叶子结点作为叶子结点的索引；B+树总是到叶子结点才命中.通常用于关系型数据库(如Mysql)和操作系统的文件系统中.

