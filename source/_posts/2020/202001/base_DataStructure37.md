---
title: DataStructure_基础 (37)
date: 2020-01-07
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[迷宫游戏之寻找最短路径]

<!-- more -->

#### 迷宫游戏之寻找最短路径
- Q
    * 假设有一个7*5大小的迷宫, 绿色格子是起点, 红色格子是终点, 蓝色格子是障碍. 从绿色出发, 每一步只能向上下/左右移动一格且不能穿越墙壁, 怎样用最少的步数到达终点
    * ![迷宫游戏之寻找最短路径](/img/20200107_1.png)
- 解题思路
    * A星寻路算法
    * 先引入两个集合和一个公式
    * OpenList: 可到达的格子; CloseList: 已到达的格子
    * 公式 F = G + H
    * G: 从起点走到当前格子的成本, 也就是已经花费了多少步
    * H: 在不考虑障碍的情况下, 从当前格子走到目标格子的距离, 也就是离目标还有多远
    * F: 从起点走到当前格子, 再从当前格子走到目标格子的总步数
- 模拟解题
    1. 把起点放到OpenList中 OpenList: Grid(1, 2) CloseList: ""
    2. 将OpenList的值转移到CloseList中 OpenList: "" CloseList: Grid(1, 2)
    3. 获取下一步操作, 得到Grid(1, 2)附近的所有可以走到的格子的F G H, 都放在OpenList中 OpenList: Grid(1, 1) Grid(0, 2) Grid(1, 3) Grid(2, 2)
    4. 找到F最小的放入OpenList中 OpenList: Grid(1, 1) Grid(0, 2) Grid(1, 3) CloseList: Grid(1, 2)
    5. 重复前四步, 如果重复第二步得到的格子和两个集合中的重复则忽略
- A
    ```php
        function aStarSearch($start, $end)
        {
            $MAZE = array(
                array(0, 0, 0, 0, 0, 0, 0),
                array(0, 0, 0, 1, 0, 0, 0),
                array(0, 0, 0, 1, 0, 0, 0),
                array(0, 0, 0, 1, 0, 0, 0),
                array(0, 0, 0, 0, 0, 0, 0),
            );

            $OpenList = $CloseList = $neighbors = array();
            $OpenList[] = $start;
            $i = 0;
            while (!empty($OpenList)) {
                $i += 1;
                // 在$OpenList中查找F值最小的节点, 将其作为当前方格节点
                if (!empty($neighbors)) {
                    $tempOpenList = array_intersect($neighbors, $OpenList);
                } else {
                    $tempOpenList = $OpenList;
                }
                $currentGrid = findMinGrid($tempOpenList, $end);
                // 将当前节点从$OpenList中移出
                foreach ($OpenList as $key=>$value) {
                    if ($value == $currentGrid) {
                        unset($OpenList[$key]);
                    }
                }
                // 当前方格节点进入$CloseList
                $CloseList[] = $currentGrid;
                // 找到所有临近节点
                $neighbors = findNeighbors($currentGrid, $OpenList, $CloseList, $MAZE);
                foreach ($neighbors as $key=>$value) {
                    // 邻近节点不在$OpenList中, 放入$OpenList
                    if ((array_search($value, $OpenList) === false) && (array_search($value, $CloseList) === false)) {
                        $OpenList[] = $value;
                    }
                }
                
                if ($currentGrid == $end) {
                    return $CloseList;
                }
            }

            return null;
        }

        function findMinGrid($arr, $end)
        {
            foreach ($arr as $key=>$value) {
                $arr[$key]["F"] = abs($end[0] - $value[0]) + abs($end[1] - $value[1]) + 1;
            }

            $tempGrid = current($arr);
            foreach ($arr as $key=>$value) {
                if ($value['F'] < $tempGrid["F"]) {
                    $tempGrid = $value;
                }
            }

            unset($tempGrid["F"]);
            return $tempGrid;
        }

        function findNeighbors($arr, $OpenList, $CloseList, $MAZE)
        {
            $res = array();
            if (isset($MAZE[$arr[0]][$arr[1] - 1]) && ($MAZE[$arr[0]][$arr[1] - 1] == 0)) {
                $tempArr1 = array($arr[0], $arr[1] - 1);
                if ((array_search($tempArr1, $OpenList) === false) && (array_search($tempArr1, $CloseList) === false)) {
                    $res[] = $tempArr1;
                }
            }

            if (isset($MAZE[$arr[0] - 1][$arr[1]]) && ($MAZE[$arr[0] - 1][$arr[1]] == 0)) {
                $tempArr1 = array($arr[0] - 1, $arr[1]);
                if ((array_search($tempArr1, $OpenList) === false) && (array_search($tempArr1, $CloseList) === false)) {
                    $res[] = $tempArr1;
                }
            }

            if (isset($MAZE[$arr[0]][$arr[1] + 1]) && ($MAZE[$arr[0]][$arr[1] + 1] == 0)) {
                $tempArr1 = array($arr[0], $arr[1] + 1);
                if ((array_search($tempArr1, $OpenList) === false) && (array_search($tempArr1, $CloseList) === false)) {
                    $res[] = $tempArr1;
                }
            }

            if (isset($MAZE[$arr[0] + 1][$arr[1]]) && ($MAZE[$arr[0] + 1][$arr[1]] == 0)) {
                $tempArr1 = array($arr[0] + 1, $arr[1]);
                if ((array_search($tempArr1, $OpenList) === false) && (array_search($tempArr1, $CloseList) === false)) {
                    $res[] = $tempArr1;
                }
            }

            return $res;
        }
        print_r(aStarSearch(array(2, 1), array(2, 5)));
        print_r(aStarSearch(array(1, 1), array(4, 4)));
    ```



