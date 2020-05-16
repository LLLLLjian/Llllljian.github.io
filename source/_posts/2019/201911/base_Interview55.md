---
title: Interview_总结 (55)
date: 2019-11-15
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * foo()和@foo()之间的区别
- A
    * 错误控制符@ : 当将其放置在一个PHP表达式之前, 该表达式可能产生的任何错误信息都被忽略掉
- 延伸
    * 运算符优先级
        * 递增/递减 > ! > 算数运算符 > 大小比较 > (不)相等比较 > 引用 > 位运算符(^) > 位运算符(|) > 与 > 或 > 三目 > 赋值 > and > xor > or
    * 等值运算符
        * ==是比较值是否相等, ===不光要比较值 还要比较类型
    * 递增/递减运算符
        * 在前就是先运算后返回, 在后就是先返回后运算

#### 问题2
- Q
    * 请列出三种PHP数组循环操作的语法, 并注明各种循环的区别
- A
    * 使用for循环
    * 使用foreach循环
    * 使用while list() each()组合循环
    * for循环只能遍历索引数组, forach可以遍历索引和关联数组, 联合使用while list() each()同样可以遍历索引和关联数组

#### 问题3
- Q
    * PHP如何优化多个if....elseif语句的情况
- A
    * 可能性大的尽量往前挪
    * 判断的值是浮点 整形 字符串可以该用switch case

#### 问题4
- Q
    * 正则表达式
- A
    * 后向引用eg
        ```php
            $str = "<b>abc</b>";
            $pattern = "/<b>(.*)<\/b>";
            preg_replace($pattern, '\\1 ', $str);
        ```
    * 贪婪模式eg
        ```php
            $str = "<b>abc</b><b>bcd</b>";
            $pattern = "/<b>(.*?)<\/b>";
            preg_replace_all($pattern, '\\1 ', $str);

            $pattern = "/<b>(.*)<\/b>/U";
            preg_replace_all($pattern, '\\1 ', $str);
        ```

#### 问题5
- Q
    * 请匹配所有img标签的src信息
- A
    * eg
        ```php
            $str= '<img alt="1" src='1.jpg'/>';
            $pattern = '/<img.*?src="(.*?)".*?\/?\/?>/i';
            preg_match($pattern, $str, $match);
            var_dump($match[1]);
        ```

