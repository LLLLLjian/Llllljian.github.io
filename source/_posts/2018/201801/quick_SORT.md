---
title: 交换排序_排序
date: 2018-01-02
tags: 算法
toc: true
---

### 快速排序
#### 基本思想
    通过一趟排序将待排记录分割成独立的两部分,其中一部分的关键字均比另一部分记录的关键字小,则可分别对这两部分记录继续进行快速排序,整个排序过程可以递归进行,以达到整个序列有序的目的.
    选择一个基准元素,通常选择第一个元素或者最后一个元素.通过一趟扫描,将待排序列分成两部分,一部分比基准元素小,一部分大于等于基准元素.此时基准元素在其排好序后的正确位置,然后再用同样的方法递归地排序划分的两部分
<!-- more -->

#### 算法实现
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