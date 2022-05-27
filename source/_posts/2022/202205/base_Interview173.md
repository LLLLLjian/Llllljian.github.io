---
title: Interview_总结 (173)
date: 2022-05-20
tags: Interview
toc: true
---

### 面试题
    别看了 这就是你的题

<!-- more -->

#### 丑数
- 问题描述
    * 我们把只包含质因子 2、3 和 5 的数称作丑数(Ugly Number).求按从小到大的顺序的第 n 个丑数.
- 思路
    * 可以理解为同一起跑线, 分别走2,3,5步, 谁走的最慢, 谁下一次再走
- 代码实现
    ```python
        class Solution:
            def nthUglyNumber(self, n: int) -> int:
                dp, a, b, c = [1] * n, 0, 0, 0
                for i in range(1, n):
                    n2, n3, n5 = dp[a] * 2, dp[b] * 3, dp[c] * 5
                    dp[i] = min(n2, n3, n5)
                    if dp[i] == n2: a += 1
                    if dp[i] == n3: b += 1
                    if dp[i] == n5: c += 1
                return dp[-1]
    ```

#### n个骰子的点数
- 问题描述
    * 把n个骰子扔在地上,所有骰子朝上一面的点数之和为s.输入n,打印出s的所有可能的值出现的概率.你需要用一个浮点数数组返回答案,其中第 i 个元素代表这 n 个骰子所能掷出的点数集合中第 i 小的那个的概率.
- 思路
    ![正向递推](/img/20220520_1.png)
    * 理解这个图很关键
    * 以2个骰子为例
    * 和为2的概率有1个, 1/6*1/6
    * 和为3的概率有2个, 1/6\*1/6+1/6\*1/6
    * [3] = [1, 2] + [2, 1]
    * [4] = [1, 3] + [2, 2] + [3, 1] 
- 代码实现
    ```python
        class Solution:
            def dicesProbability(self, n: int) -> List[float]:
                dp = [1 / 6] * 6
                for i in range(2, n + 1):
                    # n 个骰子「点数和」的范围为 [n, 6n][n,6n] ,数量为 6n - n + 1 = 5n + 16n−n+1=5n+1 种
                    tmp = [0] * (5 * i + 1)
                    for j in range(len(dp)):
                        for k in range(6):
                            # 假设有两个骰子A、B,这两个骰子相互独立.
                            # 在仅有一个骰子A的情况下,6个点出现的概率都为1/6, 同时A的每个点搭配B的每个点的概率也是相同的,所以骰子A为1会分别乘6个1/6去搭配骰子B的1~6, 即这种搭配2~7的概率分别都为1/36; 骰子A的2也会分别去乘6个1/6去搭配骰子B的1~6, 即这种搭配3~8的概率也分别为1/36, 以此类推.
                            tmp[j + k] = tmp[j + k] + dp[j] / 6
                    dp = tmp
                return dp
    ```

#### 重建二叉树
- 问题描述
    * 输入某二叉树的前序遍历和中序遍历的结果,请构建该二叉树并返回其根节点.
- 思路
    * 前序遍历的第一个数字x是跟节点, 然后根据x在中序遍历的位置找到左子树和右子树
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, x):
        #         self.val = x
        #         self.left = None
        #         self.right = None

        class Solution:
            def buildTree(self, preorder: List[int], inorder: List[int]) -> TreeNode:
                def recur(root, left, right):
                    if left > right: return                               # 递归终止
                    node = TreeNode(preorder[root])                       # 建立根节点
                    i = dic[preorder[root]]                               # 划分根节点、左子树、右子树
                    node.left = recur(root + 1, left, i - 1)              # 开启左子树递归
                    node.right = recur(i - left + root + 1, i + 1, right) # 开启右子树递归
                    return node                                           # 回溯返回根节点

                dic, preorder = {}, preorder
                for i in range(len(inorder)):
                    dic[inorder[i]] = i
                return recur(0, 0, len(inorder) - 1)
    ```

#### 二叉搜索树的后序遍历序列
- 问题描述
    * 输入一个整数数组,判断该数组是不是某二叉搜索树的后序遍历结果.如果是则返回 true,否则返回 false.假设输入的数组的任意两个数字都互不相同.
- 思路
    * 后序遍历倒序： [ 根节点 | 右子树 | 左子树 ] .类似 先序遍历的镜像 ,即先序遍历为 “根、左、右” 的顺序,而后序遍历的倒序为 “根、右、左” 顺序.
    * 倒序遍历所有节点,则第一个节点肯定是根节点,之后再先遍历的都是他右子树的节点,都比他大就压栈,之后再遍历就发现比当前节点小的就循环将栈顶出栈并赋值root节点,直到遇到最小的比它大的值就是它的根节点,而再继续遍历,那么遍历的就是当前这个根节点的左子树了,也就是说都比当前根节点要小,如果发现比当前根节点要大了,那么就是return false;当遍历结束没有返回false,就说明符合二叉搜索树
- 代码实现
    ```python
        class Solution:
            def verifyPostorder(self, postorder: [int]) -> bool:
                stack, root = [], float("+inf")
                for i in range(len(postorder) - 1, -1, -1):
                    if postorder[i] > root: return False
                    while(stack and postorder[i] < stack[-1]):
                        root = stack.pop()
                    stack.append(postorder[i])
                return True

            def verifyPostorder(self, postorder: List[int]) -> bool:
                if not postorder: return True
                root = postorder[-1]
                cur_index = 0
                for i in range(len(postorder)):
                    if postorder[i] >= root:
                        cur_index = i
                        break
                left = postorder[:cur_index]
                right = postorder[cur_index : -1]
                for val in right:
                    if val < root:
                        return False
                return self.verifyPostorder(left) and self.verifyPostorder(right)
    ```

