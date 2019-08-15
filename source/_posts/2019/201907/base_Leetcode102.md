---
title: Leetcode_基础 (102)
date: 2019-07-15 12:00:00
tags: Leetcode
toc: true
---

### 数字的补数
    Leetcode学习-476

<!-- more -->

#### Q
    给定一个正整数,输出它的补数.补数是对该数的二进制表示取反.

    注意:

    给定的整数保证在32位带符号整数的范围内.
    你可以假定二进制数不包含前导零位.
    示例 1:

    输入: 5
    输出: 2
    解释: 5的二进制表示为101（没有前导零位）,其补数为010.所以你需要输出2.
    示例 2:

    输入: 1
    输出: 0
    解释: 1的二进制表示为1（没有前导零位）,其补数为0.所以你需要输出0.

#### A
    ```php
        class Solution {
            /**
            * @param Integer $num
            * @return Integer
            */
            function findComplement($num) {
                // 5的二进制是101 7的二进制是111    111^101=010
                // 先找到$num二进制全是1的值  然后再^
                $a = 1;
                while (1) {
                    if ($a > $num) {
                        break;
                    }
                    $a *= 2;
                }
                
                $a = $a - 1;
                return $a^$num;
            }
        }
    ```
