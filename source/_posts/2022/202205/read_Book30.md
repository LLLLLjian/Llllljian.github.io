---
title: 读书笔记 (30)
date: 2022-05-14
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-双指针(链表)

<!-- more -->

#### 合并两个有序链表
- 问题描述
    * 给你输入两个有序链表,请你把他俩合并成一个新的有序链表
- 思路
    * 类似于「拉拉链」,l1, l2 类似于拉链两侧的锯齿,指针 p 就好像拉链的拉索,将两个有序链表合并.
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
                res = ListNode(0)
                cur = res
                while list1 and list2:
                    # 比较 list1 和 list2 两个指针
                    # 将值较小的的节点接到 cur 指针
                    if list1.val > list2.val:
                        cur.next = list2
                        list2 = list2.next
                    else:
                        cur.next = list1
                        list1 = list1.next
                    # 指针不断前进
                    cur = cur.next
                if list1:
                    cur.next = list1
                if list2:
                    cur.next = list2
                return res.next
    ```

#### 合并 k 个有序链表
- 问题描述
    * k个有序链表合并成一个
- 思路
    * func1: 先把链表的值存入数组,数组排序后再连成链表
    * func2: 借助两有序链表合并,对所有链表两两合并 二分法归并优化
    * func3: 堆排,将链表的值存入小根堆中,再逐次将堆顶取出连接成链表
- 代码实现
    ```python
        class Solution:
            def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
                """
                先把链表的值存入数组,数组排序后再连成链表
                """
                nums=[]
                for l in lists:         #将所有列表的值取出来放进数组
                    j=l
                    while j:
                        nums.append(j.val)
                        j=j.next
                nums.sort()              #对数组排序
                dummy=ListNode(0)
                head=dummy
                for i in range(len(nums)):#将数组的值连接成链表
                    head.next=ListNode(nums[i])
                    head=head.next
                return dummy.next
        
        class Solution:
            def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
                """
                借助两有序链表合并,对所有链表两两合并 二分法归并优化
                """
                if not lists:return
                def merge2Lists(l1,l2):#两有序链表合并
                    if not l1:return l2
                    if not l2:return l1
                    if l1.val<l2.val:
                        l1.next=merge2Lists(l1.next,l2)
                        return l1
                    else:
                        l2.next=merge2Lists(l1,l2.next)
                        return  l2
                def helper(l,r):#二分法 使所有链表两两合并
                    if l==r:return lists[l]
                    n=len(lists)
                    mid=(l+r)>>1
                    l1=helper(l,mid)
                    l2=helper(mid+1,r)
                    return merge2Lists(l1,l2)
                return helper(0,len(lists)-1)
        class Solution:
            def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
                """
                堆排,将链表的值存入小根堆中,再逐次将堆顶取出连接成链表
                """
                if not lists:return 
                import heapq
                queue=[]
                for l in lists:#将lists的值放进小根堆
                    head=l
                    while head:
                        heapq.heappush(queue,head.val)
                        head=head.next
                dummy=ListNode(0)#构造虚拟节点
                cur=dummy
                while queue:#将堆顶取出连接成链表
                    cur.next=ListNode(heapq.heappop(queue))
                    cur=cur.next
                return dummy.next
    ```

#### 单链表的倒数第k个节点

从前往后寻找单链表的第 k 个节点很简单,一个 for 循环遍历过去就找到了,但是如何寻找从后往前数的第 k 个节点呢？

那你可能说,假设链表有 n 个节点,倒数第 k 个节点就是正数第 n - k + 1 个节点,不也是一个 for 循环的事儿吗？

是的,但是算法题一般只给你一个 ListNode 头结点代表一条单链表,你不能直接得出这条链表的长度 n,而需要先遍历一遍链表算出 n 的值,然后再遍历链表计算第 n - k + 1 个节点.

也就是说,这个解法需要遍历两次链表才能得到出倒数第 k 个节点.

那么,我们能不能只遍历一次链表,就算出倒数第 k 个节点？

首先,我们先让一个指针 p1 指向链表的头节点 head,然后走 k 步

现在的 p1,只要再走 n - k 步,就能走到链表末尾的空指针了对吧？

趁这个时候,再用一个指针 p2 指向链表头节点 head：

接下来就很显然了,让 p1 和 p2 同时向前走,p1 走到链表末尾的空指针时前进了 n - k 步,p2 也从 head 开始前进了 n - k 步,停留在第 n - k + 1 个节点上,即恰好停链表的倒数第 k 个节点上：

```
    // 返回链表的倒数第 k 个节点
    ListNode findFromEnd(ListNode head, int k) {
        ListNode p1 = head;
        // p1 先走 k 步
        for (int i = 0; i < k; i++) {
            p1 = p1.next;
        }
        ListNode p2 = head;
        // p1 和 p2 同时走 n - k 步
        while (p1 != null) {
            p2 = p2.next;
            p1 = p1.next;
        }
        // p2 现在指向第 n - k 个节点
        return p2;
    }
```
- 问题描述
    * 给你一个链表,删除链表的倒数第 n 个结点,并且返回链表的头结点.
- 思路
    * 快慢指针, 快指针先走n步, 快慢同时前进n-k步, 快指针走到头的时候, 此时慢指针指向len-n个节点
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def removeNthFromEnd(self, head: ListNode, n: int) -> ListNode:
                if (not head) or (n <= 0):
                    return None
                # 设置虚拟节点, 防止越界
                dummy = ListNode(0)
                dummy.next = head
                slow = dummy
                fast = dummy
                # fast往前走n步
                for _ in range(n+1):
                    fast = fast.next
                # 直到fast走完
                while fast:
                    fast = fast.next
                    slow = slow.next
                # 删除slow的下一个节点
                slow.next = slow.next.next
                # 返回虚拟节点
                return dummy.next
    ```

#### 单链表的中点
- 问题描述
    * 给定一个头结点为 head 的非空单链表,返回链表的中间结点.如果有两个中间结点,则返回第二个中间结点.
- 思路
    * 每当慢指针 slow 前进一步,快指针 fast 就前进两步,这样,当 fast 走到链表末尾时,slow 就指向了链表中点.
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, val=0, next=None):
        #         self.val = val
        #         self.next = next
        class Solution:
            def middleNode(self, head: ListNode) -> ListNode:
                if not head:
                    return None
                # 快慢指针初始化指向 head
                fast, slow = head, head
                # 快指针走到末尾时停止
                while fast and fast.next:
                    # 慢指针走一步,快指针走两步
                    fast = fast.next.next
                    slow = slow.next
                return slow
    ```

#### 判断链表是否包含环
- 问题描述
    * 判断链表是否有环
- 思路
    * 每当慢指针 slow 前进一步,快指针 fast 就前进两步.如果 fast 最终遇到空指针,说明链表中没有环；如果 fast 最终和 slow 相遇,那肯定是 fast 超过了 slow 一圈,说明链表中含有环.
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def hasCycle(self, head: Optional[ListNode]) -> bool:
                if not head:
                    return False
                # 快慢指针初始化指向 head
                fast, slow = head, head
                # 快指针走到末尾时停止
                while fast and fast.next:
                    # 慢指针走一步,快指针走两步
                    fast = fast.next.next
                    slow = slow.next
                    # 快慢指针相遇,说明含有环
                    if fast == slow:
                        return True
                # 不包含环
                return False
    ```
- 扩展1
    * 如果链表中含有环,如何计算这个环的起点
        * head到入环为a, 入环到相遇为b, b到入环为c
        * slow * 2 = fast;
        * slow = a + b;
        * fast = a + b + c + b = a + 2*b + c;
        * (a + b)\*2 = a + 2*b + c;
        * a = c;
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def detectCycle(self, head: ListNode) -> ListNode:
                fast, slow = head, head
                while fast and fast.next:
                    fast = fast.next.next
                    slow = slow.next
                    if slow == fast:
                        break
                if (not fast) or (not fast.next):
                    # fast 遇到空指针说明没有环
                    return None
                # 重新指向头结点
                slow = head
                # 快慢指针同步前进,相交点就是环起点
                while (slow != fast):
                    fast = fast.next
                    slow = slow.next
                return slow
    ```
- 扩展2
    * 求环长
        * 第一次相遇之后, 两个人按照你1步我2步的速度, 再次相遇就是环长
    ```python
        class Solution(object):
            def detectCycle(self, head):
                fast, slow = head, head
                while True:
                    if not (fast and fast.next): return
                    fast, slow = fast.next.next, slow.next
                    if fast == slow: break
                slow = slow.next
                fast = fast.next.next
                len = 1
                while fast != slow:
                    len += 1
                    fast, slow = fast.next.next, slow.next
                return len
    ```

#### 两个链表是否相交
- 问题描述
    * 给你两个单链表的头节点 headA 和 headB ,请你找出并返回两个单链表相交的起始节点.如果两个链表不存在相交节点,返回 null .
- 思路
    * 解决这个问题的关键是,通过某些方式,让 p1 和 p2 能够同时到达相交节点 c1.如果用两个指针 p1 和 p2 分别在两条链表上前进,我们可以让 p1 遍历完链表 A 之后开始遍历链表 B,让 p2 遍历完链表 B 之后开始遍历链表 A,这样相当于「逻辑上」两条链表接在了一起.如果这样进行拼接,就可以让 p1 和 p2 同时进入公共部分,也就是同时到达相交节点 c1
- 代码实现
    ```python
        # Definition for singly-linked list.
        # class ListNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.next = None

        class Solution:
            def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> ListNode:
                # p1 指向 A 链表头结点,p2 指向 B 链表头结点
                p1, p2 = headA, headB
                while (p1 != p2):
                    # p1 走一步,如果走到 A 链表末尾,转到 B 链表
                    p1 = p1.next if p1 else headB
                    p2 = p2.next if p2 else headA
                return p1
    ```


