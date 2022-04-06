---
title: Leetcode_基础 (81)
date: 2019-06-12 18:00:00
tags: Leetcode
toc: true
---

### 字符串中的第一个唯一字符
    Leetcode学习-387

<!-- more -->

#### Q
    给定一个字符串,找到它的第一个不重复的字符,并返回它的索引.如果不存在,则返回 -1.

    案例:

    s = "leetcode"
    返回 0.

    s = "loveleetcode",
    返回 2.
     

    注意事项: 您可以假定该字符串只包含小写字母.

#### A
    ```php
        class Solution {
            /**
            * @param String $s
            * @return Integer
            */
            function firstUniqChar($s) {
                if (empty($s)) {
                    return -1;
                }
                $tempArr0 = str_split($s);
                $tempArr1 = array_count_values($tempArr0);
                
                foreach ($tempArr1 as $key=>$value) {
                    if ($value == 1) {
                        return array_search($key, $tempArr0);
                    }
                }
                return -1;
            }
        }
    ```
