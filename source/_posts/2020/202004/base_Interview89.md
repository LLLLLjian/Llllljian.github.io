---
title: Interview_总结 (89)
date: 2020-04-13
tags: Interview
toc: true
---

### 算法题
    最长公共前缀

<!-- more -->

#### 最长公共前缀
> 编写一个函数来查找字符串数组中的最长公共前缀.
如果不存在公共前缀,返回空字符串 "".
示例 1:
输入: ["flower","flow","flight"]
输出: "fl"
示例 2:
输入: ["dog","racecar","car"]
输出: ""
解释: 输入不存在公共前缀.
说明:
所有输入只包含小写字母 a-z .
- A
    ```php
        class Solution
        {
            /**
             * @param String[] $strs
             * @return String
             */
            function longestCommonPrefix1($strs) 
            {
                // 1. 水平扫描法
                // 取第一字符和第二个字符的公共前缀和第三个字符进行比较 
                $tempStr = $strs[0];
                $count = count($strs);
                for ($i=1;$i<$count;$i++) {
                    $tempStr = $this->getCommonPrefix($tempStr, $strs[$i]);
                    if (empty($tempStr)) {
                        return "";
                    }
                }
                return $tempStr;
            }

            function longestCommonPrefix2($strs) 
            {
                // 2. 分治法
                // 分而治之, 0-mid的结果 mid-end的结果
                $count = count($strs);
                if ($count == 1) {
                    return current($strs);
                }
                $mid = ceil($count / 2);
                $leftRes = $this->longestCommonPrefix2(array_slice($strs, 0, $mid));
                $rightRes = $this->longestCommonPrefix2(array_slice($strs, $mid + 1));
                return $this->getCommonPrefix($leftRes, $rightRes);
            }

            function longestCommonPrefix3($strs) 
            {
                 // 3. 终极办法
                 // 取出最长的和最短的比较
                 $minStr = min($strs);
                 $maxStr = max($strs);
                 $minlen = count($minStr);

                $res = "";
                for ($i=0;$i<$minlen;$i++) {
                    if ($minStr[$i] == $maxStr[$i]) {
                        $res .= $minStr[$i];
                    } else {
                        break;
                    }
                }
                return $res;
            }

            function getCommonPrefix($str1, $str2)
            {
                $minLen = min(strlen($str1), strlen($str2));
                $index = 0;
                while (($index < $minLen) && ($str1[$index] == $str2[$index])) {
                    $index++;
                }
                return substr($str1, 0, $index);
            }
        }
    ```


