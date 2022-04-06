---
title: DataStructure_基础 (3)
date: 2018-10-17
tags: DataStructure
toc: true
---

### 数据结构--队列
    队列(Queue)也是一种运算受限的线性表,它的运算限制与栈不同,是两头都有限制,插入只能在表的一端进行(只进不出),而删除只能在表的另一端进行(只出不进),允许删除的一端称为队尾(rear),允许插入的一端称为队头 (Front)

<!-- more -->

#### 特性
    先进先出
    队列又称作FIFO表(First In First Out)

#### 基本运算
    置空队 : InitQueue(Q)
    判队空 : QueueEmpty(Q)
    判队满 : QueueFull(Q)
    入队 : EnQueue(Q,x)
    出队 : DeQueue(Q)
    取队头元素 : QueueFront(Q),不同与出队,队头元素仍然保留

#### 使用场景
    商城秒杀[并发大、耗时长、不需要立即返回处理结果]

#### PHP实现队列
    ```php
        class data 
        {
            //数据
            private $data;
        
            public function __construct($data)
            {
                $this->data=$data;
                echo $data.":进队了！<br>";
            }
        
            public function getData()
            {
                return $this->data;
            }

            public function __destruct()
            {
                echo $this->data.": 出队了！<br>";
            }
        }
    
        class queue
        {
            protected $front;//队头
            protected $rear;//队尾
            protected $queue=array('0'=>'队尾');//存储队列
            protected $maxsize;//最大数
        
            public function __construct($size)
            {
                $this->initQ($size);
            }

            //初始化队列
            private function initQ($size)
            {
                $this->front = 0;
                $this->rear = 0;
                $this->maxsize = $size;
            }

            //判断队空
            public function QIsEmpty()
            {
                return $this->front == $this->rear;
            }

            //判断队满
            public function QIsFull()
            {
                return ($this->front-$this->rear) == $this->maxsize;
            }

            //获取队首数据
            public function getFrontDate()
            {
                return $this->queue[$this->front]->getData();
            }

            //入队
            public function InQ($data)
            {
                if ($this->QIsFull()) {
                    echo $data.":队满不能入队,请等待！<br>";
                } else {
                    $this->front++;
                    
                    for ($i = $this->front;$i > $this->rear;$i--) {
                        if ($this->queue[$i]) {
                            unset($this->queue[$i]);
                        }
                        $this->queue[$i]=$this->queue[$i-1];
                    }

                    $this->queue[$this->rear+1] = new data($data);
                    echo '入队成功！<br>';
                }
            }

            //出队
            public function OutQ()
            {
                if ($this->QIsEmpty()) {
                    echo "队空不能出队！<br>";
                } else{
                    unset($this->queue[$this->front]);
                    $this->front--;
                    echo "出队成功！<br>";
                }
            }
        }

        $q=new queue(3);
        $q->InQ("1");
        $q->InQ('2');
        $q->InQ('3');
        $q->InQ('4');
        $q->OutQ();
        $q->InQ("5");
        $q->OutQ();
        $q->OutQ();
        $q->OutQ();
        $q->OutQ();

        1:进队了！
        入队成功！
        2:进队了！
        入队成功！
        3:进队了！
        入队成功！
        4:队满不能入队,请等待！
        1: 出队了！
        出队成功！
        5:进队了！
        入队成功！
        2: 出队了！
        出队成功！
        3: 出队了！
        出队成功！
        5: 出队了！
        出队成功！
        队空不能出队！
    ```
