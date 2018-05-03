---
title: 选择排序_排序
date: 2017-12-29
tags: 算法
toc: true
---

### 堆排序
#### 基本思想
    将待排序的序列构造成一个大根堆。此时，整个序列的最大值就是堆顶的根节点。将它移走（其实就是将其与堆数组的末尾元素交换，此时末尾元素就是最大值），然后将剩余的 n - 1 个序列重新构造成一个堆，这样就会得到 n 个元素中的次小的值。如此反复执行，便能得到一个有序序列了

<!-- more -->

#### 算法实现
```bash
    function swap($arr,$a,$b)
    {
        $temp = $arr[$a];
        $arr[$a] = $arr[$b];
        $arr[$b] = $temp;
    }

    //调整 $arr[$start]的关键字，使$arr[$start]、$arr[$start+1]、、、$arr[$end]成为一个大根堆（根节点最大的完全二叉树）
    //注意这里节点 s 的左右孩子是 2*s + 1 和 2*s+2 （数组开始下标为 0 时）
    function HeapAdjust($arr,$start,$end)
    {
        $temp = $arr[$start];
        //沿关键字较大的孩子节点向下筛选
        //左右孩子计算（我这里数组开始下标识 0）
        //左孩子2 * $start + 1，右孩子2 * $start + 2
        for($j = 2 * $start + 1;$j <= $end;$j = 2 * $j + 1){
            if($j != $end && $arr[$j] < $arr[$j + 1]){
                $j ++; //转化为右孩子
            }
            if($temp >= $arr[$j]){
                break;  //已经满足大根堆
            }
            //将根节点设置为子节点的较大值
            $arr[$start] = $arr[$j];
            //继续往下
            $start = $j;
        }
        $arr[$start] = $temp;
    }

    function HeapSort($arr)
    {
        $count = count($arr);
        //先将数组构造成大根堆（由于是完全二叉树，所以这里用floor($count/2)-1，下标小于或等于这数的节点都是有孩子的节点)
        for($i = floor($count / 2) - 1;$i >= 0;$i --){
            HeapAdjust($arr,$i,$count);
        }
        for($i = $count - 1;$i >= 0;$i --){
            //将堆顶元素与最后一个元素交换，获取到最大元素（交换后的最后一个元素），将最大元素放到数组末尾
            swap($arr,0,$i);  
            //经过交换，将最后一个元素（最大元素）脱离大根堆，并将未经排序的新树($arr[0...$i-1])重新调整为大根堆
            HeapAdjust($arr,0,$i - 1);
        }
    }
```