---
title: PHP_基础 (34)
date: 2019-10-28
tags: PHP 
toc: true
---

### PHP性能优化利器：生成器yield理解
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

#### Generator类

#### Iterator接口

