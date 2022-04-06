---
title: Leetcode_基础 (161)
date: 2020-06-24
tags: Leetcode
toc: true
---

### 面试题
    今天被问傻系列-重温树

<!-- more -->

#### 树树树树
- 二叉查找树
    * 二叉查找树的特点就是任何节点的左子节点的键值都小于当前节点的键值, 右子节点的键值都大于当前节点的键值
    * 二叉树的查找过程(查找ID=12的用户)
        * 只需要3次查找
        * 将根节点作为当前节点, 把 12 与当前节点的键值 10 比较, 12 大于 10, 接下来我们把当前节点>的右子节点作为当前节点.
        * 继续把 12 和当前节点的键值 13 比较, 发现 12 小于 13, 把当前节点的左子节点作为当前节点.
        * 把 12 和当前节点的键值 12 对比, 12 等于 12, 满足条件, 我们从当前节点中取出 data, 即 id=12, name=xm.
![二叉查找树](/img/20200320_1.jpg)
- 平衡二叉树
    * 在满足二叉查找树特性的基础上, 要求每个节点的左右子树的高度差不能超过 1
![平衡二叉树](/img/20200320_2.jpg)
- B树
    * 单个节点可以存储多个键值和数据的平衡树, 可以更矮胖, 减少磁盘IO
![B树](/img/20200320_3.jpg)
- B+树
    * B+树非叶子节点上是不存储数据的, 仅存储键值, 而 B 树节点中不仅存储键值, 也会存储数据
    * B+树索引的所有数据均存储在叶子节点, 而且数据是按照顺序排列的
![B+树](/img/20200320_4.jpg)

#### 二叉搜索树中的插入操作
- 问题描述
    * 给定二叉搜索树(BST)的根节点和要插入树中的值, 将值插入二叉搜索树. 返回插入后二叉搜索树的根节点. 保证原始二叉搜索树中不存在新值.
- 解题思路
    * 递归开始操作, 如果传入值大于跟节点的值, 那么将左节点及传入值继续传入,  否则操作右节点
    ```php
        /**
         * Definition for a binary tree node.
         * class TreeNode {
         *     public $val = null;
         *     public $left = null;
         *     public $right = null;
         *     function __construct($val = 0, $left = null, $right = null) {
         *         $this->val = $val;
         *         $this->left = $left;
         *         $this->right = $right;
         *     }
         * }
         */
        class Solution 
        {
            /**
             * @param TreeNode $root
             * @param Integer $val
             * @return TreeNode
             */
            function insertIntoBST($root, $val) 
            {
                if (!empty($root)) {
                    if ($root->val > $val) {
                        $root->left = $this->insertIntoBST($root->left, $val);
                    } else {
                        $root->right = $this->insertIntoBST($root->right, $val);
                    }
                } else {
                    $root = new TreeNode($val);
                }

                return $root;
            }
        }
    ```

#### 二叉搜索树中的删除操作
- 问题描述
    * 给定一个二叉搜索树的根节点 root 和一个值 key, 删除二叉搜索树中的 key 对应的节点, 并保证二叉搜索树的性质不变.返回二叉搜索树(有可能被更新)的根节点的引用
- 解题思路
    * 相等: 要删除的节点就是当前根节点, 即递归退出条件
    * key更大: 则要递归朝右子树去删除
    * key更小: 则要递归朝左子树去删除
    * 找到要删除后的节点会出现四种情况: 
        1. 待删除的节点左右子树均为空.证明是叶子节点, 直接删除即可, 即将该节点置为null
        2. 待删除的节点左子树为空, 让待删除节点的右子树替代自己.
        3. 待删除的节点右子树为空, 让待删除节点的左子树替代自己.
        4. 如果待删除的节点的左右子树都不为空.我们需要找到比当前节点小的最大节点(前驱)[或比当前节点大的最小节点(后继)], 来替换自己
    ```php
        /**
         * Definition for a binary tree node.
         * class TreeNode {
         *     public $val = null;
         *     public $left = null;
         *     public $right = null;
         *     function __construct($value) { $this->val = $value; }
         * }
         */
        class Solution 
        {
            /**
             * @param TreeNode $root
             * @param Integer $key
             * @return TreeNode
             */
            function deleteNode($root, $key) 
            {
                if (!empty($root)) {
                    if ($root->val >  $key) {
                        $root->left = $this->deleteNode($root->left, $key);
                        return $root;
                    }

                    if ($root->val <  $key) {
                        $root->right = $this->deleteNode($root->right, $key);
                        return $root;
                    }

                    if ($root->val ==  $key) {
                        if (empty($root->left) && empty($root->right)) {
                            // 没有左孩子 也没有右孩子
                            return null;
                        }

                        if (empty($root->left)) {
                            // 没有左孩子
                            return $root->right;
                        }

                        if (empty($root->right)) {
                            // 没有右孩子
                            return $root->left;
                        }

                        // 走到这里说明  有左孩子 也有右孩子
                        $last = $root->left;
                        while ($last->right) {
                            $last = $last->right;
                        }
                        // 最终的last就是比当前节点小的最大节点, 将值进行替换
                        $root->val = $last->val;
                        // 删除该最大节点
                        $root->left = $this->deleteNode($root->left, $last->val);
                        return $root;
                    }
                } else {
                    return null;
                }
            }
        }
    ```

#### 二叉搜索树中的查找操作
- 问题描述
    * 二叉搜索树的查找
- 解题思路
    * 递归 查询
    ```php
        /**
         * Definition for a binary tree node.
         * class TreeNode {
         *     public $val = null;
         *     public $left = null;
         *     public $right = null;
         *     function __construct($value) { $this->val = $value; }
         * }
         */
        class Solution 
        {
            /**
             * @param TreeNode $root
             * @param Integer $key
             * @return TreeNode
             */
            function searchNode($root, $key) 
            {
                if (!empty($root)) {
                    if ($root->val >  $key) {
                        return $this->searchNode($root->left, $key);
                    }

                    if ($root->val <  $key) {
                        return $this->searchNode($root->right, $key);
                    }

                    if ($root->val ==  $key) {
                        return true;
                    }
                } else {
                    return false;
                }
            }
        }
    ```

#### 二叉树的前序遍历

#### 二叉树的中序遍历

#### 二叉树的后序遍历
