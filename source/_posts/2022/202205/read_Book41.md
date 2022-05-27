---
title: 读书笔记 (41)
date: 2022-05-25
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-常数时间删除/查找数组中的任意元素

<!-- more -->

#### O(1) 时间插入、删除和获取随机元素
- 问题描述
    * 实现RandomizedSet 类
        * RandomizedSet() 初始化 RandomizedSet 对象
        * bool insert(int val) 当元素 val 不存在时,向集合中插入该项,并返回 true ；否则,返回 false .
        * bool remove(int val) 当元素 val 存在时,从集合中移除该项,并返回 true ；否则,返回 false .
        * int getRandom() 随机返回现有集合中的一项(测试用例保证调用此方法时集合中至少存在一个元素).每个元素应该有 相同的概率 被返回.
    * 你必须实现类的所有函数,并满足每个函数的 平均 时间复杂度为 O(1) 
- 思路
    * 变长数组可以在 O(1) 的时间内完成获取随机元素操作,但是由于无法在 O(1) 的时间内判断元素是否存在,因此不能在 O(1) 的时间内完成插入和删除操作.哈希表可以在 O(1) 的时间内完成插入和删除操作,但是由于无法根据下标定位到特定元素,因此不能在 O(1) 的时间内完成获取随机元素操作
    * O(1)的话 插入就一定要用到哈希表, 元素如果在哈希表中就返回false, 不在的话就插入, key是该元素, value是索引
    * O(1)的话 删除就要用到数组了, 但数组只有弹出最后一个元素是O(1), 所以我们要做到把要删除的元素换到列表的最后一个并弹出
    * 随机获取的话 生成索引范围(0到len(self.nums)-1)的整数随机数作为索引, 从数组中取就可以了
- 代码实现
    ```python
        import random
        class RandomizedSet:

            def __init__(self):
                self.valtoidx = {}
                self.nums = []

            def insert(self, val: int) -> bool:
                # 如果该元素在哈希表valtoidx中则返回false
                if val in self.valtoidx.keys():
                    return False
                # 不存在则把该元素添加到数组末尾 先把索引len(self.nums)到哈希表中 再添加到nums数组的末尾
                else:
                    self.valtoidx[val] = len(self.nums)
                    self.nums.append(val)
                    return True

            def remove(self, val: int) -> bool:
                # 当元素存在时 先把该元素移到末尾再删除
                if val in self.valtoidx.keys():
                    idx = self.valtoidx.get(val)
                    # 更新哈希表中交换后的内容 原来末尾的元素索引变为idx 由于本来就要把val对应的键值对删掉 此处不对其做操作
                    self.valtoidx[self.nums[len(self.nums) - 1]] = idx
                    # 与末尾元素交换
                    self.nums[len(self.nums) - 1], self.nums[idx] = self.nums[idx], self.nums[len(self.nums) - 1]
                    # 删除
                    self.nums.pop()
                    # 记得也要删除哈希表中的记录
                    self.valtoidx.pop(val)
                    # 操作完毕要返回true
                    return True
                # 当元素不存在时返回false
                else:
                    return False

            def getRandom(self) -> int:
                # 生成索引范围(0到len(self.nums)-1)的整数随机数作为索引
                idx = random.randint(0, len(self.nums) - 1)
                # 返回该索引对应的元素
                return self.nums[idx]

        # Your RandomizedSet object will be instantiated and called as such:
        # obj = RandomizedSet()
        # param_1 = obj.insert(val)
        # param_2 = obj.remove(val)
        # param_3 = obj.getRandom()
    ```

#### 黑名单中的随机数
- 问题描述
    * 给定一个整数 n 和一个 无重复 黑名单整数数组 blacklist .设计一种算法,从 [0, n - 1] 范围内的任意整数中选取一个 未加入 黑名单 blacklist 的整数.任何在上述范围内且不在黑名单 blacklist 中的整数都应该有 同等的可能性 被返回.
    * 优化你的算法,使它最小化调用语言 内置 随机函数的次数.
    * 实现 Solution 类:
        * Solution(int n, int[] blacklist) 初始化整数 n 和被加入黑名单 blacklist 的整数
        * int pick() 返回一个范围为 [0, n - 1] 且不在黑名单 blacklist 中的随机整数
- 思路
    * 对于n = 10, blacklist = [3, 5, 8, 9]
    * 我们的整体思路就是利用Map把blacklist中的元素全部映射到最后面去,即[0, 6)存放非黑名单内的元素,[6, 10)存放黑名单内的元素
    * 需要注意的一点是：我们并非真正意义上的把元素移到最后,而是通过Map映射,其实元素的位置是没有改变的
    ![黑名单中的随机数](/img/20220525_1.png)
    * 如上图所示,元素 3 和 5 在非黑名单位置上,所以我们需要按序把这两个元素映射到 7 和 6,即map.put(3, 7); map.put(5, 6)
    * 而我们随机获得非黑名单内的元素,直接对区间[0, 6)随机即可.如果刚好随机到了 3 或 5,那么我们只需要返回map.get(3) = 7 or map.get(5) = 6即可
- 代码实现
    ```python
        class Solution:
            def __init__(self, n: int, blacklist: List[int]):
                self.bl = blacklist
                self.mapping = {}
                self.gap = n - len(blacklist) - 1    # [0,gap]都应该为白位置
                for b in self.bl:            # 先记录黑名单的初始位置
                    self.mapping[b] = b
                last = n-1                   # last用来找后部分的白位置,用来放前部分的黑元素
                for b in self.bl:
                    if b > self.gap:   # 若b已经在黑名单应该在的后半部分,不移动它
                        continue
                    while last in self.mapping:   # 若b在白名单的位置
                        last -= 1              # 则从最后往前找到白位置
                    self.mapping[b] = last     # 把它映射过去
                    last -= 1

            def pick(self):
                import random
                idx = random.randint(0, self.gap)
                if idx in self.mapping:          # 若是[0,gap]的黑位置,则找到他映射的白位置返回
                    return self.mapping[idx]
                return idx

        # Your Solution object will be instantiated and called as such:
        # obj = Solution(n, blacklist)
        # param_1 = obj.pick()
    ```



