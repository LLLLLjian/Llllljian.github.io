---
title: Interview_总结 (74)
date: 2020-03-13
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-树的深度遍历

<!-- more -->

#### 树的深度遍历
- 先来个树
![很普通的一个树](/img/20200313_1.jpeg)
- 前序遍历
    * 根左右213
    * 前序结果 : ABDECF
    ```php
        function qianxu($root)
        {
            if (!empty($root)) {
                echo $root->val;
                qianxu($root->left);
                qianxu($root->right);
            }
        }
    ```
- 中序遍历
    * 左根右123
    * 中序结果 : DBEAFC
    ```php
        function zhongxu($root)
        {
            if (!empty($root)) {
                zhongxu($root->left);
                echo $root->val;
                zhongxu($root->right);
            }
        }
    ```
- 后序遍历
    * 左右根132
    * 后序结果 : DEBFCA
    ```php
        function houxu($root)
        {
            if (!empty($root)) {
                houxu($root->left);
                houxu($root->right);
                echo $root->val;
            }
        }
    ```










