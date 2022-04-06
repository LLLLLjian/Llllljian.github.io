---
title: Leetcode_基础 (163)
date: 2020-07-02
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-位运算

<!-- more -->

#### 前菜
1. 异或的性质
    * 两个数字异或的结果a^b是将 a 和 b 的二进制每一位进行运算, 得出的数字. 
    * 运算的逻辑是如果同一位的数字相同则为0, 不同则为 1
2. 异或的规律
    * 任何数和本身异或则为0
    * 任何数和 0 异或是本身

#### 只出现一次的数字1
- 问题描述
    * 给定一个非空整数数组, 除了某个元素只出现一次以外, 其余每个元素均出现两次.找出那个只出现了一次的元素
- 解题思路
    * 将所有数都异或一遍, 最后剩下的数字就是出现一次的数字
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer
             */
            function singleNumber($nums) 
            {
                $res = 0;
                $count = count($nums);
                for ($i=0;$i<$count;$i++) {
                    $res = $res ^ $nums[$i]; 
                }
                return $res;
            }
        }
    ```

#### 只出现一次的数字2
- 问题描述
    * 除了一个数字出现一次, 其他都出现了三次, 让我们找到出现一次的数
- 解题思路
    * 值得注意的是: 如果某个数字出现3次, 那么这个3个数字的和肯定能被3整除, 则其对应二进制位的每一位的和也能被3整除
    * 统计数组中每个数字的二进制中每一位的和, 判断该和是否能被3整除.
    * 若可以, 则只出现一次的数字的二进制数中那一位为0, 否则为1
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer
             */
            function singleNumber($nums) 
            {
                $res = 0;

                for ($i=0;$i<32;$i++) {
                    $cnt = 0;
                    $bit = 1 << $i;
                    for ($j=0;$j<count($nums);$j++) {
                        if ($nums[$j] & $bit) {
                            $cnt++;
                        }
                    }
                    if ($cnt%3 != 0) {
                        $res = $res | $bit;
                    }
                }

                if ($res > pow(2, 31) - 1) {
                    return $res - pow(2, 32);
                } else {
                    return $res;
                }
            }
        }
    ```

#### 只出现一次的数字3
- 问题描述
    * 给定一个整数数组 nums, 其中恰好有两个元素只出现一次, 其余所有元素均出现两次. 找出只出现一次的那两个元素
- 解题思路
    * 参照只出现一次的数字1 得到结果的异或, 对异或结果进行移位操作, 得到分组依据, 通过分组依据对目标数组循环分成两个数组并异或就得到结果了
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer[]
             */
            function singleNumber($nums) 
            {
                $res = array(0, 0);
                $count = count($nums);

                if (empty($nums) || $count < 2) {
                    return $res;
                }

                $xorRes = 0;
                for ($i=0;$i<$count;$i++) {
                    $xorRes ^= $nums[$i];
                }
                
                $temp = 1;// 用来标志第几位是 1
                while (true) {
                    if (($xorRes & 1) == 1) {
                        break;
                    }
                    $temp = $temp << 1;
                    $xorRes = $xorRes >> 1; // 右移, 从低到高
                }
                
                for ($i=0;$i<$count;$i++) {
                    if (($nums[$i] & $temp) == 0) { // 对应位是 0
                        $res[0] ^= $nums[$i];
                    } else {
                        $res[1] ^= $nums[$i];
                    }
                }
                return $res;
            }
        }
    ```
