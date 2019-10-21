---
title: Interview_总结 (10)
date: 2018-09-03
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
    ```php
        q : ===是什么运算符？请举一个例子,说明在什么情况下使用==会得到true,而使用===却是false

        a : 
        $a == $b 等于 TRUE,如果类型转换后 $a 等于 $b.
        $a === $b 全等 TRUE,如果 $a 等于 $b,并且它们的类型也相同.
        比如：
        $x = 100;
        $y = "100";
        var_dump($x == $y); //结果是true,因为值相同
        var_dump($x === $y); //结果是false,因为不同类型
    ```

#### 问题2
    ```php
        q : 现有一组数据,请写出一个函数将这些数据按出现次数排序.如$data=array('a','b','b','d','f','a','b')经过排序后为array('b','a','d','f');

        a : 

        <?php

        $data = array('a', 'b', 'b', 'd', 'f', 'a', 'b');

        echo "<pre>";
        $data = array_COUNT_values($data);
        arsort($data);
        var_dump(array_keys($data));

        ?>
    ```

#### 问题3
    ```php
        q : 现有一组数据,请写出一个PHP函数将这些数据按出现次数排序,次数相同的则将最前面的排在前面.例如：array('a','b','b','d','f','a','b'),经过排序后为array('b','a','d','f');

        a :

        $data = array('a', 'b', 'b', 'd', 'f', 'a', 'b');

        echo "<pre>";
        $data = array_COUNT_values($data);
        if (!empty($data)) {
            $newData = array();
            foreach ($data as $key => $value) {
                $newData[] = array(
                    'name' => $key,
                    'num' => $value
                );
            }
        }
        $name = array_column($newData, 'name');
        $num = array_column($newData, 'num');

        array_multisort($name, SORT_DESC, $num, SORT_ASC, $newData);

        var_dump(array_column($newData, "name"));
    ```

#### WHERE和HAVING区别
    WHERE是一个约束声明,使用WHERE来约束来之数据库的数据,WHERE是在结果返回之前起作用的,且WHERE中不能使用聚合函数

    HAVING是一个过滤声明,是在查询返回结果集以后对查询结果进行的过滤操作,在HAVING中可以使用聚合函数

    在查询过程中聚合语句(SUM,MIN,MAX,AVG,COUNT)要比having子句优先执行.而WHERE子句在查询过程中执行优先级别优先于聚合语句(SUM,MIN,MAX,AVG,COUNT)

#### 文件和目录采用777权限利弊
- 利
    * 个人理解
    * apache|nginx|mysql等服务可能需要不同的用户和用户组去启动,而设置相关的配置以及记录日志的地方可能会因为非777权限而无法记录日志或者修改对应配置
- 弊
    * 给定用户的权限过大,可能存在安全风险,即任何可以登录系统的用户都可以对该文件或目录进行操作

#### 问题4
    ```php
        q : 
        有一个每天至少更新一次的PHP网页,每天访问量上百万PV,有一天忽然显示为白屏,浏览器怎么刷新都是一片白.以你的经验来看,通常可能因为什么导致发生这种情况？你如何排查并解决此故障

        a : 
        每台服务器每秒处理请求的数量=((80%*总PV量)/(24小时*60分*60秒*40%)) / 服务器数量
        表示一天中有80%的请求发生在一天的40%的时间内.24小时的40%是9.6小时,有80%的请求发生一天的9.6个小时当中(很适合互联网的应用,白天请求多,晚上请求少)

        ((80%*500万)/(24小时*60分*60秒*40%))/1 = 115.7个请求/秒 
        ((80%*100万)/(24小时*60分*60秒*40%))/1 = 23.1个请求/秒 

        为了应对高峰,留足余量,最少应该为2倍,最多为3倍

        如果你的服务器一秒能处理231.4--347.1个请求/秒,就可以应对平均500万PV/每天
        如果你的服务器一秒能处理46.2--69.3个请求,就可以应对平均100万PV/每天

        解决步骤1 :
        缓存引发空白---尝试清除浏览器缓存,重新硬性加载页面

        解决步骤2 :
        数据库连接发生错误---查看连接数据库是否正常
        
        解决步骤3 :
        查看错误日志---去对应服务器的日志文件中查找可能出现的问题
    ```

#### 优化SQL
    ```sql
        例子1: 请说明sql的差别
        SELECT * FROM table WHERE YEAR(orderDate) < 2013;
        SELECT * FROM table WHERE orderDate < "2013-05-03";

        在建立好的索引字段上尽量减少函数操作,这样会用不到索引,相当于全表扫描

        例子2: 优化sql
        Message表： 200万条记录,user表：1000万条记录
        select  *  from user  where  uid in (select uid from message  where to_uid = 49874022);

        SELECT u.* 
        FROM message m
        LEFT JOIN user u ON (u.uid = m.uid)
        WHERE m.to_uid = 49874022

        SELECT u.* 
        FROM user u 
        LEFT JOIN message m ON (u.uid = m.uid)
        WHERE m.to_uid = 49874022
    ```

#### 问题5
    ```php
        q : 请写出一个根据生日计算出此人在指定的时间点的年龄的函数.
        要求：
        1、入口参数为生日和指定的时间点,入口参数格式要兼容Unix timestamp和字符串两种格式,其中生日为必填参数,指定的时间点为选填参数,不填则用系统当前时间计算.
        2、返回值为年龄(周岁)或false(出现各种错误、异常)

        a : 
        function getAgeByBirthday($birthday, $now = null)
        {
            if (empty($birthday)) {
                echo "生日参数不能为空";
                return false;
            } else {
                var_dump($birthday, strtotime($birthday));
                if (strtotime($birthday)) {
                    $birthday = strtotime($birthday);
                } else {
                    if (!is_numeric($birthday)) {
                        echo "生日不对1";
                        return false;
                    }
                }
            }

            var_dump($birthday);
            
            if (empty($now)) {
                $now = time();
            } else {
                if (strtotime($now)) {
                    $now = strtotime($now);
                } else {
                    if (!is_numeric($now)) {
                        echo "当前日期不对";
                        return false;
                    }
                }
            }
            
            $diff = $now - $birthday;
            
            if ($diff < 0) {
                echo "生日不对2";
                return false;
            } elseif ($diff == 0) {
                echo "刚出生";
                return false;
            } else {
                $age = $diff / (364 * 24 * 60 * 60);
                
                echo "周岁为".floor($age);
                return true;
            }
        }

        getAgeByBirthday("1995-03-22");
        echo "<br />";
        getAgeByBirthday("a");
        echo "<br />";
        getAgeByBirthday("b");
        echo "<br />";
        getAgeByBirthday("c");
        echo "<br />";
        getAgeByBirthday("abc");
        echo "<br />";
        getAgeByBirthday("123");

        string(10) "1995-03-22" int(795801600) int(795801600) 周岁为23
        string(1) "a" int(1538156331) int(1538156331) 生日不对2
        string(1) "b" int(1538152731) int(1538152731) 生日不对2
        string(1) "c" int(1538149131) int(1538149131) 生日不对2
        string(3) "abc" bool(false) 生日不对1
        string(3) "123" bool(false) string(3) "123" 周岁为48
    ```

#### 未解之谜
    问题5发现的问题,strtotime("a")和strtotime("abc")结果不一样
    
