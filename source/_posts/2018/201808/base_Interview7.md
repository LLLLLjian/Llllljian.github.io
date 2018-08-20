---
title: Interview_总结 (7)
date: 2018-08-20
tags: Interview
toc: true
---

### 笔试总结
    列一下今天笔试题
    
<!-- more -->

#### 编程题1
    ```php
        q : 将数组array('a', 'b', 'd', 'c', 'a', 'a', 'b')转换为array('a', 'b', 'c', 'd')

        a : 

        function orderArr($arr)
        {
            $returnArr = $tempArr = $tempArr1 = array();

            if (empty($arr) || !is_array($arr)) {
                return $returnArr;
            } else {
                $tempArr = array_count_values($arr);
                
                foreach ($tempArr as $key=>$value) {
                    $tempArr1[] = array('name' => $key, 'num' => $value);
                }

                $num = array_column($tempArr1, 'num');
                $name = array_column($tempArr1, 'name');
                array_multisort($num, SORT_DESC, $name, SORT_ASC, $tempArr1);
                
                $returnArr = array_column($tempArr1, 'name');
                return $returnArr;
            }
        }

        echo "<pre>";
        $a = array('a', 'b', 'd', 'c', 'a', 'a', 'b', 'b', 'b');
        var_dump(orderArr($a));
    ```

#### MySQL锁
- 乐观锁
    * 乐观锁不是数据库自带的，需要我们自己去实现
    * 乐观锁是指操作数据库时(更新操作)，想法很乐观，认为这次的操作不会导致冲突，在操作数据时，并不进行任何其他的特殊处理（也就是不加锁），而在进行更新后，再去判断是否有冲突了
    * 在表中的数据进行操作时(更新)，先给数据表加一个版本(version)字段，每操作一次，将那条记录的版本号加1。也就是先查询出那条记录，获取出version字段,如果要对那条记录进行操作(更新),则先判断此刻version的值是否与刚刚查询出来时的version的值相等，如果相等，则说明这段期间，没有其他程序对其进行操作，则可以执行更新，将version字段的值加1；如果更新时发现此刻的version值与刚刚获取出来的version的值不相等，则说明这段期间已经有其他程序对其进行操作了，则不进行更新操作
- 悲观锁
    * 悲观锁是由数据库自己实现了的
    * 在操作数据时，认为此操作会出现数据冲突，所以在进行每次操作时都要通过获取锁才能进行对相同数据的操作
- 行锁
    * 共享锁
        * 允许一个事务去读一行，阻止其他事务获得相同的数据集的排他锁
        * 我读的时候，你可以读，但是不能写
    * 排它锁
        * 允许获得排他锁的事务更新数据，但是组织其他事务获得相同数据集的共享锁和排他锁
        * 我写的时候，你不能读也不能写.
- 表锁
    * 意向共享锁
        * 事务打算给数据行共享锁，事务在给一个数据行加共享锁前必须先取得该表的IS锁
    * 意向排他锁
        * 事务打算给数据行加排他锁，事务在给一个数据行加排他锁前必须先取得该表的IX锁

#### MySQL最左前缀
    最左前缀原则：顾名思义是最左优先，以最左边的为起点任何连续的索引都能匹配上，
    注：如果第一个字段是范围查询需要单独建一个索引
    注：在创建多列索引时，要根据业务需求，where子句中使用最频繁的一列放在最左边。
    当创建(a,b,c)复合索引时，想要索引生效的话,只能使用 a和a,b和a,b,c三种组合


