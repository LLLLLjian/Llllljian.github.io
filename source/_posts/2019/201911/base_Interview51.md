---
title: Interview_总结 (51)
date: 2019-11-06
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * 扑克牌是否连续问题PHP版
- A
    ```php
        /**
         * 解题思路
         * 既然是顺子,那么肯定没有对子, 
         * 并且, 最大值和最小值的差值为数组长度减1
         **/
        function eatDuck(array $arr)
        {
            $count = count($arr);
            if (count(array_unique($arr)) != $count) {
                return false;//对子
            }
            if (max($arr) - min($arr) != $count - 1) {
                return false;
            }
            return true;
        }

        var_dump(eatDuck([1, 3, 5, 2, 4]));
        var_dump(eatDuck([10, 13, 11, 12, 14]));
        var_dump(eatDuck([1, 3, 5, 7, 9]));
    ```

#### 问题2
- Q
    * MySQL如何高效率随机获取N条数据
- A
    ```sql
        # 假设表叫做mm_account.
        
        # ID连续的情况下(注意不能带where, 否则结果不好): 
        SELECT *
        FROM `mm_account` AS t1 
        JOIN (SELECT ROUND(RAND() * (SELECT MAX(id) FROM `mm_account`)) AS id) AS t2
        WHERE t1.id >= t2.id
        ORDER BY t1.id ASC LIMIT 4;
        
        # ID不连续的情况下: 
        SELECT * FROM `mm_account` 
        WHERE id >= (SELECT floor(RAND() * (SELECT MAX(id) FROM `mm_account`)))  and city="city_91" and showSex=1
        ORDER BY id LIMIT 4;
        
        # 如果有一个字段叫id, 最快的方法如下(随机获取5条): 
        SELECT * FROM mm_account 
        WHERE id >= ((SELECT MAX(id) FROM mm_account)-(SELECT MIN(id) FROM mm_account)) * RAND() + (SELECT MIN(id) FROM mm_account)
        limit 5;
        
        # 如果带where语句, 上面就不适合了, 带where语句请看下面: 
        SELECT *
        FROM `mm_account` AS t1 JOIN (SELECT ROUND(RAND() * (
        (SELECT MAX(id) FROM `mm_account` where id<1000 )-(SELECT MIN(id) FROM `mm_account` where id<1000 ))+(SELECT MIN(id) FROM `mm_account` where id<1000 )) AS id) AS t2
        WHERE t1.id >= t2.id
        ORDER BY t1.id LIMIT 5;
    ```

#### 问题3
- Q
    * Nginx访问日志分析请求时间最大的和请求数最多的前20条
- A
    ```bash
        cat /usr/local/var/log/nginx/access.log|sort -nrk9|head -2

        grep "07/May/2018:10:" /usr/local/var/log/nginx/access.log|awk '{print $12}'|sort -rn|uniq -c|head -20
    ```

#### 问题4
- Q
    * PHP前序、中序、后序遍历二叉树
- A
    ```php
        <?php
        class Node
        {
            public $data = null;
            public $left = null;
            public $right = null;
        }

        $A = new Node();
        $B = clone $A;
        $C = clone $A;
        $D = clone $A;
        $E = clone $A;
        $F = clone $A;
        $G = clone $A;
        $H = clone $A;
        $I = clone $A;


        $A->data = 'A';
        $B->data = 'B';
        $C->data = 'C';
        $D->data = 'D';
        $E->data = 'E';
        $F->data = 'F';
        $G->data = 'G';
        $H->data = 'H';
        $I->data = 'I';


        $A->left = $B;
        $A->right = $C;
        $B->left = $D;
        $B->right = $E;
        $E->left = $G;
        $E->right = $H;
        $G->right = $I;
        $C->right = $F;

        /**
        * 前序遍历: 中左右
        * 中序遍历: 左中右
        * 后序遍历: 左右中
        */
        function eatBtree($node)
        {
            if ($node && $node->data) {
                eatBtree($node->left);
                eatBtree($node->right);
                echo $node->data;           //把这一行的位置换一换就能实现遍历方式的转变,放到最后是后序,放到最前是前序,放到中间是中序
            }
        }

        eatBtree($A);

        /**
        * 层序遍历会用到队列
        */
        function eatBtree2($node)
        {
            $list[] = $node;
            while (count($list) > 0) {
                $cur = array_shift($list);
                if ($cur) {
                    echo $cur->data;

                    if ($cur->left) {
                        $list[] = $cur->left;
                    }

                    if ($cur->right) {
                        $list[] = $cur->right;
                    }
                }
            }
        }

        eatBtree2($A);
    ```
