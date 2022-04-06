---
title: Leetcode_基础 (56)
date: 2019-05-15
tags: Leetcode
toc: true
---

### 会议室
    Leetcode学习-252

<!-- more -->

#### Q
    给定由开始和结束时间组成的一系列会议时间间隔[[s1,e1],[s2,e2],...](s i <e i),确定一个人是否可以参加所有会议.

    例1: 

    输入:  [[0,30],[5,10],[15,20]]
    输出:  false
    例2: 

    输入:  [[7,10],[2,4]]
    输出:  true

#### A
    ```php
        class Solution {
            function canAttendMeetings($intervals) {
                if (!empty($intervals)) {
                    $cnt = count($intervals);
                    for ($i = 0; $i < $cnt - 1; $i++) {
                        for ($j = 0; $j < $cnt - $i - 1; $j++) {
                            if ($intervals[$j][0] > $intervals[$j + 1][0]) {
                                $temp = $intervals[$j];
                                $intervals[$j] = $intervals[$j + 1];
                                $intervals[$j + 1] = $temp;
                            }
                        }
                    }
            
                    for ($i = 0; $i < $cnt - 1; $i++) {
                        if ($intervals[$i+1][0] < $intervals[$i][1]) {
                            return false;
                        }
                    }
                    return true;
                } else {
                    return false;
                }
            }
        }
        $a = new Solution();
        $arr = array(
            array(5, 10),
            array(0, 30),
            array(15, 20)
        );
        var_dump($a->canAttendMeetings($arr));
        $arr = array(
            array(7, 10),
            array(2, 4)
        );
        var_dump($a->canAttendMeetings($arr));
    ```
