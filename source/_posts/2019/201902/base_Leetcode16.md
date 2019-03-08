---
title: Leetcode_基础 (16)
date: 2019-02-22
tags: Leetcode
toc: true
---

### 最大子序和
    Leetcode学习

<!-- more -->

#### Q
    给定一个由整数组成的非空数组所表示的非负整数，在该数的基础上加一。
    最高位数字存放在数组的首位， 数组中每个元素只存储一个数字。
    你可以假设除了整数 0 之外，这个整数不会以零开头。

    示例 1:
    输入: [1,2,3]
    输出: [1,2,4]
    解释: 输入数组表示数字 123。
    
    示例 2:
    输入: [4,3,2,1]
    输出: [4,3,2,2]
    解释: 输入数组表示数字 4321。

#### A
    ```php
        class Solution {
            function plusOne($digits) {
                if (empty($digits) || !is_array($digits)) {
                    return array();
                } else {
                    $digits[count($digits)-1] = $digits[count($digits)-1] + 1;
                    
                    for ($i=count($digits)-1;$i>=0;$i--) {
                        if ($digits[$i] == 10) {
                            $digits[$i] = 0;
                            if (isset($digits[$i - 1])) {
                                $digits[$i - 1] += 1;
                            } else {
                                array_unshift($digits, '1');
                            }
                        }
                    }
                }
                
                
                return $digits;
            }
        }

        $a = new Solution();
        $arr = array(9);
        var_dump($a->plusOne($arr));
    ```
