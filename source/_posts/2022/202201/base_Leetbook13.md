---
title: Leetbook_基础 (13)
date: 2022-01-25
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-二叉树

<!-- more -->

#### 树的遍历
> 树的遍历可以理解为 根所在的位置.前序遍历: 根左右; 中序遍历: 左根右; 后序遍历: 左右根
1. 前序遍历
    ![前序遍历](/img/20220125_1.png)
2. 中序遍历
    ![中序遍历](/img/20220125_2.png)
3. 后序遍历
    ![后序遍历](/img/20220125_3.png)

#### 二叉树的前序遍历
- Q
    * 返回所给树的前序遍历
- T
    * 根左右
- A
    ```python
        class Solution:
            def preorderTraversal(self, root: TreeNode) -> List[int]:
                """
                递归
                """
                def preorder(root: TreeNode):
                    if not root:
                        return
                    res.append(root.val)
                    preorder(root.left)
                    preorder(root.right)
                
                res = list()
                preorder(root)
                return res

            def preorderTraversal(self, root: TreeNode) -> List[int]:
                """
                迭代
                """
                res = list()
                if not root:
                    return res
                
                stack = []
                node = root
                while stack or node:
                    while node:
                        res.append(node.val)
                        stack.append(node)
                        node = node.left
                    node = stack.pop()
                    node = node.right
                return res
    ```

#### 二叉树的中序遍历
- Q
    * 返回所给树的中序遍历
- T
    * 左根右
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
                def preorder(root):
                    if root:
                        pass
                    else:
                        return
                    preorder(root.left)
                    res.append(root.val)
                    preorder(root.right)
                res = []
                preorder(root)
                return res
    ```

#### 二叉树的后序遍历
- Q
    * 返回所给树的后序遍历
- T
    * 左右根
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def postorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
                def preorder(root):
                    if root:
                        pass
                    else:
                        return
                    preorder(root.left)
                    preorder(root.right)
                    res.append(root.val)
                res = []
                preorder(root)
                return res
    ```
