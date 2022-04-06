---
title: DataStructure_基础 (30)
date: 2019-12-26
tags: DataStructure
toc: true
---

### 漫画算法: 小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[2的整数次幂]

<!-- more -->

#### 2的整数次幂
- Q
    * 如何判断一个数是否为2的整数次幂
- A1
    * 暴力破解法
    ```php
        function isPowerOf2($num)
        {
            $temp = 1;
            while ($num >= $temp) {
                if ($num == $temp) {
                    return true;
                }
                $temp *= 2;
            }
            return false;
        }

        function isPowerOf2_1($num)
        {
            $temp = 1;
            while ($num >= $temp) {
                if ($num == $temp) {
                    return true;
                }
                $temp<<2;
            }
            return false;
        }
    ```
- A2
    * 位运算
    ```php
        function isPowerOf2($num)
        {
            return ($num&($num-1) == 0);
        }
    ```

