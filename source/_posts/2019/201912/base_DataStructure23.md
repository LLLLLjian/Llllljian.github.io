---
title: DataStructure_基础 (23)
date: 2019-12-17
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之快速排序

<!-- more -->

#### 快速排序
- 基本思想
    * 通过设置一个初始中间值, 来将需要排序的数组分成3部分, 小于中间值的左边, 中间值, 大于中间值的右边, 继续递归用相同的方式来排序左边和右边, 最后合并数组
- 代码实现
    ```php
        function quick_sort($a)
        {
            // 判断是否需要运行, 因下面已拿出一个中间值, 这里<=1
            if (count($a) <= 1) {
                return $a;
            }

            $middle = $a[0]; // 中间值

            $left = array(); // 接收小于中间值
            $right = array();// 接收大于中间值

            // 循环比较
            for ($i=1; $i < count($a); $i++) { 

                if ($middle < $a[$i]) {
                    // 大于中间值
                    $right[] = $a[$i];
                } else {
                    // 小于中间值
                    $left[] = $a[$i];
                }
            }

            // 递归排序划分好的2边
            $left = quick_sort($left);
            $right = quick_sort($right);

            // 合并排序后的数据, 别忘了合并中间值
            return array_merge($left, array($middle), $right);
        }
    ```

