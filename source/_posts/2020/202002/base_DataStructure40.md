---
title: DataStructure_基础 (40)
date: 2020-02-24
tags: DataStructure
toc: true
---

### 树
    树还挺关键的 需要再了解一下

<!-- more -->

#### 总结
> 话不多说, 先来个总结
- 数组
    * 数组的下标寻址十分迅速, 但计算机的内存是有限的, 故数组的长度也是有限的, 实际应用当中的数据往往十分庞大；而且无序数组的查找最坏情况需要遍历整个数组；后来人们提出了二分查找, 二分查找要求数组的构造一定有序, 二分法查找解决了普通数组查找复杂度过高的问题.任和一种数组无法解决的问题就是插入、删除操作比较复杂, 因此, 在一个增删查改比较频繁的数据结构中, 数组不会被优先考虑
- 普通链表
    * 普通链表由于它的结构特点被证明根本不适合进行查找
- 哈希表
    * 哈希表是数组和链表的折中, 同时它的设计依赖散列函数的设计, 数组不能无限长、链表也不适合查找, 所以也适合大规模的查找
- 二叉查找树
    * 二叉查找树因为可能退化成链表, 同样不适合进行查找
- AVL树
    * AVL树是为了解决可能退化成链表问题, 但是AVL树的旋转过程非常麻烦, 因此插入和删除很慢, 也就是构建AVL树比较麻烦
- 红黑树
    * 红黑树是平衡二叉树和AVL树的折中, 因此是比较合适的.集合类中的Map、关联数组具有较高的查询效率, 它们的底层实现就是红黑树.
- 多路查找树
    * 多路查找树是大规模数据存储中, 实现索引查询这样一个实际背景下, 树节点存储的元素数量是有限的(如果元素数量非常多的话, 查找就退化成节点内部的线性查找了), 这样导致二叉查找树结构由于树的深度过大而造成磁盘I/O读写过于频繁, 进而导致查询效率低下.
- B树
    * B树与自平衡二叉查找树不同, B树适用于读写相对大的数据块的存储系统, 例如磁盘.它的应用是文件系统及部分非关系型数据库索引.
- B+树
    * B+树在B树基础上, 为叶子结点增加链表指针(B树+叶子有序链表), 所有关键字都在叶子结点 中出现, 非叶子结点作为叶子结点的索引；B+树总是到叶子结点才命中.通常用于关系型数据库(如Mysql)和操作系统的文件系统中.

#### 相关题目
- 前序遍历: 根左右
- 中序遍历: 左根右
- 后序遍历: 左右根
- leetcode100
    * 相同的树
    ```php
        public boolean isSameTree(TreeNode p, TreeNode q) 
        {
            if (p == null && q == null) return true; // 递归到最后二者都是null 说明相同
            if (p == null || q == null) return false; // 递归到其中有一方为空, 则不相同
            if (p.val != q.val) return false; // 值不相等
            return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
        }
    ```
- leetcode101
    * 对称二叉树
    ```php
        class Solution 
        {
            public boolean isSymmetric(TreeNode root) 
            {
                return isSym(root, root);
            }
            private boolean isSym(TreeNode root, TreeNode root1) 
            {
                if(root == null && root1 == null) return true;
                if(root == null || root1 == null) return false;
                if(root.val != root1.val) return false;
                return isSym(root.left, root1.right) && isSym(root.right, root1.left);
            }
        }
    ```
- leetcode104
    * 二叉树的最大深度
    ```php
        class Solution 
        {
            public int maxDepth(TreeNode root)
            {
                return root == null ? 0 : Math.max(maxDepth(root.left), maxDepth(root.right)) + 1;
            }
        }
    ```




