---
title: Interview_总结 (40)
date: 2019-09-29
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 算法题1
- Q
    * [1,1,2,2,3,4,4,5,5,5]找出不重复的元素
- A
    ```php
        function getResult($arr)
        {
            $count = count($arr);
            for ($i=0;$i<$count;$i++) {
                for ($j=0;$j<$count;$j++) {
                    if (($arr[$i] == $arr[$j]) && ($i != $j)) {
                        continue 2;
                    }
                }
                if ($j == $count) {
                    return $arr[$i];
                }
            }
        }

        function getResult1($arr)
        {
            $count = count($arr);
            $arr1 = array();
            for ($i=0;$i<$count;$i++) {
                if (array_key_exists($arr[$i], $arr1)) {
                    $arr1[$arr[$i]] += 1;
                } else {
                    $arr1[$arr[$i]] = 1;
                }
            }
            return array_search(1, $arr1);
        }

        function getResult1($arr)
        {
            $arr1 = array_count_values($arr);
            return array_search(1, $arr1);
        }
    ```

#### 算法题2
- Q
    * 反转链表，要求时间复杂度O(N)，空间复杂度O(1) 
- A
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val) { $this->val = $val; }
         * }
         */
        class Solution {

            /**
             * @param ListNode $head
             * @return ListNode
             */
            function reverseList($head) {
                $retHead = null;
                // 每次循环，都将当前节点指向它前面的节点，然后当前节点和前节点后移
                while($head != null) {
                    // 临时节点，暂存当前节点的下一节点，用于后移
                    $tmpHead = clone $head;
                    // 将当前节点指向它前面的节点
                    $head->next = $retHead;
                    // 前指针后移
                    $retHead = $head;
                    // 当前指针后移
                    $head = $tmpHead->next;
                };
                return $retHead;
            }
        }
    ```

#### 时间复杂度
    执行一次代码需要花费的时间
- 常数阶O(1)
    * 无论代码执行了多少行，只要是没有循环等复杂结构，那这个代码的时间复杂度就都是O(1)
    * 代码在执行的时候，它消耗的时候并不随着某个变量的增长而增长
    * eg
        ```php
            int i = 1;
            int j = 2;
            ++i;
            j++;
            int m = i + j;
        ```
- 线性阶O(n)
    * 循环里面的代码会执行n遍
    * eg
        ```php
            for (i=1; i<=n; ++i) {
                j = i;
                j++;
            }
        ```
- 对数阶O(logN)
    * eg
        ```php
            int i = 1;
            while (i<n) {
                i = i * 2;
            }
        ```
- 线性对数阶O(nlogN)
    * eg
        ```php
            for (m=1; m<n; m++) {
                i = 1;
                while (i < n) {
                    i = i * 2;
                }
            }
        ```
- 平方阶O(n²)
    * eg
        ```php
            for (x=1; i<=n; x++) {
                for (i=1; i<=n; i++) {
                    j = i;
                    j++;
                }
            }
        ```
- 立方阶O(n³)
- K次方阶O(n^k)【n的k次方，符号不会敲】
- 指数阶(2^n)

#### 空间复杂度
    空间复杂度是对一个算法在运行过程中临时占用存储空间大小的一个量度
- O(1)
    * 如果算法执行所需要的临时空间不随着某个变量n的大小而变化，即此算法空间复杂度为一个常量，可表示为 O(1)
    * eg
        ```php
            int i = 1;
            int j = 2;
            ++i;
            j++;
            int m = i + j;
        ```
- O(n)
    * eg
        ```php
            int[] m = new int[n]
            for (i=1; i<=n; ++i) {
                j = i;
                j++;
            }
        ```







