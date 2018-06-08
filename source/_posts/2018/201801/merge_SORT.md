---
title: 归并排序_排序
date: 2018-01-03
tags: 算法
toc: true
---

### 归并排序
#### 基本思想
    就是利用归并（合并）的思想实现的排序方法.它的原理是假设初始序列含有 n 个元素,则可以看成是 n 个有序的子序列,每个子序列的长度为 1,然后两两归并,得到 ⌈ n / 2⌉ （⌈ x ⌉ 表示不小于 x 的最小整数）个长度为 2 或 1 的有序序列；再两两归并,······,如此重复,直至得到一个长度为 n 的有序序列为止,这种排序方法就成为 2 路归并排序

<!-- more -->

#### 算法实现
```php
    //交换方法
    function swap($arr,$a,$b)
    {
        $temp = $arr[$a];
        $arr[$a] = $arr[$b];
        $arr[$b] = $temp;
    }

    //归并操作
    function Merge($arr,$start,$mid,$end)
    {
        $i = $start;
        $j=$mid + 1;
        $k = $start;
        $temparr = array();

        while($i!=$mid+1 && $j!=$end+1)
        {
        if($arr[$i] >= $arr[$j]){
            $temparr[$k++] = $arr[$j++];
        }
        else{
            $temparr[$k++] = $arr[$i++];
        }
        }

        //将第一个子序列的剩余部分添加到已经排好序的 $temparr 数组中
        while($i != $mid+1){
            $temparr[$k++] = $arr[$i++];
        }
        //将第二个子序列的剩余部分添加到已经排好序的 $temparr 数组中
        while($j != $end+1){
            $temparr[$k++] = $arr[$j++];
        }
        for($i=$start; $i<=$end; $i++){
            $arr[$i] = $temparr[$i];
        }
    }

    function MSort($arr,$start,$end)
    {
        //当子序列长度为1时,$start == $end,不用再分组
        if($start < $end){
            $mid = floor(($start + $end) / 2);	//将 $arr 平分为 $arr[$start - $mid] 和 $arr[$mid+1 - $end]
            MSort($arr,$start,$mid);			//将 $arr[$start - $mid] 归并为有序的$arr[$start - $mid]
            MSort($arr,$mid + 1,$end);			//将 $arr[$mid+1 - $end] 归并为有序的 $arr[$mid+1 - $end]
            Merge($arr,$start,$mid,$end);       //将$arr[$start - $mid]部分和$arr[$mid+1 - $end]部分合并起来成为有序的$arr[$start - $end]
        }
    }

    //归并算法总函数
    function MergeSort($arr)
    {
        $start = 0;
        $end = count($arr) - 1;
        MSort($arr,$start,$end);
    }
```