---
title: Interview_总结 (182)
date: 2022-06-07 18:00:00
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP100

<!-- more -->

#### LRU 缓存
- 问题描述
    * 设计一个LRU缓存
- 思路
    * 类ListNode 双链表类
    * 类DoubleList 双链表功能类
        * 向尾部中添加节点
        * 移除节点
        * 移除第一个节点并返回
        * 获取链表长度
    * 类LRUCache 缓存类
        * 将某个key提升为最近使用的
            * 删除节点
            * 插到队尾
        * 添加最近使用的元素
            * 向尾部添加节点
            * 记录hash
        * 删除某个key
            * 先删链表
            * 再删hash
        * 删除最久未使用的节点
            * 删除头部节点
            * 删除头部节点hash
        * get
            * 不存在就直接返回-1
            * 存在的话, 将该数据提升为最近使用的
        * put
            * key存在, 就先删除然后再把他加到节点尾部
            * key不存在
                * 超过长度, 移除最久未使用节点
                * 添加为最近使用的元素
- 代码实现
    ```python
        class ListNode:
            def __init__(self, key=None, value=None):
                self.key = key
                self.value = value
                self.prev = None
                self.next = None

        class DoubleList:
            def __init__(self):
                """
                初始化双向链表的数据
                """
                self.head = ListNode()
                self.tail = ListNode()
                self.head.next = self.tail
                self.tail.prev = self.head
                self.size = 0

            def addLast(self, x):
                """
                在链表尾部添加节点 x,时间 O(1)
                """
                # 之后将x插入到尾节点前
                # prev <-> tail  ...  x       -->         prev <-> tail <-> x
                x.prev = self.tail.prev
                x.next = self.tail
                self.tail.prev.next = x
                self.tail.prev = x
                self.size += 1

            def remove(self, x):
                """
                删除链表中的 x 节点(x 一定存在)
                由于是双链表且给的是目标 Node 节点,时间 O(1)
                """
                # prev <-> x <-> next     -->    pre <-> next   ...   x
                x.prev.next = x.next
                x.next.prev = x.prev
                self.size -= 1
            
            def removeFirst(self):
                """
                删除链表中第一个节点,并返回该节点,时间 O(1)
                """
                if self.head.next == self.tail:
                    return None
                first = self.head.next
                self.remove(first)
                # 为什么要在链表中同时存储 key 和 val,而不是只存储 val」,注意 removeLeastRecently 函数中,我们需要用 deletedNode 得到 deletedKey
                return first

            def getSize(self):
                """
                返回链表长度,时间 O(1)
                """
                return self.size

        class LRUCache:
            def __init__(self, capacity: int):
                self.capacity = capacity
                self.hashmap = {}
                # 新建两个节点 head 和 tail
                self.cache = DoubleList()

            def makeRecently(self, key):
                """
                将某个 key 提升为最近使用的
                """
                x = self.hashmap.get(key)
                # 先从链表中删除这个节点
                self.cache.remove(x)
                # 重新插到队尾
                self.cache.addLast(x)
            
            def addRecently(self, key, value):
                """
                添加最近使用的元素
                """
                x = ListNode(key, value)
                # 链表尾部就是最近使用的元素
                self.cache.addLast(x)
                # 别忘了在 map 中添加 key 的映射
                self.hashmap[key] = x
            
            def deleteKey(self, key):
                """
                删除某一个key
                """
                x = self.hashmap.get(key)
                # 从链表中删除
                self.cache.remove(x)
                # 从 map 中删除
                del self.hashmap[key]
            
            def removeLeastRecently(self):
                """
                删除最久未使用的元素
                """
                # 链表头部的第一个元素就是最久未使用的
                deletedNode = self.cache.removeFirst()
                # 同时别忘了从 map 中删除它的 key
                deletedKey = deletedNode.key
                del self.hashmap[deletedKey]

            def get(self, key: int) -> int:
                if key not in self.hashmap:
                    return -1
                # 将该数据提升为最近使用的
                self.makeRecently(key)
                return self.hashmap[key].value

            def put(self, key: int, value: int) -> None:
                if key in self.hashmap:
                    # 删除旧的数据
                    self.deleteKey(key)
                    # 新插入的数据为最近使用的数据
                    self.addRecently(key, value)
                    return
                if self.capacity == self.cache.getSize():
                    # 删除最久未使用的元素
                    self.removeLeastRecently()

                # 添加为最近使用的元素
                self.addRecently(key, value)

        # Your LRUCache object will be instantiated and called as such:
        # obj = LRUCache(capacity)
        # param_1 = obj.get(key)
        # obj.put(key,value)
    ```

#### 根据身高重建队列 
- 问题描述
    * 有一伙人, 重排一下顺序
- 思路
    * 先按个头倒序拍, 然后按要站的位置正序排,然后循环依次入队就可以了
- 代码实现
    ```python
        class Solution:
            def reconstructQueue(self, people: List[List[int]]) -> List[List[int]]:
                people = sorted(people, key = lambda x: (-x[0], x[1]))
                res = []
                for temp in people:
                    if len(res) <= temp[1]:
                        # 因为先插入大的 所以当前的位置就是已插入对列的位置
                        res.append(temp)
                    elif len(res) > temp[1]:
                        res.insert(temp[1], temp)
                return res
    ```

#### 把二叉搜索树转换为累加树 
- 问题描述
    * 给出二叉 搜索 树的根节点,该树的节点值各不相同,请你将其转换为累加树(Greater Sum Tree),使每个节点 node 的新值等于原树中大于或等于 node.val 的值之和.
- 思路
    * 中序遍历是 左根右, 是个单调递增的序列
    * 题目要求转换为单调递减的序列, 并且改变val值, 所以这里直接用反中序遍历, 顺带改一下val的值就可以了
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def convertBST(self, root: TreeNode) -> TreeNode:
                def dfs(root: TreeNode):
                    if root:
                        dfs(root.right)
                        self.total += root.val
                        root.val = self.total
                        dfs(root.left)
                
                self.total = 0
                dfs(root)
                return root
    ```

#### 最短无序连续子数组
- 问题描述
    * 给你一个整数数组 nums ,你需要找出一个 连续子数组 ,如果对这个子数组进行升序排序,那么整个数组都会变为升序排序.请你找出符合题意的 最短 子数组,并输出它的长度.
- 思路
    * 最小元素左边比它大的元素都要参与排序,最大元素右边比它小的元素都要调整
- 代码实现
    ```python
        class Solution:
            def findUnsortedSubarray(self, nums: List[int]) -> int:
                """
                * 一次遍历
                * 正常排序(1 2 3 4 5): 左边所有元素的最大值(2) <= 每个元素(例如3) <= 右边所有元素的最小值(4)
                * 求解: 2  6  8  10  4  9  15
                * 其中: 从左到右 9是最后一个小于 (左边所有元素最大值)的
                *      从右到左 6是最后一个大于 (右边所有元素最小值)的
                * 故解为求:
                *      从左到右遍历, 记录当前遍历数的最大值, 最后一个小于最大值的即 需要倒置数组的右边索引
                *      从右到左遍历, 记录当前遍历数的最小值, 最后一个大于最小值的即 需要倒置数组的左边索引
                """
                length = len(nums)
                # 最小值是倒序遍历使用的(求需排序数组的左边索引leftDiff), 也可以取Integer.MAX_VALUE
                minNum = nums[-1]
                # 最大值是顺序遍历使用的(求需排序数组的右边索引rightDiff), 也可以取Integer.MIN_VALUE
                maxNum = nums[0]
                l, r = 0, -1
                for i in range(length):
                    # 顺序执行, 判断 当前值是否小于 已遍历的最大值, 是的话属于需排序的数组元素, 替换rightDiff; 否就更新最大值
                    if nums[i] < maxNum:
                        r = i
                    else:
                        maxNum = nums[i]
                    # 倒序执行, 判断 当前值是否大于 已遍历的最小值, 是的话属于需排序的数组元素, 替换leftDiff; 否就更新最小值
                    if(nums[length-i-1] > minNum):
                        l = length-i-1
                    else:
                        minNum = nums[length-i-1]
                return r - l + 1
    ```

