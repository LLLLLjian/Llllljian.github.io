---
title: DataStructure_基础 (12)
date: 2019-10-15
tags: DataStructure
toc: true
---

### 算法--递归
    算法--递归

<!-- more -->

#### 递归
- 是什么
    * 是指函数直接或间接的调用自己，递归是基于栈来实现的
- 实现条件
    * 可调用自己 : 可以通过将大问题分解为子问题，然后子问题再可以分解为子子问题，这样不停的分解。并且大问题与子问题/子子问题的解决思路是完全一样的，只不过数据不一样
    * 可停止调用自己 : 大问题不停的一层层分解为小问题后，最终必须有一个条件是来终止这种分解动作的(也就是停止调用自己)

#### demo
- Q
    实现 pow(x, n) ，即计算 x 的 n 次幂函数。
    说明:
    -100.0 < x < 100.0
    n 是 32 位有符号整数，其数值范围是 [−2^31, 2^31 − 1]

    示例:
    输入: 2.00000, 10
    输出: 1024.00000
- A
    ```php
        function f1($x, $n)
        {
            $res = 1;
            if ($n > 0) {
                for ($i=1;$i<=$n;$i++) {
                    $res *= $x
                }
            } elseif ($n < 0) {
                for ($i=1;$i<=$n;$i++) {
                    $res *= $x
                }
                $res = 1/$res;
            }

            return $res;
        }

        function f2($x, $n)
        {
            if ($n == 0) {
                return 1;
            } 
            if ($n == 1) {
                return $x;
            }
            if ($n < 0) {
                return 1/($x*f2($x, abs($n)-1));
            }
            return $x*f2($x, abs($n)-1);
        }

        function f3($x, $n)
        {
            //如果n是负数，则改为正数，但把x取倒数
            if ($n<0) {
                $n = -$n;
                $x = 1/$x;
            }
            return f3_1($x, $n);

        }

        function f3_1($x, $n)
        {
            if ($n==0) {
                return 1;
            }
            if ($n==0) {
                return $x;
            }
            $half = f3_1($x, $n/2);
            //偶数个
            if($n%2==0) {
                return $half*$half;
            }
            //奇数个
            return $half*$half*$x;
        }
    ```


