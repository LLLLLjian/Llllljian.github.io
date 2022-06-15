---
title: 读书笔记 (49)
date: 2022-06-06
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-LRU

<!-- more -->

#### LRU算法描述
> LRU 的全称是 Least Recently Used,也就是说我们认为最近使用过的数据应该是是「有用的」,很久都没用过的数据应该是无用的,内存满了就优先删那些很久没用过的数据.
- 栗子
    * 举个简单的例子,安卓手机都可以把软件放到后台运行,比如我先后打开了「设置」「手机管家」「日历」,那么现在他们在后台排列的顺序是这样的：
    ![LRU算法](/img/20220606_1.png)
    * 但是这时候如果我访问了一下「设置」界面,那么「设置」就会被提前到第一个,变成这样
    ![LRU算法](/img/20220606_2.png)
    * 假设我的手机只允许我同时开 3 个应用程序,现在已经满了.那么如果我新开了一个应用「时钟」,就必须关闭一个应用为「时钟」腾出一个位置,关那个呢
    * 按照 LRU 的策略,就关最底下的「手机管家」,因为那是最久未使用的,然后把新开的应用放到最上面
    ![LRU算法](/img/20220606_3.png)
- 实现逻辑
    ```
        /* 缓存容量为 2 */
        LRUCache cache = new LRUCache(2);
        // 你可以把 cache 理解成一个队列
        // 假设左边是队头,右边是队尾
        // 最近使用的排在队头,久未使用的排在队尾
        // 圆括号表示键值对 (key, val)

        cache.put(1, 1);
        // cache = [(1, 1)]

        cache.put(2, 2);
        // cache = [(2, 2), (1, 1)]

        cache.get(1);       // 返回 1
        // cache = [(1, 1), (2, 2)]
        // 解释：因为最近访问了键 1,所以提前至队头
        // 返回键 1 对应的值 1

        cache.put(3, 3);
        // cache = [(3, 3), (1, 1)]
        // 解释：缓存容量已满,需要删除内容空出位置
        // 优先删除久未使用的数据,也就是队尾的数据
        // 然后把新的数据插入队头

        cache.get(2);       // 返回 -1 (未找到)
        // cache = [(3, 3), (1, 1)]
        // 解释：cache 中不存在键为 2 的数据

        cache.put(1, 4);    
        // cache = [(1, 4), (3, 3)]
        // 解释：键 1 已存在,把原始值 1 覆盖为 4
        // 不要忘了也要将键值对提前到队头
    ```
- 思路
    * 函数 get 和 put 必须以 O(1) 的平均时间复杂度运行
    * get要想O(1)的话 首选一定是hash, 根据key-value直接获取
    * 但光用hash的话, 因为它是无序的, 无法确认插入顺序, 所以还需要另一种数据结构进行补充
        * 首先考虑列表结构, 新增(append)和删除(pop)都是满足的, 都是O(1), 但是查找并移动的时间复杂度是O(N)
        * 单链表结构的话, 查找并移动的时间也是O(N),所以也被排除掉了
        * 双链表结构的话, 移动只要改变头尾节点指针就可以了, O(1)时间就可以实现, 双向链表才能支持直接查找前驱,保证操作的时间复杂度 O(1)
    * 所以这里用到的数据结构就是哈希链表(双向链表+哈希表)
    * 主要实现的三个功能
        * 在末尾加入一项
        * 去除最前端一项
        * 将队列中某一项移到末尾
    ![哈希链表](/img/20220606_4.png)
    * 针对三个功能
        * 因为使用了hash, 所以查找是O(1)
        * hash中新增一个key, 改变末尾的头尾指针即可
        * 改变最前端头尾指针即可
        * 通过hash找到要修改的节点, 先移除它的头尾指针, 然后执行步骤1

#### 代码实现
- 代码实现
    ```python
        class ListNode:
            def __init__(self, key=None, value=None):
                self.key = key
                self.value = value
                self.prev = None
                self.next = None
                self.size = 0

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
                # prev <-> tail  ...  x       -->         prev <-> x <-> tail
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
