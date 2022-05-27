---
title: 读书笔记 (28)
date: 2022-05-11
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-二叉树

<!-- more -->

#### 二叉树解题思维模式
1. 是否可以通过遍历一遍二叉树得到答案？如果可以,用一个 traverse 函数配合外部变量来实现,这叫「遍历」的思维模式.
2. 是否可以定义一个递归函数,通过子问题(子树)的答案推导出原问题的答案？如果可以,写出这个递归函数的定义,并充分利用这个函数的返回值,这叫「分解问题」的思维模式.

#### 二叉树的重要性
- 快速排序≈前序遍历
    * 思想
        * 若要对 nums[lo..hi] 进行排序,我们先找一个分界点 p,通过交换元素使得 nums[lo..p-1] 都小于等于 nums[p],且 nums[p+1..hi] 都大于 nums[p],然后递归地去 nums[lo..p-1] 和 nums[p+1..hi] 中寻找新的分界点,最后整个数组就被排序了
    * 代码实现
        ```
            void sort(int[] nums, int lo, int hi) {
                /****** 前序遍历位置 ******/
                // 通过交换元素构建分界点 p
                int p = partition(nums, lo, hi);
                /************************/

                sort(nums, lo, p - 1);
                sort(nums, p + 1, hi);
            }
        ```
- 归并排序≈后序遍历
    * 思想
        * 若要对 nums[lo..hi] 进行排序,我们先对 nums[lo..mid] 排序,再对 nums[mid+1..hi] 排序,最后把这两个有序的子数组合并,整个数组就排好序了
    * 代码实现
        ```
            // 定义：排序 nums[lo..hi]
            void sort(int[] nums, int lo, int hi) {
                int mid = (lo + hi) / 2;
                // 排序 nums[lo..mid]
                sort(nums, lo, mid);
                // 排序 nums[mid+1..hi]
                sort(nums, mid + 1, hi);

                /****** 后序位置 ******/
                // 合并 nums[lo..mid] 和 nums[mid+1..hi]
                merge(nums, lo, mid, hi);
                /*********************/
            }
        ```

#### 深入理解前中后序
- 二叉树遍历框架
    ```
        void traverse(TreeNode root) {
            if (root == null) {
                return;
            }
            // 前序位置
            traverse(root.left);
            // 中序位置
            traverse(root.right);
            // 后序位置
        }
    ```
- 其它数据结构遍历框架
    ```
        /* 迭代遍历数组 */
        void traverse(int[] arr) {
            for (int i = 0; i < arr.length; i++) {

            }
        }

        /* 递归遍历数组 */
        void traverse(int[] arr, int i) {
            if (i == arr.length) {
                return;
            }
            // 前序位置
            traverse(arr, i + 1);
            // 后序位置
        }

        /* 迭代遍历单链表 */
        void traverse(ListNode head) {
            for (ListNode p = head; p != null; p = p.next) {

            }
        }

        /* 递归遍历单链表 */
        void traverse(ListNode head) {
            if (head == null) {
                return;
            }
            // 前序位置
            traverse(head.next);
            // 后序位置
        }
    ```
- 倒序打印一条单链表上所有节点的值
    ```
        /* 递归遍历单链表,倒序打印链表元素 */
        void traverse(ListNode head) {
            if (head == null) {
                return;
            }
            traverse(head.next);
            // 后序位置
            print(head.val);
        }
    ```
- 前序位置的代码在刚刚进入一个二叉树节点的时候执行
- 后序位置的代码在将要离开一个二叉树节点的时候执行
- 中序位置的代码在一个二叉树节点左子树都遍历完,即将开始遍历右子树的时候执行

#### 两种解题思路
- 遍历一遍二叉树得出答案(回溯算法核心框架)
- 通过分解问题计算出答案(动态规划核心框架)
- eg: 二叉树的最大深度
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def maxDepth(self, root: Optional[TreeNode]) -> int:
                """
                遍历一遍二叉树得出答案
                """
                self.res = 0
                self.depth = 0
                # 遍历二叉树
                def traverse(root):
                    if not root:
                        return
                    # 前序遍历位置
                    self.depth += 1
                    # 遍历的过程中记录最大深度
                    self.res = max(self.res, self.depth)
                    traverse(root.left)
                    traverse(root.right)
                    # 后序遍历位置
                    self.depth -= 1
                traverse(root)
                return self.res
        
        class Solution:
            def maxDepth(self, root: Optional[TreeNode]) -> int:
                """
                通过分解问题计算出答案
                """
                if not root:
                    return 0
                maxLeft = self.maxDepth(root.left)
                maxRight = self.maxDepth(root.right)
                return max(maxLeft, maxRight) + 1
    ```

#### 二叉树题目的通用思考过程
1. 是否可以通过遍历一遍二叉树得到答案？如果可以,用一个 traverse 函数配合外部变量来实现.
2. 是否可以定义一个递归函数,通过子问题(子树)的答案推导出原问题的答案？如果可以,写出这个递归函数的定义,并充分利用这个函数的返回值.
3. 无论使用哪一种思维模式,你都要明白二叉树的每一个节点需要做什么,需要在什么时候(前中后序)做.

#### 后序遍历
> 前序位置的代码只能从函数参数中获取父节点传递来的数据,而后序位置的代码不仅可以获取参数数据,还可以获取到子树通过函数返回值传递回来的数据
- 如果把根节点看做第 1 层,如何打印出每一个节点所在的层数
    ```python
        # 二叉树遍历函数
        def traverse(root, level):
            if not root:
                return
            # 前序位置
            print("节点 %s 在第 %s 层" % (root, level));
            traverse(root.left, level + 1);
            traverse(root.right, level + 1);
        }
        # 这样调用
        traverse(root, 1);
    ```
- 如何打印出每个节点的左右子树各有多少节点
    ```python
        # 定义：输入一棵二叉树,返回这棵二叉树的节点总数
        def count(root) {
            if not root:
                return 0
            leftCount = count(root.left)
            rightCount = count(root.right)
            # 后序位置
            print("节点 %s 的左子树有 %s 个节点,右子树有 %s 个节点" % (root, leftCount, rightCount))
            return leftCount + rightCount + 1
        }
    ```
- 二叉树的直径
    * 每一条二叉树的「直径」长度,就是一个节点的左右子树的最大深度之和
    * 代码实现
        ```python
            # Definition for a binary tree node.
            # class TreeNode:
            #     def __init__(self, val=0, left=None, right=None):
            #         self.val = val
            #         self.left = left
            #         self.right = right
            class Solution:
                def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
                    self.maxDiameter = 0
                    def traverse(node):
                        if not node:
                            return
                        # 对每个节点计算直径
                        maxLeft = maxDepth(node.left)
                        maxRight = maxDepth(node.right)
                        # 更新全局最大直径
                        self.maxDiameter = max(self.maxDiameter, maxLeft+maxRight)
                        traverse(node.left)
                        traverse(node.right)

                    def maxDepth(node):
                        if not node:
                            return 0
                        maxLeft = maxDepth(node.left)
                        maxRight = maxDepth(node.right)
                        return max(maxLeft, maxRight) + 1

                    traverse(root)
                    return self.maxDiameter
        ```
    * 优化1
        ```python
            # Definition for a binary tree node.
            # class TreeNode:
            #     def __init__(self, val=0, left=None, right=None):
            #         self.val = val
            #         self.left = left
            #         self.right = right
            class Solution:
                def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
                    self.maxDiameter = 0
                    def maxDepth(node):
                        if not node:
                            return 0
                        maxLeft = maxDepth(node.left)
                        maxRight = maxDepth(node.right)
                        self.maxDiameter = max(self.maxDiameter, maxLeft+maxRight)
                        return max(maxLeft, maxRight) + 1
                    maxDepth(root)
                    return self.maxDiameter
    ```

#### 层序遍历
- 思路
    * ![层序遍历](/img/20220511_1.png)
- 代码实现
    ```python
        def levelTraverse(root):
            if not root:
                return None
            res = []
            queue = []
            queue.append(root)
            while queue:
                length = len(queue)
                for i in range(length):
                    temp = queue.pop(0)
                    res.append(temp.val)
                    if temp.left:
                        queuq.append(temp.left)
                    if temp.right:
                        queuq.append(temp.right)
            return res
    ```

