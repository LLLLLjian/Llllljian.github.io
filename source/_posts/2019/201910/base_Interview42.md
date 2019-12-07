---
title: Interview_总结 (42)
date: 2019-10-16
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * 表a、b、c之间用id关联,求阴影部分的数据
    ![问题1](/img/20191016_1.png)
- A
    ```sql
        ## 解题思路
        ## a表中为 1 2 3     6 7 8 9
        ## b表中为 1 2 3 4 5         10 11
        ## c表中为 1     4 5 6 7           12 13
        ## 想得到的结果是 2 3 4 5 6 7
        ## 得到出现两次的数
        SELECT * from (
            SELECT id from a
            UNION ALL
            SELECT id FROM b
            UNION ALL
            SELECT id from c) d 
        GROUP BY d.id 
        HAVING COUNT(d.id) = 2
    ```

#### 问题2
- Q
    * 一个整形无序数组,里面两个数之和[A+B]等于某个数[C],求这两个数
- A
    ```php
        // 解题思路[暴力法就不说了, 两个循环自己操作]
        // 一遍循环, 在新数组中寻找 C与当前值的差, 找不到的话把当前值放进新数组中
        function twoSum($nums, $target) 
        {
            $tempNums = array();
            $count = count($nums);
            for ($i=0;$i<$count;$i++) {
                $temp = $target - $nums[$i];
                if (array_key_exists($temp, $tempNums)) {
                    return [$tempNums[$temp], $i];
                } else {
                    $tempNums[$nums[$i]] = $i;
                }
            }
            return [-1, -1];
        }
    ```

#### 问题2进阶
- Q
    * 一个整形无序数组,里面三个数之和等于0,求这三个数
- A
    ```php
        // 解题思路[暴力法就不说了, 三个循环自己操作]
        // 无序数组排序
        // 定义三个变量 I[C位] L[最小的] R[最大的]
        // 如果 nums[i]nums[i]大于 00,则三数之和必然无法等于 00,结束循环
        // 如果 nums[i]nums[i] == nums[i-1]nums[i−1],则说明该数字重复,会导致结果重复,所以应该跳过
        // 当 sumsum == 00 时,nums[L]nums[L] == nums[L+1]nums[L+1] 则会导致结果重复,应该跳过,L++
        // 当 sumsum == 00 时,nums[R]nums[R] == nums[R-1]nums[R−1] 则会导致结果重复,应该跳过,R--
        // 时间复杂度：O(n^2),nn 为数组长度
        function threeSum($nums) {
            $count = count($nums);
            $res = array();
            if (($count < 3) || empty($nums)) {
                return $res;
            } 

            sort($nums);
            for ($i=0;$i<$count;$i++) {
                if ($nums[$i] > 0) {
                    // 如果第一个数都比0大 那三数之和一定大于0
                    break;
                }
                if (($i>0) && ($nums[$i] == $nums[$i-1])) {
                    // 当前i与下一个数相同
                    continue;
                }

                $l = $i + 1;
                $r = $count - 1;
                while ($l < $r)
                {
                    $sum = $nums[$i] + $nums[$l] + $nums[$r];
                    if ($sum == 0) {
                        $res[] = array($nums[$i], $nums[$l], $nums[$r]);

                        while(($l<$r) && ($nums[$l] == $nums[$l+1])) 
                        {
                            $l++;
                        }
                        while(($l<$r) && ($nums[$r] == $nums[$r-1])) 
                        {
                            $r--;
                        }
                        $l++;
                        $r--;
                    } elseif ($sum < 0) {
                        $l++;
                    } elseif ($sum > 0) {
                        $r--;
                    }
                }
            }
            return $res;
        }
    ```

