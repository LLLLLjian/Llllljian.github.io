---
title: Interview_总结 (108)
date: 2020-06-30
tags: Interview
toc: true
---

### 面试题
    面试题汇总-海量数据查找Top20

<!-- more -->

#### 海量数据查找Top20
- 问题描述
    * 现在有10g文件, 其中每一行都是一个ip,  请列出该文件中出现次数最多的前20个
- 解题思路
    * 将文件内容一行一行读出来, 通过hash分别插入到100张表里, 然后再分别对表计算
- 实例
    * 想模仿一下这种海量数据的操作,  我先写了往文件中追加随机ip的php程序
        ```php
        <?php
                /**
                * File Name: roundNum.php
                **/
                $ip_long = array(
                    array('607649792', '608174079'), //36.56.0.0-36.63.255.255
                    array('1038614528', '1039007743'), //61.232.0.0-61.237.255.255
                    array('1783627776', '1784676351'), //106.80.0.0-106.95.255.255
                    array('2035023872', '2035154943'), //121.76.0.0-121.77.255.255
                    array('2078801920', '2079064063'), //123.232.0.0-123.235.255.255
                    array('-1950089216', '-1948778497'), //139.196.0.0-139.215.255.255
                    array('-1425539072', '-1425014785'), //171.8.0.0-171.15.255.255
                    array('-1236271104', '-1235419137'), //182.80.0.0-182.92.255.255
                    array('-770113536', '-768606209'), //210.25.0.0-210.47.255.255
                    array('-569376768', '-564133889'), //222.16.0.0-222.95.255.255
                );
                for ($i=0;$i<=10000;$i++) {
                    $rand_key = mt_rand(0, 9);
                    $ip = long2ip(mt_rand($ip_long[$rand_key][0], $ip_long[$rand_key][1]));
                    file_put_contents('./roundIp.log', $ip."\r\n", FILE_APPEND);
                }
        ```
    * shell命令行中直接循环执行
        ```bash
            for i in {1..10000}  ; do   php roundIp.php;   done
        ```
    * 海量数据成果
        ```bash
            [llllljian@llllljian-cloud-tencent php 13:39:39 #7]$ du -sh *
            10G	roundIp.log

            [llllljian@llllljian-cloud-tencent php 13:40:37 #8]$ wc -l roundIp.log
            700080001 roundIp.log
        ```
    * hash脚本
        ```php
            <?php
            /**
             * File Name: roundIpMysql.php
             **/
            header("Content-type: text/html; charset=utf-8");
            set_time_limit(0);
            ini_set("memory_limit", "-1");//去除内存限制
            ini_set('max_execution_time', 0);

            $dbms='mysql';
            $dbName='tentcent_tp';
            $user='root';
            $pwd='xxxx';
            $host='localhost';
            $charset = 'utf8';
            $dsn="$dbms:host=$host;dbname=$dbName;charset=$charset";
            try {
                $pdo=new PDO($dsn,$user,$pwd);
            } catch(Exception $e) {
                echo $e->getMessage();
            }

            $file = fopen("./roundIp.log","r");
            while(!feof($file))
            {
                $tempDecStr = trim(fgets($file));
                // 哈希加密
                $a = hash("sha256", $tempDecStr);
                // 50取余
                $b = $a%100;
                $table = "round_ip_" . $b;
                //插入
                $sql = "insert into ".$table."(ip) values(?)";
                //准备sql模板
                $stmt = $pdo->prepare($sql);
                //绑定参数
                $stmt->bindValue(1, $tempDecStr);
                $stmt->execute();
            }

            //释放查询结果
            $stmt = null;
            //关闭连接
            $pdo = null;
            fclose($file);
        ```
    * 每个表中取出现次数最多的前20条数据
        ```sql
            SELECT ip, COUNT(*) AS num
            FROM round_ip_0
            GROUP BY ip
            ORDER BY num desc limit 20
        ```
    * 再从2000条数据里取前20即可

- 存储结构批量建表
    ```sql
        DELIMITER $$
        CREATE  PROCEDURE `createTablesWithIndex`()
        BEGIN 
                DECLARE `@i` INT(11);     
                DECLARE `@createSql` VARCHAR(2560); 
                DECLARE `@createIndexSql1` VARCHAR(2560);
                DECLARE `@createIndexSql2` VARCHAR(2560);
                DECLARE `@createIndexSql3` VARCHAR(2560);
                DECLARE `@j` VARCHAR(10);

                SET `@i`=0; 
                WHILE  `@i`< 100 DO
                    SET `@j` = `@i`;
                        
                    SET @createSql = CONCAT('CREATE TABLE IF NOT EXISTS round_ip_',`@j`,'(
                        `id` bigint(18) UNSIGNED NOT NULL auto_increment COMMENT"注释",
                        `ip` VARCHAR(255) DEFAULT NULL,
                        PRIMARY KEY(id),
                        KEY `ip` (`ip`)) '
                    ); 
                    PREPARE stmt FROM @createSql; 
                    EXECUTE stmt;
                    SET `@i`= `@i`+1; 
                END WHILE;
        END
    ```



