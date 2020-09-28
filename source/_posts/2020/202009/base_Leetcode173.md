---
title: Leetcode_基础 (173)
date: 2020-09-03
tags: Leetcode
toc: true
---

### 面试题
    是道面试题-积水问题

<!-- more -->

#### 积水问题
- 问题描述
![积水问题](/img/20200903_1.png)
- 解题思路(自己想的)
    * 可以通过分层去解决, 计算出每一层的存水量, 然后相加
    ```php
        function test($arr)
        {
            $num = 0;
            
            // 缩减台阶
            while(!empty($arr)) {
                if (!empty($arr)) {
                    while (!empty($arr)) {
                        // 去掉前边的空台阶
                        $first = current($arr);
                        if ($first <= 0) {
                            array_shift($arr);
                        } else {
                            break;
                        }
                        // 去掉后边的空台阶
                        $end = end($arr);
                        if ($end <= 0) {
                            array_pop($arr);
                        } else {
                            break;
                        }
                    }
                } else {
                    break;
                }

                // 此时台阶为0的 就是积水的地方
                $num += getZeroNum($arr);
                // 台阶减1 计算下一层台阶
                $arr = array_map("decr", $arr);
            }
            return $num;
        }

        // 获取数组中为0的数量
        function getZeroNum($arr)
        {
            $temp = array_count_values($arr);
            return isset($temp[0]) ? $temp[0] : 0;
        }

        // 台阶减1
        function decr($n)
        {
            // 防止出现两层都为空的情况
            if (($n-1) < 0) {
                return 0;
            } else {
                return ($n-1) ;
            }
        }

        $arr = array(0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1);
        var_dump(test($arr));
    ```
- 解题思路(别人想的)
    * 分别从坐向右,从右向左遍历数组,找到每个i的maxLeft和maxRight,再比较min(maxLeft,maxRight),若最小值大于i,则差值为蓄水量.例：横坐标上(3,0)的蓄水量为1.其maxLeft为1,maxRight为2,min(1,2)=1,1-0=1
    ```php
        function test($arr)
        {
            $length = count($arr);
            $maxValue = 0;// 最大值
            $maxKey = 0;// 最大值对应的数组下标

            for ($i=0;$i<$length;$i++) {
                if ($maxValue < $arr[$i]) {
                    $maxValue = $arr[$i];
                    $maxKey = $i;
                }
            }

            $maxLeft = 0;// 从左边开始遍历时的极大值
            $maxRight = 0;// 从右边开始遍历时的极大值
            $v = 0;// 储存容量

            // 从左边开始向右遍历到最大值处
            for ($i=0;$i<$maxKey;$i++) {
                // 不断更新左边的极大值
                if ($maxLeft < $arr[$i]) {
                    $maxLeft = $arr[$i];
                } else {
                    // 否则 加上新增加的容积
                    $v += ($maxLeft - $arr[$i]);
                }
            }

            // 从最右边开始向左遍历到最大值处
            for ($j=$length-1;$j>$maxKey;$j--) {
                // 不断更新右边的极大值
                if ($maxRight < $arr[$j]) {
                    $maxRight = $arr[$j];
                } else {
                    // 否则 加上新增加的容积
                    $v += ($maxRight - $arr[$j]);
                }
            }
            return $v;
        }

        $arr = array(0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1);
        var_dump(test($arr));
    ```



