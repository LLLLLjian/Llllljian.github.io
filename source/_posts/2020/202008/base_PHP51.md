---
title: PHP_基础 (51)
date: 2020-08-11
tags: PHP 
toc: true
---

### PHP操作Redis
    使用phpredis操作有序集合Zset

<!-- more -->

#### Zset(有序集合 sorted set)操作
- 基础操作
    ```php
        /**
         *
         * Zset操作
         * sorted set操作
         * 有序集合
         * sorted set 它在set的基础上增加了一个顺序属性,这一属性在修改添加元素的时候可以指定,每次指定后,zset会自动从新按新的值调整顺序
         *
         */
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        //将一个或多个元素插入到集合里面,默认从尾部开始插入
        //如果要在头部插入,则找一个元素,在元素后面添加一个你需要插入的元素即可
        $redis->zAdd('sorted1',100,'坑啊',98.999,99,90,90,80,80,60,60,70,70);

        //返回有序集中指定区间内的成员.成员按分数值递增排序,分数值相同的则按字典序来排序.
        //参数：第四个参数表示是否返回各个元素的分数值,默认为false.
        $redis->zRange('sorted', 0, -1, true);

        //返回有序集中指定区间内的成员.成员按分数值递减排序,分数值相同的则按字典序的倒序来排序.
        $redis->zReverseRange('sorted', 0, -1, true);

        //返回有序集中指定分数区间的成员列表,按分数值递增排序
        $redis->zRangeByScore('sorted', 10, 99);
        //自定义返回的序集返回起始位置及条数
        $redis->zRangeByScore('sorted', 0,90,['limit' =>[0,2]]);

        //返回有序集中指定分数区间的成员列表,按分数值递减排序,分数值相同的则按字典序的倒序来排序.注意,区间表示的时候大值在前,小值在后.
        $redis->zRevRangeByScore('sorted', 100, 90);

        //迭代有序集合中的元素.
        //可理解为查找指定的值,将元素修改为float类型
        //返回值：[元素名=>分数值,,..]
        $redis->zscan('sorted', $it, 100, 10);

        //返回指定有序集的元素数量,序集的长度.
        $redis->zCard('sorted');

        //返回有序集中指定分数区间的成员数量.
        $redis->zCount('sorted', 90, 100);

        //返回有序集中指定成员的分数值.若成员不存在则返回false.
        $redis->zScore('sorted', 'math');

        //返回有序集中指定成员元素的大小排名,按分数值递增排序.分数值最小者排名为0.
        $redis->zRank('sorted', 60);

        //返回有序集中指定成员元素的排名,按分数值递减排序.分数值最大者排名为0.
        $redis->zRevRank('sorted', 70);

        //删除有序集中的一个或多个成员,忽略不存在的成员.返回删除的元素个数.
        $redis->zRem('sorted', 'chemistry', 'English');

        //删除有序集中指定排名区间的所有成员,返回删除元素个数
        $redis->zRemRangeByRank('sorted', 0, 2);

        //删除有序集中指定分数值区间的所有成员,返回删除元素的个数
        $redis->zRemRangeByScore('sorted', 80, 90);

        //对有序集中指定成员的分数值增加指定增量值.若为负数则做减法,若有序集不存在则先创建,若有序集中没有对应成员则先添加,最后再操作.
        $redis->zIncrBy('sorted', 2, 'Chinese');

        //计算给定一个或多个有序集的交集,元素相加,并将其存储到目的有序集中
        $redis->zinterstore('zset3',['sorted','sorted1']);

        //计算给定一个或多个有序集的并集,元素相加,并将其存储到目的有序集中
        $redis->zunionstore('zset3',['sorted', 'sorted1']);
    ```
- 使用场景
    * 排行榜
    * 反spam系统
    * 延迟队列
- demo
    ```php
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        $action = isset($_GET['action']) ? $_GET['action'] : 'test1';

        $key1 = 'testZSet';
        $key2 = 'testZSet2';
        $key3 = 'testZSet3';

        if ($action == 'test1') {
            // 排行榜-增
            for ($i=1;$i<100;$i++) {
                $redis->zadd($key1, $i, 'user_' . $i);
            }
            echo "排行榜-增 设置成功";
        } elseif ($action == 'test2') {
            // 排行榜-删
            $redis->zRem($key1, 'user_5', 'user_95');
            echo "排行榜-删 设置成功";
        } elseif ($action == 'test3') {
            // 排行榜-改
            $redis->zadd($key1, 666, 'user_6');
            $redis->zadd($key1, 999, 'user_96');
        } elseif ($action == 'test4') {
            // 排行榜-查
            echo "排序 zRange: ";
            // 返回的是二维数组[user_从小到大] ,key为user_ value为分数
            var_dump($redis->zRange($key, 0, -1, true));
            // 返回的是二维数组[从小到大] key从0开始, value为user_
            //var_dump($redis->zRange($key, 0, -1, true));
            echo "<br />";

            echo "排序 zReverseRange: ";
            // [返回的是二维数组[user_从大到小]
            var_dump($redis->zReverseRange($key, 0, -1, true));
            echo "<br />";

            echo "排序 zRangeByScore: ";
            // 返回的是value在1到10里边的数据     limit2取前两条
            var_dump($redis->zRangeByScore($key, 1, 10), $redis->zRangeByScore($key, 1, 10, ['limit' =>[0,2]]));
            echo "<br />";

            echo "排序 zRevRangeByScore: ";
            // 返回的是value在100到90里边的数据 
            var_dump($redis->zRevRangeByScore($key, 100, 90));
            echo "<br />";

            echo "返回分数 zScore: ";
            // 返回user_6的分数
            var_dump($redis->zScore($key, 'user_6'));
            echo "<br />";


            echo "返回排名(score值最小的成员排名为0) zRank: ";
            // 从小到大 user_6的排名[从0开始]
            var_dump($redis->zRank($key, 'user_6'));
            echo "<br />";

            echo "返回排名(score值最大的成员排名为0) zRevRank: ";
            // 从大到小 user_6的排名[从0开始]
            var_dump($redis->zRevRank($key, 'user_6'));
            echo "<br />";
        } elseif ($action == 'test5') {
            // 反spam系统[反垃圾系统]-5秒内不能评论
            $res = $redis->zReverseRange($key2, time()-5, time());
            if ($res) {
                $redis->zAdd($key2, time(), '评论ID');
            } else {
                echo "5s内不能评论";
            }

            #5秒内评论不得超过2次
            if($redis->zRangeByScore('user:1000:comment',time()-5 ,time())==1) {
                echo '5秒之内不能评论2次';
            }
            
            #5秒内评论不得少于2次
            if(count($redis->zRangeByScore('user:1000:comment',time()-5 ,time()))<2) {
                echo '5秒之内不能评论2次';
            }
        } elseif ($action == 'test6') {
            // 延迟队列-添加任务
            $redis->zAdd(
                $key3, 
                time(), 
                json_encode(['task_name' => "订单1", 'task_time' => time()], JSON_UNESCAPED_UNICODE));
            $redis->zAdd(
                $key3, 
                time() + 120, 
                json_encode(['task_name' => "订单2", 'task_time' => time()], JSON_UNESCAPED_UNICODE));
            $redis->zAdd(
                $key3, 
                time() + 240, 
                json_encode(['task_name' => "订单3", 'task_time' => time()], JSON_UNESCAPED_UNICODE));
        } elseif ($action == 'test7') {
            // 处理任务
            while (true) {
                $temp = $redis->zRangeByScore($key3, 0, time(), ['limit' => [0, 1]]);

                if ($temp) {
                    // 过期了准备删除
                    if ($redis->zrem($key, $temp[0])) {
                        echo "任务删除成功";
                    } else {
                        echo "任务删除失败";
                    }
                }
            }
        }
    ```


