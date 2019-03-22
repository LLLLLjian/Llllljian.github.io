---
title: PHP_基础 (16)
date: 2018-09-14
tags: PHP 
toc: true
---

### 字符串操作总结
    字符串比较

<!-- more -->

#### 计算两个字符串的相似度
- fun
    ```php
        $word2compare = "stupid";
        $words = array(
            'stupid',
            'stu and pid',
            'hello',
            'foobar',
            'stpid',
            'upid',
            'stuuupid',
            'sstuuupiiid',
        );
        while(list($id, $str) = each($words)){
            similar_text($str, $word2compare, $percent);
            print "Comparing '$word2compare' with '$str': ";
            print round($percent) . "%\n";
        }
        /*
        Results:
        Comparing 'stupid' with 'stupid': 100%
        Comparing 'stupid' with 'stu and pid': 71%
        Comparing 'stupid' with 'hello': 0%
        Comparing 'stupid' with 'foobar': 0%
        Comparing 'stupid' with 'stpid': 91%
        Comparing 'stupid' with 'upid': 80%
        Comparing 'stupid' with 'stuuupid': 86%
        Comparing 'stupid' with 'sstuuupiiid': 71%
        */
    ```

#### 字符串比较
    双等号不比较类型,三等号会比较类型,它不转换类型；用双等号进行比较时,如果等号左右两边有数字类型的值,刚会把另一个值转化为数字,然后进行比较
    比较字符串可以用PHP的自带函数strcmp和strcasecmp.其中strcasecmp是strcmp的变种,它会先把字符串转化为小写再进行比较

#### 浮点数相关
- bccomp  比较浮点数大小
- bcadd 将两个高精度数字相加
- bccomp 比较两个高精度数字,返回-1, 0, 1
- bcdiv 将两个高精度数字相除
- bcmod 求高精度数字余数
- bcmul 将两个高精度数字相乘
- bcpow 求高精度数字乘方
- bcpowmod 求高精度数字乘方求模,数论里非常常用
- bcscale 配置默认小数点位数,相当于就是Linux bc中的”scale=”
- bcsqrt 求高精度数字平方根
- bcsub 将两个高精度数字相减
