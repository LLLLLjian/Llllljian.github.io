---
title: Interview_总结 (27)
date: 2019-09-09
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 算法篇
- 快速排序
    ```php
        function quickSort($arr) 
        {
            //先判断是否需要继续进行
            $length = count($arr);
            if($length <= 1) {
                return $arr;
            }
            //选择第一个元素作为基准
            $base_num = $arr[0];
            //遍历除了标尺外的所有元素,按照大小关系放入两个数组内
            //初始化两个数组
            $left_array = array();  //小于基准的
            $right_array = array();  //大于基准的
            for($i=1; $i<$length; $i++) {
                if($base_num > $arr[$i]) {
                    //放入左边数组
                    $left_array[] = $arr[$i];
                } else {
                    //放入右边
                    $right_array[] = $arr[$i];
                }
            }
            //再分别对左边和右边的数组进行相同的排序处理方式递归调用这个函数
            $left_array = quick_sort($left_array);
            $right_array = quick_sort($right_array);
            //合并
            return array_merge($left_array, array($base_num), $right_array);
        }
    ```
- 冒泡排序
    ```php
        function bubbleSort($arr)
        {
            $n = count($arr);
            // 冒泡的轮数(最多$n-1轮)
            for ($i=1;$i<$n;$i++) {
                // 是否发生位置交换的标志
                $flag = 0;       
                // 每一轮冒泡(两两比较,大者后移)
                for ($j=0;$j<$n-$i;$j++) {
                    // 前者大于后者,交换位置
                    if ($arr[$j] > $arr[$j+1]) {  
                        $tmp = $arr[$j];
                        $arr[$j] = $arr[$j+1];
                        $arr[$j+1] = $tmp;
                        $flag = 1;
                    }
                }
                // 没有发生位置交换,排序已完成
                if ($flag == 0) {     
                    break;
                }
            }
            
            return $arr;
        }
    ```
- 二分查找
    ```php
        function binSearch2($arr, $low, $height, $k)
        {
            if ($low <= $height) {
                $mid = floor(($low+$height)/2);//获取中间数
                if ($arr[$mid] == $k) {
                    return $mid;
                } elseif ($arr[$mid] < $k) {
                    return binSearch2($arr, $mid+1, $height, $k);
                } elseif ($arr[$mid] > $k) {
                    return binSearch2($arr, $low, $mid-1, $k);
                }
            }
            return -1;
        }
    ```
- LRU缓存淘汰算法
    * 新数据插入到链表头部；
    * 每当缓存命中(即缓存数据被访问),则将数据移到链表头部；
    * 当链表满的时候,将链表尾部的数据丢弃.