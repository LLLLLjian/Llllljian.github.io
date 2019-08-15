---
title: Leetcode_基础 (105)
date: 2019-07-16 18:00:00
tags: Leetcode
toc: true
---

### 构造矩形
    Leetcode学习-492

<!-- more -->

#### Q
    作为一位web开发者, 懂得怎样去规划一个页面的尺寸是很重要的. 现给定一个具体的矩形页面面积,你的任务是设计一个长度为 L 和宽度为 W 且满足以下要求的矩形的页面.要求：

    1. 你设计的矩形页面必须等于给定的目标面积.

    2. 宽度 W 不应大于长度 L,换言之,要求 L >= W .

    3. 长度 L 和宽度 W 之间的差距应当尽可能小.
    你需要按顺序输出你设计的页面的长度 L 和宽度 W.

    示例：

    输入: 4
    输出: [2, 2]
    解释: 目标面积是 4, 所有可能的构造方案有 [1,4], [2,2], [4,1].
    但是根据要求2,[1,4] 不符合要求; 根据要求3,[2,2] 比 [4,1] 更能符合要求. 所以输出长度 L 为 2, 宽度 W 为 2.
    说明:

    给定的面积不大于 10,000,000 且为正整数.
    你设计的页面的长度和宽度必须都是正整数.

#### A
    ```php
        class Solution {
            /**
             * @param Integer $area
             * @return Integer[]
             */
            function constructRectangle($area) {
                // 找出所有符合条件的长和宽,存入一个列表中,然后再次遍历,找出差最小的那一对
                $res = array();
                
                for ($i=1;$i<($area+1);$i++) {
                    if ((($i*$i) <= $area) && ($area%$i == 0)) {
                        $res[] = array($area/$i, $i);
                    }
                    if (($i*$i) > $area) {
                        break;
                    }
                }
                return $this->getMinArr($res);
            }

            function constructRectangle1($area) {
                // 减少了i*i的比较次数
                $res = array();
                
                $i = 1;
                
                while (($i*$i) <= $area) {
                    if ($area%$i == 0) {
                        $res[] = array($area/$i, $i);
                    }
                    $i += 1;
                }
                
                return $this->getMinArr($res);
            }

            function constructRectangle2($area) {
                // 开方求解
                $sqrt = intval(sqrt($area));
                
                while ($area%$sqrt != 0) {
                    $sqrt--;
                }
                
                return array($area/$sqrt, $sqrt);
            }
            
            function getMinArr($arr) {
                $res = array();
                if (empty($arr)) {
                    return $res;
                }
                
                for ($i=0;$i<count($arr);$i++) {
                    $temp = $arr[$i][0] - $arr[$i][1];
                    if (empty($res)) {
                        $res[$i] = $temp;
                        continue;
                    }
                    if (($temp >= 0) && ($temp <= reset($res))) {
                        $res = array();
                        $res[$i] = $temp;
                    }
                }
                return $arr[reset(array_keys($res))];
            }
        }
    ```
