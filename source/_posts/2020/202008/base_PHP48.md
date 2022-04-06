---
title: PHP_基础 (48)
date: 2020-08-06
tags: PHP 
toc: true
---

### PHP操作Redis
    使用phpredis操作字符串String

<!-- more -->

#### String(字符串)操作
- 基础操作
    ```php
        /**
         *
         *  String操作
         *  字符串操作
         * 
         */
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        //设置键值: 成功返回true,否则返回false,键值不存在则新建,否则覆盖
        $redis->set('string', 'hello world!');

        //从左往右第五个字符开始替换为另一指定字符串,成功返回替换后新字符串的长度.
        $redis->setRange('string',6, '1111'); 

        //截取字符串里指定key对应的value里的第一个到第七个字符.
        $redis->getRange('string', 0, 6);

        //添加键,返回旧键值: 若key不存在则创建键值,返回false
        $redis->getSet('ad', 'hi man');

        //一次设置多个键值对: 成功返回true
        $redis->mset(['name' => 'jet', 'age' => 18]);

        //一次获取多个key的值: 返回一个键值对数组,其中不存在的key值为false.
        $redis->mget(['name', 'age']);

        //创建一个具有时间限制的键值,过期则删除,秒为单位,成功返回true
        $redis->setex('name', 10, 'jetwu');

        //创建一个具有时间限制的键值,过期则删除,毫秒为单位,成功返回true
        $redis->psetex('name', 10, 'jetwu');

        //key的值不存在时,添加key并返回true,key存在返回false.
        $redis->setnx('name', 'boby');

        //setnx命令的批量操作.只有在给定所有key都不存在的时候才能设置成功,只要其中一个key存在,所有key都无法设置成功.
        $redis->msetnx(['name' => '11', 'name1' => '22']);

        //获取指定key存储的字符串的长度,key不存在返回0,不为字符串返回false.
        $redis->strlen('name');

        //将指定key存储的数字值增加1.若key不存在会先初始化为0再增加1,若key存储的不是整数值则返回false.成功返回key新值.
        $redis->incr('name');

        //给指定key存储的数字值增加指定增量值.
        $redis->incrBy('age', 10);

        //给指定key存储的数字值增加指定浮点数增量.
        $redis->incrByFloat('age', 1.5);

        //将指定key存储的数字值减一.
        $redis->decr('age');

        //将指定key存储的数字值减去指定减量值.
        $redis->decrBy('age', 10);

        //为指定key值尾部添加字符,返回值得长度,若key不存在则创建
        $redis->append('name', 'haha');

        //获取键值: 成功返回String类型键值,若key不存在或不是String类型则返回false
        $redis->get('name');
    ```
- 使用场景
    * incr、decr计数器
    * setnx、expire、del分布式锁
    * json、set 储存对象(不常变化部分)
- demo
    ```php
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);
        $empArr = array(
            'name_key' => 'name_value',
            'id_key' => 'id_value'
        );

        $key = 'testString';
        $action = isset($_GET['action']) ? $_GET['action'] : 'set';

        if ($action == 'set') {
            // 单值缓存
            $redis->set($key, 'hello world!');
        } elseif ($action == 'get') {
            // 单值缓存
            echo $key . "的值为" . $redis->get($key);
        } elseif ($action == 'oSet') {
            // 对象缓存
            $redis->set($key, json_encode($arr));
        } elseif ($action == 'mSet') {
            // 同时设置一个或多个key-value对
            $redis->mset($empArr);
        } elseif ($action == 'mGet') {
            // 同时获取一个或多个key
            echo "<pre>";
            var_dump($redis->mget(array_keys($empArr)));
        } elseif ($action == 'setnx') {
            // 分布式锁 如果key存在就返回false, 否则就将key设置为对应value并且返回true
            var_dump($redis->setnx($key, 'world hello!'));
        } elseif ($action == 'del')  {
            // 删除key
            $redis->del($key);
        } elseif () {
            // 自增1
        } else {
            echo "action参数错误";
        }
    ```

#### Redis实现分布式锁
- 用redis的setnx、expire方法做分布式锁
    * 伪代码
        ```php
            if ($redis->setnx($key, $value)) {
                $redis->expire($key, 60 * 60);// 缓存时间设置为1小时
                // 执行业务代码
                $redis->del($key);
            } else {
                echo "被锁了";
            }
        ```
    * setnx()
        * setnx的含义就是 SET if Not Exists,其主要有两个参数setnx(key,value).该方法是原子的,如果key不存在,则设置当前key成功,返回1；如果当前key已经存在,则设置当前key失败,返回0
    * expire()
        * expire设置过期时间,要注意的是setnx 命令不能设置key的超时时间,只能通过expire()来对key设置
    * 可能存在的问题
        * 如果在第一步setnx执行成功后,在expire()命令执行成功前,发生了宕机的现象,那么就依然会出现死锁的问题
- 用redis的setnx()、get()、getset()方法做分布式锁
    * 伪代码
        ```php
            /**
             * 获取Redis分布式锁
             * @param $lockKey
             * @return bool
             */
            function getRedisDistributedLock(string $lockKey) : bool
            {
                $lockTimeout = 2000;// 锁的超时时间2000毫秒
                $now = intval(microtime(true) * 1000);
                $lockExpireTime = $now + $lockTimeout;
                $lockResult = Redis::setnx($lockKey, $lockExpireTime);
                if ($lockResult) {
                    // 当前进程设置锁成功
                    return true;
                } else {
                    $oldLockExpireTime = Redis::get($lockKey);
                    if ($now > $oldLockExpireTime && $oldLockExpireTime == Redis::getset($lockKey, $lockExpireTime)) {
                        return true;
                    }
                }
                return false;
            }
            /**
            * 串行执行程序
            *
            * @param string $lockKey Key for lock
            * @param Closure $closure 获得锁后进程要执行的闭包
            * @return mixed
            */
            function serialProcessing(string $lockKey, Closure $closure)
            {
                if (getRedisDistributedLock($lockKey)) {
                    $result = $closure();
                    $now = intval(microtime(true) * 1000);
                    if ($now < Redis::get($lockKey)) {
                        Redis::del($lockKey); 
                    }
                } else {
                    // 延迟200毫秒再执行
                    usleep(200 * 1000);
                    return serialProcessing($lockKey, $closure);
                }
                return $result;
            }
        ```
    * getset()
        * 这个命令主要有两个参数getset(key,newValue).该方法是原子的,对key设置newValue这个值,并且返回key原来的旧值.假设key原来是不存在的,那么多次执行这个命令,会出现下边的效果: getset(key,"value1")返回null此时key的值会被设置为value1;getset(key,"value2")返回value1此时key的值会被设置为value2依次类推







