---
title: Leetcode_基础 (174)
date: 2020-09-04
tags: Leetcode
toc: true
---

### 重温系列
    重温系列-递归/回溯/分治

<!-- more -->

#### 开胃菜
- 预备知识(循环)
    ```php
        $arr = array(1, 2, 3);
        $tempA = $tempB = array();
        for ($i=0;$i<count($arr);$i++) {
            array_push($tempA, $arr[$i]);
            array_push($tempB, $tempA);
        }
        //[[1], [1, 2], [1, 2, 3]]
    ```
- 预备知识(递归)
    ```php
        function generate($i, &$nums, &$item, &$result)
        {
            if ($i >= count($nums)) {
                return;
            }
            $item[] = $nums[$i];
            $result[] = $item;
            generate($i+1, $nums, $item, $result);
        }

        $arr = array(1, 2, 3);
        $item = $result = array();
        generate(0, $arr, $item, $result);
        echo "<pre>";
        var_dump($result);

        /**
         * 第一次递归调用
         * generate(0, $arr, $item, $result);
         * i=0; item=[1]; result=[[1]]
         * 
         * 第二次递归调用
         * generate(1, $arr, $item, $result);
         * i=1; item=[1, 2]; result=[[1], [1, 2]]
         * 
         * 第三次递归调用
         * generate(2, $arr, $item, $result);
         * i=2; item=[1, 2, 3]; result=[[1], [1, 2], [1, 2, 3]]
         * 
         * 第四次递归调用
         * generate(3, $arr, $item, $result);
         * return;
         */
    ```

#### 组合总和
- 问题描述
    > 给定一个无重复元素的数组 candidates 和一个目标数 target ,找出 candidates 中所有可以使数字和为 target 的组合.
    candidates 中的数字可以无限制重复被选取.
    说明: 
    所有数字(包括 target)都是正整数.
    解集不能包含重复的组合. 
    示例 1: 
    输入: candidates = \[2,3,6,7], target = 7,
    所求解集为: 
    \[[7], [2,2,3]]
    示例 2: 
    输入: candidates = \[2,3,5], target = 8,
    所求解集为: 
    \[ [2,2,2,2], [2,3,3], [3,5]]
- 解题思路
    * ![组合总和](/img/20200904_1.png)
    ```php
        class Solution
        {
            protected $result = [];
            /**
             * @param Integer[] $candidates
             * @param Integer $target
             * @return Integer[][]
             */
            function combinationSum($candidates, $target)
            {
                if ($target <= 0) return [];
                sort($candidates);
                $this->combine($candidates, $target, [], 0);
                return $this->result;
            }

            private function combine($nums, $target, $list, $start)
            {
                // terminator
                if ($target < 0) return;
                if ($target == 0) {
                    $this->result[] = $list;
                    return;
                }

                for ($i = $start; $i < count($nums); ++$i) {
                    // 由于数字是排好序的,所以可以进行剪枝
                    if ($target - $nums[$i] < 0) break;
                    $list[] = $nums[$i];
                    // 数字可重复使用
                    $this->combine($nums, $target - $nums[$i], $list, $i);
                    // 回溯
                    array_pop($list);
                }
            }
        }
    ```

#### 组合数之和2
- 问题描述
    > 给定一个数组 candidates 和一个目标数 target ,找出 candidates 中所有可以使数字和为 target 的组合.
    candidates 中的每个数字在每个组合中只能使用一次.
    说明: 
    所有数字(包括目标数)都是正整数.
    解集不能包含重复的组合. 
    示例 1:
    输入: candidates = \[10,1,2,7,6,1,5], target = 8,
    所求解集为:
    [[1, 7], [1, 2, 5], [2, 6], [1, 1, 6]]
    示例 2:
    输入: candidates = \[2,5,2,1,2], target = 5,
    所求解集为:\[\[1,2,2], \[5]]
- 解题思路
    * 跟之前一样, 多一个判断是否该值使用的判断
    ```php
        class Solution
        {
            protected $result = [];
            /**
            * @param Integer[] $candidates
            * @param Integer $target
            * @return Integer[][]
            */
            function combinationSum2($candidates, $target)
            {
                if ($target <= 0) return [];
                sort($candidates);
                $this->helper($candidates, $target, [], 0);
                return $this->result;
            }

            private function helper($nums, $target, $path, $start)
            {
                if ($target < 0) return;
                if ($target == 0) {
                    $this->result[] = $path;
                    return;
                }

                for ($i = $start; $i < count($nums); ++$i) {
                    // 第一次剪枝,因为数组排好序了,小的数字都得不到结果,大的数字就没有必要计算了
                    if ($target - $nums[$i] < 0) break;
                    // 第二次剪枝,如示例 [1,1,2,5,6],遍历到第二个分支时,[1,2], [1,5], [1,6], [1,2,5], [1,2,6], [1,5,6] 
                    // 这样的子树下的所有情况在第一次遍历时都已覆盖,无需再重复计算
                    if ($i > $start) {
                        if ($nums[$i] == $nums[$i - 1]) continue;
                    }
                    $path[] = $nums[$i];
                    $this->helper($nums, $target - $nums[$i], $path, $i + 1);
                    array_pop($path);
                }
            }
        }
    ```
