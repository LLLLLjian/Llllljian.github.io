---
title: DataStructure_基础 (25)
date: 2019-12-19
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之桶排序

<!-- more -->

#### 桶排序
- 算法核心
    * 每一个桶代表一个区间范围, 里边可以承载一个或多个元素
    1. 创建桶,  并确定每一个桶的区间范围
    2. 遍历原始数组, 把元素对号入座放入桶中
    3. 对每个桶的内部元素进行排序
    4. 遍历所有桶, 输出所有元素
- 代码实现
    ```php
        function bucketSort($arr, $bucketSize = 5)
        {
            if (count($arr) === 0) {
                return $arr;
            }

            $minValue = $arr[0];
            $maxValue = $arr[0];
            for ($i = 1; $i < count($arr); $i++) {
                if ($arr[$i] < $minValue) {
                    $minValue = $arr[$i];
                } elseif ($arr[$i] > $maxValue) {
                    $maxValue = $arr[$i];
                }
            }

            $bucketCount = floor(($maxValue - $minValue) / $bucketSize) + 1;
            $buckets = array();
            for ($i = 0; $i < count($bucketCount); $i++) {
                $buckets[$i] = [];
            }

            for ($i = 0; $i < count($arr); $i++) {
                $buckets[floor(($arr[$i] - $minValue) / $bucketSize)][] = $arr[$i];
            }

            $arr = array();
            for ($i = 0; $i < count($buckets); $i++) {
                $bucketTmp = $buckets[$i];
                sort($bucketTmp);
                for ($j = 0; $j < count($bucketTmp); $j++) {
                    $arr[] = $bucketTmp[$j];
                }
            }

            return $arr;
        }
    ```



