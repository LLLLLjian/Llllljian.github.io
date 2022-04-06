---
title: DataStructure_基础 (47)
date: 2022-03-17
tags: DataStructure
toc: true
---

### 重学数据结构
    重学数据结构-常见数据结构

<!-- more -->

#### 链表
    链表是一种在物理上非连续 非顺序的数据结构 由若干节点组成
- 查找节点
    * 只能从头节点开始向后一个一个节点逐一查找
- 更新节点
    * 直接把旧数据替换掉即可
- 插入节点
    * 尾部插入
        * 将最后一个节点的next指针指向新插入的节点即可
    * 头部插入
        * 把新节点的next指针指向原先的头节点
        * 把新节点变为链表的头节点
    * 中间插入
        * 新节点的next指针指向插入位置的节点
        * 插入位置前置节点的next指针指向新节点
- 删除元素
    * 尾部删除
        * 把倒数第二个节点的next指针指向空
    * 头部删除
        * 把链表的 头节点设为原先头节点的next指针
    * 中间删除
        * 把删除节点的前置节点的next指针, 指向要删除元素的下一个节点即可
- 优
    * 能够灵活的进行插入和删除操作
- 劣
    * 查找最坏的情况是要遍历整个链表
- 头插法
    * 5->4->3->2->1->0
    * ![链表头插法](/img/20220317_1.png)
    * 代码
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
        ```
- 尾插法
    * 0->1->2->3->4->5
    * ![链表尾插法](/img/20220317_2.png)
    * 代码
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
        ```

#### 数组
    数组是有限个相同类型的变量所组成的有序集合, 数组中的每一个变量都被称为元素
- 读取元素
    * 由于数组在内存中顺序存储 所以只要给出一个数组下标 就可以读取到对应的数组元素
- 更新元素
    * 直接利用数组下标, 就可以把新值赋给该元素了
- 插入元素
    * 尾部插入
        * 直接把插入的元素放在数组尾部的空闲位置即可, 等同更新元素
    * 中间插入
        * 将插入位置后面所有的元素都往后挪
        * eg 
        ```php
            /**
             * $arr 插入的数组
             * $value 插入的值
             * $key 插入的位置 
             */
            function insertArr($arr, $value, $key)
            {
                $count = count($arr);
                if (($key < 0) || ($key > $count)) {
                    return false;
                }

                // 从右往左循环 将元素逐个向右挪1位
                for ($i=$count-1;$i>=$key;$i--) {
                    $arr[$i+1] = $arr[$i];
                }

                // 腾出的位置放入新元素
                $arr[$key] = $value;
            }
        ```
    * 超范围插入
        * 数组扩容[PHP是弱类型语言 不需要数组扩容]
- 删除元素
    * 删除操作和插入操作过程正好相反, 如果删除的元素位于数组的中间, 其后的元素都需要向前挪动1位
- 优
    * 有非常高效的随机访问能力, 只要给出下标, 就可以用常量时间找到对应元素, 有一种高效查找元素的算法叫做二分查找, 就是利用了数组的这个优势
- 劣
    * 由于数组元素连续紧密地储存在内存中, 插入和删除元素都会导致大量元素被迫移动 影响效率

#### 栈
    栈是一种线性数据结构, 栈中的元素只能先进后出, 最早进入的元素存放的位置叫做栈底, 最后进入的元素存放的位置叫做栈顶
- 入栈
    * push
    * 将新元素放入栈中, 新元素的位置将成为新的栈顶
- 出栈
    * pop
    * 将栈顶元素弹出, 出栈元素的前一个元素将会称为新的栈顶
- 使用队列来实现堆栈的下列操作
    * push(x) -- 元素 x 入栈; pop() -- 移除栈顶元素; top() -- 获取栈顶元素; empty() -- 返回栈是否为空
    ```php
        class MyStack {
            public $query1;
            public $query2;

            /**
            * Initialize your data structure here.
            */
            function __construct() {
                $this->query1 = array();
                $this->query2 = array();
            }
        
            /**
            * Push element x onto stack.
            * @param Integer $x
            * @return NULL
            */
            function push($x) {
                if (empty($this->query1) && empty($this->query2)) {
                    array_push($this->query1, $x);
                    return;
                }
                
                if (empty($this->query1)) {
                    array_push($this->query1, $x);
                    
                    while (!empty($this->query2)) {
                        array_unshift($this->query1, array_pop($this->query2));
                    }
                } else {
                    array_push($this->query2, $x);
                    
                    while (!empty($this->query1)) {
                        array_unshift($this->query2, array_pop($this->query1));
                    }
                }
            }
        
            /**
            * Removes the element on top of the stack and returns that element.
            * @return Integer
            */
            function pop() {
                if (empty($this->query1)) {
                    return array_pop($this->query2);
                } else {
                    return array_pop($this->query1);
                }
            }
        
            /**
            * Get the top element.
            * @return Integer
            */
            function top() {
                if (empty($this->query1)) {
                    return reset($this->query2);
                } else {
                    return reset($this->query1);
                }
            }
        
            /**
            * Returns whether the stack is empty.
            * @return Boolean
            */
            function emptyForQ() {
                if (empty($this->query1) && empty($this->query2)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```

#### 队列
    队列是一种线性数据结构 他的特性和行驶车辆的单行隧道类似 队列中的元素只能先入先出, 队列的出口端叫对头 入口端叫队尾
- 入队
    * 把新元素放入队列中, 只允许在队尾的位置放入元素, 新元素会成为新的队尾
- 出队
    * 把元素移出队列, 只允许在队头一侧移出元素, 出队元素的后一个元素会成为新的对头
- 用栈实现队列
    * 使用栈实现队列的下列操作: push(x) -- 将一个元素放入队列的尾部; pop() -- 从队列首部移除元素; peek() -- 返回队列首部的元素; empty() -- 返回队列是否为空.
    ```php
        // 栈 FILO
        // 队列 FIFO
        class MyQueue {
            public $in;
            public $out;
            /**
            * Initialize your data structure here.
            */
            function __construct() {
                $this->in = array();
                $this->out = array();
            }
        
            /**
            * Push element x to the back of queue.
            * @param Integer $x
            * @return NULL
            */
            function push($x) {
                array_unshift($this->in, $x);
                return;
            }
        
            /**
            * Removes the element from in front of queue and returns that element.
            * @return Integer
            */
            function pop() {
                if (!empty($this->out)) {
                    // 出队栈不为空时,直接从出队栈中移除栈顶元素
                    return array_shift($this->out);
                } else {
                    // 出队栈为空时,从入队栈中依次将元素放入出队栈
                    while (!empty($this->in)) {
                        array_unshift($this->out, array_shift($this->in));
                    }
                    // 放完后,从出队栈依次将栈顶元素弹出
                    return array_shift($this->out);
                }
            }
        
            /**
            * Get the front element.
            * @return Integer
            */
            function peek() {
                if (!empty($this->out)) {
                    // 出队栈不为空时,直接从出队栈中得到栈顶元素
                    return reset($this->out);
                } else {
                    // 出队栈为空时,从入队栈中依次将栈顶元素放入出队栈
                    while (!empty($this->in)) {
                        array_unshift($this->out, array_shift($this->in));
                    }
                    // 放完后,从出队栈得到栈顶元素
                    return reset($this->out);
                }
            }
        
            /**
            * Returns whether the queue is empty.
            * @return Boolean
            */
            function empty() {
                return empty($this->in) && empty($this->out);
            }
        }
    ```

#### 哈希表
    哈希表也叫散列表, 这种数据结构提供了键和值的映射关系, 只要给出一个key, 就可以高效查找到它所匹配的值, 时间复杂度接近O(1)
- 哈希函数
    * 通过哈希函数 我们可以将字符串或其它类型的key转换成数组的下标index\[java采用了位运算的方式进行转换, 最简单的转化方式为按照数组长度进行取模]
- 写操作
    * 通过哈希函数将key转化为对应的数组下标
    * 如果对应的数组下标没有元素, 就把value填入到对应下标位置
    * 如果对应下标有元素, 可以使用<a href="#desc1">开放寻址法</a>, 或者<a href="#desc2">链表法</a>
- 读操作
    * 通过给定的key, 在散列表中查找相应的value
- 扩容
    * 创建一个新的entry空数组, 长度是原数组的2倍
    * 重新hash, 遍历原数组, 将原数组中所有的值都重新hash到新数组中


##### 开放寻址法<span id="desc1"></span>
    当一个key通过哈希函数获得对应的数组下标已被占用时, 寻找下一个空挡位置

##### 链表法<span id="desc2"></span>
    当一个key通过哈希函数获得对应的数组下标已被占用时, 插到以该节点为链表的头节点的下一个节点中