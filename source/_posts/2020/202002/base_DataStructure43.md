---
title: DataStructure_基础 (43)
date: 2020-02-27
tags: DataStructure
toc: true
---

### 冒泡排序
    快排都看了 不看看别的?

<!-- more -->

#### 冒泡排序
> 两两比较相邻记录的关键字, 如果反序则交换, 直到没有反序的记录为止
- 代码实现
    ```php
        function bubbleSort($arr)
        {
            if (!empty($arr) && is_array($arr)) {
                $count = count($arr);

                for ($i=0;$i<$count;$i++) {
                    // 默认没有冒泡
                    $tempFlag = false;
                    for ($j=0;(($j<$count-$i-1)&&!$tempFlag);$j++) {
                        if ($arr[$j] > $arr[$j+1]) {
                            $tempStr = $arr[$j+1];
                            $arr[$j+1] = $arr[$j];
                            $arr[$j] = $tempStr;
                            $tempFlag = true;
                        }
                    }
                }
                return $arr;
            } else {
                return false;
            }
        }
    ```
- 时间复杂度分析
    * O(n²)
    * 两次循环不多说了

#### 简单选择排序
> 是通过 n－i 次关键字间的比较, 从 n－i＋1 个记录中选出关键字最小的记录, 并和第 i(1≤i≤n)个记录交换之
- 代码实现
    ```php
        function selectSort($arr) 
        {
            //双重循环完成,外层控制轮数,内层控制比较次数
            $len=count($arr);
            for($i=0; $i<$len-1; $i++) {
                //先假设最小的值的位置
                $p = $i;
                
                for($j=$i+1; $j<$len; $j++) {
                    //$arr[$p] 是当前已知的最小值
                    if($arr[$p] > $arr[$j]) {
                    //比较,发现更小的,记录下最小值的位置；并且在下次比较时采用已知的最小值进行比较.
                        $p = $j;
                    }
                }
                //已经确定了当前的最小值的位置,保存到$p中.如果发现最小值的位置与当前假设的位置$i不同,则位置互换即可.
                if($p != $i) {
                    $tmp = $arr[$p];
                    $arr[$p] = $arr[$i];
                    $arr[$i] = $tmp;
                }
            }
            //返回最终结果
            return $arr;
        }
    ```
- 时间复杂度分析
    * O(n²)
    * 两次循环不多说了
    * 比冒泡好的一点是减少了交换次数

#### 直接插入排序
> 将一个记录插入到已经排好序的有序表中, 从而得到一个新的、记录数增 1 的有序表.
- 代码实现
    ```php
        function insertSort($arr) 
        {
            $len=count($arr); 
            for($i=1, $i<$len; $i++) {
                $tmp = $arr[$i];
                //内层循环控制,比较并插入
                for($j=$i-1;$j>=0;$j--) {
                    if($tmp < $arr[$j]) {
                        //发现插入的元素要小,交换位置,将后边的元素与前面的元素互换
                        $arr[$j+1] = $arr[$j];
                        $arr[$j] = $tmp;
                    } else {
                        //如果碰到不需要移动的元素,由于是已经排序好是数组,则前面的就不需要再次比较了.
                        break;
                    }
                }
            }
            return $arr;
        }
    ```
- 时间复杂度分析
    * 还是O(n²)

#### 希尔排序
> 将相距某个“增量”的记录组成一个子序列, 这样才能保证在子序列内分别进行直接插入排序后得到的结果是基本有序而不是局部有序
- 代码实现
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
- 时间复杂度分析
    * 还是O(n²)





