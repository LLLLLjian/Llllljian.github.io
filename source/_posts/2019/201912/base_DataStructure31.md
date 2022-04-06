---
title: DataStructure_基础 (31)
date: 2019-12-27
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[无序数组排序后的最大相邻差]

<!-- more -->

#### 无序数组排序后的最大相邻差
- Q
    * 有一个无序整形数组, 求出该数组排序之后两个相邻元素的最大差值
- A1
    * 暴力破解法
    * 嘻嘻嘻, 先排序, 然后循环数组依次求差值
- A2
    * 利用计数排序的思想, 先求出最大值max和最小值min的区间长度k(max-min+1), 以及偏移量d=min
    * 创建一个长度为k的新数组arr
    * 遍历原数组, 每遍历一个元素, 就把新数组对应下标的值+1, 例如原数组元素n, arr[n-min]的值加1
    * 遍历新数组, 统计新数组中最大连续出现0值的次数+1, 即为相邻元素最大差值
- A3
    * 利用桶排序的思想, 根据数组的长度n创建出n个桶, 每个桶代表一个区间范围, 其中第一个桶从最小值开始, 区间跨度为(max-min)/(n-1)
    * 遍历原数组, 把原数组中的每一个值都插入到相应的桶中, 并记录每一个桶的最大值和最小值
    * 遍历所有的桶, 统计出每一个桶的最大值, 和这个桶右侧非空桶的最小值的差, 数组最大的差即为原数组排序后相邻位置最大的差值
    ```php
        function getMaxSortedDistance($arr)
        {
            // 1.得到最大值和最小值
            $max = max($arr);
            $min = min($arr);
            $bucketSize = $max - $min;
            // 如果max和min相等, 那就说明所有元素都相等, 返回0
            if ($bucketSize == 0) {
                return 0;
            }

            // 2.初始化桶
            $count = count($arr);
            for ($i=0;$i<$count;$i++) {
                $buckets[$i] = "";
            }

            // 3.遍历原始数组, 确定每个桶的最大值和最小值
            for ($i = 0; $i < $count; $i++) {
                $index = floor(($arr[$i] - $min) * ($count - 1) / $bucketSize);
                // 确定一下要放在哪个桶里
                $buckets[$index][] = $arr[$i];
            }

            // 4.遍历桶, 找到最大差值
            $leftMax = max($buckets[0]);
            $maxDistance = 0;
            for ($i=1;$i<count($buckets);$i++) {
                if (empty($buckets[$i])) {
                    continue;
                }
                if ((min($buckets[$i]) - $leftMax) > $maxDistance) {
                    $maxDistance = min($buckets[$i]) - $leftMax;
                }
                $leftMax = max($buckets[$i]);
            }
            return $maxDistance;
        }

        $arr = array(2, 6, 3, 4, 5, 10, 9);
        var_dump(getMaxSortedDistance($arr));
    ```



