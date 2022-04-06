---
title: PHP_基础 (34)
date: 2019-10-28
tags: PHP 
toc: true
---

### PHP性能优化利器: 生成器yield理解
    今天看了一下python中的生成器, 搜了一下发现PHP里也有生成器, 处理大文件的时候会用到

<!-- more -->

#### yield是什么
    生成器是PHP 5.5.0才引入的功能, 生成器函数看上去就像一个普通函数,除了不是返回一个值之外,生成器会根据需求产生更多的值.

#### yield特性
- yield只能用于函数内部,在非函数内部运用会抛出错误.
- 如果函数包含了yield关键字的,那么函数执行后的返回值永远都是一个Generator对象.
- 如果函数内部同事包含yield和return 该函数的返回值依然是Generator对象,但是在生成Generator对象时,return语句后的代码被忽略.
- Generator类实现了Iterator接口.
- 可以通过返回的Generator对象内部的方法,获取到函数内部yield后面表达式的值.
- 可以通过Generator的send方法给yield 关键字赋一个值.
- 一旦返回的Generator对象被遍历完成,便不能调用他的rewind方法来重置
- Generator对象不能被clone关键字克隆

#### yield优点
- 生成器会对PHP应用的性能有非常大的影响
- PHP代码运行时节省大量的内存
- 比较适合计算大量的数据

#### 概念引入
- eg1
    ```bash
        function createRange($number){
            $data = [];
            for($i=0;$i<$number;$i++){
                $data[] = time();
            }
            return $data;
        }

        $result = createRange(10); // 这里调用上面我们创建的函数
        foreach($result as $value){
            sleep(1);//这里停顿1秒,我们后续有用
            echo $value.'<br />';
        }
    ```
- 代码解读
    * 我们创建一个函数.
    * 函数内包含一个 for 循环,我们循环的把当前时间放到$data里面
    * for循环执行完毕,把 $data 返回出去
    * createRange 函数内的 for 循环结果被很快放到 $data 中,并且立即返回.所以, foreach 循环的是一个固定的数组.
- eg2
    ```bash
        function createRange($number){
            for($i=0;$i<$number;$i++){
                yield time();
            }
        }

        $result = createRange(10); // 这里调用上面我们创建的函数
        foreach($result as $value){
            sleep(1);
            echo $value.'<br />';
        }
    ```
- 代码解读
    * createRange函数,传入参数10,但是for值执行了一次然后停止了,并且告诉 foreach 第一次循环可以用的值.
    * foreach开始对$result循环,进来首先 sleep(1) ,然后开始使用 for 给的一个值执行输出.
    * foreach准备第二次循环,开始第二次循环之前,它向for循环又请求了一次.
    * for循环于是又执行了一次,将生成的时间戳告诉foreach .
    * foreach拿到第二个值,并且输出.由于foreach中sleep(1) ,所以,for循环延迟了1秒生成当前时间
    * createRange的值不是一次性快速生成,而是依赖于foreach循环.foreach循环一次,for执行一次.

#### 实际应用
- 读取超大文件
- 百万级别的访问量

#### Iterator接口
    会发现当对象被foreach的时候, 内部的valid,current,key方法会依次被调用, 其返回值便是foreach语句的key和value.循环的终止条件则根据valid方法的返回而定.如果返回的是true则继续循环, 如果是false则终止整个循环, 结束遍历.当一次循环体结束之后, 将调用next进行下一次的循环直到valid返回false.而rewind方法则是在整个循环开始前被调用, 这样保证了多次遍历得到的结果都是一致的
- 源码
    ```php
        Iterator extends Traversable {
            /* Methods */
            abstract public mixed current ( void )   //返回当前位置的元素
            abstract public scalar key ( void )      //返回当前元素对应的key
            abstract public void next ( void )       //移到指向下一个元素的位置
            abstract public void rewind ( void )     //倒回到指向第一个元素的位置
            abstract public boolean valid ( void )   //判断当前位置是否有效
        }
    ```
- eg
    ```php
        class Number implements Iterator{  
            protected $i = 1;
            protected $key;
            protected $val;
            protected $count; 
            public function __construct(int $count){
                $this->count = $count;
                echo "第{$this->i}步:对象初始化.\n";
                $this->i++;
            }
            public function rewind(){
                $this->key = 0;
                $this->val = 0;
                echo "第{$this->i}步:rewind()被调用.\n";
                $this->i++;
            }
            public function next(){
                $this->key += 1;
                $this->val += 2;
                echo "第{$this->i}步:next()被调用.\n";
                $this->i++;
            }
            public function current(){
                echo "第{$this->i}步:current()被调用.\n";
                $this->i++;
                return $this->val;
            }
            public function key(){
                echo "第{$this->i}步:key()被调用.\n";
                $this->i++;
                return $this->key;
            }
            public function valid(){
                echo "第{$this->i}步:valid()被调用.\n";
                $this->i++;
                return $this->key < $this->count;
            }
        }

        $number = new Number(5);
        echo "start...\n";
        foreach ($number as $key => $value){
            echo "{$key} - {$value}\n";
        }
        echo "...end...\n";
    ```

#### Generator类
- 源码
    ```php
        Generator implements Iterator {
            /* 方法 */
            // 返回当前产生的值
            public current ( void ) : mixed
            // 返回当前产生的键
            public key ( void ) : mixed
            // 生成器继续执行
            public next ( void ) : void
            // 重置迭代器
            public rewind ( void ) : void
            // 向生成器中传入一个值
            public send ( mixed $value ) : mixed
            // 向生成器中抛入一个异常
            public throw ( Exception $exception ) : void
            // 检查迭代器是否被关闭
            public valid ( void ) : bool
            // 序列化回调
            public __wakeup ( void ) : void
        }
    ```


