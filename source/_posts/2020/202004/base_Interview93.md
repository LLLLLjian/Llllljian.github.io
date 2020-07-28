---
title: Interview_总结 (93)
date: 2020-04-24
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### 程序题1
```php
    <?php
        $str = "abcd";
        /*
        abcd
        abc
        bcd
        ab
        cd
        a
        b
        c
        d
        */

        function t1($str)
        {
            $res = array();
            $len = strlen($str);
            for ($i=0;$i<$len;$i++) {
                for ($j=0;$j<=$len;$j++) {
                    $tempStr = substr($str, $i, $j);
                    if (!empty($tempStr)) {
                        $res[$tempStr] = $tempStr;
                    }
                }
            }
            return $res;
        }
        echo "<pre>";
        var_dump(t1($str));
    ?>
```

#### 程序题2
```php
    <?php
    /**
     * ab 171
     * b1 177
     */
    
    function t1($str)
    {
        $arr = array(
            'a' => 10,
            'b' => 11,
            'c' => 12,
            'd' => 13,
            'e' => 14,
            'f' => 15
        );
        
        $res = 0;
        $temp = 0;
        $len = strlen($str);
        for ($i=$len-1;$i>=0;$i--) {
            if (isset($arr[$str[$i]])) {
                $res += $arr[$str[$i]] * pow(16, $temp);
            } else {
                $res += $str[$i] * pow(16, $temp);
            }
            $temp += 1;
        }
        return $res;
    }

    var_dump(t1("ab"));
    var_dump(t1("b1"));

    ?>
```

#### 程序题3
```php
    class Solution {
        /**
         * 十进制转化为七进制
         * 100 => 202
         * -7  => -10
         * @param Integer $num
         * @return String
         */
        function convertToBase7($num) {
            $tempFlag = false;
            $res = array();
            // 是否为负数
            if ($num < 0) {
                $tempFlag = true;
                $num *= -1;
            } else {
                $tempFlag = false;
            }

            if ($num < 7) {
                $res = $num;
            } else {
                while (!empty($num)) {
                    $chushu = intval($num/7);
                    $yushu = $num%7;
                    array_unshift($res, $yushu);
                    $num = $chushu;
                }

                $res = implode($res);
            }
            if (!$tempFlag) {
                return strval($res);
            } else {
                return strval(-$res);
            }
        }
    }
```

