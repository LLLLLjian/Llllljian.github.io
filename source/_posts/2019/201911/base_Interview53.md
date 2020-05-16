---
title: Interview_总结 (53)
date: 2019-11-08
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * MySQL事务的隔离级别
- A
    * Read Uncommitted：读取未提交内容
        * 未提交读是最低的隔离级别，其含义是允许一个事务读取另外一个事务没有提交的数据。这是一种危险的隔离级别，所以一般在我们实际的开发中应用不广，但是它的优点在于并发能力高，适用于那些对数据一致性没有要求而追求高并发的场景，他的最大坏处是出现脏读（Dirty Read）
        * eg
        <table border="1" cellpadding="1" cellspacing="1"><tbody><tr><td><strong>时刻</strong></td><td><strong>事务1</strong></td><td><strong>事务2</strong></td><td><strong>备注</strong></td></tr><tr><td>T0</td><td>&nbsp;</td><td>&nbsp;</td><td>商品库存初始为2</td></tr><tr><td>T1</td><td>读取库存为2</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>T2</td><td>扣减库存</td><td>&nbsp;</td><td>此时库存为1</td></tr><tr><td>T3</td><td>&nbsp;</td><td>扣减库存</td><td>此时库存为0，因为读取到事务1未提交的库存数据</td></tr><tr><td>T4</td><td>&nbsp;</td><td>提交事务</td><td>库存保存为0</td></tr><tr><td>T5</td><td>回滚事务</td><td>&nbsp;</td><td>因为第一类丢失更新已经解决，所以不会回滚为2。因此此时库存为0</td></tr></tbody></table>
        * 上表的T3时刻，因为采用未提交读，所以事务2可以读取事务1未提交的库存数据（库存为1），这里当它扣减库存后提交，数据库将保存此数据为0。当事务1回滚时，结果仍然为0
        * 脏读：A事务读取B事务尚未提交的更改数据，并在这个数据的基础上进行操作，这时候如果事务B回滚，那么A事务读到的数据是不被承认的。
    * Read Committed：读取提交内容
        * 这是大多数数据库系统的默认隔离级别（但不是MySQL默认的）。它满足了隔离的简单定义：一个事务只能看见已经提交事务所做的改变。这种隔离级别 也支持所谓的不可重复读（Nonrepeatable Read），因为同一事务的其他实例在该实例处理其间可能会有新的commit，所以同一select可能返回不同结果
        * eg
        <table border="1" cellpadding="1" cellspacing="1"><tbody><tr><td><strong>时刻</strong></td><td><strong>事务1</strong></td><td><strong>事务2</strong></td><td><strong>备注</strong></td></tr><tr><td>T0</td><td>&nbsp;</td><td>&nbsp;</td><td>商品库存初始为1</td></tr><tr><td>T1</td><td>读取库存为1</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>T2</td><td>扣减库存</td><td>&nbsp;</td><td>事务未提交</td></tr><tr><td>T3</td><td>&nbsp;</td><td>读取库存为1</td><td>认为可扣减</td></tr><tr><td>T4</td><td>提交事务</td><td>&nbsp;</td><td>库存保存为0</td></tr><tr><td>T5</td><td>&nbsp;</td><td>扣减库存</td><td>失败，因为此时库存为0，无法扣减</td></tr></tbody></table>
        * 在T3时刻事务2读取库存时候，因为事务1未提交事务，所以读出的库存为1，于是事务2认为当前可扣减库存。当时当T4时刻，事务1提交事务后，在T5时刻，事务2会发现扣减失败。像这样的问题，叫做不可重复读。
        * 不可重复读是指A事务读取到了B事务已经提交的更改数据，在同个时间段内，两次查询的结果不一致
    * Repeatable Read：可重读
        * 这是MySQL的默认事务隔离级别，它确保同一事务的多个实例在并发读取数据时，会看到同样的数据行。不过理论上，这会导致另一个棘手的问题：幻读 （Phantom Read）。简单的说，幻读指当用户读取某一范围的数据行时，另一个事务又在该范围内插入了新行，当用户再读取该范围的数据行时，会发现有新的“幻影” 行。InnoDB和Falcon存储引擎通过多版本并发控制（MVCC，Multiversion Concurrency Control）机制解决了该问题
        * eg
        <table border="1" cellpadding="1" cellspacing="1"><tbody><tr><td><strong>时刻</strong></td><td><strong>事务1</strong></td><td><strong>事务2</strong></td><td><strong>备注</strong></td></tr><tr><td>T0</td><td>读取库存50件</td><td>&nbsp;</td><td>商品库存初始为100，现在已经销售50件，库存50件</td></tr><tr><td>T1</td><td>&nbsp;</td><td>查询交易记录，50笔</td><td>&nbsp;</td></tr><tr><td>T2</td><td>扣减库存</td><td>&nbsp;</td><td>事务未提交</td></tr><tr><td>T3</td><td>插入一笔交易记录</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>T4</td><td>提交事务</td><td>&nbsp;</td><td>库存保存为49件，交易记录为51笔</td></tr><tr><td>T5</td><td>&nbsp;</td><td>打印交易记录，51笔</td><td>这里与查询的不一致，在事务2看来有一笔交易记录是虚幻的</td></tr></tbody></table>
        * 幻读是指A事务读取B事务提交的新增数据，导致的幻读现象
    * Serializable：可串行化
        * 这是最高的隔离级别，它通过强制事务排序，使之不可能相互冲突，从而解决幻读问题。简言之，它是在每个读的数据行上加上共享锁。在这个级别，可能导致大量的超时现象和锁竞争
         * list
        <table border="1" cellpadding="1" cellspacing="1"><tbody><tr><td><strong>隔离级别</strong></td><td><strong>脏读</strong></td><td><strong>不可重复读</strong></td><td><strong>幻读</strong></td><td><strong>第一类丢失更新</strong></td><td><strong>第二类丢失更新</strong></td></tr><tr><td>未提交读</td><td>允许</td><td>允许</td><td>允许</td><td>不允许</td><td>允许</td></tr><tr><td>读写提交</td><td>不允许</td><td>允许</td><td>允许</td><td>不允许</td><td>允许</td></tr><tr><td>可重复读</td><td>不允许</td><td>不允许</td><td>允许</td><td>不允许</td><td>不允许</td></tr><tr><td>串行化</td><td>不允许</td><td>不允许</td><td>不允许</td><td>不允许</td><td>不允许</td></tr></tbody></table>
        * 事务的隔离级别和数据库并发性是成反比的，隔离级别越高，并发性越低。所以应该根据实际情况选择事务的隔离级别
    * 幻读和不可重复读的区别：
        * 不可重复读是指读到了已经提交的事务的更改数据（修改或删除），幻读是指读到了其他已经提交事务的新增数据。对于这两种问题解决采用不同的办法。为了防止读到更改数据（解决不可重复读），只需对操作的数据添加行级锁，防止操作中的数据发生变化；而为了防止读到新增数据（解决幻读），往往需要添加表级锁，将整张表锁定，防止新增数据（oracle采用多版本数据的方式实现）

#### 问题2
- Q
    * PHP数组合并+和array_merge()有什么区别
- A
    ```php
        $array1['foo'] = 'Bar1';
        $array2['foo'] = 'Bar2';

        print_r($array1 + $array2); // Array ( [foo] => Bar1 )
        print_r($array2 + $array1); // Array ( [foo] => Bar2 )
        print_r(array_merge($array1, $array2)); // Array ( [foo] => Bar2 )
        print_r(array_merge($array2, $array1)); // Array ( [foo] => Bar1 )


        $array1 = [1, 2, 3];
        $array2 = [4, 5, 6];

        print_r($array1 + $array2); // Array ( [0] => 1 [1] => 2 [2] => 3 ) 
        print_r($array2 + $array1); // Array ( [0] => 4 [1] => 5 [2] => 6 )
        print_r(array_merge($array1, $array2)); // Array ( [0] => 1 [1] => 2 [2] => 3 [3] => 4 [4] => 5 [5] => 6 ) 
        print_r(array_merge($array2, $array1)); // Array ( [0] => 4 [1] => 5 [2] => 6 [3] => 1 [4] => 2 [5] => 3 )
    ```
    ![数组合并差异](/img/20191108_1.png)

#### 问题3
- Q
    * 从用户在浏览器中输入网址并回车，到看到完整的页面，中间都经历了哪些过程
- A
    * 浏览器 → url → dns → ip → port → TCP → Nginx → server name → php-fpm/fast cgi → php → php-fpm/fast cgi → Nginx → TCP → 浏览器

#### 问题4
- Q
    * 正则表达式过滤JavaScript标签及内容
- A
    ```php
        function stripScript($text)
        {
            $pattern = '/<script.*>.*<\/script>/i';         // 后面的 /i 为忽略大小写
            return preg_replace($pattern, '', $text);
        }
    ```

#### 问题5
- Q
    * PHP转义和反转义，引用和反引用函数
- A
    * htmlentities()
        * 将字符转换为 HTML 转义字符
        ```php
            echo htmlentities('<b> php </b>');
            // 结果：&lt;b&gt; php &lt;/b&gt;
        ```
    * html_entity_decode()
        * 将HTML转移字符转化为字符
        ```php
            echo htmlentities('&lt;b&gt; php &lt;/b&gt;');
            // 结果：<b> php </b>
        ```
    * htmlspecialchars()
        * 将特殊字符转换为 HTML 实体，功能同htmlentities()
    * addcslashes()
        * 以C语言风格使用反斜线转义字符串中的字符
        ```php
            echo addcslashes("zoO['.']", 'A..a');
            // 结果为：zo\O\['.'\]
            // A..a表示ASCII码中的字符范围
        ```
    * stripcslashes()
        * 反引用一个使用 addcslashes() 转义的字符串
        ```php
            echo stripcslashes('\n\tABC');
            // 则返回如下一个回车，一个TAB和ABC字符串。

                ABC
        ```
    * stripslashes()
        * 反引用一个引用字符串，去除转义反斜线后的字符串（\’ 转换为 ‘ 等等）
        ```php
            echo stripslashes("I\'m a phper.");
            // 结果：I'm a phper.
        ```
    * addslashes()
        * 使用反斜线引用字符串，包括'、"、\与 NULL
        ```php
            echo addslashes("I'm a phper.");
            // 结果： I\'m a phper.
        ```
    * strip_tags()
        * 从字符串中去除 HTML 和 PHP 标记
        ```php
            echo strip_tags('<p>Test paragraph.</p>');
            // 结果：Test paragraph.
        ```

    