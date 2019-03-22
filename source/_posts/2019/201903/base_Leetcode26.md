---
title: Leetcode_基础 (26)
date: 2019-03-18
tags: Leetcode
toc: true
---

### 杨辉三角
    Leetcode学习-118

<!-- more -->

#### Q
    给定一个非负整数 numRows,生成杨辉三角的前 numRows 行

    在杨辉三角中,每个数是它左上方和右上方的数的和.

    示例:

    输入: 5
    输出:
    [
        [1],
        [1,1],
    [1,2,1],
    [1,3,3,1],
    [1,4,6,4,1]
    ]

#### A
    ```php
       class Solution {
            /**
             * @param Integer $numRows
             * @return Integer[][]
             */
            function generate($numRows) {
                $returnArr = array(
                    1 => array('1'),
                    2 => array('1', '1')
                );
                
                for ($i=3;$i<=$numRows;$i++) {
                    for ($m=$i-1;$m>=0;$m--) {
                        if ($m == ($i-1)) {
                            $returnArr[$i][$m] = 1;
                            continue;
                        } 
                        if ($m == 0) {
                            $returnArr[$i][0] = 1;
                            continue;
                        }
                        $returnArr[$i][$m] = $returnArr[$i-1][$m-1] + $returnArr[$i-1][$m];
                        
                    }
                }
                
                if (empty($numRows)) {
                    $returnArr = array();
                } elseif ($numRows == 1) {
                    $returnArr = array(array('1'));
                }
                return $returnArr;
            }

            function generate1($numRows) {
                $returnArr = array();
                
                if (empty($numRows)) {
                    
                } else{
                    for ($i=1;$i<=$numRows;$i++) {
                        if ($i == 1) {
                            $returnArr[1][1] = 1;
                            continue;
                        }
                        if ($i == 2) {
                            $returnArr[2][0] = 1;
                            $returnArr[2][1] = 1;
                            continue;
                        }
                        
                        $returnArr[$i][0] = 1;
                        for ($m=1;$m<$i-1;$m++) {
                            $returnArr[$i][$m] = $returnArr[$i-1][$m-1] + $returnArr[$i-1][$m];
                        }
                        $returnArr[$i][$i-1] = 1;
                    }   
                }
                
                return $returnArr;
            }

            function generate2($numRows) {
                $res = [];
                for ($i=1; $i<=$numRows; $i++) {
                    $row = [];
                    for ($j=0; $j<$i; $j++) {
                        if ($j == 0 || $j == $i-1) {
                            $row[] = 1;
                        } else {
                            $row[] = $res[$i-2][$j-1] + $res[$i-2][$j];
                        }
                    }
                    
                    $res[] = $row;
                }
            }
        }
    ```
