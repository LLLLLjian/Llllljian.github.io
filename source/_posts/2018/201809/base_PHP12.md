---
title: PHP_基础 (12)
date: 2018-09-10
tags: PHP 
toc: true
---

### 字符串操作总结
    字符串查找

<!-- more -->

#### 查找字符串中某一特定字符
    ```php
        q : 在下面的字符串中查找第一个出现在双竖线前面的字符

        a : 
        <?php
            $str = "admin||46cc468df60c961d8da2326337c7aa58||0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,";

            // 通过explode将字符串转化为数组,然后取第一个
            $result = explode('||', $str);
            var_dump($result[0]);

            // strpos得到第一次出现||的位置,然后通过substr进行字符串的截取
            $result1 = substr($str, 0, strpos($str,"||"));
            var_dump($result1);
        ?>
    ```

#### 指定字符串中查找子字符串
    ```php
        <?php
            $haystack1 = "2349534134345w3mentor16504381640386488129";
            $haystack2 = "w3mentor234953413434516504381640386488129";
            $haystack3 = "center234953413434516504381640386488129fyi";

            $pos1 = strpos($haystack1, "w3mentor");
            $pos2 = strpos($haystack2, "w3mentor");
            $pos3 = strpos($haystack3, "w3mentor");

            print("pos1 = ($pos1); type is " . gettype($pos1) . "\n");
            print("pos2 = ($pos2); type is " . gettype($pos2) . "\n");
            print("pos3 = ($pos3); type is " . gettype($pos3) . "\n");
        ?>
    ```

#### 查找字符串常用函数
- strstr
    * 查找字符串的首次出现
    * eg
        ```php
            $email  = 'name@example.com';
            $domain = strstr($email, '@');
            // 打印 @example.com
            echo $domain; 

            // 从PHP 5.3.0 起
            $user = strstr($email, '@', true);
            // 打印 name
            echo $user; 
        ```
- stristr
    * strstr()函数的忽略大小写版本
- strpos
    * 查找字符串首次出现的位置
    * 字符串位置是从0开始
    * eg
        ```php
            $string = 'abc';
            $findme   = 'a';
            $pos = strpos($string, $findme);
            // 0
            var_dump($pos);

            // 忽视位置偏移量之前的字符进行查找
            $newstring = 'abcdef abcdef';
            $pos = strpos($newstring, 'a', 1); 
            // 7
            var_dump($pos);
        ```
- substr
    * 返回字符串的子串
    * eg
        ```php
            echo substr('abcdef', 1);     // bcdef
            echo substr('abcdef', 1, 3);  // bcd
            echo substr('abcdef', 0, 4);  // abcd
            echo substr('abcdef', 0, 8);  // abcdef
            echo substr('abcdef', -1, 1); // f

            // 访问字符串中的单个字符
            // 也可以使用中括号
            $string = 'abcdef';
            echo $string[0];                 // a
            echo $string[3];                 // d
            echo $string[strlen($string)-1]; // f
        ```
- strrchr
    * 查找指定字符在字符串中的最后一次出现
- strripos
    * 计算指定字符串在目标字符串中最后一次出现的位置
- stripos
    * 查找字符串首次出现的位置
