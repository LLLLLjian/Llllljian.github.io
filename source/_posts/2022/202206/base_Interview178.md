---
title: Interview_总结 (178)
date: 2022-06-04
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题
    TOP100

<!-- more -->

#### 每日温度
- 问题描述
    * 给定一个整数数组 temperatures ,表示每天的温度,返回一个数组 answer ,其中 answer[i] 是指在第 i 天之后,才会有更高的温度.如果气温在这之后都不会升高,请在该位置用 0 来代替.
- 思路
    * 单调栈
- 代码实现
    ```python
        class Solution:
            def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
                if not temperatures:
                    return []
                length = len(temperatures)
                s = []
                res = [0] * length
                for i in range(length-1, -1, -1):
                    while s and s[-1][0] <= temperatures[i]:
                        s.pop()
                    if s:
                        res[i] = s[-1][1] - i
                    s.append((temperatures[i], i))
                return res
    ```

#### 最长回文子串
- 问题描述
    * 给你一个字符串 s,找到 s 中最长的回文子串
- 思路
    * 因为中心点可能是一个 也有可能是两个, 所以要查两次
    * 设置左和右, 从中间往两边扩展就可以了
- 代码实现
    ```python
        class Solution:
            def longestPalindrome(self, s: str) -> str:
                res = ""
                def palindrome(s, l, r):
                    # 防止索引越界
                    while (l >= 0) and (r < len(s)) and (s[l] == s[r]):
                        # 双指针,向两边展开
                        l -= 1
                        r += 1
                    # 返回以 s[l] 和 s[r] 为中心的最长回文串
                    return s[l+1:r]
                for i in range(len(s)):
                    # 以 s[i] 为中心的最长回文子串
                    s1 = palindrome(s, i, i)
                    # 以 s[i] 和 s[i+1] 为中心的最长回文子串
                    s2 = palindrome(s, i, i+1)
                    res = s1 if len(s1) > len(res) else res
                    res = s2 if len(s2) > len(res) else res
                return res
    ```

#### 回文子串
- 问题描述
    * 给你一个字符串 s ,请你统计并返回这个字符串中 回文子串 的数目.回文字符串 是正着读和倒过来读一样的字符串.子字符串 是字符串中的由连续字符组成的一个序列.具有不同开始位置或结束位置的子串,即使是由相同的字符组成,也会被视作不同的子串.
- 思路
    * 和上题类似, 只不过在计算回文数的时候加1就可以了
- 代码实现
    ```python
        class Solution:
            def countSubstrings(self, s: str) -> int:
                if not s:
                    return 0
                self.ans = 0
                def palindrome(s, l, r):
                    while (l>=0) and (r<=len(s)-1) and (s[l] == s[r]):
                        self.ans += 1
                        l -= 1
                        r += 1
                for i in range(len(s)):
                    # 以单个字母为中心的情况
                    palindrome(s, i, i)
                    # 以两个字母为中心的情况
                    palindrome(s, i, i+1)
                return self.ans
    ```

#### 连续的子数组和
- 问题描述
    * 给你一个整数数组 nums 和一个整数 k ,编写一个函数来判断该数组是否含有同时满足下述条件的连续子数组：子数组大小 至少为 2 ,且子数组元素总和为 k 的倍数.如果存在,返回 true ；否则,返回 false .如果存在一个整数 n ,令整数 x 符合 x = n * k ,则称 x 是 k 的一个倍数.0 始终视为 k 的一个倍数.
- 思路
    * 利用前缀和, 判断取余, 只要余数一样并且索引差2就返回True
- 代码实现
    ```python
        class Solution:
            def checkSubarraySum(self, nums: List[int], k: int) -> bool:
                # 寻找 i, j 使得 (preSum[i] - preSum[j]) % k == 0 且 i - j >= 2.
                # 另外,(preSum[i] - preSum[j]) % k == 0 其实就是 preSum[i] % k == preSum[j] % k
                preSum = [0] * (len(nums)+1)
                preSum[0] = 0
                for i in range(1, len(nums)+1):
                    preSum[i] = preSum[i-1] + nums[i-1]
                hash_set = {}
                for i in range(len(preSum)):
                    # 在哈希表中记录余数
                    val = preSum[i] % k
                    if val in hash_set:
                        if abs(hash_set[val] - i) >= 2:
                            return True
                    else:
                        hash_set[val] = i
                return False
    ```

#### 连续数组
- 问题描述
    * 给定一个二进制数组 nums , 找到含有相同数量的 0 和 1 的最长连续子数组,并返回该子数组的长度.
- 思路
    * 首先,我们做一个等价,题目让你找 0 和 1 数量相同的最长子数组,如果我们把 0 视作 -1,就把题目转变成了：寻找和为 0 的最长子数组
    * 和上题一样了
- 代码实现
    ```python
        class Solution:
            def findMaxLength(self, nums: List[int]) -> int:
                preSum = [0] * (len(nums) + 1)
                for i in range(1, len(nums) + 1):
                    if nums[i-1] == 1:
                        preSum[i] = preSum[i-1] + nums[i-1]
                    else:
                        preSum[i] = preSum[i-1] - 1
                tempDict = {}
                res = 0
                for i in range(len(preSum)):
                    if preSum[i] in tempDict:
                        res = max(res, i-tempDict[preSum[i]])
                    else:
                        tempDict[preSum[i]] = i
                return res 
    ```

#### 和为 K 的子数组
- 问题描述
    * 给你一个整数数组 nums 和一个整数 k ,请你统计并返回 该数组中和为 k 的子数组的个数 .
- 思路
    * 前缀和减去k, 判断在不在哈希表中, 在的话, 加上val值, 不在就置为1
- 代码实现
    ```python
        class Solution:
            def subarraySum(self, nums: List[int], k: int) -> int:
                preSum = [0] * (len(nums) + 1)
                res = 0
                # 为了应对 nums[0] +nums[1] + ... + nums[i] == k 的情况的, 也就是从下标 0 累加到下标 
                count = {0:1}
                for i in range(1, len(nums) + 1):
                    preSum[i] = preSum[i-1] + nums[i-1]
                    need = preSum[i] - k
                    if need in count:
                        res += count[need]
                    if preSum[i] in count:
                        count[preSum[i]] += 1
                    else:
                        count[preSum[i]] = 1
                return res
    ```

#### 任务调度器
- 问题描述
    * 给你一个用字符数组 tasks 表示的 CPU 需要执行的任务列表.其中每个字母表示一种不同种类的任务.任务可以以任意顺序执行,并且每个任务都可以在 1 个单位时间内执行完.在任何一个单位时间,CPU 可以完成一个任务,或者处于待命状态.然而,两个 相同种类 的任务之间必须有长度为整数 n 的冷却时间,因此至少有连续 n 个单位时间内 CPU 在执行不同的任务,或者在待命状态.你需要计算完成所有任务所需要的 最短时间 .
- 思路
    * 建立大小为 n+1 的桶子,个数为任务数量最多的那个任务,比如下图,等待时间 n=2,A 任务个数 6 个,我们建立 6 桶子,每个容量为 3：
    ![任务调度器1](/img/20220602_1.png)
    * 先从最简单的情况看起,现在就算没有其他任务,我们完成任务 A 所需的时间应该是 (6-1)*3+1=16,因为最后一个桶子,不存在等待时间.
    ![任务调度器2](/img/20220602_2.png)
    * 接下来我们添加些其他任务
    ![任务调度器3](/img/20220602_3.png)
    * 可以看到 C 其实并没有对总体时间产生影响,因为它被安排在了其他任务的冷却期间；而 B 和 A 数量相同,这会导致最后一个桶子中,我们需要多执行一次 B 任务,现在我们需要的时间是 (6-1)*3+2=17
    * 前面两种情况,总结起来：**总排队时间 = (桶个数 - 1) * (n + 1) + 最后一桶的任务数**
    * 当冷却时间短,任务种类很多时
    ![任务调度器4](/img/20220602_4.png)
    * 比如上图,我们刚好排满了任务,此时所需时间还是 17,如果现在我还要执行两次任务 F,该怎么安排呢
    ![任务调度器5](/img/20220602_5.png)
    * 可以得出结论: 记录最大任务数量 N,看一下任务数量并列最多的任务有多少个,即最后一个桶子的任务数 X,计算 NUM1=(N-1)*(n+1)+x
- 代码实现
    ```python
        class Solution:
            def leastInterval(self, tasks: List[str], n: int) -> int:
                """
                m: 最大出现次数
                c: 有多少种元素出现了m次
                """
                counter = collections.Counter(tasks)
                m = 0   # 最大任务数量
                c = 0   # 最大任务数量的个数
                for v in counter.values():
                    if v > m:
                        m = v
                        c = 1
                    elif v == m:
                        c += 1
                # 总排队时间 = (桶个数 - 1) * (n + 1) + 最后一桶的任务数
                return max(len(tasks), (m-1) * (n+1) + c)
    ```

#### 根据身高重建队列
- 问题描述
    * 假设有打乱顺序的一群人站成一个队列,数组 people 表示队列中一些人的属性(不一定按顺序).每个 people[i] = [hi, ki] 表示第 i 个人的身高为 hi ,前面 正好 有 ki 个身高大于或等于 hi 的人.请你重新构造并返回输入数组 people 所表示的队列.返回的队列应该格式化为数组 queue ,其中 queue[j] = [hj, kj] 是队列中第 j 个人的属性(queue[0] 是排在队列前面的人).
- 思路
    * 首先对数对进行排序,按照数对的元素0降序排序,按照数对的元索1序排序
    * 按照元素0降序排序,对于每个元愫,在其之前的元素都是大于当前元素的数.
    * 按照元素1正向排序,是希望元素值相同时 k大的尽量在后面,保证插入时的正确性.(防止后面的相同值 插入到前面而影响结果,因为值是按降序排序的！)
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