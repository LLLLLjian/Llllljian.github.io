---
title: Leetcode_基础 (27)
date: 2019-03-19
tags: Leetcode
toc: true
---

### 杨辉三角II
    Leetcode学习-119

<!-- more -->

#### Q
    给定一个非负索引 k,其中 k ≤ 33,返回杨辉三角的第 k 行.

    在杨辉三角中,每个数是它左上方和右上方的数的和.

    示例:

    输入: 3
    输出: [1,3,3,1]

#### A
    ```php
       class Solution {
            /**
             * @param Integer $rowIndex
             * @return Integer[]
             */
            function getRow($rowIndex) {
                $returnArr = array();
                $numRows = $rowIndex + 1;
                        
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

                return $returnArr[$numRows];
            }

            function getRow1($rowIndex) {
                if ($rowIndex > 33 || $rowIndex < 0) {
                    return [];
                }
                $rowIndex += 1;

                $res = [];
                for ($i=1; $i<=$rowIndex; $i++) {
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

                return $res[$rowIndex-1];
            }
        }
    ```
