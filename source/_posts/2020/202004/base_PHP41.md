---
title: PHP_基础 (41)
date: 2020-04-16
tags: PHP 
toc: true
---

### 关于PHP中usort()函数的解读
    最近学习遇到自定义数组排序函数usort()有些不了解,搜了很多地方都没有很好的解释,自己研究好久

<!-- more -->

#### 定义
> bool usort ( array &$array , callable $cmp_function )
函数为对数组进行自己自定义排序,排序规则由 $cmp_function 定义.返回值为ture 或者false.

#### 初使用
- demo
    ```php
        function re($a,$b)
        {
            var_dump($a, $b);
            echo "<br />";
            return ($a<$b)?1:-1;
        }
        $x = array(1,3,2,5,9);
        usort($x, 're');
        print_r($x);

        int(2) int(3)
        int(2) int(1)
        int(9) int(2)
        int(5) int(2)
        int(3) int(5)
        int(9) int(3)
        int(5) int(9)
        Array
        (
            [0] => 9
            [1] => 5
            [2] => 3
            [3] => 2
            [4] => 1
        )
    ```
- 分析
    * usort两两提取数组中的数值,并按顺序输入自定义函数中,自定义函数根据内容返回1或者-1；usort根据返回值为1或者-1,得到传入的数值1“大于”或者“小于”数值2,然后对数值进行从小到大的排序
    * 即：返回值为1,说明数值1“小于”数值2,然后排序：数值2, 数值1；返回值为-1,说明数值1“大于”数值2,然后排序：数值1, 数值2.

#### 复使用
- demo
    ```php
        function Compare($str1, $str2) 
        {
            if (($str1 % 2 == 0) && ($str2 %2 == 0)) {
                if ($str1 > $str2) {
                    return -1;
                } else {
                    return 1;
                }
            }
            if ($str1 % 2 == 0) {
                return 1;
            }
            if ($str2 % 2 == 0) {
                return -1;
            }
            return ($str2 > $str1) ? 1 : - 1;
        }
        $scores = array (22,57,55,12,87,56,54,11);
        usort ( $scores, 'Compare' );
        echo "<pre>";
        print_r ( $scores );

        Array
        (
            [0] => 87
            [1] => 57
            [2] => 55
            [3] => 11
            [4] => 56
            [5] => 54
            [6] => 22
            [7] => 12
        )
    ```
- 分析
    * 规则1: 判断输入的两个值是否都为偶数,都为偶数,进行从大到小排序；
    * 规则2: 如果不都为偶数,则至少一个为奇数,先判断$str1是否为偶数,如果为偶数,即：if($str1%2==0)成立,则返回1,意味着$str1“大于”$str2,则usort函数进行排序为“小的”$str2->“大的”$str1(偶数)；
    * 规则3: 如果$str1为奇数,上面不返回任何值,接着判断$str2是否为偶数,如果为偶数,则返回-1,意味着$str1“小于”$str2,则usort函数进行排序为“小的”$str1(奇数)->“大的”$str2(偶数)；
    * 规则4: 如果两个值都为奇数,则上面不返回任何值,接着对$str1和$str2进行从大到小排序








