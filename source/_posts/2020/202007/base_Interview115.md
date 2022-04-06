---
title: Interview_总结 (115)
date: 2020-07-27
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-你真的懂约瑟夫环了吗

<!-- more -->

#### 约瑟夫环
- 问题描述
    * n个人围成一个圈,指定一个数字m,从第一个人开始报数,每轮报到m的选手出局,由下一个人接着从头开始报,最后一个人是赢家.其中n>1,m>2
- 数组形式
    * init : 1   2   3   4   5   6   ...   n个人
    * 假设第一次杀掉的人是k, 那么可以推算出 k = m % n;
    * first:                k-2 k-1 [k] k+1 k+2 ... k-3 此时有n-1个人
    * 那么他们重新编号就是     n-2 n-1       1   2 ... n-3  那么此时杀掉的人是 m % (n-1), 他在0-n中的序号为(k+m)%n
    * 知道了怎么推出之前的下标,那么也就可以一步步递推回去得到开始的队列或者从小推到大得到最后剩余的结果
    * 原序列( sum ) 中第二次被扔入海中编号可以由新序列( sum - 1) 第一次扔海里的编号通过特定的逆推运算得出
    * (sum-2)环的第1次出环编号 >>>(sum-1)环的第2次出环编号 >>>(sum)环的第3次出环编号
    * 在以 k 为出环报数值的约瑟夫环中, n人环中的第m次出环编号可以由 (n-1) 人环中的第 (m-1) 次出环编号通过特定运算推出
    * f(n) = (f(n-1) + m)%n
    ```php
        // 迭代
        function killMonkey($monkeys , $m)
        {
            $n = count($monkeys);
            $result = 0;
            for ($i=2;$i<=$n;$i++) {
                $result = ($result + $m) % $i;
            }
            return $result+1;
        }

        // 递归
        function killMonkey($n , $m)
        {
            if ($n == 1) {
                return 0;
            } else {
                return (killMonkey($n-1) + $m)%$n;
            }
        }
    ```
- 链表形式
    ```php
        final class Kid 
        {
            public $no;
            public $next = null;

            public function __construct($no) {
                $this->no = $no;
            }
        }

        /*
         * 环形链表 解决约瑟夫问题
         */
        final class CircularLinkedList 
        {
            public function addKid($n = 0, &$head = null)
            {
                for ($i = 0; $i < $n; $i++) {
                    $Kid = new Kid($i + 1);
                    if ($i == 0) { //第一个小孩的情况
                        $head = $Kid; //对象赋值,是引用赋值
                        $head->next = $Kid; //自己指向自己
                        $current = $head; //对象赋值,是引用赋值
                    } else {
                        $current->next = $Kid;
                        $Kid->next = $head;
                        //继续指向下一个
                        $current = $current->next;
                    }
                }
            }

            /*
             * $start 从几开始
             * $count 数到几就出圈
            */
            public function play(Kid $head, $start, $count) 
            {
                $current = $head;
                //移动指针从$start 移动到
                while (1) {
                    if ($current->no == $start) {
                        break;
                    }
                    $current = $current->next;
                }

                while ($current->next != $current->next->next) {
                    //少移动一位,方便一处节点
                    for ($i = 1; $i < $count; $i++) {
                        $current = $current->next;
                    }
                    //去除节点
                    echo '出去的小孩是  --' . $current->next->no . "<br />";
                    $current->next = $current->next->next;
                    //移动指针,移到删除节点的下一位就是重新数数的那个节点
                    $current = $current->next;
                }
                echo $current->no;
            }

            public function countKids(Kid $head)
            {
                $current = $head;
                $count = 1;
                while ($head->no != $current->next->no) {
                    $count++;
                    $current = $current->next;
                }

                return $count;
            }
        }

        $CircularLinkedList = new CircularLinkedList();
        $CircularLinkedList->addKid(10, $head);
        $CircularLinkedList->play($head, 3, 2);
    ```

#### 约瑟夫环公式推导
> 用文字说明一下 为啥f(n) = (f(n-1) + m)%n
1. 举个栗子: 总人数sum为10人,从0开始,每报到4就把一人扔下去(value=4)
    初始情况为:
    0   1   2   3   4   5   6   7   8   9
    扔下去一个之后:
    0   1   2        4   5   6   7   8   9
------------
2. 构造一个新环
    原始   0   1   2   3   4   5   6   7   8   9
    旧环   0   1   2       4   5   6   7   8   9
                                      ^
    新环   6   7   8       0   1   2   3   4   5
                                      ^
- 得到新环位置与旧环位置联系
    * 新环中编号 = (旧环中编号-最大报数值)%旧总人数
    * 旧环中编号 = (新环中的数字+最大报数值)% 旧总人数
    * old_number = ( new_number + value ) % old_sum
------------
3. 开始推导
    ![约瑟夫环推导1](/img/20200727_1.png)
    ![约瑟夫环推导2](/img/20200727_2.png)

