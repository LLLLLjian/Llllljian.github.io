---
title: PHP_基础 (48)
date: 2020-08-10
tags: PHP 
toc: true
---

### PHP操作Redis
    使用phpredis操作集合Set

<!-- more -->

#### Set(集合)操作
- 基础操作
    ```php
        /**
         *
         * Set操作
         * 集合命令
         * 保证数据的唯一
         * 不保证顺序
         * 
         */
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        //将一个元素加入集合,已经存在集合中的元素则忽略.若集合不存在则先创建,若key不是集合类型则返回false,若元素已存在返回0,插入成功返回1.
        $redis->sAdd('set3', '11');

        //返回集合中所有成员.
        $redis->sMembers('set3');

        //判断集合里是否存在指定元素,是返回true,否则返回false.
        $redis->sismember('set', 'hello');

        //返回集合中元素的数量.
        $redis->scard('set');

        //随机删除并返回集合里的一个元素.
        $redis->sPop('set');

        //随机返回(n)个集合内的元素,由第二个参数决定返回多少个
        //如果 n 大于集合内元素的个数则返回整个集合
        //如果 n 是负数时随机返回 n 的绝对值,数组内的元素会重复出现
        $redis->sRandMember('set', -20);

        //删除集合中指定的一个元素,元素不存在返回0.删除成功返回1,否则返回0.
        $redis->srem('set', 'hello');

        //模糊搜索相对的元素,
        //参数：key,迭代器变量,匹配值,每次返回元素数量(默认为10个)
        $redis->sscan('set', $it, 's*', 5);

        //将指定一个源集合里的值移动到一个目的集合.成功返回true,失败或者源集合值不存在时返回false.
        //参数：源集合,目标集合,移动的元素
        $redis->sMove('set', 'set2', 'sdf4');

        //以第一个集合为标准,后面的集合对比,返回差集
        $redis->sDiff('set', 'set2','set3');

        //参数：第一个参数为目标集合,存储缺少的值(三个集合相加,同样字段覆盖,组合成一个新的集合)返回第一个参数所增加的值的个数.
        $redis->sDiffStore('set', 'set3', 'set2');

        //返回所有集合的相同值,必须所有集合都有,不存在的集合视为空集.
        $redis->sInter('set', 'set3', 'set2');

        //参数：第一个参数为目标集合,存储后面集合的交集
        //若目的集合已存在则覆盖它.返回交集元素个数,否则返回储存的交集
        $redis->sInterStore('set4', 'set', 'set3');

        //把所有集合合并在一起并返回
        $redis->sUnion('set', 'set2', 'set3');

        //以第一个集合为目标,把后面的集合合并在一起,存储到第一个集合里面,如果已经存在则覆盖掉,并返回并集的个数
        $redis->sUnionStore('set4', 'set', 'set2', 'set3');
    ```
- 使用场景
    * sismember、scard、smove 好友/关注/粉丝/感兴趣的人集合
    * sranmember 随机展示
    * sismember 黑名单/白名单
- demo
    ```php
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        $action = isset($_GET['action']) ? $_GET['action'] : 'act1';
        $key1 = 'testSet1';
        $key2 = 'testSet2';
        $key3 = 'testSet3';
        
        if ($action == 'act1') {
            for ($i=1;$i<10;$i++) {
                $redis->sadd($key1, $i);
            }
            
            for ($i=5;$i<15;$i++) {
                $redis->sadd($key2, $i);
            }

            // 展示key中所有内容
            echo "key1: " . $key1 . " => ";
            var_dump($redis->smembers($key1))
            echo "<br />";
            
            echo "key2: " . $key2 . " => ";
            var_dump($redis->smembers($key2))
            echo "<br />";
        } elseif ($action == 'act2') {
            // 展示集合交集
            echo "key1和key2交集";
            var_dump($redis->sinter($key1, $key2));
        } elseif ($action == 'act3') {
            // 判断元素是否存在于集合中
            var_dump($redis->sismember($key1, 1));
            var_dump($redis->sismember($key1, 100));
        } elseif ($action == 'act4') {
            // 获取集合数量
            var_dump($redis->scard($key1));
            var_dump($redis->scard($key2));
        } elseif ($action == 'act5') {
            // 将集合1中的5移除至集合3中
            $redis->smove($key1, $key3, 5);
            var_dump($redis->smembers($key1));
            var_dump($redis->smembers($key3));
        } elseif ($action == 'act6') {
            // 随机展示 n > 0 ? { n < 集合数据 ? 随机取5个不重复 : 全取出来 } : 随机取5个可能会重复 
            var_dump($redis->srandmember($key1, 5));
            var_dump($redis->srandmember($key1, -5));
            var_dump($redis->srandmember($key3, 5));
        } else {
            echo "action参数错误";
        }
    ```


