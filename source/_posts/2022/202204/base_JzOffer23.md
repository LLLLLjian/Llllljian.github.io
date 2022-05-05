---
title: 剑指Offer_基础 (23)
date: 2022-04-07
tags: 剑指Offer
toc: true
---

### 剑指Offer
    剑指Offer 读后感

<!-- more -->

#### 树中两个节点的最低公共祖先
- 题目描述
    * 给定一个二叉搜索树,输入两个节点,求树中两个节点的最低公共祖先
- 思路
    * 从根节点开始遍历树,如果节点 p 和 q 都在右子树上,那么以右孩子为根节点递归,如果节点 p 和节点 q 都在左子树上,那么以左孩子为根节点递归,否则 就意味找到节 p 和节点 q 的最低公共祖先了.
- 代码实现
    ```python
        class Solution:
            def lowestCommonAncestor(self, root: TreeNode, p: TreeNode, q: TreeNode) -> TreeNode:
                if (root == None) or (p == None) or (q == None):
                    return None
                rootValue = root.val
                pValue = p.val
                qValue = q.val
                if (pValue > rootValue) and (qValue > rootValue):
                    return self.lowestCommonAncestor(root.right, p, q)
                elif (pValue < rootValue) and (qValue < rootValue):
                    return self.lowestCommonAncestor(root.left, p, q)
                else:
                    return root
    ```

#### 二叉树的最近公共祖先
- 题目描述
    * 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先.
    * 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q,最近公共祖先表示为一个结点 x,满足 x 是 p、q 的祖先且 x 的深度尽可能大(一个节点也可以是它自己的祖先)
- 思路
    * 
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def lowestCommonAncestor(self, root: TreeNode, p: TreeNode, q: TreeNode) -> TreeNode:
                # 判断当前(树)节点是否为最近公共祖先
                if (root == None) or (p == root) or (q == root):
                    return root
                # 在左子树中寻找最近公共节点
                left = self.lowestCommonAncestor(root.left, p, q)
                # 在右子树中寻找最近公共节点
                right = self.lowestCommonAncestor(root.right, p, q)
                # 左右子树都找到了公共节点,只能是根节点(因为左右子树交集只有根节点)
                if (left != None) and (right != None):
                    return root
                elif (left != None):
                    # 在左子树找到了公共节点,返回公共节点
                    return left
                elif (right != None):
                    # 在右子树找到了公共节点,返回公共节点
                    return right
                else:
                    # 左右两边都没找到公共节点,说明没有公共祖先
                    return None
    ```

#### 找出重复的数
- 题目描述
    * 题目描述:在一个长度为 n 的数组里的所有数字都在 0 到 n-1 的范围内,找出数组中任意一个重复的数字
- 思路
    * 遍历数组 nums ,设索引初始值为 i = 0
    * 若 nums[i]=i ： 说明此数字已在对应索引位置,无需交换,因此跳过；
    * 若 nums[nums[i]]=nums[i] ： 代表索引 nums[i] 处和索引 i 处的元素值都为 nums[i] ,即找到一组重复值,返回此值 nums[i] ；
    * 否则： 交换索引为 i 和 nums[i] 的元素值,将此数字交换至对应索引位置.
    * 若遍历完毕尚未返回,则返回 -1 .
- 代码实现
    ```python
        class Solution:
            def findRepeatNumber(self, nums: List[int]) -> int:
                N = len(nums)
                for i in range(N):
                    while nums[i] != i:         # 发现这个坑里的萝卜不是自己家的
                        temp = nums[i]          # 看看你是哪家的萝卜
                        if nums[temp] == temp:  # 看看你家里有没有和你一样的萝卜
                            return temp         # 发现你家里有了和你一样的萝卜,那你就多余了,上交国家
                        else:                   # 你家里那个萝卜和你不一样
                            nums[temp], nums[i] = nums[i], nums[temp]   # 把你送回你家去,然后把你家里的那个萝卜拿回来
    ```



