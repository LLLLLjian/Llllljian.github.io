---
title: Leetcode_基础 (40)
date: 2019-04-19
tags: Leetcode
toc: true
---

### 切钢条
    Leetcode学习-198衍生

<!-- more -->

#### Q
    给定一段长度为n的钢条和一个价格表，求切割方案使得销售收益最大
    长度1   2   3   4   5   6   7   8   9   10
    价格1   5   8   9   10  17  17  20  24  30

#### A
    ```php
        class Solution {
            public $priceArr = array(
                    // 长度 => 价格
                    1 => 1,
                    2 => 5,
                    3 => 8,
                    4 => 9,
                    5 => 10,
                    6 => 17,
                    7 => 17,
                    8 => 20,
                    9 => 24,
                    10 => 30
                );
            
            public $resultP = array();

            /**
             * @param Integer $len
             * @return Integer
             */
            function steelBar($len) 
            {
                if ($len == 0) {
                    return 0;
                } else {
                    $q = -1;
                    for ($i=1;$i<=$len;$i++) {
                        $q = max($q, $this->priceArr[$i] + $this->steelBar($len-$i));
                    }
                    return $q;
                }
            }

            function steelBar1($len)
            {
                if ($len == 0) {
                    return 0;
                } else {
                    if (!empty($this->resultP[$len])) {
                        return $this->resultP[$len];
                    } else {
                        $q = -1;
                        for ($i=1;$i<=$len;$i++) {
                            $q = max($q, $this->priceArr[$i] + $this->steelBar($len-$i));
                            $this->resultP[$len] = $q;
                        }

                        return $q;
                    }
                }
            }
            
            function steelBar2($len)
            {
                if ($len == 0) {
                    return 0;
                } else {
                    $resultR = array(0);
                    for ($i=1;$i<=$len;$i++) {
                        $q = 0;
                        for ($j=1;$j<=$i;$j++) {
                            $q = max($q, $this->priceArr[$j] + $resultR[$i - $j]);
                        }
                        $resultR[$i] = $q;
                    }

                    return $resultR[$len];
                }
            }
        }
        
        $a = new Solution();

        echo "当长度为3时，产生的最大效益为".$a->steelBar(3)."<br />";
        echo "当长度为3时，产生的最大效益为".$a->steelBar1(3)."<br />";
        echo "当长度为3时，产生的最大效益为".$a->steelBar2(3)."<br />";

        echo "当长度为4时，产生的最大效益为".$a->steelBar(4)."<br />";
        echo "当长度为4时，产生的最大效益为".$a->steelBar1(4)."<br />";
        echo "当长度为4时，产生的最大效益为".$a->steelBar2(4)."<br />";

        echo "当长度为5时，产生的最大效益为".$a->steelBar(5)."<br />";
        echo "当长度为5时，产生的最大效益为".$a->steelBar1(5)."<br />";
        echo "当长度为5时，产生的最大效益为".$a->steelBar2(5)."<br />";
    ```
