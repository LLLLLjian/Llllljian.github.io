---
title: PHP_封装函数
date: 2017-12-11
tags: PHP
toc: true
---
## PHP封装函数

### 数组中value去空

``` bash
    /**
    * $param[array,要去除value值中空格的数组]
    * $isMoreArray[bool,是否为多维数组]
    */
    function trimEmptyValue($param, $isMoreArray) {
        foreach ($param as $aKey=>$aValue) {
            if (!is_array($aValue)) {
                $param[$aKey] = trim($aValue);
            } elseif ($isMoreArray) {
                foreach ($aValue as $bKey=>$bValue) {
                    if (!is_array($bValue)) {
                        $param[$aKey][$bKey] = trim($bValue);
                    } elseif ($isMoreArray) {
                        foreach ($bValue as $cKey=>$cValue) {
                            if (!is_array($cValue)) {
                                $param[$aKey][$bKey] = trim($cValue);
                            }
                        }
                    }
                }
            }
        } 
    }
```

<!-- more-->

### 对数据进行编码转化

``` bash
    /**
    * $inCharset[string,输入内容编码]
    * $outCharset[string,输出内容编码]
    * $param [要转化的内容，可以是数组也可以是字符串]
    */
    function iconv_param($inCharset, $outCharset, $param) {
        if (is_array($param)) {
            foreach ($param as $key=>$value) {
                if (is_string($key)) {
                    $keyTmp = iconv($inCharset, $outCharset, $key);
                } else {
                    $keyTmp = $key;
                }

                $param[$keyTmp] = iconv_array($inCharset, $outCharset, $value);

                if ($key != $keyTmp) {
                    unset($param[$key]);
                }
            }
        } else {
            if (is_string($param)) {
                $param = iconv($inCharset, $outCharset, $param);
            }
        }

        return $param;
    }
```

### 对数据值进行去空

``` bash
    /**
    * $arr[array,去除空值的数组]
    * $trim
    */
    function array_remove_empty ($arr, $trim = true) {
        if (empty ($arr)) {
            return array();
        }

        foreach ($arr as $key => $value) {
            if (is_array($value)) {
                array_remove_empty($value, $trim);
            } else {
                $value = trim($value);

                if (empty($value)) {
                    unset($arr[$key]);
                } elseif ($trim) {
                    $arr[$key] = $value;
                }
            }
        }
        return $arr;
    }
```

### 两个数字进行比较

``` bash
    function floatcmp($f1,$f2,$percision=10)
    {
        if (!is_numeric($f1)) {
            throw new Exception('first param of function floatcmp must be number');
        }
        if (!is_numeric($f2)) {
            throw new Exception('second param of function floatcmp must be number');
        }
        if (!is_int($percision)) {
            throw new Exception('third param of function floatcmp must be int');
        }
            $e = pow(10,$percision);
            $i1 = floor($f1*$e);
            $i2 = floor($f2*$e);
        if ($i1 > $i2) {
            return 1;
        }
        elseif ($i1 == $i2) {
            return 0;
        }
        else {
            return -1;
        }
    }
```

### 通话时长转化

``` bash

    function convert_time_len($l) {
        $h = floor($l/3600);
        $m = floor(($l - $h*3600)/60);
        $s = $l % 60;
        return sprintf("%02d:%02d:%02d", $h, $m, $s);
    }
```

### 转化为秒数

``` bash

    function convert_time_string($tmp_rec_long) {
        if(is_numeric($tmp_rec_long)){
            return $tmp_rec_long;
        }

        $tmp_rec_long = str_replace("：",":",$tmp_rec_long);

        $tmp_rec_long_arr = explode(":", $tmp_rec_long);
        $tmp_rec_long_count = count($tmp_rec_long_arr);

        $tmp_rec_long_int = -1;
        if($tmp_rec_long_count == 3) {
            $tmp_rec_long_int = intval($tmp_rec_long_arr[0]) * 3600 + intval($tmp_rec_long_arr[1]) * 60 + intval($tmp_rec_long_arr[2]);
        } elseif ($tmp_rec_long_count == 2) {
            $tmp_rec_long_int = intval($tmp_rec_long_arr[0]) * 60 + intval($tmp_rec_long_arr[1]);
        } elseif($tmp_rec_long_count == 1) {
            $tmp_rec_long_int = intval($tmp_rec_long_arr[0]);
        }

        return $tmp_rec_long_int;
    }
```

### 检查两个数组是否不同

``` bash

    function checkChange($newValue, $oldValue, $filter = array()) {
        if (is_array($newValue) && is_array($oldValue)) {
            if (empty($filter) || !is_array($filter)) {
                $filter = array('ctime', 'mtime', 'updater', 'creator', 'isvalid');
            }
            $flag = 0;
            foreach ($newValue as $key => $val){
                if (in_array($key, $filter)) {
                    continue;
                }
                if ($newValue[$key] != $oldValue[$key]) {
                    $flag = 1;
                    break;
                }
            }
            return $flag;
        }
    }
```

### 数组转化为树

``` bash

    function getTreebyArray($list, $pk='id', $pid = 'pid', $child = 'Children', $root = 0) {
        $tree = array();

        if (is_array($list)) {
            $refer = array();

            foreach ($list as $key => $data) {
                    $refer[$data[$pk]] = &$list[$key];
            }

            foreach ($list as $key => $data) {
                $parantId = $data[$pid];

                if ($root == $parantId) {
                    $tree[] = &$list[$key];
                } else {
                    if (isset($refer[$parantId])) {
                        $parent = &$refer[$parantId];
                        $parent[$child][] = &$list[$key];
                    }
                }
            }
        }

        return $tree;
    }
```

### 对用户名隐藏几位

``` bash

    function hideAccount($account){
        $account_hide = '';
        if (empty($account)) {
            return $account_hide;
        }

        $len = mb_strlen($account, SYSTEM_CHARSET);
        if ($len <= 2) {
            $account_hide = str_repeat("*", $len);
        } elseif($len <= 5) {
            $account_hide = mb_substr($account,0,1,SYSTEM_CHARSET).str_repeat("*", $len-2).mb_substr($account,-1,1,SYSTEM_CHARSET);
        } elseif($len < 9) {
            $account_hide =  mb_substr($account,0,2,SYSTEM_CHARSET).str_repeat("*", $len-4).mb_substr($account,-2,2,SYSTEM_CHARSET);
        } elseif($len >= 9) {
            $account_hide = mb_substr($account,0,3,SYSTEM_CHARSET).str_repeat("*", $len-6).mb_substr($account,-3,3,SYSTEM_CHARSET);
        }
        return $account_hide;
    }
```

### 通过身份证获取年龄

``` bash

    function getAgeByIdcard($idcard){
        $birthday = substr($idcard, 10, 4);
        $birthyear = substr($idcard, 6, 4);
        $age = date("Y") - $birthyear;
        if ($birthday > date("md")) {
            $age --;
        }
        return $age;
    }
```

### 通过身份证获取性别

``` bash

    function getSexByIdcard($idcard, $type = 0) {
        $sexMap = array('男' => 1, '女' => 2);
        $sexFlag = substr($idcard, -2, 1);
        if ($sexFlag % 2 == 1) {
            $sex = '男';
        } else {
            $sex = '女';
        }
        if ($type) {
            $sex = $sexMap[$sex];
        }
        return $sex;
    }
```