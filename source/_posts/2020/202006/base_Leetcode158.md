---
title: Leetcode_基础 (158)
date: 2020-06-19
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温散列表

<!-- more -->

#### 无重复字符的最长子串
- 问题描述
    * 给定一个字符串, 请你找出其中不含有重复字符的 最长子串 的长度
- 解题思路
    * 可以考虑从一个空字符串每次增加一个字符直到s结束,当前字符为s[i],left = max(left, last[s[i]]);获得的区间(left, i]是以s[i]结尾无重复字符的最长字串,因为s[left]与s[i]是同一个字符,减小left会有重复字符,从0遍历到s.size()就取到了每个字符结尾的最长无重复字符字串,ans记录其中的最大值,
    ```php
        class Solution 
        {
            /**
             * @param String $s
             * @return Integer
             */
            function lengthOfLongestSubstring($s) 
            {
                $last = array();
                $left = -1;
                $ans = 0;
                for ($i = 0; $i < 128; $i++) {
                    $last[$i] = -1;
                }
                $len = strlen($s);
                for ($i = 0; $i < $len; $i++) {
                    $left = max($left, $last[$s[$i]]);
                    $last[$s[$i]] = $i;
                    $ans = max($ans, $i - $left);
                }
                return $ans;
            }

            function lengthOfLongestSubstring1($s)
            {
                $tempArr = array();
                $len = strlen($s);
                $ans = 0;

                for ($i=0;$i<$len;$i++) {
                    if (isset($tempArr[$s[$i]])) {
                        while (isset($tempArr[$s[$i]])) {
                            array_shift($tempArr);
                        }   
                    }
                    $tempArr[$s[$i]] = $i;
                    $ans = max($ans, count($tempArr));
                }
                return $ans;
            }
        }
    ```

#### 两数之和
- 问题描述
    * 给定一个整数数组 nums 和一个目标值 target, 请你在该数组中找出和为目标值的那 两个 整数, 并返回他们的数组下标.你可以假设每种输入只会对应一个答案.但是, 你不能重复利用这个数组中同样的元素
- 解题思路
    * $target - $nums[$i]是否在数组中,  在的话返回下标, 不在把$nums[$i]放在数组中
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @param Integer $target
             * @return Integer[]
             */
            function twoSum($nums, $target) {
                if (empty($nums)) {
                    return false;
                } else {
                    $count = count($nums);
                    $tempArr = array();
                    for ($i=0;$i<$count;$i++) {
                        $tempStr = $target - $nums[$i];

                        if (array_key_exists($tempStr, $tempArr)) {
                            return array($tempArr[$tempStr], $i);
                        } else {
                            $tempArr[$nums[$i]] = $i;
                        }
                    }
                }
            }
        }
    ```

#### 三数之和
- 问题描述
    * 两数之和升级版
- 解题思路
    * 首先对数组进行排序, 排序后固定一个数 nums[i], 再使用左右指针指向 nums[i]后面的两端, 数字分别为 nums[L] 和 nums[R], 计算三个数的和 sum 判断是否满足为 0, 满足则添加进结果集
    * 如果 nums[i]大于 0, 则三数之和必然无法等于 0, 结束循环
    * 如果 nums[i] == nums[i−1], 则说明该数字重复, 会导致结果重复, 所以应该跳过 
    * 当 sum = 0 时, nums[L] == nums[L+1] 则会导致结果重复, 应该跳过, L++
    * 当 sum = 0 时, nums[R] == nums[R−1] 则会导致结果重复, 应该跳过, R--
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer[][]
             */
            function threeSum($nums) 
            {
                $count = count($nums);
                $res = array();
                if (($count < 3) || empty($nums)) {
                    return $res;
                } 

                sort($nums);
                for ($i=0;$i<$count;$i++) {
                    if ($nums[$i] > 0) {
                        // 如果第一个数都比0大 那三数之和一定大于0
                        break;
                    }
                    if (($i>0) && ($nums[$i] == $nums[$i-1])) {
                        // 当前i与下一个数相同
                        continue;
                    }

                    $l = $i + 1;
                    $r = $count - 1;
                    while ($l < $r)
                    {
                        $sum = $nums[$i] + $nums[$l] + $nums[$r];
                        if ($sum == 0) {
                            $res[] = array($nums[$i], $nums[$l], $nums[$r]);

                            while(($l<$r) && ($nums[$l] == $nums[$l+1])) 
                            {
                                $l++;
                            }
                            while(($l<$r) && ($nums[$r] == $nums[$r-1])) 
                            {
                                $r--;
                            }
                            $l++;
                            $r--;
                        } elseif ($sum < 0) {
                            $l++;
                        } elseif ($sum > 0) {
                            $r--;
                        }
                    }
                }
                return $res;
            }
        }
    ```

#### 四数之和
- 问题描述
    * 三数之和升级版
- 解题思路
    * 使用四个指针(a&lt;b&lt;c&lt;d).固定最小的a和b在左边, c=b+1,d=_size-1 移动两个指针包夹求解.保存使得nums[a]+nums[b]+nums[c]+nums[d]==target的解.偏大时d左移, 偏小时c右移.c和d相遇时, 表示以当前的a和b为最小值的解已经全部求得.b++,进入下一轮循环b循环, 当b循环结束后.a++, 进入下一轮a循环. 即(a在最外层循环, 里面嵌套b循环, 再嵌套双指针c,d包夹求解)

    ```php
        class Solution
        {
            function fourSum($nums, $target)
            {
                sort($nums);
                $ans = [];
                $len = count($nums);
                for ($i = 0; $i < $len - 3; ++$i) {
                    $arr = array_slice($nums, $i + 1);
                    $threeSum = $this->threeSum($arr, $target - $nums[$i]);
                    if ($threeSum) {
                        foreach ($threeSum as $val) {
                            array_unshift($val, $nums[$i]);
                            $ans[implode(',', $val)] = $val;
                        }
                    }
                }

                return array_values($ans);
            }

            private function threeSum($nums, $target)
            {
                $ans = [];
                $len = count($nums);
                for ($i = 0; $i < $len - 2; ++$i) {
                    $left = $i + 1;
                    $right = $len - 1;
                    while ($left < $right) {
                        $sum = $nums[$i] + $nums[$left] + $nums[$right];
                        if ($sum == $target) {
                            $key = sprintf('%d_%d_%d', $nums[$i], $nums[$left], $nums[$right]);
                            $ans[$key] = [$nums[$i], $nums[$left], $nums[$right]];
                            $left++;
                            $right--;
                        } elseif ($sum < $target) {
                            while ($left < $right && $nums[$left + 1] == $nums[$left]) {
                                $left++;
                            }
                            $left++;
                        } else {
                            while ($left < $right && $nums[$right - 1] == $nums[$right]) {
                                $right--;
                            }
                            $right--;
                        }
                    }
                }
                return array_values($ans);
            }
        }

        class Solution {
            function fourSum($nums, $target) {
                $n = count($nums);
                if ($n < 4) return [];
                sort($nums);

                $ans = [];
                for ($i = 0; $i <= $n - 4; ++$i) {
                    if ($i > 0 && $nums[$i] == $nums[$i - 1]) continue;
                    for ($j = $i + 1; $j <= $n - 3; ++$j) {
                        if ($j > $i + 1 && $nums[$j] == $nums[$j - 1]) continue;
                        $left = $j + 1;
                        $right = $n - 1;
                        while ($left < $right) {
                            $sum = $nums[$i] + $nums[$j] + $nums[$left] + $nums[$right];
                            if ($sum == $target) {
                                $ans[] = [$nums[$i], $nums[$j], $nums[$left], $nums[$right]];
                                while ($left < $right && $nums[$left + 1] == $nums[$left]) $left++;
                                while ($left < $right && $nums[$right - 1] == $nums[$right]) $right--;
                                $left++;
                                $right--;
                            } elseif ($sum > $target) {
                                $right--;
                            } else {
                                $left++;
                            }
                        }
                    }
                }
                return $ans;
            }
        }
    ```
