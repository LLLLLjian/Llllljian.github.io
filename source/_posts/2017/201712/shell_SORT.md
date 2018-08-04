---
title: SORT_插入排序
date: 2017-12-28
tags: SORT
toc: true
---

### 希尔排序
#### 基本思想
    记录按下标的一定增量分组,对每一组使用 直接插入排序 ,随着增量逐渐减少,每组包含的关键字越来越多,当增量减少至 1 时,整个序列恰好被分成一组,算法便终止
    初次取序列的一半为增量,以后每次减半,直到增量为1.

<!-- more -->

#### 算法实现
```php
    function ShellSort($arr)
    {
        $count = count($arr);
        $inc = $count;    //增量
        do {
            //计算增量
            //$inc = floor($inc / 3) + 1;
            $inc = ceil($inc / 2);
            for ($i = $inc; $i < $count; $i++) {
                $temp = $arr[$i];    //设置哨兵
                //需将$temp插入有序增量子表
                for ($j = $i - $inc; $j >= 0 && $arr[$j + $inc] < $arr[$j]; $j -= $inc) {
                    $arr[$j + $inc] = $arr[$j]; //记录后移
                }
                //插入
                $arr[$j + $inc] = $temp;
            }
            //增量为1时停止循环
        } while ($inc > 1);
    }
```