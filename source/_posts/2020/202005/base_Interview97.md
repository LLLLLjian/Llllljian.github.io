---
title: Interview_总结 (97)
date: 2020-05-28
tags: Interview
toc: true
---

### 面试题
    面试题汇总

<!-- more -->

#### 如何解决超卖问题
- 优化方案1
    * 将库存字段number字段设为unsigned, 当库存为0时, 因为字段不能为负数, 将会返回false
        ```php
            //库存减少
            $sql="update ih_store set number=number-{$number} where sku_id='$sku_id' and number>0";
            $store_rs = mysql_query($sql,$conn);
            if (mysql_affected_rows()) {
                insertLog('库存减少成功');
            }
        ```
- 优化方案2
    * 使用事务锁住需要操作的行
        ```php
            //模拟下单操作
            //库存是否大于0
            mysqli_query($conn,"BEGIN"); //开始事务
            $sql="select number from ih_store where goods_id='$goods_id' and sku_id='$sku_id' FOR UPDATE";//此时
            $rs=mysqli_query($conn,$sql);
            $row=mysqli_fetch_assoc($rs);
            if ($row['number']>0) {
                //生成订单 $order_sn=build_order_no();
                $sql="insert into ih_order(order_sn,user_id,goods_id,sku_id,price)
                values('$order_sn','$user_id','$goods_id','$sku_id','$price')";
                $order_rs=mysqli_query($conn,$sql);
                //库存减少
                $sql="update ih_store set number=number-{$number} where sku_id='$sku_id'"; 
                $store_rs=mysqli_query($conn,$sql);
                if (mysqli_affected_rows($conn)) {
                    insertLog('库存减少成功');
                    mysqli_query($conn,"COMMIT");//事务提交即解锁 
                } else {
                    insertLog('库存减少失败'); 
                }
            } else {
                insertLog('库存不够'); mysqli_query($conn,"ROLLBACK");
            }
        ```
- 优化方案3
    * 使用非阻塞的文件排他锁
        ```php
            $fp = fopen("lock.txt", "w+");
            if (!flock($fp,LOCK_EX | LOCK_NB)) {
                echo "系统繁忙, 请稍后再试";
                return;
            }
            //下单
            $sql="select number from ih_store where goods_id='$goods_id' and sku_id='$sku_id'"; 
            $rs = mysqli_query($conn,$sql);
            $row = mysqli_fetch_assoc($rs);
            if ($row['number'] > 0) {//库存是否大于0 //模拟下单操作
                $order_sn=build_order_no();
                $sql="insert into ih_order(order_sn,user_id,goods_id,sku_id,price) values('$order_sn','$user_id','$goods_id','$sku_id','$price')";
                $order_rs=mysqli_query($conn,$sql);

                 //库存减少
                $sql="update ih_store set number=number-{$number} where sku_id='$sku_id'"; $store_rs=mysqli_query($conn,$sql);
                if (mysqli_affected_rows($conn)) {
                    insertLog('库存减少成功');
                    flock($fp,LOCK_UN);//释放锁 
                } else {
                    insertLog('库存减少失败'); 
                }
            } else { 
                insertLog('库存不够');
            }
            fclose($fp);
        ```
- 优化方案4
    * 使用redis队列, 因为pop操作是原子的, 即使有很多用户同时到达, 也是依次执行, 推荐使用(mysql 事务在高并发下性能下降很厉害, 文件锁的方式也是)
        ```php
            // 1. 先将商品库存如队列
            $store = 1000;
            $redis = new Redis();
            $result = $redis->connect('127.0.0.1',6379); 
            $res = $redis->llen('goods_store');
            echo $res;
            $count = $store-$res;
            for ($i=0;$i<$count;$i++) {
                $redis->lpush('goods_store',1);
            }
            echo $redis->llen('goods_store');

            $count = $redis->lpop('goods_store');
            if (!$count) {
                insertLog('error:no store redis');
                return;
            }
        ```





