---
title: PHP_基础 (45)
date: 2020-07-24
tags: PHP 
toc: true
---

### PHP与数据结构
    PHP实现链表
    在力扣上刷题的时候 一直用的是现成的链表类, 没有自己具体生成过链表类, 被人问懵了 现在来看看.

<!-- more -->

#### PHP实现链表
> 在力扣上刷题的时候 一直用的是现成的链表类, 没有自己具体生成过链表类, 被人问懵了 现在来看看.
```php
    class Node
    {
        public $val;
        public $next;

        public function __construct($val)
        {
            $this->val = $val;
        }
    }

    /**
     * $n 链表的生成长度
     * $type 生成链表的方式 1是头插法 2是尾插法
     */
    function getNodeList($n, $type=1)
    {
        if ($type == 1) {
            return headInsert($n);
        } else {
            return rearInsert($n);   
        }
    }

    /**
     * 头插法 
     */
    function headInsert($n)
    {
        $newNode = new Node(null);
        if (empty($n) || !is_numeric($n)) {
            return $newNode;
        }
        
        for ($i=0;$i<$n;$i++) {
            $tempNode = new Node($i);
            $tempNode->next = $newNode;
            $newNode = $tempNode;
        }
        return $newNode;
    }

    /**
     * 尾插法
     */
    function rearInsert($n)
    {
        //指向表尾节点的指针
        $head = $rear = new Node(null);
        if (empty($n) || !is_numeric($n)) {
            return $head;
        }
        for($i=0;$i<$n;$i++) {
            $newNode = new Node($i);
            //将表尾节点的指针指向新节点
            $rear->next = $newNode;
            //将当前的新节点定义为表尾终端节点
            $rear = $newNode;
        }

        //循环结束后最终的尾节点的指针赋值null
        $rear->next = null;
        return $head;
    }

    function dumpNodeList($head)
    {
        $res = array();
        while (!empty($head)) {
            $res[] = $head->val;
            $head = $head->next;
        }
        return $res;
    }

    /**
     * 链表反转
     */
    function reverseList($head)
    {
        if (!empty($head)) {
            $cur = $head;
            $pre = null;
            
            while (!empty($cur)) {
                $next = $cur->next;
                $cur->next = $pre;
                $pre = $cur;
                $cur = $next;
            }
            return $pre;
        } else {
            return null;
        }
    }

    echo "<pre>";
    $node1 = getNodeList(3, 1);
    var_dump(dumpNodeList($node1));
    var_dump(dumpNodeList(reverseList($node1)));
    $node2 = getNodeList(3, 2);
    var_dump(dumpNodeList($node2));
    var_dump(dumpNodeList(reverseList($node2)));
```
