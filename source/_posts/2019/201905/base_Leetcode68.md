---
title: Leetcode_基础 (68)
date: 2019-05-31
tags: Leetcode
toc: true
---

### 翻转游戏
    Leetcode学习-292

<!-- more -->

#### Q
    你和朋友玩一个叫做「翻转游戏」的游戏,游戏规则：给定一个只有 + 和 - 的字符串.你和朋友轮流将 连续 的两个 "++" 反转成 "--". 当一方无法进行有效的翻转时便意味着游戏结束,则另一方获胜.
    请你写出一个函数,来计算出每个有效操作后,字符串所有的可能状态.
    注意：如果不存在可能的有效操作,请返回一个空列表 [].

    例子1
    s = "++++"
    返回
    [
    "--++",
    "+--+",
    "++--"
    ]

#### A
    ```php
        class Solution {
            function generatePossibleNextMoves($s) {
                $res = array();

                if (!empty($s)) {
                    $len = strlen($s);
                    for ($i=0;$i<$len;$i++) {
                        if ((($i+1) < $len) && (($s[$i].$s[$i+1]) == "++")) {
                            $res[] = substr($s, 0, $i) . "--" . substr($s, $i+2);;
                        }
                    }
                }
                return $res;
            }
        }

        $a = new Solution();
        // array(3) { [0]=> string(4) "--++" [1]=> string(4) "+--+" [2]=> string(4) "++--" } 
        var_dump($a->generatePossibleNextMoves("++++")); 
        // array(0) { } 
        var_dump($a->generatePossibleNextMoves("----"));
        // array(0) { } 
        var_dump($a->generatePossibleNextMoves("+-+-"));
        // array(1) { [0]=> string(4) "----" } 
        var_dump($a->generatePossibleNextMoves("-++-"));
        // array(2) { [0]=> string(4) "--+-" [1]=> string(4) "+---" } 
        var_dump($a->generatePossibleNextMoves("+++-"));
    ```
