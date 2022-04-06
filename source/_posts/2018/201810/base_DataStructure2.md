---
title: DataStructure_基础 (2)
date: 2018-10-16
tags: DataStructure
toc: true
---

### 数据结构--栈
    栈(Stack)是限制在表的一端进行插入和删除运算的线性表,通常称插入、删除的这一端为栈顶(Top),另一端为栈底(Bottom)

<!-- more -->

#### 特性
    后进先出
    栈又称为LIFO线性表[Last In First Out]

#### 基本运算
    构造空栈 : InitStack(S)
    判栈空 : StackEmpty(S)
    判栈满 : StackFull(S)
    进栈 : Push(S,x)、可形象地理解为压入,这时栈中会多一个元素
    退栈 : Pop(S) 、 可形象地理解为弹出,弹出后栈中就无此元素了
    取栈顶元素 : StackTop(S),不同与弹出,只是使用栈顶元素的值,该元素仍在栈顶不会改变

#### 汉诺塔问题
    ```php
        q : 汉诺塔问题是一个经典的问题.汉诺塔(Hanoi Tower),又称河内塔,源于印度一个古老传说.大梵天创造世界的时候做了三根金刚石柱子,在一根柱子上从下往上按照大小顺序摞着64片黄金圆盘.大梵天命令婆罗门把圆盘从下面开始按大小顺序重新摆放在另一根柱子上.并且规定,任何时候,在小圆盘上都不能放大圆盘,且在三根柱子之间一次只能移动一个圆盘.问应该如何操作？[假设有64个盘子]

        a : 
        s   =>  A [1-64] B 0 C 0 
        ....
        t   =>  A [64] B[1-63] C 0
        t+1 =>  A 0 B[1-63] C [64]
        ....
        e   =>  A 0 B 0 C [1-64]

        1. 先假设除最下面的盘子之外,我们已经成功地将上面的63个盘子移到了b柱,此时只要将最下面的盘子由a移动到c即可
        2. 先将上面的62个盘子由b移到a,再将最下面的盘子移到c
        ....

        1个盘子    =>  移动1次
        2个盘子    =>  移动3次
        3个盘子    =>  移动7次
        n个盘子    =>  移动2的n次-1次

        function hanuota($n,$a,$b,$c)
        {
            global $step;
            if ($n==1) {
                $step++;
                echo "将圆盘 $n 从 $a 柱子 到 $b 柱子 <br />";
            } else {
                hanuota($n-1, $a, $c, $b);
                $step++;
                echo "将圆盘 $n 从 $a 柱子 到 $b 柱子 <br />";
                hanuota($n-1, $c, $b, $a);
            }
        }
        //移动的次数
        $step = 0;
        hanuota(2, 'A', 'B', 'C');
        echo "移动次数: " . $step;
        echo "移动次数: " . getCount(2);

        function getCount($num)
        {
            if (is_numeric($num)) {
                return pow(2, $num) - 1;
            } else {
                return "";
            }
        }

        将圆盘 1 从 A 柱子 到 C 柱子 
        将圆盘 2 从 A 柱子 到 B 柱子 
        将圆盘 1 从 C 柱子 到 B 柱子 
        移动次数: 3
        移动次数: 3
    ```

