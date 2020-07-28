---
title: Interview_总结 (82)
date: 2020-03-25
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列

<!-- more -->

#### 问题1
> 有一个字符串1a2b3cc4dde567fs, 需要把它转化为1:a 2:b
- A
    ```php
        function changeStr1($str)
        {
            // 先找出数字
            $pre = "/\d{1,}/";
            preg_match_all($pre, $str, $res);
            
            // 再匹配字母
            $pre1 = "/[a-zA-Z]{1,}/";
            preg_match_all($pre1, $str, $res1);
            
            $res2 = array();
            foreach ($res[0] as $key=>$value) {
                $res2[$value] = isset($res1[0][$key]) ? $res1[0][$key] : "";
            }

            // 不用这个的原因是 如果$res[0]和$res1[0]数量不相等会报错
            //$res2 = array_combine($res[0], $res1[0]);
            return $res2;
        }

        function changeStr2($str)
        {
            $strLen = strlen($str);
            
            $res2 = array();
            for ($i=0;$i<$strLen;$i++) {
                $tempKey = $tempValue = "";
                while (isset($str[$i]) && is_numeric($str[$i])) {
                    $tempKey .= $str[$i];
                    $i+=1;
                }
                
                while (isset($str[$i]) && !is_numeric($str[$i])) {
                    $tempValue .= $str[$i];
                    $i+=1;
                }
                
                $res2[$tempKey] = $tempValue;
                $i -= 1;
            }
            return $res2;
        }

        function changeStr3($str)
        {
            $arr = str_split($str);
            $len = count($arr);
            $str = "";
            $res = array();
            
            for ($i=0;$i<$len;$i++) {
                $str .= $arr[$i];
                
                if (is_numeric($arr[$i]) && !is_numeric($arr[$i+1])) {
                    $str .= ":";
                } else if (($i == $len - 1) || (!is_numeric($arr[$i]) && is_numeric($arr[$i+1]))) {
                    $tempArr = explode(":", $str);
                    $res[$tempArr[0]] = $tempArr[1];
                    $str = "";
                }
            }
            return $res;
        }

        $str = "1a2b3cc4dde567ad";
        var_dump(changeStr1($str));
        var_dump(changeStr2($str));
        var_dump(changeStr3($str));
    ```


