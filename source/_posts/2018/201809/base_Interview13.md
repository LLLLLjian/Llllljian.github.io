---
title: Interview_总结 (13)
date: 2018-09-06
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
    ```php
        q : 使对象可以像数组一样进行foreach循环,要求属性必须是私有

        a : 
        class sample implements Iterator
        {
            private $_items = array(1,2,3,4,5,6,7);
        
            public function __construct($arr) {
                if (!empty($arr) && is_array($arr)) {
                    $this->$_items = $arr;
                }
            }
            public function rewind() { reset($this->_items); }
            public function current() { return current($this->_items); }
            public function key() { return key($this->_items); }
            public function next() { return next($this->_items); }
            public function valid() { return ( $this->current() !== false ); }
        }
        
        $sa = new sample();
        foreach($sa as $key => $val){
            print $key . "=>" .$val
        }
    ```
