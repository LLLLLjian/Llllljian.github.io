---
title: Leetcode_基础 (153)
date: 2020-05-19
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-子数组最大平均数 I

<!-- more -->

#### 子数组最大平均数 I
    给定 n 个整数,找出平均数最大且长度为 k 的连续子数组,并输出该最大平均数.
    示例 1:
    输入: [1,12,-5,-6,50,3], k = 4
    输出: 12.75
    解释: 最大平均数 (12-5-6+50)/4 = 51/4 = 12.75
    注意:
    1 <= k <= n <= 30,000.
    所给数据范围 [-10,000,10,000].
- A
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $arr
             * @param Integer $k
             * @return Float
             * 
             * 假设我们已经索引从 i 到 i+k 子数组和为 x.
             * 要知道索引从 i+1 到 i+k+1 子数组和,只需要从 x 减去 sum[i],加上 sum[i+k+1] 即可
             * 根据此方法可以获得长度为 k 的子数组最大平均值
             */
            function findMaxAverage($arr, $k) 
            {
                $count = count($arr);

                if ($count < $k) {
                    return -1;
                }

                // 计算出第一个窗口的值
                $maxSum = 0;
                for ($i=0;$i<$k;$i++) {
                    $maxSum += $arr[$i];
                }

                $res = $maxSum;
                // 开始滑动窗口
                for ($i=$k;$i<$count;$i++) {
                    // 新窗口的值 = 旧窗口值 - 左边第一个 + 右边第一个
                    $maxSum = $maxSum + $arr[$i] - $arr[$i - $k];
                    $res = max($res, $maxSum);
                }
                return $res/$k;    
            }
        }
    ```

