---
title: 读书笔记 (26)
date: 2022-05-08
tags: Book
toc: true
---

### 还是要多读书鸭
    labuladong的算法小抄-BFS

<!-- more -->

#### BFS
> 核心思想应该不难理解的,就是把一些问题抽象成图,从一个点开 始,向四周开始扩散.一般来说,我们写 BFS 算法都是用「队列」这种数 据结构,每次将一个节点周围的所有节点加入队列.
- 算法框架
    * 问题的本质就 是让你在一幅「图」中找到从起点 start 到终点 target 的最近距离
- 模板
    ```
        // 计算从起点 start 到终点 target 的最近距离 
        int BFS(Node start, Node target) {
            Queue<Node> q; // 核心数据结构 
            Set<Node> visited; // 避免走回头路
            
            q.offer(start); // 将起点加入队列
            visited.add(start);
            int step = 0; // 记录扩散的步数

            while (q not empty) {
                int sz = q.size();
                /* 将当前队列中的所有节点向四周扩散 */
                for (int i = 0; i < sz; i++) {
                    Node cur = q.poll();
                    /* 划重点:这里判断是否到达终点 */
                    if (cur is target)
                        return step;
                    /* 将 cur 的相邻节点加入队列 */
                    for (Node x : cur.adj())
                        if (x not in visited) {
                            q.offer(x);
                            visited.add(x);
                        }
                }
                /* 划重点:更新步数在这里 */
                step++;
            }
        }
    ```

#### 二叉树的最小高度
- 问题描述
    * 给定一个二叉树,找出其最小深度.最小深度是从根节点到最近叶子节点的最短路径上的节点数量.说明：叶子节点是指没有子节点的节点.
- 思路
    * 直接套模板, 终点条件是左右节点都为空
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def minDepth(self, root: TreeNode) -> int:
                res = 0
                if not root:
                    return res
                queue = []
                queue.append(root)
                res += 1
                while queue:
                    length = len(queue)
                    for i in range(length):
                        temp = queue.pop(0)
                        if (not temp.left) and (not temp.right):
                            return res
                        if temp.left:
                            queue.append(temp.left)
                        if temp.right:
                            queue.append(temp.right)
                    res += 1
                return res
    ```

#### 二叉树的全路径
> 做这个题的时候 我就想到了二叉树的全路径, 发现自己也不太会做, 记录一下
- 问题描述
    * 给你一个二叉树的根节点 root ,按 任意顺序 ,返回所有从根节点到叶子节点的路径.叶子节点 是指没有子节点的节点.
- 思路
    * 最直观的方法是使用深度优先搜索.在深度优先搜索遍历二叉树时,我们需要考虑当前的节点以及它的孩子节点.
    * 如果当前节点不是叶子节点,则在当前的路径末尾添加该节点,并继续递归遍历该节点的每一个孩子节点.
    * 如果当前节点是叶子节点,则在当前路径末尾添加该节点后我们就得到了一条从根节点到叶子节点的路径,将该路径加入到答案即可
- 代码实现
    ```python
        # Definition for a binary tree node.
        # class TreeNode:
        #     def __init__(self, val=0, left=None, right=None):
        #         self.val = val
        #         self.left = left
        #         self.right = right
        class Solution:
            def binaryTreePaths(self, root):
                """
                :type root: TreeNode
                :rtype: List[str]
                """
                def construct_paths(root, path):
                    if root:
                        path += str(root.val)
                        if not root.left and not root.right:  # 当前节点是叶子节点
                            paths.append(path)  # 把路径加入到答案中
                        else:
                            path += '->'  # 当前节点不是叶子节点,继续递归遍历
                            construct_paths(root.left, path)
                            construct_paths(root.right, path)
                paths = []
                construct_paths(root, '')
                return paths
    ```

#### 
- 问题描述
    * 你有一个带有四个圆形拨轮的转盘锁.每个拨轮都有10个数字： '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' .每个拨轮可以自由旋转：例如把 '9' 变为 '0','0' 变为 '9' .每次旋转都只能旋转一个拨轮的一位数字.锁的初始数字为 '0000' ,一个代表四个拨轮的数字的字符串.列表 deadends 包含了一组死亡数字,一旦拨轮的数字和列表里的任何一个元素相同,这个锁将会被永久锁定,无法再被旋转.字符串 target 代表可以解锁的数字,你需要给出解锁需要的最小旋转次数,如果无论如何不能解锁,返回 -1 
- 思路
    * 先求出来所有的可能的密码组合, 然后再过滤
    * 0000 转动一次的结果有 0001 0010 0100 1000 0009 0090 0900 9000
    * 所以就是每个数字加1/减1
- 代码实现1
    ```python
        def plusOne(res, i):
            if res[i] == 9:
                res[i] == 0
            else:
                res[i] += 1
            return res
        def minusOne(res, i):
            if res[i] == 0:
                res[i] == 9
            else:
                res[i] -= 1
            return res

        def bfs():
            base = "0000"
            base_list = list(base)
            queue = []
            queue.append(base_list)
            while queue:
                length = len(queue)
                for i in range(length):
                    temp = queue.pop(0)
                    for i in range(4):
                        up = plusOne(temp, i)
                        down = minusOne(temp, i)
                        queue.append(up)
                        queue.append(down)
    ```
- 代码实现1问题
    * 没有去重, 因为 0000 的下一个是 0001, 0001的下一个还会有0000, 所以我们要把重复的去掉
    * 没有过滤掉死亡锁
- 代码实现2
    ```python
        class Solution:
            def openLock(self, deadends: List[str], target: str) -> int:
                ''' BFS可解 密码锁可以看作是一层一层的:穷举可能的密码组合时 每一位每次有2种(上拨、下拨) 每一层就是2*4=8种 '''
                def upone(s,i) -> str:
                    # 上拨s的第i位数字
                    l = list(s)
                    if l[i] == '9':
                        l[i] = '0'
                    else:
                        l[i] = str(int(l[i])+1)
                    return ''.join(l)
                def downone(s,i) -> str:
                    # 下拨s的第i位数字
                    l = list(s)
                    if l[i] == '0':
                        l[i] = '9'
                    else:
                        l[i] = str(int(l[i])-1)
                    return ''.join(l)
                def bfs(deadends,target) -> int:
                    # 如果target是'0000'则不需要拨动 返回0
                    if target == '0000':
                        return 0
                    step = 0 # 拨动次数 初始时没拨所以次数为0
                    q = collections.deque()
                    visited = set() # 存放已经比较过的字符组合、死亡数字组合 避免死循环
                    visited.update(deadends) # 初始化为死亡数字组合
                    q.append('0000')
                    while q:
                        length = len(q) # 按层处理队列中的字符串
                        for i in range(length):
                            cur = q.popleft() # 当前处理的节点
                            if cur in visited: # 当前节点已经处理过或属于死亡数字组合 所以跳过
                                continue
                            else:
                                visited.add(cur) # 首次比较 加入已经处理的集合
                            # 判断是否满足终止条件
                            if cur == target:
                                return step
                            # 不满足终止条件将所有相邻的节点加入队列
                            for j in range(4): # cur的每位数都可以上拨或下拨 这些都是cur的相邻节点
                                up = upone(cur,j)
                                # 需要判断上拨、下拨后的组合是否合法(在不在visited里) 不合法就跳过
                                if up not in visited:
                                    q.append(up)
                                down = downone(cur,j)
                                if down not in visited:
                                    q.append(down)
                        # 每循环一遍是一次拨动 次数要+1
                        step += 1
                    # 所有可能都穷举后无法达到target说明不能解锁 返回-1
                    return -1
                return bfs(deadends,target)
    ```


