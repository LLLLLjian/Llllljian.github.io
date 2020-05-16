---
title: DataStructure_基础 (24)
date: 2019-12-18
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之计数排序

<!-- more -->

#### 计数排序
- 算法核心
    * 利用数组下标来确认元素的正确位置
- demo1
    * 假设数组中有20个随机数字, 他们的取值是0-10之间的整数, 通过计数排序进行排序
    ```php
        // 建立一个长度为11的空数组, 数组下标从0到10, 每一个值都为0, 循环随机数字, 对应的值索引的值加1
        function countSort($arr)
        {
            $countArr = array();
            $max = max($arr);
            for ($i=0;$i<=$max;$i++) {
                $countArr[$i] = 0;
            }

            for ($i=0;$i<count($arr);$i++) {
                $countArr[$arr[$i]]++;
            }

            $index = 0;
            for ($i=0;$i<count($countArr);$i++) {
                for ($j=0;$j<$countArr[$i];$j++) {
                    $sortArr[$index++] = $i;
                }
            }
            return $sortArr;
        }
    ```



