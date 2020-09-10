---
title: Leetcode_基础 (170)
date: 2020-07-22
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-贪心法

<!-- more -->

#### 射击气球
- 问题描述
- 解题思路
    * 我的思路(方法1)
        * 按照气球的左端点从小到大排序(快排或者用usort排)
        * 遍历气球数组, 维护一个射击区间,在满足可以将当前气球射穿的情况下 尽可能击穿更多的气球 没击穿一个新的气球更新一次射击区间
        * 如果新的气球没办法击穿,就增加一个弓箭手,即维护一个新的射击区间,随后继续遍历气球数组
    * 力扣思路(方法2)
        * 根据 x_end 将气球进行排序.
        * 初始化 first_end 为第一个气球结束的坐标 points[0][1].
        * 初始化箭的数量 arrows = 1.
        * 遍历所有的气球：如果气球的开始坐标大于 first_end：则增加箭的数量.将 first_end 设置为当前气球的 x_end.
        * 返回 arrows
    ```php
        class Solution 
        {
            /**
             * @param Integer[][] $points
             * @return Integer
             */
            function findMinArrowShots($points) 
            {
                if (empty($points)) {
                    return 0;
                }
                //$points = $this->balloonSort($points);
                usort($points,function($value1,$value2){
                    if( $value1[0] > $value2[0] ){
                        return 1;
                    }else if( $value1[0] < $value2[0] ){
                        return -1;
                    }else{
                        if( $value1[1] > $value2[1] ){
                            return 1;
                        }else if($value1[1] < $value2[1]){
                            return -1;
                        }else{
                            return 0;
                        }
                    }
                });
            
                $res = array();
                $tempS = 0;
                $tempE = PHP_INT_MAX;
                $resCount = 0;

                $count = count($points);
                for ($i=0;$i<$count;$i++) {
                    // 维护左边
                    if ($tempS < $points[$i][0]) {
                        $tempS = $points[$i][0];
                    }
                    // 维护右边
                    if ($tempE > $points[$i][1]) {
                        $tempE = $points[$i][1];
                    }
                    if ($tempS > $tempE) {
                        // 如果发现起点大于终点 就说明当前这个区间不能击穿下一个气球 需要再加一个区间
                        $tempE = $points[$i][1];
                        $res = array($tempS, $tempE);
                        $resCount += 1;
                    } else {
                        if (!empty($res)) {
                            // 如果当前气球导致起点右移, 更新起点
                            $res[0] = $tempS;
                        } else {
                            // 初始化节点
                            $res = array($tempS, $tempE);
                            $resCount += 1;
                        }
                    }
                }
                return $resCount;
            }

            function balloonSort($points)
            {
                if (empty($points)) {
                    return $points;
                } else {
                    $middle = $points[0];
                    $sortMiddle = $middle[0];
                    $sortMiddle1 = $middle[1];

                    $leftBalloon = $rightBalloon = array();
                    $count = count($points);
                    for ($i=1;$i<$count;$i++) {
                        if ($points[$i][0] < $sortMiddle) {
                            $leftBalloon[] = $points[$i];
                        }
                        if ($points[$i][0] > $sortMiddle) {
                            $rightBalloon[] = $points[$i];
                        }
                        if ($points[$i][0] == $sortMiddle) {
                            if ($points[$i][1] < $sortMiddle1) {
                                $leftBalloon[] = $points[$i];
                            } else {
                                $rightBalloon[] = $points[$i];
                            }
                        }
                    }
                    $leftBalloon = $this->balloonSort($leftBalloon);
                    $rightBalloon = $this->balloonSort($rightBalloon);
                    $res = array_merge($leftBalloon, array($middle), $rightBalloon);
                    return $res;
                }
            }

            function findMinArrowShots1($points)
            {
                if (empty($points)) {
                    return 0;
                }
                //$points = $this->balloonSort($points);
                usort($points,function($value1,$value2){
                    if( $value1[1] > $value2[1] ){
                        return 1;
                    }else if( $value1[1] < $value2[1] ){
                        return -1;
                    }else{
                        if( $value1[0] > $value2[0] ){
                            return 1;
                        }else if($value1[0] < $value2[0]){
                            return -1;
                        }else{
                            return 0;
                        }
                    }
                });

                $firstEnd = $points[0][1];
                $arrows = 1;

                $count = count($points);
                for ($i=0;$i<$count;$i++) {
                    if ($points[$i][0] > $firstEnd) {
                        $arrows+=1;
                        $firstEnd = $points[$i][1];
                    }
                }
                return $arrows;
            }
        }
    ```