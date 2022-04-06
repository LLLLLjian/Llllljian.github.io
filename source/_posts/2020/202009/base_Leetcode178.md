---
title: Leetcode_基础 (178)
date: 2020-09-10
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-递归/回溯/分治

<!-- more -->

#### 合并有序数组
- 问题描述
    * 两个有序数组合并成一个有序数组
- 解题思路
    * 两个指针一点一点往前走
    ```php
        fucntion merge_sort_two_vec($arr1, $arr2)
        {
            $res = array();
            $i = $j = 0;
            if (($i<count($arr1)) && ($j<count($arr2))) {
                if ($arr[$i] < $arr2[$j]) {
                    $res[] = $arr1[$i];
                    $i += 1;
                } else {
                    $res[] = $arr2[$j];
                    $j += 1;
                }
            }

            if ($i < count($arr1)) {
                for ($i;$i<count($arr1);$i++) {
                    $res[] = $arr1[$i];
                }
            }
            if ($j < count($arr2)) {
                for ($j;$j<count($arr2);$j++) {
                    $res[] = $arr2[$j];
                }
            }
            return $res;
        }
    ```

#### 数组中的逆序对
- 问题描述
    > 在数组中的两个数字,如果前面一个数字大于后面的数字,则这两个数字组成一个逆序对.输入一个数组,求出这个数组中的逆序对的总数.
    示例 1:
    输入: [7,5,6,4]
    输出: 5
    限制: 
    0 <= 数组长度 <= 50000
- 解题思路
    * 
    ```php
        class Solution 
        {
            //出现逆序对的个数
            private $cnt=0;

            function reversePairs($nums)
            {
                $this->merge_sort_helper($nums,0,count($nums)-1);
                return $this->cnt;
            }

            //分治
            function merge_sort_helper(&$nums,$l,$r){
                if($l>=$r) return;
                $mid = intval(floor(($l+$r)/2));
                $this->merge_sort_helper($nums,$l,$mid);
                $this->merge_sort_helper($nums,$mid+1,$r);
                $this->merge($nums,$l,$mid,$r);
            }

            //合并
            function merge(&$nums,$l,$mid,$r){
                $i = $l;     // 左数组的下标
                $j = $mid + 1;  // 右数组的下标
                $temp = [];// 临时合并数组
                while($i<=$mid && $j<=$r){
                    if($nums[$i]<=$nums[$j]){
                        $temp[] = $nums[$i];
                        $i++;
                    }else{
                        //如果左边部分的数字大于右边的数字
                        $this->cnt += $mid-$i+1;
                        $temp[] = $nums[$j];
                        $j++;
                    }
                }

                while ($i <= $mid) {
                    $temp[] = $nums[$i];
                    $i++;
                }
                while ($j <= $r) {
                    $temp[] = $nums[$j];
                    $j++;
                }
                for($k = 0; $k < count($temp); $k++) {
                    $nums[$l + $k] = $temp[$k];
                }
            }
        }
    ```

#### 计算右侧小于当前元素的个数
- 问题描述
    >给定一个整数数组 nums,按要求返回一个新数组 counts.数组 counts 有该性质:  counts[i] 的值是  nums[i] 右侧小于 nums[i] 的元素的数量.
    示例: 
    输入: nums = [5,2,6,1]
    输出: [2,1,1,0] 
    解释: 
    5 的右侧有 2 个更小的元素 (2 和 1)
    2 的右侧仅有 1 个更小的元素 (1)
    6 的右侧有 1 个更小的元素 (1)
    1 的右侧有 0 个更小的元素
    提示: 
    0 <= nums.length <= 10^5
    -10^4 <= nums[i] <= 10^4
- 解题思路
    ```php
        class Solution
        {
            function countSmaller($nums) {
                $len_n = count($nums);
                if ($len_n == 0)return [];
                $res = array_fill(0, $len_n, 0);
                $sorted = [];
                //从右往左遍历
                for ($i = $len_n - 1; $i >= 0; $i--) {
                    // var_dump($sorted);
                    $index = $this->findIndex($sorted, $nums[$i]);
                    array_splice($sorted, $index, 0, $nums[$i]);//
                    $res[$i] = $index;
                }

                $res[$len_n-1] = 0;
                // array_reverse($res);

                return $res;
            }
            //二分查找变形,并不是真正查找到某个值
            protected function findIndex($nums, $target) {
                // var_dump($nums);
                // var_dump($target);
                $left = 0;
                $right = count($nums) - 1;
                while ($left < $right) {
                    $mid = ($left + $right) >> 1;
                    if ($nums[$mid] < $target) {
                        $left = $mid + 1;
                    } else {
                        $right = $mid;
                    }
                }
                //isset防止空数组
                if (isset($nums[$left]) && $nums[$left] < $target)return $left + 1;
                return $left;
            }
        }
    ```

