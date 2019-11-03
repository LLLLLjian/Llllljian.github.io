---
title: Interview_总结 (23)
date: 2019-09-03
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * Autoload原理简单概述
- A
    * 1.检查执行器全局变量函数指针autoload_func是否为NULL.
    * 2.如果autoload_func==NULL, 则查找系统中是否定义有__autoload()函数,如果没有,则报告错误并退出.
    * 3.如果定义了__autoload()函数,则执行__autoload()尝试加载类,并返回加载结果.
    * 4.如果autoload_func不为NULL,则直接执行autoload_func指针指向的函数用来加载类.

#### 问题2
- Q
    * 如何foreach迭代对象
- A
    * eg
        ```php
            class myIterator implements Iterator {
                private $position = 0;
                private $array = array(
                    "firstelement",
                    "secondelement",
                    "lastelement",
                );
            
                public function __construct() {
                    $this‐>position = 0;
                }
                //返回到迭代器的第一个元素
                function rewind() {
                    var_dump(__METHOD__);
                    $this‐>position = 0;
                }
                // 返回当前元素
                function current() {
                    var_dump(__METHOD__);
                    return $this‐>array[$this‐>position];
                }
                //返回当前元素的键
                function key() {
                    var_dump(__METHOD__);
                    return $this‐>position;
                }
                //向前移动到下一个元素
                function next() {
                    var_dump(__METHOD__);
                    ++$this‐>position;
                }
                //检查当前位置是否有效
                function valid() {
                    var_dump(__METHOD__);
                    return isset($this‐>array[$this‐>position]);
                }
            }
            
            $it = new myIterator;
            foreach($it as $key => $value) {
                var_dump($key, $value);
                echo "\n";
            }
            
            输出结果：
            string(18) "myIterator::rewind"
            string(17) "myIterator::valid"
            string(19) "myIterator::current"
            string(15) "myIterator::key"
            int(0)
            string(12) "firstelement"

            string(16) "myIterator::next"
            string(17) "myIterator::valid"
            string(19) "myIterator::current"
            string(15) "myIterator::key"
            int(1)
            string(13) "secondelement"

            string(16) "myIterator::next"
            string(17) "myIterator::valid"
            string(19) "myIterator::current"
            string(15) "myIterator::key"
            int(2)
            string(11) "lastelement"

            string(16) "myIterator::next"
            string(17) "myIterator::valid"
        ```

#### 问题3
- Q
    * 如何数组化操作对象 $obj[key]
- A
    * eg
        ```php
            class obj implements arrayaccess {
                private $container = array();
                public function __construct() {
                    $this‐>container = array(
                    "one" => 1,
                    "two" => 2,
                    "three" => 3,
                    );
                }
                //设置一个偏移位置的值
                public function offsetSet($offset, $value) {
                    if (is_null($offset)) {
                        $this‐>container[] = $value;
                    } else {
                        $this‐>container[$offset] = $value;
                    }
                }
                //检查一个偏移位置是否存在
                public function offsetExists($offset) {
                    return isset($this‐>container[$offset]);
                }
                //复位一个偏移位置的值
                public function offsetUnset($offset) {
                    unset($this‐>container[$offset]);
                }
                //获取一个偏移位置的值
                public function offsetGet($offset) {
                    return isset($this‐>container[$offset]) ? $this‐>
                    container[$offset] : null;
                }
            }
            
            对该类测试使用：
            $obj = new obj;
            var_dump(isset($obj["two"]));
            var_dump($obj["two"]);
            unset($obj["two"]);
            var_dump(isset($obj["two"]));
            $obj["two"] = "A value";
            var_dump($obj["two"]);
            $obj[] = 'Append 1';
            $obj[] = 'Append 2';
            $obj[] = 'Append 3';
            print_r($obj);
        ```

