---
title: DataStructure_基础 (33)
date: 2019-12-31
tags: DataStructure
toc: true
---

### 漫画算法：小灰的算法之旅读书笔记
    漫画算法观后感之面试算法[删除k个数字之后的最小值]

<!-- more -->

#### 删除k个数字之后的最小值
- Q
    * 给出一个整数, 从该整数中去掉k个数字, 要求剩下的数字形成的新整数尽可能的小
    * 例如1234 去除一个数字的话, 去除4 得到的结果是123
    * 例如3549 去除一个数字的话, 去除5 得到的结果是349
- 解题思路
    * 先把问题简化一下, 只去除一个数字
    * 把原整数的所有数字从左到右进行比较, 如果发现某一个数字比他右边的数字大, 那么去掉它是最合适的, 
- A1
    ```php
        function removeKDigits($num, $k)
        {
            for ($i=1;$i<=$k;$i++) {
                $tempFlag = false;
                $num = strval($num);
                $len = strlen($num);
                for ($j=0;$j<$len-1;$j++) {
                    if ($num[$j] > $num[$j+1]) {
                        $tempFlag = true;
                        $temp0 = substr($num, 0, $j);
                        $temp1 = substr($num, $j+1);

                        $num = $temp0 . $temp1;
                        break;
                    }
                }

                if (!$tempFlag) {
                    // 如果没有找到想删除的数字 就删除最后一位
                    $num = substr($num, 0, $len-1);
                }

                // 清除整数左边的0
                $num = ltrim($num, "0");

            }

            if (strlen($num) == 0) {
                return 0;
            }
            return $num;
        }

        var_dump(removeKDigits(1234, 1));
        var_dump(removeKDigits(1593212, 3));
        var_dump(removeKDigits(3549, 1));
        var_dump(removeKDigits(541270936, 3));
    ```
- A2
    ```php
        function removeKDigits($num, $k)
        {
            $numStr = strval($num);
            $numLen = strlen($numStr);

            $resArr = array();
            $top = 0;

            for ($i=0;$i<$numLen;$i++) {
                $c = $numStr[$i];

                while (($top > 0) && ($resArr[$top-1] > $c) && ($k > 0)) {
                    $top -= 1;
                    $k -= 1;
                    unset($resArr[$top]);
                }

                $resArr[$top++] = $c;
            }
            $resStr = implode($resArr);
            $resStr = ltrim(substr($resStr, 0, count($resArr) - $k), 0);
            if (empty($resStr)) {
                return "0";
            }
            return $resStr;
        }
    ```

