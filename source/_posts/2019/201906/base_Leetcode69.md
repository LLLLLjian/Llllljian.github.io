---
title: Leetcode_基础 (69)
date: 2019-06-03
tags: Leetcode
toc: true
---

### 区域和检索-数组不可变
    Leetcode学习-303

<!-- more -->

#### Q
    给定一个整数数组  nums，求出数组从索引 i 到 j  (i ≤ j) 范围内元素的总和，包含 i,  j 两点。

    示例：

    给定 nums = [-2, 0, 3, -5, 2, -1]，求和函数为 sumRange()
    sumRange(0, 2) -> 1
    sumRange(2, 5) -> -1
    sumRange(0, 5) -> -3
    说明:
    你可以假设数组不可变。
    会多次调用 sumRange 方法。

#### A
    ```php
        class NumArray {
            public $sumArr;
            /**
             * @param Integer[] $nums
             */
            function __construct($nums) {
                $this->sumArr = array();
                $countN = count($nums);
                
                for ($i=0;$i<$countN;$i++) {
                    if ($i == 0) {
                        $this->sumArr[$i] = $nums[$i];
                    } else {
                        $this->sumArr[$i] = $nums[$i] + $this->sumArr[$i-1];
                    }
                }
            }
        
            /**
             * @param Integer $i
             * @param Integer $j
             * @return Integer
             */
            function sumRange($i, $j) {
                if ($i ==0) {
                    return $this->sumArr[$j];
                } else {
                    return $this->sumArr[$j] - $this->sumArr[$i-1];
                }
            }
        }

        /**
        * Your NumArray object will be instantiated and called as such:
        * $obj = NumArray($nums);
        * $ret_1 = $obj->sumRange($i, $j);
        */
        $nums = array(-2, 0, 3, -5, 2, -1);
        $obj = new NumArray($nums);
        var_dump($obj->sumRange(0, 2));
        echo "<br />";
        var_dump($obj->sumRange(2, 5));
        echo "<br />";
        var_dump($obj->sumRange(0, 5));
        echo "<br />";

        $nums = array(-4, -5);
        $obj = new NumArray($nums);
        var_dump($obj->sumRange(0, 0));
        echo "<br />";
        var_dump($obj->sumRange(1, 1));
        echo "<br />";
        var_dump($obj->sumRange(0, 1));
        echo "<br />";
        var_dump($obj->sumRange(1, 1));
        echo "<br />";
        var_dump($obj->sumRange(0, 0));
        echo "<br />";
    ```
