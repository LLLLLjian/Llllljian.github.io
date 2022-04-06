---
title: Leetbook_基础 (14)
date: 2022-01-26
tags: Leetbook
toc: true
---

### 今日被问傻系列
    leetbook-二叉树

<!-- more -->

#### 层序遍历介绍
> 广度优先搜索

层序遍历就是逐层遍历树结构
广度优先搜索(BFS)是一种广泛运用在树或图这类数据结构中, 遍历或搜索的算法. 该算法从一个根节点开始, 首先访问节点本身. 然后遍历它的相邻节点, 其次遍历它的二级邻节点、三级邻节点, 以此类推.
当我们在树中进行广度优先搜索时, 我们访问的节点的顺序是按照层序遍历顺序的

![层序遍历](/img/20220126_1.png)

#### 二叉树的层序遍历
- Q
    ```
        给你二叉树的根节点 root , 返回其节点值的 层序遍历 . (即逐层地, 从左到右访问所有节点)
    ```
- T
    * 1
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def levelOrder(self,root):
                """
                :type root: TreeNode
                :rtype: List[List[int]]
                """
                # 存储每层的节点列表
                result = []
                # 辅助队列
                queue = [root]
                # 判断头节点是否为空
                if not root:
                    return result
                # 遍历队列
                while queue:
                    # root非空时,第一层的节点数为1
                    length = len(queue)
                    # 存储每层的节点
                    alist = []
                    # 进行n次循环,确保当前层的的节点全部出队列
                    for i in range(length):
                        node = queue.pop(0)
                        # 存储当前节点
                        alist.append(node.val)
                        # 把当前节点所有的左右节点全部加入队列,进而确保当前队列的len就是下一层的节点数
                        if node.left:
                            queue.append(node.left)
                        if node.right:
                            queue.append(node.right)
                    # 将每层的节点列表加入结果列表中
                    result.append(alist)
                # 返回结果
                return result

            def levelOrder1(self, root: TreeNode) -> List[List[int]]:
                if not root: return []
                #跟结点入queue
                queue = [root]
                res = []
                while queue:
                    res.append([node.val for node in queue])
                    #存储当前层的孩子节点列表
                    ll = []
                    #对当前层的每个节点遍历
                    for node in queue:
                        #如果左子节点存在, 入队列
                        if node.left:
                            ll.append(node.left)
                        #如果右子节点存在, 入队列
                        if node.right:
                            ll.append(node.right)
                    #后把queue更新成下一层的结点, 继续遍历下一层
                    queue = ll
                return res
    ```

#### 二叉树的层序遍历 II
- Q
    ```
        给你二叉树的根节点 root , 返回其节点值 自底向上的层序遍历 . (即按从叶子节点所在层到根节点所在的层, 逐层从左向右遍历)
    ```
- T
    * 和上题类似, 只是把输出结果反向输出
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def levelOrderBottom(self, root: TreeNode) -> List[List[int]]:
                res = []
                if not root:
                    return res
                q = []
                q.append(root)
                while q :
                    ll = []
                    res.append([node.val for node in q])
                    for node in q:
                        if node.left:
                            ll.append(node.left)
                        if node.right:
                            ll.append(node.right)
                    q = ll
                return res[::-1]
    ```

#### 二叉树的右视图
- Q
    ```
        给定一个二叉树的 根节点 root, 想象自己站在它的右侧, 按照从顶部到底部的顺序, 返回从右侧所能看到的节点值.
    ```
- T
    * 和上题类似, 但append的时候只用append最后一项即可
- A
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def rightSideView(self, root: TreeNode) -> List[int]:
                res = []
                if not root:
                    return res
                q = []
                q.append(root)
                while q:
                    res.append([node.val for node in q][-1])
                    tmp_list = []
                    for node in q:
                        if node.left:
                            tmp_list.append(node.left)
                        if node.right:
                            tmp_list.append(node.right)
                    q = tmp_list
                return res
    ```
