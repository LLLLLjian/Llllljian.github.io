---
title: Leetcode_基础 (50)
date: 2019-05-07
tags: Leetcode
toc: true
---

### 2的幂
    Leetcode学习-231

<!-- more -->

#### Q
    给定一个整数,编写一个函数来判断它是否是 2 的幂次方.

    示例 1:

    输入: 1
    输出: true
    解释: 20 = 1
    示例 2:

    输入: 16
    输出: true
    解释: 24 = 16
    示例 3:

    输入: 218
    输出: false

#### A
    ```php
        class Solution {
            /**
             * @param Integer $n
             * @return Boolean
             */
            function isPowerOfTwo($n) {
                // &运算,同1则1. return (n > 0) && (n & -n) == n;
                // 解释: 2的幂次方在二进制下,只有1位是1,其余全是0.例如:8---00001000.负数的在计算机中二进制表示为补码(原码->正常二进制表示,原码按位取反(0-1,1-0),最后再+1.然后两者进行与操作,得到的肯定是原码中最后一个二进制的1.例如8&(-8)->00001000 & 11111000 得 00001000,即8.
                return ($n > 0) && ($n & -$n) == $n;
            }
            
            function isPowerOfTwo1($n) {
                // 移位运算: 把二进制数进行左右移位.左移1位,扩大2倍；右移1位,缩小2倍. return (n>0) && (1<<30) % n == 0;
                // 解释: 1<<30得到最大的2的整数次幂,对n取模如果等于0,说明n只有因子2.
                return ($n > 0) && (1<<30) % $n == 0;
            }
            
            function isPowerOfTwo2($n) {
                // 10进制转为2进制 2进制的2的幂仅会出现一个1
                $temp = decbin($n);
                if (substr_count($temp,'1') == 1) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```

#### R
<table class=""><colgroup><col><col><col><col><col></colgroup><thead class="ant-table-thead"><tr><th class="time-column__1XPS"><span>提交方法</span></th><th class="status-column__2sa0"><span>状态</span></th><th class="runtime-column__3PGH"><span>执行用时</span></th><th class="memory-column__3yTX"><span>内存消耗</span></th><th class="lang-column__3rNc"><span>语言</span></th></tr></thead><tbody class="ant-table-tbody"><tr class="ant-table-row  ant-table-row-level-0" data-row-key="19078478"><td class="time-column__1XPS"><span class="ant-table-row-indent indent-level-0" style="padding-left: 0px;"></span>isPowerOfTwo</td><td class="status-column__2sa0"><a class="ac__2y0l">通过</a></td><td class="runtime-column__3PGH">20 ms</td><td class="memory-column__3yTX">14.6 MB</td><td class="lang-column__3rNc">php</td></tr><tr class="ant-table-row  ant-table-row-level-0" data-row-key="19078441"><td class="time-column__1XPS"><span class="ant-table-row-indent indent-level-0" style="padding-left: 0px;"></span>isPowerOfTwo1</td><td class="status-column__2sa0"><a class="ac__2y0l">通过</a></td><td class="runtime-column__3PGH">20 ms</td><td class="memory-column__3yTX">14.8 MB</td><td class="lang-column__3rNc">php</td></tr><tr class="ant-table-row  ant-table-row-level-0" data-row-key="19078374"><td class="time-column__1XPS"><span class="ant-table-row-indent indent-level-0" style="padding-left: 0px;"></span>isPowerOfTwo2</td><td class="status-column__2sa0"><a class="ac__2y0l">通过</a></td><td class="runtime-column__3PGH">8 ms</td><td class="memory-column__3yTX">14.7 MB</td><td class="lang-column__3rNc">php</td></tr></tbody></table>
