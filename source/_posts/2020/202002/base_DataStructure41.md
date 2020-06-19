---
title: DataStructure_基础 (41)
date: 2020-02-25
tags: DataStructure
toc: true
---

### 时间复杂度
    上次人问我时间复杂度, 我有点懵, 开始瞎猜了, 趁这个时间再看一下

<!-- more -->

#### 衡量算法优劣
> **时间维度** 是指执行当前算法所消耗的时间, 我们通常用「时间复杂度」来描述.
> **空间维度** 是指执行当前算法需要占用多少内存空间, 我们通常用「空间复杂度」来描述.

#### 时间复杂度
- 常数阶O(1)
    ![时间复杂度O(1)](/img/20200225_1.gif)
    * 无论代码执行了多少行, 其他区域不会影响到操作, 这个代码的时间复杂度都是O(1)
    ```php
        function test1($key)
        {
            $arr = array(1, 2, 3, 4);
            if (isset($arr[$key])) {
                return $arr[$key];
            } else {
                return 0;
            }
        }
    ```
- 线性阶O(n)
    ![时间复杂度O(n)](/img/20200225_2.gif)
    * 消耗的时间是随着n的变化而变化的
    ```php
        function twoNumSum($sum) 
        {
            $res = array();
            $arr = array(1, 2, 3, 4, 5);
            $count = count($arr);
            for ($i=0;$i<$count;$i++) {
                $temp = $sum - $arr[$i];
                if (isset($res[$temp])) {
                    return array($res[$temp], $i)
                } else {
                    $res[$arr[$i]] = $i;
                }
            }
            return array();
        }
    ```
- 平方阶O(n²)
    ![时间复杂度O(n²)](/img/20200225_3.gif)
    * 当存在双重循环的时候, 即把 O(n) 的代码再嵌套循环一遍, 它的时间复杂度就是 O(n²) 了
    ```php
        function maopao($arr)
        {
            if (is_array($arr) && !empty($arr)) {
                $count = count($arr);

                for ($i=0;$i<$count;$i++) {
                    for ($j=0;$j<$count-$i-1;$j++) {
                        if ($arr[$j] > $arr[$j+1]) {
                            $tempValue = $arr[$j+1];
                            $arr[$j+1] = $arr[$j];
                            $arr[$j] = $tempValue;
                        }
                    }
                }
                return $arr;
            } else {
                return false;
            }
        }
    ```
- 对数阶O(logn)
    ![时间复杂度O(n²)](/img/20200225_4.gif)
    * 由于每次count乘以 2 之后, 就距离n更近了一分.也就是说, 有多少个 2 相乘后大于n, 则会退出循环.由 2x=n得到x=log2n.所以这个循环的时间复杂度为O(logn).
    ```php
        $count = 1;
        while ($count < $n) {
            $count = $count * 2; // 时间复杂度为 O(1)的程序步骤序列
        } 
    ```
- 线性对数阶O(nlogn)
    * 将时间复杂度为O(logn)的代码循环N遍的话, 那么它的时间复杂度就是 n * O(logn), 也就是了O(nlogn)
    ```php
        function hello($n)
        {
            for ($m=0;$m<$n;$m++) {
                $i = 1;
                while ($i < $n) {
                    $i *= 2;
                }
            }
        }
    ```

