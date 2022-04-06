---
title: Interview_总结 (12)
date: 2018-09-05
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
    ```php
        q : PHP实现链表反转

        a : 
        <?php
        class Node
        {
            private $value;
            private $next;

            public function __construct($value = null)
            {
                $this->value = $value;
            }

            public function getValue()
            {
                return $this->value;
            }

            public function setValue($value)
            {
                $this->value = $value;
            }

            public function getNext()
            {
                return $this->next;
            }

            public function setNext($next)
            {
                $this->next = $next;
            }
        }

        //遍历,将当前节点的下一个节点缓存后更改当前节点指针 
        function reverse($head)
        {
            if ($head == null) {
                return $head;
            }
            $pre = $head;//注意: 对象的赋值
            $cur = $head->getNext();
            $next = null;
            while ($cur != null)                       {
                $next = $cur->getNext();
                $cur->setNext($pre);
                $pre = $cur;
                $cur = $next;
            }
            //将原链表的头节点的下一个节点置为null,再将反转后的头节点赋给head  
            $head->setNext(null);
            $head = $pre;
            return $head;
        }

        //递归,在反转当前节点之前先反转后续节点 
        function reverse2($head)
        {
            if (null == $head || null == $head->getNext()) {
                return $head;
            }
            $reversedHead = reverse2($head->getNext());
            $head->getNext()->setNext($head);
            $head->setNext(null);
            return $reversedHead;
        }

        function test()
        {
            $head = new Node(0);
            $tmp = null;
            $cur = null;
            // 构造一个长度为10的链表,保存头节点对象head   
            for($i=1;$i<10;$i++){
                $tmp = new Node($i);
                if($i == 1){
                    $head->setNext($tmp);
                }else{
                    $cur->setNext($tmp);
                }
                $cur = $tmp;
            }
            //print_r($head);exit;
            $tmpHead = $head;
            while ($tmpHead != null) {
                echo $tmpHead->getValue().' ';
                $tmpHead = $tmpHead->getNext();
            }
            echo "\n";
            //$head = reverse($head);
            $head = reverse2($head);
            while($head != null){
                echo $head->getValue().' ';
                $head = $head->getNext();
            }
        }
        test();
        ?>
    ```
