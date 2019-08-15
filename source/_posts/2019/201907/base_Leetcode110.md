---
title: Leetcode_基础 (110)
date: 2019-07-24
tags: Leetcode
toc: true
---

### 最小覆盖子串
    Leetcode学习-76

<!-- more -->

#### Q
    给定一个字符串 S 和一个字符串 T,请在 S 中找出包含 T 所有字母的最小子串.

    示例：

    输入: S = "ADOBECODEBANC", T = "ABC"
    输出: "BANC"
    说明：

    如果 S 中不存这样的子串,则返回空字符串 "".
    如果 S 中存在这样的子串,我们保证它是唯一的答案.

#### A
    ```php
        class Solution {
            function minWindow($s, $t) {
                $lent = strlen($t);
                $lens = strlen($s);
                if($lens<$lent) return '';//T比S长,证明S肯定不能包含T
                //构建哈希表
                $hash = [];
                for($i = 0;$i<$lent;$i++){
                    $hash[$t[$i]]++;//包含的字幕,重复字符加1
                }
                //双指针,滑动窗口左右界
                $left = $right = 0;
                //记录结果数量
                $count = 0;
                //记录结果字符
                $res = '';
                //记录结果最长长度
                $max = strlen($s)+1;
                while ($right < $lens) {
                    //右边界右移,扩充窗口
                    if(isset($hash[$s[$right]])){
                        //在S中找到T的字符
                        $hash[$s[$right]]--;
                        if($hash[$s[$right]]>=0)
                            //当找到T中符合条件的非重复字符,结果数量+1
                            $count++;
                        //当字符串完全包含T中的字符时,开始收缩窗口和验证结果
                        while ($count == $lent) {
                            //验证结果
                            if(($right-$left+1)<$max){
                                $max = $right-$left+1;
                                $res = substr($s,$left,$right-$left+1);
                            }
                            //收缩窗口,左边界右移
                            if(isset($hash[$s[$left]])){
                                $hash[$s[$left]]++;//在S中找到T的字符,哈希表加一
                                if($hash[$s[$left]]>0)
                                    $count--;//当哈希表中某一值大于0时,则包含数减一
                            }
                            $left++;//左边界右移
                        }
                    }
                    $right++;//右边界右移
                }
                return $res;
            }
        }
    ```
