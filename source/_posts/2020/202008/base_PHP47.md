---
title: PHP_基础 (47)
date: 2020-08-05
tags: PHP 
toc: true
---

### PHP操作Redis
    使用phpredis操作列表List

<!-- more -->

#### List(列表)操作
- 基础操作
    ```php
        /**
         * 
         * List操作
         * 列表操作
         * 可理解为数组操作
         * 插入、删除数据按照一定规律排列的
         * 元素可重复
         * 适用于队列
         * 
         */
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);
        
        //在列表头部插入一个值one,当列表不存在时自动创建一个列表,key1为列表名
        $redis->lpush("key1", "one");

        //在列表尾部插入一个值two,当列表不存在时自动创建一个列表,key1为列表名
        $redis->rPush("key1","two");

        //将一个插入已存在的列表头部,列表不存在时操作无效
        $redis->rPushx("key1","1");

        //删除列表的第一个元素并返回列表和列表的第一个元素,当key1不存在或不是列表则返回false
        $redis->lPop('key1');

        //删除列表的最后一个元素并返回列表和列表的最后一个元素,当key1不存在或不是列表则返回false
        $redis->rPop('key1');

        //删除并或取列表的第一个元素,如果没有元素则会阻塞直到等待超时
        $redis->blPop('asd', 10);

        //删除并或取列表的最后一个元素,如果没有元素则会阻塞直到等待超时
        $ret = $redis->brPop('asd', 10);

        //移除列表key1中最后一个元素,将其插入另一个列表asd头部,并返回这个元素.若源列表没有元素则返回false
        $redis->rpoplpush('key1', 'asd');

        //移除列表key1中最后一个元素,将其插入另一个列表asd头部,并返回这个元素.如果列表没有元素则会阻塞列表直到超时,超时返回false.
        $ret = $redis->brpoplpush('key1', 'asd', 10);

        //返回列表长度
        $redis->lLen('key1');

        //通过索引 (也就是下标key) 获取列表中的元素,如果没有该索引,则返回false.
        $redis->lindex('key1', 0);
        
        //通过索引修改列表中元素的值,如果没有该索引,则返回false.
        $redis->lSet('key1', 2, '1');


        //在列表key1中指定元素six前面或后面插入元素.若指定元素不在列表中,或列表不存在时,不执行任何操作
        //Redis::AFTER插入元素后面    Redis::BEFORE插入元素前面
        //返回值：插入成功返回插入后列表元素个数,若key1不存在返回0,若key1不是列表返回false
        $redis->lInsert('key1', Redis::BEFORE, 'one', '1');

        //根据第三个参数(count),删除掉相对的value
        //count > 0 : 从表头开始向表尾搜索,移除与value相等的元素,数量为count.
        //count < 0 : 从表尾开始向表头搜索,移除与value相等的元素,数量为count的绝对值.
        //count = 0 : 移除表中所有与value相等的值.
        //返回实际删除元素个数
        $redis->lrem('key1', '1', -2);

        //对一个列表进行截取,只保留指定区间 (如：下标1到10) 的元素,其他元素都删除.成功返回true.
        $redis->ltrim('key1', 1, 10);

        // 获取存储的数据并输出列表下标0到5的数据
        // 0为开始查询的列表里的第一个元素,-1则为最后一个元素
        // 5代表查询5条数据,当5为-1时则查看所有数据,
        $redis->lrange("key1", 0 ,5);
    ```
- 使用场景
    * rpush、lpop消息队列
    * rpush、lrange排行榜(定时计算的)
    * lpush、lrange最新列表(不需要按时间范围查询&&(不需要分页||更新频率低))
- demo
    ```php
        //连接本地的 Redis 服务
        $redis = new Redis();
        $redis->connect('127.0.0.1', 6379);

        $action = isset($_GET['action']) ? $_GET['action'] : 'push';

        $key = 'testList';
        if ($action == 'push') {
            if ($redis->exists($key)) {
                $listLen = $redis->llen($key);
            } else {
                $listLen = 0;
            }
            if ($listLen == 0) {
                for ($i=1;$i<=1000;$i++) {
                    $redis->rpush($key, $i);
                }
                echo "插入成功了, 现在列表的长度为" . $redis->llen($key) . "<br />";
            } else {
                echo "长度已经够了不会再插入了<br />";
            }
        } elseif ($action == 'del') {
            if ($redis->exists($key)) {
                $redis->del($key);
                echo "key" . $key. "已经删了<br />";   
            } else {
                echo "没有key" . $key . "了, 别删除了<br />";
            }
        } elseif ($action == 'pop') {
            $redis->lpop($key);
            $listLen = $redis->llen($key);
            $lastList = $redis->lindex($key, $listLen - 1);
            $redis->rpush($key, $lastList + 1);
        } elseif ($action == 'limit') {
            $pageSize = 10;
            //判断页面是否是提交状态
            if ( isset($_GET['page']) && $_GET['page'] >1) {
                $pageVal = $_GET['page'];
            } else {
                $pageVal = 1;
            }
            //计算起始位置
            $start = ($pageVal - 1) * $pageSize;
            $stop = $start + $pageSize - 1;
            $tempArr = $redis->LRANGE($key, $start, $stop);
            echo "<pre>";
            var_dump($tempArr);
        } elseif ($action == 'end') {
            $listLen = $redis->llen($key);
            echo $redis->lindex($key, $listLen - 1);
        } else {
            echo "action参数错误";
        }
    ```


