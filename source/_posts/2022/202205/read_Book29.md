---
title: 读书笔记 (29)
date: 2022-05-13
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-回溯算法秒杀所有排列/组合/子集问题

<!-- more -->

#### 回溯算法

论是排列、组合还是子集问题,简单说无非就是让你从序列 nums 中以给定规则取若干元素,主要有以下几种变体

- 形式一、元素无重不可复选,即 nums 中的元素都是唯一的,每个元素最多只能被使用一次,这也是最基本的形式.
    * 以组合为例,如果输入 nums = [2,3,6,7],和为 7 的组合应该只有 [7].
- 形式二、元素可重不可复选,即 nums 中的元素可以存在重复,每个元素最多只能被使用一次.
    * 以组合为例,如果输入 nums = [2,5,2,1,2],和为 7 的组合应该有两种 [2,2,2,1] 和 [5,2].
- 形式三、元素无重可复选,即 nums 中的元素都是唯一的,每个元素可以被使用若干次.
    * 以组合为例,如果输入 nums = [2,3,6,7],和为 7 的组合应该有两种 [2,2,3] 和 [7].
- 组合/子集树
    ![组合/子集树](/img/20220513_1.png)
- 排列树
    ![排列树](/img/20220513_2.png)

#### 子集(元素无重不可复选)
- 问题描述
    * 给你一个整数数组 nums ,数组中的元素 互不相同 .返回该数组所有可能的子集(幂集).解集 不能 包含重复的子集.你可以按 任意顺序 返回解集.
- 自己的思路
    * 可以理解为拜把子, 需要每个人都和之前队伍里的人都认识一下
- 代码实现
    ```python
        class Solution:
            def subsets(self, nums: List[int]) -> List[List[int]]:
                res = []
                res.append([])
                for num in nums:
                    # 获取一下当前队伍有几个人
                    length = len(res)
                    for i in range(length):
                        # 每个人都和之前队伍里的人认识一下并入队
                        temp = res[i] + [num]
                        res.append(temp)
                return res
    ```
- 回溯思路
    * 首先,生成元素个数为 0 的子集,即空集 [],为了方便表示,我称之为 S_0
    * 然后,在 S_0 的基础上生成元素个数为 1 的所有子集,我称为 S_1
    * 接下来,我们可以在 S_1 的基础上推导出 S_2,即元素个数为 2 的所有子集
    * 接着,我们可以通过 S_2 推出 S_3,实际上 S_3 中只有一个集合 [1,2,3],它是通过 [1,2] 推出的
    * ![子集](/img/20220513_3.png)
- 代码实现
    ```python
        class Solution:
            def subsets(self, nums: List[int]) -> List[List[int]]:
                res = []
                def backtrack(nums, start, path):
                    # 每个节点的值都是一个子集
                    res.add([list(path)])
                    for i in range(start, len(nums)):
                        path.append(nums[i])
                        backtrack(nums, i+1, path)
                        path.remove(nums[i])
                backtrack(nums, 0, [])
                return res
    ```

#### 组合(元素无重不可复选)
- 问题描述
    * 给你输入一个数组 nums = [1,2..,n] 和一个正整数 k,请你生成所有大小为 k 的子集
- 解题思路
    * 还是以 nums = [1,2,3] 为例,刚才让你求所有子集,就是把所有节点的值都收集起来；现在你只需要把第 2 层(根节点视为第 0 层)的节点收集起来,就是大小为 2 的所有组合
    * ![组合](/img/20220513_4.png)
- 解题思路
    ```python
        class Solution:
            def combine(self, n: int, k: int) -> List[List[int]]:
                res = []
                def backtrack(path, nums, start, k):
                    if len(path) == k:
                        res.append(list(path))
                        return
                    for i in range(start, len(nums)):
                        path.append(nums[i])
                        backtrack(path, nums, i+1, k)
                        path.pop()
                nums = [i for i in range(1, n+1)]
                backtrack([], nums, 0, k)
                return res
    ```

#### 排列(元素无重不可复选)
- 问题描述
    * 给定一个不含重复数字的数组 nums,返回其所有可能的全排列
- 思路
    * 回溯+记录使用
- 代码实现
    ```python
        class Solution:
            def permute(self, nums: List[int]) -> List[List[int]]:
                res = []
                def backtrack(path, nums, used):
                    if len(path) == len(nums):
                        res.append(list(path))
                        return
                    for num in nums:
                        if num in used and used[num]:
                            continue
                        path.append(num)
                        used[num] = True
                        backtrack(path, nums, used)
                        path.pop()
                        used[num] = False
                backtrack([], nums, {})
                return res
    ```

#### 子集/组合(元素可重不可复选)
- 问题描述
    * 给你一个整数数组 nums,其中可能包含重复元素,请你返回该数组所有可能的子集
- 思路
    * 需要先进行排序,让相同的元素靠在一起,如果发现 nums[i] == nums[i-1],则跳过
- 代码实现
    ```python
        class Solution:
            def subsetsWithDup(self, nums: List[int]) -> List[List[int]]:
                res = []
                def backtrack(path, nums, start):
                    # 每个都要加入
                    res.append(list(path))
                    for i in range(start, len(nums)):
                        # 剪枝逻辑,值相同的相邻树枝,只遍历第一条
                        if (i > start) and (nums[i] == nums[i-1]):
                            continue
                        path.append(nums[i])
                        backtrack(path, nums, i+1)
                        path.pop()
                nums.sort()
                backtrack([], nums, 0)
                return res
    ```

- 问题描述
    * 给你输入 candidates 和一个目标和 target,从 candidates 中找出中所有和为 target 的组合. candidates 可能存在重复元素,且其中的每个数字最多只能使用一次.
- 思路
    * 需要先进行排序,让相同的元素靠在一起,如果发现 nums[i] == nums[i-1],则跳过
- 代码实现
    ```python
        class Solution:
            def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
                candidates.sort()
                res = []
                def backtrack(path, nums, start, target):
                    # 先写条件
                    if sum(path) == target:
                        res.append(list(path))
                        return
                    # 超过了就直接返回
                    if sum(path) > target:
                        return
                    for i in range(start, len(nums)):
                        if (i > start) and (nums[i] == nums[i-1]):
                            continue
                        path.append(nums[i])
                        backtrack(path, nums, i+1, target)
                        path.pop()
                backtrack([], candidates, 0, target)
                return res
    ```

#### 排列(元素可重不可复选)
- 问题描述
    * 给你输入一个可包含重复数字的序列 nums,请你写一个算法,返回所有可能的全排列
- 思路
    * 加一个排序, 加一个额外的剪枝
    * 新增了 not used[i - 1] 的逻辑判断
        * 考虑[1,1',1'',2]
        * 使用!used[i-1],递归过程中有一个情况是,已经选择了1,正在判定是否选择1'',但由于前一个1' 没有被使用(!used[i-1]) ,所以continue剪枝,所以最终只会有1,1',1''...的顺序排列
        * 使用used[i-1],递归过程中有一个情况是,已经选择了1,正在判定是否选择1'',但由于前一个1' 已经被使用(used[i-1]) ,所以continue剪枝,所以最终会有1,1'',1'...的乱序排列
- 代码实现
    ```python
        class Solution:
            def permuteUnique(self, nums: List[int]) -> List[List[int]]:
                res = []
                nums.sort()
                used = {}
                def backtrack(path, nums, used):
                    # 先写条件
                    if len(path) == len(nums):
                        res.append(list(path))
                        return
                    for i in range(len(nums)):
                        if i in used and used[i]:
                            continue
                        # 新添加的剪枝逻辑,固定相同的元素在排列中的相对位置
                        if (i > 0) and (nums[i] == nums[i-1]) and (not used[i-1]):
                            # 如果前面的相邻相等元素没有用过,则跳过
                            continue
                        path.append(nums[i])
                        used[i] = True
                        backtrack(path, nums, used)
                        path.pop()
                        used[i] = False
                backtrack([], nums, used)
                return res
    ```

#### 子集/组合(元素无重可复选)
- 问题描述
    * 给你一个无重复元素的整数数组 candidates 和一个目标和 target,找出 candidates 中可以使数字和为目标数 target 的所有组合.candidates 中的每个数字可以无限制重复被选取.
- 思路
    * 
- 代码实现
    ```python
        class Solution:
            def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
                res = []
                candidates.sort()
                def backtrack(path, nums, start, target):
                    # 先写条件
                    temp = sum(path)
                    if temp == target:
                        res.append(list(path))
                        return
                    elif temp > target:
                        # 大于target直接返回
                        return
                    for i in range(start, len(nums)):
                        path.append(nums[i])
                        # 同一元素可重复使用,所以还是从0开始
                        backtrack(path, nums, i, target)
                        path.pop()
                backtrack([], candidates, 0, target)
                return res
    ```

#### 总结
- 元素无重不可复选,即 nums 中的元素都是唯一的,每个元素最多只能被使用一次
    ```
        /* 组合/子集问题回溯算法框架 */
        void backtrack(int[] nums, int start) {
            // 回溯算法标准框架
            for (int i = start; i < nums.length; i++) {
                // 做选择
                track.addLast(nums[i]);
                // 注意参数
                backtrack(nums, i + 1);
                // 撤销选择
                track.removeLast();
            }
        }

        /* 排列问题回溯算法框架 */
        void backtrack(int[] nums) {
            for (int i = 0; i < nums.length; i++) {
                // 剪枝逻辑
                if (used[i]) {
                    continue;
                }
                // 做选择
                used[i] = true;
                track.addLast(nums[i]);

                backtrack(nums);
                // 撤销选择
                track.removeLast();
                used[i] = false;
            }
        }
    ```
- 元素可重不可复选,即 nums 中的元素可以存在重复,每个元素最多只能被使用一次, **其关键在于排序和剪枝**
    ```
        Arrays.sort(nums);
        /* 组合/子集问题回溯算法框架 */
        void backtrack(int[] nums, int start) {
            // 回溯算法标准框架
            for (int i = start; i < nums.length; i++) {
                // 剪枝逻辑,跳过值相同的相邻树枝
                if (i > start && nums[i] == nums[i - 1]) {
                    continue;
                }
                // 做选择
                track.addLast(nums[i]);
                // 注意参数
                backtrack(nums, i + 1);
                // 撤销选择
                track.removeLast();
            }
        }

        Arrays.sort(nums);
        /* 排列问题回溯算法框架 */
        void backtrack(int[] nums) {
            for (int i = 0; i < nums.length; i++) {
                // 剪枝逻辑
                if (used[i]) {
                    continue;
                }
                // 剪枝逻辑,固定相同的元素在排列中的相对位置
                if (i > 0 && nums[i] == nums[i - 1] && !used[i - 1]) {
                    continue;
                }
                // 做选择
                used[i] = true;
                track.addLast(nums[i]);

                backtrack(nums);
                // 撤销选择
                track.removeLast();
                used[i] = false;
            }
        }
    ```
- 元素无重可复选,即 nums 中的元素都是唯一的,每个元素可以被使用若干次,**只要删掉去重逻辑即可**
    ```
        /* 组合/子集问题回溯算法框架 */
        void backtrack(int[] nums, int start) {
            // 回溯算法标准框架
            for (int i = start; i < nums.length; i++) {
                // 做选择
                track.addLast(nums[i]);
                // 注意参数
                backtrack(nums, i);
                // 撤销选择
                track.removeLast();
            }
        }


        /* 排列问题回溯算法框架 */
        void backtrack(int[] nums) {
            for (int i = 0; i < nums.length; i++) {
                // 做选择
                track.addLast(nums[i]);
                backtrack(nums);
                // 撤销选择
                track.removeLast();
            }
        }
    ```




