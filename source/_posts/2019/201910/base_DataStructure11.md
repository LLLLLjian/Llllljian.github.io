---
title: DataStructure_基础 (11)
date: 2019-10-12
tags: DataStructure
toc: true
---

### 算法--堆栈
    算法--堆栈

<!-- more -->

#### 堆栈
- 是什么
    * 堆栈(stack)是一种先进后出的、操作受限的线性表,也可以直接称为 栈
    * 后进先出Last In-First Out
- 顺序栈
    * 用数组实现的栈
    * 先初始化一个数组,然后再用一个变量给这个数组里的元素进行计数,当有新元素需要入栈的时候,将这个新元素写入到数组的最后一个元素的后面,然后计数器加一.当需要做出栈操作时,将数组中最后一个元素返回,计数器减一.当然在入栈前需要判断数组是否已经满了,如果数组大小等于计数器大小,则表明数组是满的.出栈的时候也需要判断数组是不是空数组,如果计数器是0,则表明数组是空的
- 链式栈
    * 用链表实现的栈
    * 先定义一个链表节点的类,基于这个类去定义一个头节点Head.当有新元素需要入栈的时候,将这个新元素的Next指针指向头结点Head的Next节点,然后再将Head的Next指向这个新节点.当需要做出栈操作时,直接将Head所指向的节点返回,同时让Head指向下一个节点.当然,在入栈和出栈时都需要判断链表是否为空的情况

#### demo
- Q
    给定一个只包括 '(',')','{','}','[',']' 的字符串,判断字符串是否有效.
    有效字符串需满足: 

    左括号必须用相同类型的右括号闭合.
    左括号必须以正确的顺序闭合.
    注意空字符串可被认为是有效字符串.

    示例 1:

    输入: "()"
    输出: true
    示例 2:

    输入: "()[]{}"
    输出: true
    示例 3:

    输入: "(]"
    输出: false
    示例 4:

    输入: "([)]"
    输出: false
    示例 5:

    输入: "{[]}"
    输出: true
- A
    ```php
        function f1($s)
        {
            $arr = array('(', ')', '{', '}', '[', ']');
        
            if (empty($s)) {
                return true;
            } else {
                if (strlen($s) % 2 != 0) {
                    return false;
                } else {
                    while (strstr($s, '{}') || strstr($s, '()') || strstr($s, '[]')) {
                        $s = str_replace("{}","",$s);
                        $s = str_replace("()","",$s);
                        $s = str_replace("[]","",$s);
                    }
                    return $s == '';
                }
            }
        }

        function f2($s)
        {
            $arr = array('(' => ')', '{' => '}', '[' => ']');
        
            if (empty($s)) {
                return true;
            } else {
                if (strlen($s) % 2 != 0) {
                    return false;
                } else {
                    $tempArr = array();
                    $len = strlen($s);
                    for ($i=0;$i<$len;$i++) {
                        if (empty($tempArr) || ($arr[$tempArr[0]] != $s[$i])) {
                            array_unshift($tempArr, $s[$i]);
                        } elseif ($arr[$tempArr[0]] == $s[$i]) {
                            array_shift($tempArr);
                        }
                    }

                    if (empty($tempArr)) {
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    ```





