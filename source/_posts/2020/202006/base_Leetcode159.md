---
title: Leetcode_基础 (159)
date: 2020-06-22
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温散列表

<!-- more -->

#### 两个数组的交集
- 问题描述
    * 给定两个数组, 编写一个函数来计算它们的交集.
- 解题思路
    * 那你敢让我用php内置函数的话  那我赢了呀
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums1
             * @param Integer[] $nums2
             * @return Integer[]
             */
            function intersection($nums1, $nums2) 
            {
                return array_intersect(array_unique($nums1), array_unique($nums2));   
            }
        }
    ```

#### 两个数组的交集II
- 问题描述
    * 这次不去重了, 应与元素在两个数组中出现次数的最小值一致
- 解题思路
    * 遍历一个 然后放在新数组中并记录出现的次数, 另一个数组循环时, 判断是否存在及出现次数, 大于0就放入结果中, 并将原数组出现次数减1
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums1
             * @param Integer[] $nums2
             * @return Integer[]
             */
            function intersect($nums1, $nums2) {
                $tempArr1 = $tempArr2 = array();
                
                for ($i=0;$i<count($nums1);$i++) {
                    if (array_key_exists($nums1[$i], $tempArr2)) {
                        $tempArr2[$nums1[$i]] += 1;
                    } else {
                        $tempArr2[$nums1[$i]] = 1;
                    }
                }
                for ($j=0;$j<count($nums2);$j++) {
                    if (array_key_exists($nums2[$j], $tempArr2) && ($tempArr2[$nums2[$j]] > 0)) {
                        $tempArr2[$nums2[$j]] -= 1;
                        $tempArr1[] = $nums2[$j];
                    }
                }
                return $tempArr1;
            }
        }
    ```

#### 回旋镖的数量
- 问题描述
    * 给定平面上 n 对不同的点, “回旋镖” 是由点表示的元组 (i, j, k) , 其中 i 和 j 之间的距离和 i 和 k 之间的距离相等(需要考虑元组的顺序).
- 解题思路
    * 首先理解题意.组成回旋镖的条件是这样.
    * 先找到一个点.如果对这个点来说, 存在两个点, 它们到回旋镖的距离一样, 那么这三个点组成一个回旋镖.注意这两个点交换位置也算另一种回旋镖.
    * 遍历所有点,  统计它和所有点之间的距离,  按照频率为键组成哈希表.值是这个距离出现的次数.(这里用Counter类别简化操作),  如果这个次数大于等于 2, 那么计算P(次数, 2), 即排列组合当中的知识, 计算所有这些点中取出两个点总共有多少个组合, 位置是相关的.这里用perm()函数简化操作.把所有点的次数加起来即可
    ```php
        class Solution {
            function numberOfBoomerangs($points) {
                //查找数
                $len = count($points);
                $num = 0;
                //取一个固定点, 检测该固定点到其他点的距离
                for($i = 0;$i<$len;++$i){
                    $distance = [];
                    for($j = 0;$j<$len;++$j){
                        if($j != $i){
                            $key = $this->dis($points[$i],$points[$j]);
                            if(isset($distance[$key])){
                                $distance[$key]++;
                            }else{
                                $distance[$key] = 1;
                            }
                        }
                    }
                    //print_r($distance);
                    //取得的结果,两两成一对, 每一对可以有两种可能, 所以进行排列组合排列组合An(n-1)
                    foreach ($distance as $v)
                        if($v>1)
                            $num += $v*($v-1);
                }
                return $num;
            }
            function dis($a ,$b){
                //勾股定理, 不开根号, 防止出现浮点数
                return ($a[0]-$b[0])*($a[0]-$b[0]) + ($a[1]-$b[1])*($a[1]-$b[1]);
            }
        }
    ```

#### 重复的DNA序列
- 问题描述
    * 编写一个函数来查找目标子串, 目标子串的长度为 10, 且在 DNA 字符串 s 中出现次数超过一次.
- 解题思路
    * 固定窗口长度为10, 每次往后移动一个长度, 截取出来一个长度为10的, 如果出现两次 那他就是结果
    ```php
        class Solution 
        {
            /**
             * @param String $s
             * @return String[]
             */
            function findRepeatedDnaSequences($s) 
            {
                $res = $tempArr = array();
                if (!empty($s)) {
                    $len = strlen($s);
                    // 比11小的话 没办法滑动窗口了 直接退出
                    if ($len < 11) {
                        return $res;
                    } else {
                        for ($i=0;$i+10<=$len;$i++) {
                            $tempStr = substr($s, $i, 10);
                            if (isset($tempArr[$tempStr])) {
                                $res[$tempStr] = $tempStr;
                            } else {
                                $tempArr[$tempStr] = 1;
                            }
                        }
                        return $res;
                    }
                }
                return $res;
            }
        }
    ```

