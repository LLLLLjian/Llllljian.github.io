---
title: PHP_批量取数据
date: 2017-12-10
tags: PHP
toc: true
---

## 从MySQL数据库中批量取数据

### 以id为维度进行批量取数据

``` php
    取最小id和最大id."SELECT MIN(id) minId, MAX(id) maxId FROM 表名"
    $startId = $minId;
    $tempSize = 1000;
    $tempSql = "SELECT * FROM 表名 WHERE id >= ? AND id < ?";
    while ($startId <= $maxId>) {
        $tempBind = [];
        $tempBind[0] = $startId;       
        $tempId = $startId + $tempSize;
        if ($tempId > $maxId>) {
            $tempBind[1] = $maxId + 1;
        } else {
             $tempBind[1] = $tempId;
        }
        //pdo绑定参数
        $tempRes = $pdo->fetchAll($tempSql, $tempBind);

        $startId = $tempId;
    }
```

<!-- more-->

### 以时间为维度进行批量取数据

``` php
    取起始时间和截止时间的时间戳.$sTime $eTime
    $startTime = $sTime;
    $tempSql = "SELECT * FROM 表名 WHERE time >= ? AND time < ?";
    while ($startTime < $eTime>) {
        $tempBind = [];
        $tempBind[0] = $startTime;       
        $tempTime = $startTime + 86400;
        $tempBind[1] = $tempTime;

        $tempRes = $pdo->fetchAll($tempSql, $tempBind);
        $startTime = $tempTime;
    }
```

### 根据limit进行批量取数据       

``` php
    $loop = 1;
    $startId = 0;
    $size = 1000;
    $res = array();
    $sql = "SELECT * FROM 表名 WHERE id > ? LIMIT ? ORDER BY id";

    while (($loop == 1) || (count($res) == $size)) {
        $loop = 0;
        $bind = [];
        $bind[0] = $startId;
        $bind[1] = $size;

        $res = $pdo->fetchAll($sql, $bind);
        if (!empty($res)) {
            foreach($res as $row) {
                $row['id'] > $startId ? $startId = $row['id'] : ;
            }
        }
    }
```