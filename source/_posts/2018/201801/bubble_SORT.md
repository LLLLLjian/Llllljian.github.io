---
title: 交换排序_排序
date: 2018-01-02
tags: 算法
toc: true
---

### 冒泡排序
#### 基本思想
    两两比较相邻记录的关键字,如果反序则交换,直到没有反序的记录为止

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

    //冒泡排序的优化(如果某一次循环的时候没有发生元素的交换,则整个数组已经是有序的了)
    function BubbleSort($arr)
    {
        $length = count($arr);
        $flag = TRUE;

        for($i = 0;($i < $length - 1) && $flag;$i ++){
            $flag = FALSE;
            for($j = $length - 2;$j >= $i;$j --){
                if($arr[$j] > $arr[$j + 1]){
                    swap($arr,$j,$j+1);
                    $flag = TRUE;
                }
            }
        }
    }
```