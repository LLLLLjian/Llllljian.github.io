---
title: Leetcode_基础 (171)
date: 2020-07-23
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-贪心法

<!-- more -->

#### 加最少的油到终点
- 问题描述
    * 汽车从起点出发驶向目的地,该目的地位于出发位置东面 target 英里处.沿途有加油站,每个 station[i] 代表一个加油站,它位于出发位置东面 station[i][0] 英里处,并且有 station[i][1] 升汽油.假设汽车油箱的容量是无限的,其中最初有 startFuel 升燃料.它每行驶 1 英里就会用掉 1 升汽油.当汽车到达加油站时,它可能停下来加油,将所有汽油从加油站转移到汽车中.为了到达目的地,汽车所必要的最低加油次数是多少？如果无法到达目的地,则返回 -1 .注意: 如果汽车到达加油站时剩余燃料为 0,它仍然可以在那里加油.如果汽车到达目的地时剩余燃料为 0,仍然认为它已经到达目的地
- 解题思路
    * 何时加油最合适 : 油用完的时候加油最合适
    * 哪个加油站加油最合适 : 在油量最多的加油站加油最合适
    ```php
        class Solution 
        {
            /**
            * @param Integer $target
            * @param Integer $startFuel
            * @param Integer[][] $stations
            * @return Integer
            */
            function minRefuelStops($target, $startFuel, $stations) 
            {
                $res = 0;
                $qArr = array();
                for ($i=0;$i<count($stations);$i++) {
                    // 扣除从出发点到当前的油费
                    $startFuel -= $stations[$i][0]; 
                    // 重复的路程加回去
                    $startFuel += ($i>0?$stations[$i-1][0]:0);
                    if ($startFuel < 0) { // 当前不够,从已经过的站点取油
                        while (!empty($qArr) && $startFuel<0) {
                            asort($qArr);
                            $startFuel += array_pop($qArr);
                            $res += 1;
                        }
                        if(empty($qArr) && $startFuel<0) {
                            return -1;//不够冲
                        } 
                    }
                    $qArr[] = $stations[$i][1];
                }
                $startFuel -= ($target - $stations[count($stations)-1][0]); // 扣除最后一段路的油费
                while (!empty($qArr) && $startFuel < 0) {
                    asort($qArr);
                    $startFuel += array_pop($qArr);
                    $res += 1;
                }
                return $startFuel>=0?$res:-1;
            }
        }
    ```




