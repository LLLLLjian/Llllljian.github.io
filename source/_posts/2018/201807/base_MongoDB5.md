---
title: MongoDB_基础 (5)
date: 2018-07-29
tags: MongoDB
toc: true
---

### MongoDB-PHP7
    php7用的是php-Mongdb.
    需要支持php-Mongdb扩展.
    php-mongo已经被移除.
    安装过程可以参考网上,有很多.

<!-- more -->

#### 原生
- 确保连接及选择一个数据库
    ```php
        $manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");
    ```
- 插入文档
    ```php
        $bulk = new MongoDB\Driver\BulkWrite;
        $document = ['_id' => new MongoDB\BSON\ObjectID, 'name' => 'llllljian'];

        $_id= $bulk->insert($document);

        $manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");  
        $writeConcern = new MongoDB\Driver\WriteConcern(MongoDB\Driver\WriteConcern::MAJORITY, 1000);
        $result = $manager->executeBulkWrite('llllljian.test3', $bulk, $writeConcern);
    ```

    ```sql
        db.getCollection('test3').find({name:"llllljian"})
    ```
- 读取文档
    ```php
        $manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");  

        // 插入数据
        $bulk = new MongoDB\Driver\BulkWrite;
        $bulk->insert(['x' => 1, 'name'=>'1']);
        $bulk->insert(['x' => 2, 'name'=>'2']);
        $bulk->insert(['x' => 3, 'name'=>'3']);
        $manager->executeBulkWrite('llllljian.test3', $bulk);

        $filter = ['x' => ['$gt' => 1]];
        $options = [
            'projection' => ['_id' => 0],
            'sort' => ['x' => -1],
        ];

        // 查询数据
        $query = new MongoDB\Driver\Query($filter, $options);
        $cursor = $manager->executeQuery('llllljian.test3', $query);

        foreach ($cursor as $document) {
            print_r($document);
        }
    ```

    ```sql
        db.test3.find({ x: { $gt: 1} }, {_id: 0}).sort(x: -1);
    ```
- 更新文档
    ```php
        $bulk = new MongoDB\Driver\BulkWrite;
        $bulk->update(
            ['x' => 2],
            ['$set' => ['name' => '4']],
            ['multi' => false, 'upsert' => false]
        );

        $manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");  
        $writeConcern = new MongoDB\Driver\WriteConcern(MongoDB\Driver\WriteConcern::MAJORITY, 1000);
        $result = $manager->executeBulkWrite('llllljian.test3', $bulk, $writeConcern);
    ```

    ```sql
        db.getCollection('test3').find({x:"2"})
    ```
- 删除文档
    ```php
        $bulk = new MongoDB\Driver\BulkWrite;
        $bulk->delete(['x' => 1], ['limit' => 1]);   // limit 为 1 时，删除第一条匹配数据
        $bulk->delete(['x' => 2], ['limit' => 0]);   // limit 为 0 时，删除所有匹配数据

        $manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");  
        $writeConcern = new MongoDB\Driver\WriteConcern(MongoDB\Driver\WriteConcern::MAJORITY, 1000);
        $result = $manager->executeBulkWrite('llllljian.test3', $bulk, $writeConcern);
    ```
- GUI
    rockmongo需要用到php-mongo扩展,如果你的机器php5和php7都有的话可以用
    如果你只有php7,推荐使用robo3t

#### 类封装
- 类
    ```php
        baseMongodb.class.php
        <?php
        /**
         * File Name: baseMongodb.class.php
         * Author: llllljian
         * Created Time: 2018年07月28日 星期六 16时20分24秒
         **/

        class m_mgdb 
        {
            //--------------  定义变量  --------------//
            private static $ins     = [];
            private static $def     = "default";
            private $_conn          = null;
            private $_db            = null;
            private static $_config = [
                "default" => ["url" => "mongodb://127.0.0.1:27017","dbname" => "llllljian"]
            ];


            /**
             * 创建实例
             * @param  string $confkey
             * @return \m_mgdb
             */
            static function i($confkey = NULL) {
                if (!$confkey) {
                    $confkey = self::$def;
                }
                if (!isset(self::$ins[$confkey]) && ($conf = self::$_config[$confkey])) {
                    $m = new m_mgdb($conf);
                    self::$ins[$confkey] = $m;
                }
                return self::$ins[$confkey];
            }


            /**
             * 构造方法
             * 单例模式
             */
            private function __construct(array $conf) {
                $this->_conn = new MongoDB\Driver\Manager($conf["url"]."/{$conf["dbname"]}");
                $this->_db   = $conf["dbname"];
            }


            /**
             * 插入数据
             * @param  string $collname
             * @param  array  $documents    [["name"=>"values", ...], ...]
             * @param  array  $writeOps     ["ordered"=>boolean,"writeConcern"=>array]
             * @return \MongoDB\Driver\Cursor
             */
            function insert($collname, array $documents, array $writeOps = []) {
                $cmd = [
                    "insert"    => $collname,
                    "documents" => $documents,
                ];
                $cmd += $writeOps;
                return $this->command($cmd);
            }


            /**
             * 删除数据
             * @param  string $collname
             * @param  array  $deletes      [["q"=>query,"limit"=>int], ...]
             * @param  array  $writeOps     ["ordered"=>boolean,"writeConcern"=>array]
             * @return \MongoDB\Driver\Cursor
             */
            function del($collname, array $deletes, array $writeOps = []) {
                foreach($deletes as &$_){
                    if(isset($_["q"]) && !$_["q"]){
                        $_["q"] = (Object)[];
                    }
                    if(isset($_["limit"]) && !$_["limit"]){
                        $_["limit"] = 0;
                    }
                }
                $cmd = [
                    "delete"    => $collname,
                    "deletes"   => $deletes,
                ];
                $cmd += $writeOps;
                return $this->command($cmd);
            }


            /**
             * 更新数据
             * @param  string $collname
             * @param  array  $updates      [["q"=>query,"u"=>update,"upsert"=>boolean,"multi"=>boolean], ...]
             * @param  array  $writeOps     ["ordered"=>boolean,"writeConcern"=>array]
             * @return \MongoDB\Driver\Cursor
             */
            function update($collname, array $updates, array $writeOps = []) {
                $cmd = [
                    "update"    => $collname,
                    "updates"   => $updates,
                ];
                $cmd += $writeOps;
                return $this->command($cmd);
            }


            /**
             * 查询
             * @param  string $collname
             * @param  array  $filter     [query]     参数详情请参见文档.
             * @return \MongoDB\Driver\Cursor
             */
            function query($collname, array $filter, array $writeOps = []){
                $cmd = [
                    "find"      => $collname,
                    "filter"    => $filter
                ];
                $cmd += $writeOps;
                return $this->command($cmd);
            }


            /**
             * 执行MongoDB命令
             * @param array $param
             * @return \MongoDB\Driver\Cursor
             */
            function command(array $param) {
                $cmd = new MongoDB\Driver\Command($param);
                return $this->_conn->executeCommand($this->_db, $cmd);
            }


            /**
             * 获取当前mongoDB Manager
             * @return MongoDB\Driver\Manager
             */
            function getMongoManager() {
                return $this->_conn;
            }
        }
    ```
- 使用
    ```php
        mongodbTest1.php
        <?php
        /**
         * File Name: mongodbTest1.php
         * Author: llllljian
         * mail: 18634678077@163.com
         * Created Time: 2018年07月28日 星期六 16时20分56秒
         **/

        require_once 'baseMongodb.class.php';

        $db = m_mgdb::i();         // 使用配置self::$_config[self::$def]
        $collname = "test1";

        echo "\n---------- 删除 proinfo 所有数据 -----------\n";
        $delets = [
            ["q" => [],"limit" => 0]
        ];
        // $rs = $db->del($collname, $delets);
        // print_r($rs->toArray());


        echo "\n---------- 创建索引 -----------\n";
        $cmd = [
            "createIndexes" => $collname,
            "indexes"       => [
                ["name" => "proname_idx", "key" => ["name"=>1],"unique" => true],
            ],
        ];
        // $rs = $db->command($cmd);
        // print_r($rs->toArray());


        echo "\n---------- 查询索引 -----------\n";
        $cmd = [
            "listIndexes" => $collname,
        ];
        // $rs = $db->command($cmd);
        // print_r($rs->toArray());


        echo "\n------------ 插入数据 ---------\n";
        $rows = [
            ["name" => "ns w1","type"=>"ns","size"=>["height"=>150,"width"=>30],"price"=>3000],
            ["name" => "ns hd","type"=>"ns","size"=>["height"=>154,"width"=>30],"price"=>3500],
            ["name" => "ns w3","type"=>"ns","size"=>["height"=>160,"width"=>30],"price"=>3800],
            ["name" => "bt s1","type"=>"bt","size"=>["height"=>158,"width"=>32],"price"=>3500],
            ["name" => "bt w1","type"=>"bt","size"=>["height"=>157,"width"=>30],"price"=>3600],
            ["name" => "an w1","type"=>"bt","size"=>["height"=>157,"width"=>30],"price"=>3700],
            ["name" => "wn w6","type"=>"wn","size"=>["height"=>157,"width"=>30],"price"=>3500],
        ];
        // $rs = $db->insert($collname, $rows);
        // print_r($rs->toArray());


        echo "\n---------- 查询数据 -----------\n";
        $filter = [
            "name" => ['$regex' => '\sw\d'], // mongo 正则匹配
            '$or'  => [["type"  => "bt"], ["size.height" => ['$gte' => 160]]]
        ];
        $queryWriteOps = [
            "projection" => ["_id"   => 0],
            "sort"       => ["price" => -1],
            "limit"      => 20
        ];
        // $rs = $db->query($collname, $filter, $queryWriteOps);
        // print_r($rs->toArray());


        echo "\n---------- 更新数据 -----------\n";
        $updates = [
            [
                "q"     => ["name" => "ns w3"],
                "u"     => ['$set' => ["size.height" => 140],'$inc' => ["size.width" => 14]],
                "multi" => true,
            ]
        ];
        // $rs = $db->update($collname, $updates);
        // print_r($rs->toArray());


        echo "\n---------- 查询数据 -----------\n";
        $filter = [
            "name" => "ns w3",
        ];
        // $rs = $db->query($collname, $filter, $queryWriteOps);
        // print_r($rs->toArray());
    ```
