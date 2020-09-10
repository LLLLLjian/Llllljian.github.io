---
title: PHP_基础 (49)
date: 2020-08-07
tags: PHP 
toc: true
---

### PHP操作Redis
    使用phpredis操作哈希Hash

<!-- more -->

#### Hash(哈希)操作
- 基础操作
    ```php
        /**
         *
         * Hash操作
         * 哈希操作
         * 可理解为数据库操作
         * 
         */
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        //为user表中的字段赋值.成功返回1,失败返回0.若user表不存在会先创建表再赋值,若字段已存在会覆盖旧值.
        $redis->hSet('user', 'name', '222');

        //获取user表中指定字段的值.若user表不存在则返回false.
        $redis->hGet('user', 'realname');

        //查看user表的某个字段是否存在,存在返回true,否则返回false.
        $redis->hExists('user', 'realname');

        //删除user表的一个字段,不支持删除多个字段.成功返回1,否则返回0.
        $redis->hDel('user', '222');

        //同时设置某个user表的多个字段值.成功返回true.
        $redis->hMset('user', ['name' => 'jet', 'age' => 18]);

        //同时获取某个user表的多个字段值.其中不存在的字段值为false.
        $redis->hMget('user', ['name', 'age']);

        //获取某个user表所有的字段和值.
        $redis->hGetAll('user');

        //获取某个user表所有字段名.user表不存在时返回空数组,key不为user表时返回false.
        $redis->hKeys('user');

        //获取某个user表所有字段值.
        $redis->hVals('user');

        //为user表中不存在的字段赋值.若user表不存在则先创建,若字段已存在则不做任何操作.设置成功返回true,否则返回false.
        $redis->hSetNx('user', 'realname', 'jetwu');

        //获取某个user表的字段数量.若user表不存在返回0,若user不是hash表则返回false.
        $redis->hLen('user');

        //为user表中的指定字段加上指定的数值,若user表不存在则先创建,若字段不存在则先初始化值为0再进行操作,若字段值为字符串则返回false.设置成功返回字段新值.
        $redis->hIncrBy('user', 'age', 10);

        //为user表中的指定字段加上指定浮点数值.
        $redis->hIncrBy('user', 'age', 1.5);
    ```
- 使用场景
    * hset、hdel、hlen、hincrby、hgetall 购物车
    * hset、hincrby 储存对象(频繁变化部分)
- demo
    ```php
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        $action = isset($_GET['action']) ? $_GET['action'] : 'set';

        $tempGoodsArr = array(
            'id' => 1,
            'name' => 'goods1',
            'price' => 123,
            'view' => 5
        );

        $key = 'testHash';
        
        if ($action == 'set') {
            foreach ($tempGoodsArr AS $k=>$v) {
                $redis->hset($key, $k, $v);
            }
        } elseif ($action == 'mset') {
            if ($redis->HEXISTS($key)) {
                echo "添加Hash失败, $key已存在" . "<br />";
            } else {
                $redis->hmset($key, $tempGoodsArr);
            }
        } elseif ($action == 'del') {
            $redis->hdel($key);
        } elseif ($action == 'get') {
            foreach ($tempGoodsArr AS $k=>$v) {
                echo "$k : " . $redis->hget($key, $k) . '||' . $v . "<br />";
            }
        } elseif ($action == 'mget') {
            var_dump($redis->hmget(array_keys($tempGoodsArr)));
        } elseif ($action == 'getall') {
            var_dump($redis->hgetall($key));
        } elseif ($action == 'hincrby') {
            $redis->hincrby($key, 'view', 1);
        } else {
            echo "参数错误" . "<br />";
        }
    ```





