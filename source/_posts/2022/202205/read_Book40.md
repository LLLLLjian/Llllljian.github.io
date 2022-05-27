---
title: 读书笔记 (40)
date: 2022-05-24
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-田忌赛马背后的算法决策

<!-- more -->

#### 优势洗牌
- 问题描述
    * 给定两个大小相等的数组 nums1 和 nums2,nums1 相对于 nums 的优势可以用满足 nums1[i] > nums2[i] 的索引 i 的数目来描述.返回 nums1 的任意排列,使其相对于 nums2 的优势最大化.
- 思路
    * 如果田忌的一号选手比不过齐王的一号选手,那其他马肯定是白给了,显然这种情况应该用田忌垫底的马去送人头,降低己方损失,保存实力,增加接下来比赛的胜率.
    * 但如果田忌的一号选手能比得过齐王的一号选手,那就和齐王硬刚好了,反正这把田忌可以赢
- 伪代码
    ```
        int n = nums1.length;

        sort(nums1); // 田忌的马
        sort(nums2); // 齐王的马
        // 从最快的马开始比
        for (int i = n - 1; i >= 0; i--) {
            if (nums1[i] > nums2[i]) {
                // 比得过,跟他比
            } else {
                // 比不过,换个垫底的来送人头
            }
        }
    ```
- 代码实现
    ```python
        class Solution:
            def advantageCount(self, nums1: List[int], nums2: List[int]) -> List[int]:
                res = []
                # 降序排列nums1
                nums1.sort(reverse=True)
                # nums2的索引与值组成元组,以便排序后返回,本例中nums3 = [(0,1), (1,10),(2,4), (3,11)]
                nums3 = []
                for i in range(len(nums2)):
                    nums3.append((i, nums2[i]))

                # 对nums3中第二列降序排列(其实就是对nums2降序排列),排列后得[(3,11), (1,10),(2,4), (0,1)]
                nums3.sort(key=lambda x:x[1], reverse=True)

                # 从nums1的后面开始弹元素s,如果元素s比C中最后一个元素大的话,就将nums1中弹出的s【int】和m【tuple】组成一个元组,反之就将s与nums3中第一个元素组成元组添加到res中,
                # 最后形成：[(2, (0, 1)), (7, (2, 4)), (11, (1, 10)), (15, (3, 11))]
                while nums1:
                    s = nums1.pop()
                    if s > nums3[-1][1]:
                        res.append((s, nums3.pop()))
                    else:
                        res.append((s, nums3.pop(0)))

                # 排序,返回
                res.sort(key=lambda x: x[1][0])
                return [i[0] for i in res]
    ```
