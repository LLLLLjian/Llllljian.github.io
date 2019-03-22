---
title: PHP_基础 (15)
date: 2018-09-13
tags: PHP 
toc: true
---

### 字符串操作总结
    字符串转换

<!-- more -->

#### 大小写
- 全部大写
    * strtolower
- 全部小写
    * strtoupper
- 第一个字母大写
    * ucfirst
- 每一个字母大写
    * ucwords

#### 字符串数组转化
- 将字符串转为数组
    * str_split
        * 将一个字符串转化为数组
        * str_split(string, length)
        * length小于1返回false
        * length为空,每个字符块为单个字符
        * length小于字符串长度,返回数组中的每个元素均为一个长度为split_length的字符块
        * length大于等于字符串长度,整个字符串作为一个字符块返回
    * explode
        * 按照某个依据将字符串分割为数组
- 将数组转为字符串
    * implode
        * 将数组中的元素按某个依据组合

