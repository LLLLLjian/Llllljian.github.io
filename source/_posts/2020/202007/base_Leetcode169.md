---
title: Leetcode_基础 (169)
date: 2020-07-21
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-贪心法

<!-- more -->

#### 跳跃游戏
- 问题描述
    * 给定一个非负整数数组,你最初位于数组的第一个位置.数组中的每个元素代表你在该位置可以跳跃的最大长度.判断你是否能够到达最后一个位置
- 解题思路
    * 解法1
    ![跳跃游戏](/img/20200721_1.png)
    * 解法2
        * 我们依次遍历数组中的每一个位置,并实时维护 最远可以到达的位置.对于当前遍历到的位置 x,如果它在 最远可以到达的位置 的范围内,那么我们就可以从起点通过若干次跳跃到达该位置,因此我们可以用x+nums[x] 更新 最远可以到达的位置.在遍历的过程中,如果 最远可以到达的位置 大于等于数组中的最后一个位置,那就说明最后一个位置可达,我们就可以直接返回 True 作为答案.反之,如果在遍历结束后,最后一个位置仍然不可达,我们就返回 False 作为答案
    ```php
        class Solution 
        {
            /**
             * [2,3,1,1,4]
             * [3,2,1,0,4]
             * 
             * @param Integer[] $nums
             * @return Boolean
             */
            function canJump1($nums) 
            {
                // 最远可跳至的位置
                $index = array();
                $i = 0;
                $count = count($nums);
                for ($i=0;$i<$count;$i++) {
                    $index[$i] = $i + $nums[$i];
                }
                // 跳的值
                $jump = 0;
                // 当前允许最大的跳跃值
                $maxIndex = $nums[0];
                // 直到jump跳到数组尾部 或者 jump超越了当前可以跳的最远位置
                // 一共就5个元素最多跳4步 或者 4步最远跳到了3
                while (($jump < $count) && ($jump <= $maxIndex)) {
                    if ($maxIndex < $index[$jump]) {
                        $maxIndex = $index[$jump];
                    }
                    $jump += 1;
                }

                if ($jump == $count)) {
                    return true;
                }
                return false;
            }

            function canJump2($nums)
            {
                $n = count($nums);
                $rightMost = 0;
                for ($i=0;$i<$n;$i++) {
                    if ($i <= $rightMost) {
                        $rightMost = max($rightMost, $i+$nums[$i]);

                        if ($rightMost >= ($n-1)) {
                            return true;
                        }
                    }
                }
                return false;
            }
        }
    ```

#### 跳跃游戏2
- 问题描述
    * 求跳跃游戏的最少跳跃次数
- 解题思路
    * 解法1
        * 从后往前, 先找到能到结果的最远的点
        * 离4最远的并且能到达的是index=1的3, 然后就找能到index=1的3的最远的, 就找到了index=0的2
    * 解法2
        * 维护当前能够到达的最大下标位置,记为边界.从左到右遍历数组,到达边界时,更新边界并将跳跃次数增加 1
    ```php
        class Solution 
        {
            /**
             * [0,1,2,3,4]
             * [2,3,1,1,4]
             * 
             * @param Integer[] $nums
             * @return Integer
             */
            function jump1($nums) 
            {
                $position = count($nums);
                $steps = 0;

                while ($position > 0) {
                    for ($i=0;$i<$position;$i++) {
                        if ($i+$nums[$i] >= $position) {
                            $position = $i;
                            $steps++;
                            break;
                        }
                    }
                }
                return  $steps;
            }

            function jump2($nums)
            {
                $length = count($nums);
                $end =0;
                $maxPosition = 0;
                $steps = 0;
                for ($i=0;$i<$length;$i++) {
                    $maxPosition = max($maxPosition, $i+$nums[$i]);

                    if ($i == $end) {
                        $end = $maxPosition;
                        $steps++;
                    }
                }
                return $steps;
            }
        }
    ```


