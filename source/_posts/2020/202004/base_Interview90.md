---
title: Interview_总结 (90)
date: 2020-04-14
tags: Interview
toc: true
---

### 算法题
    把数组排成最小的数

<!-- more -->

#### 把数组排成最小的数
> 输入一个非负整数数组,把数组里所有数字拼接起来排成一个数,打印能拼接出的所有数字中最小的一个.
示例 1:
输入: [10,2]
输出: "102"
示例 2:
输入: [3,30,34,5,9]
输出: "3033459"
提示:
0 < nums.length <= 100
说明:
输出结果可能非常大,所以你需要返回一个字符串而不是整数
拼接起来的数字可能会有前导 0,最后结果不需要去掉前导 0
- 解题思路
    * 此题求拼接起来的 “最小数字” ,本质上是一个排序问题.
    * 排序判断规则:  设 numsnums 任意两数字的字符串格式 xx 和 yy ,则
    * 若拼接字符串 x + y > y + xx+y>y+x ,则 m > nm>n ；
    * 反之,若 x + y < y + xx+y<y+x ,则 n < mn<m ；
    * 根据以上规则,套用任何排序方法对 numsnums 执行排序即可.
- A
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return String
             */
            function minNumber($nums) 
            {
                $count = count($nums);
                for ($i=0;$i<$count;$i++) {
                    $tempFlag = true;
                    for ($j=0;$j<$count-$i-1;$j++) {                
                        if ($nums[$j].$nums[$j+1] > $nums[$j+1].$nums[$j]) {
                            $tempStr = $nums[$j+1];
                            $nums[$j+1] = $nums[$j];
                            $nums[$j] = $tempStr;

                            $tempFlag = false;
                        }
                    }

                    if ($tempFlag) {
                        break;
                    }
                }
                return implode("", $nums);
            }

            function minNumber1($nums)
            {
                //模拟排序
                //var_dump('303' > '330');exit;
                usort($nums, function($a, $b) {
                    $astr = (string)($a);
                    $bstr = (string)($b);
                    return ($astr . $bstr) > ($bstr . $astr);
                });
                return implode('', $nums);
            }
        }
    ```


