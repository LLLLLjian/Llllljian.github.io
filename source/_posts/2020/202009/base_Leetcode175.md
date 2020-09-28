---
title: Leetcode_基础 (175)
date: 2020-09-07
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-递归/回溯/分治

<!-- more -->

#### 求子集
- 问题描述
    * 给定一组不含重复元素的整数数组 nums,返回该数组所有可能的子集(幂集).
    * 说明：解集不能包含重复的子集.
- 解题思路
    * 遍历给定数组中的每一个元素,在每一次遍历中,处理结果集.结果集中的每个元素添加遍历到的数字,结果集的长度不断增加
    ```php
        function subsets($nums)
        {
            if (is_null($nums)) {
                return [];
            }

            // 1. 迭代法
            $result = [[]];
            if (empty($nums) {
                return $result;
            }
            foreach ($nums as $num) {
                foreach ($result as $item) {
                    $tmp = $item;
                    $tmp[] = $num;
                    $result[] = $tmp;
                }
            }

            /*
            for ($i=0;$i<count($nums);$i++) {
                $tempCount = count($res);
                for ($j=0;$j<$tempCount;$j++) {
                    $temp = $res[$j];
                    $temp[] = $nums[$i];
                    $res[] = $temp;
                }
            }
            */

            return $result;
        }
    ```
    *  递归法(分治)
    ```php
        function subsets($nums)
        {
            if (empty($nums)) {
                return [];
            }

            $result = [];
            // 2. 递归回溯法
            $this->helper($nums, 0, [], $result);
            return $result;
        }

        function helper($nums, $index, $current, &$result)
        {
            // terminator
            if ($index == count($nums)) {
                $result[] = $current;
                return;
            }

            // split and drill down
            // 不选 not pick the number in this index
            $this->helper($nums, $index + 1, $current, $result);
            // 选
            $current[] = $nums[$index];
            $this->helper($nums, $index + 1, $current, $result);

            // merge
            // $result[] = $current;
            // revert
        }
    ```
    * 回溯法
    ```php
        class Solution
        {
            protected $result;
            /**
            * @param Integer[] $nums
            * @return Integer[][]
            */
            function subsets($nums)
            {
                // 画出递归树,答案是遍历递归树的所有节点
                $this->result[] = [];
                $this->sub($nums, [], 0);
                return $this->result;
            }

            private function sub($nums, $list, $start)
            {
                if (count($list) == count($nums)) {
                    return;
                }
                for ($i = $start; $i < count($nums); ++$i) {
                    $list[] = $nums[$i];
                    // 在这里,递归中途添加,而不是递归终止条件处添加
                    $this->result[] = $list;
                    $this->sub($nums, $list, $i + 1);
                    array_pop($list);
                }
            }
        }
    ```

#### 子集II
- 问题描述
    > 给定一个可能包含重复元素的整数数组 nums,返回该数组所有可能的子集(幂集).
    说明：解集不能包含重复的子集.
    示例:
    输入: \[1,2,2]
    输出:
    \[\[2], \[1], \[1,2,2], \[2,2], \[1,2], \[]]
- 解题思路
    * 和之前的求子集是一样的, 多了一个去除重复的过程
    ```php
        class Solution 
        {
            /**
             * @param Integer[] $nums
             * @return Integer[][]
             */
            protected $res = [];
            function subsetsWithDup($nums) 
            {
                sort($nums);
                $this->help($nums, [], 0);
                return $this->res;
            }

            protected function help(&$nums, $path, $start) 
            {
                $this->res[] = $path;
                if ($start == count($nums)) {
                    return;
                }

                for ($i = $start; $i < count($nums); $i++) {
                    if ($i > $start && $nums[$i] == $nums[$i-1]) {
                        continue;
                    }
                    $path[] = $nums[$i];
                    $this->help($nums, $path, $i + 1);
                    array_pop($path);
                }
                return;
            }
        }
    ```

