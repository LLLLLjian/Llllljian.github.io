---
title: PHP_基础 (14)
date: 2018-09-12
tags: PHP 
toc: true
---

### 字符串操作总结
    字符串替换

<!-- more -->

#### substr_replace
- 功能
    * 函数把字符串的一部分替换为另一个字符串
- 语法
    * substr_replace(string,replacement,start,length)
- 参数
    * string : 必需 规定要检查的字符串
    * replacement : 必需 规定要插入的字符串
    * start : 必需 规定在字符串的何处开始替换
        * 正数 在字符串的指定位置开始
        * 负数 在从字符串结尾的指定位置开始
        * 0 在字符串中的第一个字符处开始
    * length : 可选 规定要替换多少个字符.默认是与字符串长度相同
        * 正数 被替换的字符串长度
        * 负数 从字符串末端开始的被替换字符数
        * 0 插入而非替换
- demo
    * 替换字符串
        ```php
            $a=substr_replace('ABCD1234','...',4);
            print_r($a);//ABCD...
        ```
    * 插入字符串
        ```php
            $b=substr_replace('ABCD1234','...',4,0);
            print_r($b);//ABCD...1234
        ```
    * 插入字符串和规定要替换多少个字符
        ```php
            $c=substr_replace('ABCD1234','...',4,1);
            print_r($c);//ABCD...234
        ```
    * 数组匹配字符串插入
        ```php
            $replace = array('A','BB','CCC','DDDD');
            print_r(substr_replace($replace,'E',2,0));//Array ( [0] => AE [1] => BBE [2] => CCEC [3] => DDEDD )
        ```

#### str_replace
- 功能
    * 函数替换字符串中的一些字符
- 语法
    * str_replace(find,replace,string,count)
- 参数
    * find : 必需,规定要查找的值
    * replace : 必需,规定替换find中的值的值
    * string : 必需,规定被搜索的字符串
    * count : 可选,一个变量,对替换数进行计数
- demo
    * 字符串替换字符串
        ```php
            $stringData = str_replace('world','Admin','Hello world',$i);
            print_r($stringData);//Hello Admin
            echo '替换次数:'.$i;//替换次数:1
        ```
    * 字符串替换数组键值
        ```php
            $arrData = array('A','B','C','D_A');
            print_r(str_replace('A','E',$arrData,$i));//Array ( [0] => E [1] => B [2] => C [3] => D_E )
            echo '替换次数:'. $i;//替换次数:2
        ```
    * 数组匹配字符串替换数组键值
        ```php
            $find = array('A','D');
            $replace = 'E';
            $arrData = array('A','B','C','D_A');
            print_r(str_replace($find,$replace,$arrData,$i));//Array ( [0] => E [1] => B [2] => C [3] => E_E )
            echo '替换次数:'.$i;//替换次数:3
        ```
    * 数组匹配数组替换数组键值
        ```php
            $find = array('A','D');
            $replace = array('E');
            $arrData = array('A','B','C','D_A');
            print_r(str_replace($find,$replace,$arrData,$i));//Array ( [0] => E [1] => B [2] => C [3] => _E )
            echo '替换次数:'.$i;//替换次数:3
        ```

#### 手机号隐藏中间四位
- fun
    ```php
        function hideString($str = '13888888888', $to = '*', $start = 1, $end = 0) 
        { 
            $lenth = strlen($str) - $start - $end; 
            $lenth = ($lenth < 0) ? 0 : $lenth; 
            $to = str_repeat($to, $lenth); 
            $str = substr_replace($str, $to, $start, $lenth); 
            return $str; 
        } 
    ```

