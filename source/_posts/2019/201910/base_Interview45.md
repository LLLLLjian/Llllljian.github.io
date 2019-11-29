---
title: Interview_总结 (45)
date: 2019-10-21
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题

<!-- more -->

#### 手写LRU算法
    ```php
        class LRUCache 
        {
            // 头结点
            private $head;
            // 尾节点
            private $tail;
            // 允许的最大元素数
            private $capacity;
            // 原始哈希映射的数组
            private $hashmap;
            /**
             * 初始化方法
             * @param int $capacity 允许的最大元素数
             */
            public function __construct($capacity) {
                $this->capacity = $capacity;
                $this->hashmap = array();
                $this->head = new Node(null, null);
                $this->tail = new Node(null, null);
                $this->head->setNext($this->tail);
                $this->tail->setPrevious($this->head);
            }
            /**
             * 获取指定的节点
             */
            public function get($key) {
                if (!isset($this->hashmap[$key])) { 
                    return null; 
                }
                $node = $this->hashmap[$key];
                if (count($this->hashmap) == 1) { 
                    return $node->getData(); 
                }
                // refresh the access
                $this->detach($node);
                $this->attach($this->head, $node);
                return $node->getData();
            }
            /**
             * 在缓存中插入新元素
             */
            public function put($key, $data) {
                if ($this->capacity <= 0) { return false; }
                if (isset($this->hashmap[$key]) && !empty($this->hashmap[$key])) {
                    $node = $this->hashmap[$key];
                    // update data
                    $this->detach($node);
                    $this->attach($this->head, $node);
                    $node->setData($data);
                }
                else {
                    $node = new Node($key, $data);
                    $this->hashmap[$key] = $node;
                    $this->attach($this->head, $node);
                    // check if cache is full
                    if (count($this->hashmap) > $this->capacity) {
                        // we're full, remove the tail
                        $nodeToRemove = $this->tail->getPrevious();
                        $this->detach($nodeToRemove);
                        unset($this->hashmap[$nodeToRemove->getKey()]);
                    }
                }
                return true;
            }
            /**
             * 从缓存中移除节点
             */
            public function remove($key) {
            if (!isset($this->hashmap[$key])) { return false; }
            $nodeToRemove = $this->hashmap[$key];
            $this->detach($nodeToRemove);
            unset($this->hashmap[$nodeToRemove->getKey()]);
            return true;
            }
            /**
             * 将节点添加到列表头
             */
            private function attach($head, $node) {
                $node->setPrevious($head);
                $node->setNext($head->getNext());
                $node->getNext()->setPrevious($node);
                $node->getPrevious()->setNext($node);
            }
            /**
             * 从列表中删除节点
             */
            private function detach($node) {
                $node->getPrevious()->setNext($node->getNext());
                $node->getNext()->setPrevious($node->getPrevious());
            }
        }
        /**
         * 双链表
         */
        class Node {
            /**
             * 节点的键
             */
            private $key;
            // 节点的值
            private $data;
            // 下一个节点
            private $next;
            // 上一个节点
            private $previous;
            /**
             * @param string $key the key of the node
             * @param string $data the content of the node
             */
            public function __construct($key, $data) {
                $this->key = $key;
                $this->data = $data;
            }
            /**
             * 为当前节点设置一个新值
             * @param string the new content of the node
             */
            public function setData($data) {
                $this->data = $data;
            }
            /**
             * 为下个节点设置一个新值
             * @param Node $next the next node
             */
            public function setNext($next) {
                $this->next = $next;
            }
            /**
             * 为上个节点设置一个新值
             * @param Node $previous the previous node
             */
            public function setPrevious($previous) {
                $this->previous = $previous;
            }
            /**
             * 获取某个节点的键
             * @return string the key of the node
             */
            public function getKey() {
                return $this->key;
            }
            /**
             * 获取某个节点的值
             * @return mixed the content of the node
             */
            public function getData() {
                return $this->data;
            }
            /**
             * 获取下一个节点
             * @return Node the next node of the node
             */
            public function getNext() {
                return $this->next;
            }
            /**
             * 获取上一个节点
             * @return Node the previous node of the node
             */
            public function getPrevious() {
                return $this->previous;
            }
        }
    ```