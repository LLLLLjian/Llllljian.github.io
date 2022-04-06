---
title: Interview_总结 (92)
date: 2020-04-23
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### 斐波那契数列
- A1
    ```php
        function Fibonacci($number){
            if ($number == 0) {
                return 0;
            } elseif ($number == 1) {
                return 1;
            } else {
                return Fibonacci($number - 1) + Fibonacci($number - 2)
            }
        }
    ```
- A2
    ```php
        function Fibonacci($number)
        {
            if ($number < 1) {
                return 0;
            } elseif (($number == 1) || ($number == 2)) {
                return 1;
            }

            $res = 1;
            $pre = 1;
            $temp = 0;
            for ($i=3;$i<$number;$i++) {
                $temp = $res;
                $res = $res+ $pre;
                $pre = $temp;
            }
            return $res;
        }
    ```

#### 二分查找
- A1
    ```php
        function bin_search($array, $low, $high, $target)
        {
            if ( $low <= $high){
                $mid =  intval(($low+$high)/2 );
                if ($array[$mid] ==  $target){
                    return true;
                }elseif ( $target < $array[$mid]){
                    return  bin_search($array, $low,  $mid-1, $target);
                } else {
                    return  bin_search($array, $mid+ 1, $high, $target);
                }
            }
            return false;
        }
    ```
- A2
    ```php
        function bin_search()
        {
            $low = 0;
            $high = count($array)-1;
            $find = false;

            while (true){
                if ($low <= $high){
                    var_dump($low, $high);echo "\n";
                    $mid = intval(($low + $high)/2);
                    if ($array[$mid] == $target){
                        $find = true;
                        break;
                    } elseif ($array[$mid] < $target){
                        $low = $mid+1;
                    } elseif ($array[$mid] > $target){
                        $high = $mid-1;
                    }
                } else {
                    break;
                }
            }
            return $find;
        }
    ```

#### 发号器
- 基于数据库的实现方案
    * 数据库自增id, 单独一个表或者一个库存自增主键, 性能缺陷
    * 设置数据库sequence或者表自增字段步长, 局限性导致后续扩展性低
* UUID
    * 好处是本地生成, 不要基于数据库来了
    * 不好之处就是, UUID 太长了、占用空间大, 作为主键性能太差了；更重要的是, UUID 不具有有序性, 会导致 B+ 树索引在写的时候有过多的随机写操作
* 获取系统当前时间
    * 并发很高时并不实用, 要和业务进行拼接生成唯一编号
* snowflake算法
    * 是 twitter 开源的分布式 id 生成算法, 采用 Scala 语言实现, 是把一个 64 位的 long 型的 id, 1 个 bit 是不用的, 用其中的 41 bit 作为毫秒数, 用 10 bit 作为工作机器 id, 12 bit 作为序列号

#### 访问前10的nginx日志
    ```bash
        cat access_log | awk print {$1} | sort | uniq -c | sort -nr head -10
    ```

#### 删除更改时间在10天前的所有文件
    ```bash
        find /tmp/* -type f -mtime +10 -exec rm {} \;
    ```

#### 查找更改时间在10天前的所有文件
    ```bash
        find /tmp/* -type f -mtime +10 -exec ls -l {} \;
    ```

#### redis-mget
#### redis-mset

#### redis的过期策略以及内存淘汰机制
> redis采用的是定期删除+惰性删除策略.为什么不用定时删除策略?定时删除,用一个定时器来负责监视key,过期则自动删除.虽然内存及时释放, 但是十分消耗CPU资源.在大并发请求下, CPU要将时间应用在处理请求, 而不是删除key,因此没有采用这一策略.定期删除+惰性删除是如何工作的呢?定期删除, redis默认每个100ms检查, 是否有过期的key,有过期key则删除.需要说明的是, redis不是每个100ms将所有的key检查一次, 而是随机抽取进行检查(如果每隔100ms,全部key进行检查, redis岂不是卡死).因此, 如果只采用定期删除策略, 会导致很多key到时间没有删除.于是, 惰性删除派上用场.也就是说在你获取某个key的时候, redis会检查一下, 这个key如果设置了过期时间那么是否过期了？如果过期了此时就会删除
- 思考
    * 采用定期删除+惰性删除就没其他问题了么?
    * 不是的, 如果定期删除没删除key.然后你也没即时去请求key, 也就是说惰性删除也没生效.这样, redis的内存会越来越高.那么就应该采用内存淘汰机制
- 内存淘汰机制
    * volatile-lru: 从已设置过期时间的数据集(server.db[i].expires)中挑选最近最少使用的数据淘汰









