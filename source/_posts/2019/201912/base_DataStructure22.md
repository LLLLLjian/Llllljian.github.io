---
title: DataStructure_基础 (22)
date: 2019-12-16
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之冒泡算法

<!-- more -->

#### 冒泡算法
    冒泡算法是一种稳定排序, 值相等的元素并不会打乱原先的排序, 由于该排序算法的每一轮都要遍历所有元素, 总共遍历 (元素数量-1)轮, 所以平均复杂度为O(n^2)
- 冒泡算法第一版
    * 使用双循环进行排序, 外部循环控制所有回合, 内部循环实现每一轮的冒泡处理, 先进行元素比较, 然后进行元素交换 
    ```php
        function bubbleSort($arr)
        {
            for ($i=0;$i<count($arr)-1;$i++) {
                for ($j=0;$j<count($arr)-$i-1;$j++) {
                    if ($arr[$j] > $arr[$j+1]) {
                        $temp = $arr[$j+1];
                        $arr[$j+1] = $arr[$j];
                        $arr[$j] = $temp;
                    }
                }
            }

            return $arr;
        }
    ```
- 可能存在的问题
    * 还是以刚才的数组为例, 当进行到第6轮和第7轮时, 1和2进行冒泡, 后面的数组全是有序的, 但排序还是在不必要的运行
    * 如果能判断出数组已经有序, 并进行了标记, 那么剩下的不必要排序就可以不用做了
    ```php
        function bubbleSort($arr)
        {
            for ($i=0;$i<count($arr)-1;$i++) {
                // 有序标记, 每一轮都是true
                $isSort = true;
                for ($j=0;$j<count($arr)-$i-1;$j++) {
                    if ($arr[$j] > $arr[$j+1]) {
                        $temp = $arr[$j+1];
                        $arr[$j+1] = $arr[$j];
                        $arr[$j] = $temp;

                        // 因为有元素进行交换, 所以不是有序的
                        $isSort = false;
                    }
                }
                if ($isSort) {
                    break;
                }
            }
            return $arr;
        }
    ```
- 可能存在的问题
    * 上边的程序认为, 有序区的长度和排序的轮数是相等的, 实际上有序区的长度可能大于排序的轮数
    * 解决方法 : 在每一次排序后, 记录最后一次元素交换的位置, 该位置即为无序数组的边界
    ```php
        function bubbleSort($arr)
        {
            // 记录最后一次交换的位置
            $laseExchageIndex = 0;
            // 无序数组的边界, 每次比较只需要比到这里就可以了
            $sortBorder = count($arr)-1;
            for ($i=0;$i<$sortBorder;$i++) {
                // 有序标记, 每一轮都是true
                $isSort = true;
                for ($j=0;$j<count($arr)-$i-1;$j++) {
                    if ($arr[$j] > $arr[$j+1]) {
                        $temp = $arr[$j+1];
                        $arr[$j+1] = $arr[$j];
                        $arr[$j] = $temp;

                        // 因为有元素进行交换, 所以不是有序的
                        $isSort = false;
                        // 更新为最后一次交换元素的位置
                        $laseExchageIndex = $j;
                    }
                }
                $sortBorder = $laseExchageIndex;
                if ($isSort) {
                    break;
                }
            }

            return $arr;
        }
    ```
- 冒泡排序的升级排序: 鸡尾酒排序
    * 鸡尾酒算法的排序和比较都是双向的
    ```php
        function bubbleSort($arr)
        {
            $temp = 0;
            for ($i=0;$i<count($arr)/2;$i++) {
                // 有序标记, 每一轮都是true
                $isSort = true;
                // 奇数轮, 从左往后
                for ($j=$i;$j<count($arr)-$i-1;$j++) {
                    if ($arr[$j] > $arr[$j+1]) {
                        $temp = $arr[$j+1];
                        $arr[$j+1] = $arr[$j];
                        $arr[$j] = $temp;

                        // 因为有元素进行交换, 所以不是有序的
                        $isSort = false;
                    }
                }
                if ($isSort) {
                    break;
                }

                // 在偶数轮之前 将$isSort置为true
                $isSort = true;
                // 偶数轮, 从右往左
                for ($j=count($arr)-$i-1;$j>$i;$j--) {
                    if ($arr[$j] < $arr[$j-1]) {
                        $temp = $arr[$j];
                        $arr[$j] = $arr[$j-1];
                        $arr[$j-1] = $temp;

                        // 因为有元素进行交换, 所以不是有序的
                        $isSort = false;
                    }
                }
                if ($isSort) {
                    break;
                }
            }

            return $arr;
        }
    ```
