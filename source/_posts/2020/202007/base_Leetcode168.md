---
title: Leetcode_基础 (168)
date: 2020-07-20
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-贪心法

<!-- more -->

#### 摆动序列
- 问题描述
    * 如果连续数字之间的差严格地在正数和负数之间交替,则数字序列称为摆动序列.第一个差(如果存在的话)可能是正数或负数.少于两个元素的序列也是摆动序列.例如, [1,7,4,9,2,5] 是一个摆动序列,因为差值 (6,-3,5,-7,3) 是正负交替出现的.相反, [1,4,7,2,5] 和 [1,7,4,5,5] 不是摆动序列,第一个序列是因为它的前两个差值都是正数,第二个序列是因为它的最后一个差值为零.给定一个整数序列,返回作为摆动序列的最长子序列的长度. 通过从原始序列中删除一些(也可以不删除)元素来获得子序列,剩下的元素保持其原始顺序.
- 解题思路
    1. nums[i+1] > nums[i]
        * 假设down[i]表示的最长摆动序列的最远末尾元素下标正好为i,遇到新的上升元素后,up[i+1] = down[i] + 1,这是因为up一定从down中产生(初始除外),并且down[i]此时最大.
        * 假设down[i]表示的最长摆动序列的最远末尾元素下标小于i,设为j,那么nums[j:i]一定是递增的,因为若完全递减,最远元素下标等于i,若波动,那么down[i] > down[j].由于nums[j:i]递增,down[j:i]一直等于down[j],依然满足up[i+1] = down[i] + 1.
    2. nums[i+1] < nums[i],类似第一种情况
    3. nums[i+1] == nums[i],新的元素不能用于任何序列,保持不变
    ![摆动序列解题思路](/img/20200720_1.png)
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer
             */
            function wiggleMaxLength($nums) 
            {
                $count = count($nums);
                $up = $down = 1;
                if ($count < 2) {
                    return $count;
                }
                for ($i=1;$i<$count;$i++) {
                    if ($nums[$i] > $nums[$i-1]) {
                        $up = $down + 1;
                    }
                    if ($nums[$i] < $nums[$i-1]) {
                        $down = $up + 1;
                    }
                }

                return max($up, $down);
            }

            /**
             * 状态机, 根据当前状态判断$res是否需要加1
             */
            function wiggleMaxLength1($nums) 
            {
                $count = count($nums);
                if ($count < 2) {
                    return $count;
                }
                $state = "BEGIN";
                $res = 1;

                for ($i=1;$i<$count;$i++) {
                    switch($state) {
                        case "BEGIN":
                            if ($nums[$i] > $nums[$i-1]) {
                                $state = "UP";
                                $res++;
                            }
                            if ($nums[$i] < $nums[$i-1]) {
                                $state = "DOWN";
                                $res++;
                            }
                            break;
                        case "UP":
                            if ($nums[$i] < $nums[$i-1]) {
                                $state = "DOWN";
                                $res++;
                            }
                            break;
                        case "DOWN":
                            if ($nums[$i] > $nums[$i-1]) {
                                $state = "UP";
                                $res++;
                            }
                            break;
                    }
                }
                return $res;
            }
        }
    ```

#### 删除k个数字之后的最小值
- 问题描述
    * 给出一个整数, 从该整数中去掉k个数字, 要求剩下的数字形成的新整数尽可能的小
    * 例如1234 去除一个数字的话, 去除4 得到的结果是123
    * 例如3549 去除一个数字的话, 去除5 得到的结果是349
- 解题思路
    * 先把问题简化一下, 只去除一个数字
    * 把原整数的所有数字从左到右进行比较, 如果发现某一个数字比他右边的数字大, 那么去掉它是最合适的
    ```php
        class Solution 
        {
            /**
             * @param String $num
             * @param Integer $k
             * @return String
             */
            function removeKdigits($num, $k) 
            {
                $tempArr = str_split($num);
                $resArr = array();
                for($i=0;$i<count($tempArr);$i++){
                    while (!empty($resArr) && (end($resArr) > $tempArr[$i]) && ($k>0)) {
                        array_pop($resArr);
                        $k-=1;
                    }
                    $resArr[] =  $tempArr[$i];
                }
                $resStr = implode($resArr);
                $resStr = ltrim(substr($resStr, 0, count($resArr) - $k), 0);
                if (empty($resStr)) {
                    $resStr = "0";
                }
                return $resStr;
            }
        }
    ```


