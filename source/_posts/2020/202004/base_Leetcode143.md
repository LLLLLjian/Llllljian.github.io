---
title: Leetcode_基础 (143)
date: 2020-04-29
tags: Leetcode
toc: true
---

### 刷题之链表
    系统的过一遍,先看链表

<!-- more -->

#### 合并两个有序链表
    将两个升序链表合并为一个新的 升序 链表并返回.新链表是通过拼接给定的两个链表的所有节点组成的. 
    示例: 
    输入: 1->2->4, 1->3->4
    输出: 1->1->2->3->4->4
- A
    ```php
        /**
         * Definition for a singly-linked list.
         * class ListNode {
         *     public $val = 0;
         *     public $next = null;
         *     function __construct($val = 0, $next = null) {
         *         $this->val = $val;
         *         $this->next = $next;
         *     }
         * }
         */
        class Solution 
        {
            /**
             * @param ListNode $l1
             * @param ListNode $l2
             * @return ListNode
             */
            function mergeTwoLists($l1, $l2)
            {
                $tempHead = new ListNode();
                $temp = $tempHead;

                while (!empty($l1) && !empty($l2)) {
                    if ($l1->val > $l2->val) {
                        $temp->next = $l2;
                        $l2 = $l2->next;
                    } else {
                        $temp->next = $l1;
                        $l1 = $l1->next;
                    }
                    $temp = $temp->next;
                }

                if (!empty($l1)) {
                    $temp->next = $l1;
                }
                if (!empty($l2)) {
                    $temp->next = $l2;
                }
                return $tempHead->next;
            }

            function mergeTwoLists1($l1, $l2)
            {
                if (empty($l1)) {
                    return $l2;
                }
                if (empty($l2)) {
                    return $l1;
                }

                if ($l1->val < $l2->val) {
                    $l1->next = $this->mergeTwoLists1($l1->next, $l2);
                    return $l1;
                } else {
                    $l2->next = $this->mergeTwoLists1($l1, $l2->next);
                    return $l2;
                }
            }
        }
    ```

#### 合并多个有序链表
    已知K个已排序链表头节点指针, 将这K个链表合并, 合并后仍为有序的, 返回合并后的头节点
- A
    ```php
        // 解法一 暴力解法 性能却出奇地好.吊诡的是,这是所有解法中耗时最少的
        public function mergeKLists($lists)
        {
            // 1. 暴力解法
            // 时间复杂度, O(nlogn)
            // 空间复杂度 O(n)
            $n = count($lists);
            $arr = [];
            for ($i = 0; $i < $n; ++$i) {
                $list = $lists[$i];
                while ($list !== null) {
                    $arr[] = $list->val;
                    $list = $list->next;
                }
            }

            $dummyHead = new ListNode(0);
            $cur = $dummyHead;
            sort($arr);
            foreach ($arr as $v) {
                $cur->next = new ListNode($v);
                $cur = $cur->next;
            }

            return $dummyHead->next;
        }

        // 解法二 逐一比较 性能差
        public function mergeKLists($lists)
        {
            // 2. 逐一比较
            // 时间复杂度 O(kN)
            // 空间复杂度 O(N)
            $n = count($lists);
            foreach ($lists as $key => $list) {
                if ($list === null) {
                    unset($lists[$key]);
                }
            }

            $dummyHead = new ListNode(0);
            $cur = $dummyHead;
            while (!empty($lists)) {
                $min = PHP_INT_MAX;
                $minKey = -1;
                $offset = 0;
                foreach ($lists as $key => $list) {
                    if ($list->val < $min) {
                        $min = $list->val;
                        $minKey = $key;
                    }
                }

                $cur->next = new ListNode($min);
                $cur = $cur->next;
                $lists[$minKey + $offset] = $lists[$minKey + $offset]->next;
                if ($lists[$minKey + $offset] === null) {
                    unset($lists[$minKey + $offset]);
                }
            }

            return $dummyHead->next;
        }

        // 解法三 使用优先队列对解法二进行优化,性能不错
        public function mergeKLists($lists)
        {
            // 3. 使用优先队列
            // 时间复杂度, O(nlogk)
            // 空间复杂度 O(n)
            $n = count($lists);
            $pq = new SplPriorityQueue();
            foreach ($lists as $list) {
                while ($list !== null) {
                    // 优先队列默认是从大到小
                    $pq->insert($list->val, -$list->val);
                    $list = $list->next;
                }
            }

            $dummyHead = $cur = new ListNode(0);
            while (!$pq->isEmpty()) {
                $cur->next = new ListNode($pq->extract());
                $cur = $cur->next;
            }
            return $dummyHead->next;
        }
        
        // 辅助方法 合并两个有序链表
        private function mergeTwoLists($list1, $list2)
        {
            if ($list1 === null) return $list2;
            if ($list2 === null) return $list1;
            $dummyHead = $cur = new ListNode(0);
            while ($list1 !== null && $list2 !== null) {
                if ($list1->val < $list2->val) {
                    $cur->next = new ListNode($list1->val);
                    $list1 = $list1->next;
                } else {
                    $cur->next = new ListNode($list2->val);
                    $list2 = $list2->next;
                }
                $cur = $cur->next;
            }

            if ($list1 !== null) {
                $cur->next = $list1;
            } else {
                $cur->next = $list2;
            }
            return $dummyHead->next;
        }

        // 解法四 两两合并,把前 n - 1 个链表合并至第 n 个,超时未通过
        public function mergeKLists($lists)
        {
            // 4. 两两合并
            // 时间复杂度, O(kN)
            // 空间复杂度 O(1)
            $n = count($lists);
            for ($i = 0; $i < $n - 1; ++$i) {
                $lists[$n - 1] = $this->mergeTwoLists($lists[$i], $lists[$n - 1]);
            }

            return $lists[$n - 1];
        }
        // 解法五 优化解法四,分治
        public function mergeKLists($lists)
        {
            // 5. 两两合并 + 分治
            // 时间复杂度, O(kN)
            // 空间复杂度 O(1)
            $n = count($lists);
            // 不好理解,画图看
            $interval = 1;
            while ($interval < $n) {
                for ($i = 0; $i < $n; $i += $interval * 2) {
                    if (isset($lists[$i + $interval])) {
                        $lists[$i] = $this->mergeTwoLists($lists[$i], $lists[$i + $interval]);
                    }
                }
                $interval *= 2;
            }

            return $lists[0];
        }

        // 解法六 优化解法五 使用更好理解的递归
        public function mergeKLists($lists)
        {
            // 5. 两两合并 + 分治 + 递归
            // 时间复杂度, O(kN)
            // 空间复杂度 O(1)
            $n = count($lists);
            if ($n == 0) return null;
            if ($n == 1) return reset($lists);
            if ($n == 2) return $this->mergeTwoLists($lists[0], $lists[1]);
            return $this->merge1$lists, 0, $n - 1);
        }
        private function merge(&$lists, $left, $right)
        {
            if ($left == $right) return $lists[$left];

            $mid = $left + floor(($right - $left) / 2);
            $l1 = $this->merge1($lists, $left, $mid);
            $l2 = $this->merge1($lists, $mid + 1, $right);
            return $this->mergeTwoLists($l1, $l2);
        }
    ```

