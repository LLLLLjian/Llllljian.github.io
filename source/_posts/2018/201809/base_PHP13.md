---
title: PHP_基础 (13)
date: 2018-09-11
tags: PHP 
toc: true
---

### 字符串操作总结
    字符串截取

<!-- more -->

#### 截取指定2个字符之间字符串
    ```php
        q : 从 "查找(计组实验)" 中得到 计组实验

        a: 
        function getNeedBetween($kw, $mark1, $mark2)
        {
            $result = "";
            if (empty($kw) || empty($mark1) || empty($mark2)) {
                return $result;
            }
            $st = stripos($kw, $mark1);
            $ed = stripos($kw, $mark2);
            if (($st == false || $ed == false) || $st >= $ed) {
                return $result;
            }
            $result = substr($kw, ($st+1), ($ed-$st-1));
            return $result;
        }

        $keyword = '查找(计组实验)';
        $need = getNeedBetween($keyword, '(' , ')' );
        echo $need;
    ```

#### 按单词截取字符串
    ```php
        q : 按单词量截取字符串

        a : 
        function limit_words($string, $word_limit)
        {
            $words = explode(" ",$string);
            return implode(" ", array_splice($words, 0, $word_limit));
        }

        $content = "A B C D E F G";
        echo limit_words($content, 4);
    ```

#### 中文截取
    ```php
        q : 中文截取
        a : 
        header("content-type:text/html; charset=UTF-8");
        $string = "你好我好大家好";
        echo strlen($string).'</br>';
        // 按字来分割字符
        echo mb_substr($string,0,4,'UTF-8').'...</br>';
        // 按字节来分割字符
        echo mb_strcut($string,0,4,'UTF-8').'...</br>';
        echo mb_strcut($string,0,6,'UTF-8').'...</br>';

        21
        你好我好...
        你...
        你好...
    ```

