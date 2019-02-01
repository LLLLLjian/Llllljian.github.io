---
title: MongoDB_基础 (4)
date: 2018-07-28
tags: MongoDB
toc: true
---

### MongoDB-PHP5
    php5用的是php-mongo.
    需要支持php-mongo扩展.
    安装过程可以参考网上,有很多.

<!-- more -->

#### 原生
- 确保连接及选择一个数据库
    ```php
        // 连接默认主机和端口为：mongodb://localhost:27017
        $m = new MongoClient(); 
        // 获取名称为 "test" 的数据库
        $db = $m->test; 
    ```
- 创建集合
    ```php
        // 连接
        $m = new MongoClient(); 
        // 获取名称为 "test" 的数据库
        $db = $m->test; 
        $collection = $db->createCollection("llllljian");
        echo "集合创建成功";
    ```
- 插入文档
    ```php
        // 连接到mongodb
        $m = new MongoClient();   
        // 选择一个数据库 
        $db = $m->llllljian;  
        // 选择集合
        $collection = $db->test1; 
        $document = array( 
            "name" => "llllljian",
            "description" => "test0",
            "ctime" => time()
        );
        $collection->insert($document);
        
        $document = array( 
            "name" => "llllljian",
            "description" => "test1",
            "ctime" => time()
        );
        $collection->insert($document);
        echo "数据插入成功";
    ```

    ```sql
        db.llllljian.find({ name: "llllljian" })       
    ```
- 查找文档
    ```php
        $m = new MongoClient();    
        $db = $m->llllljian;           
        $collection = $db->test1;

        $cursor = $collection->find();

        foreach ($cursor as $document) {
            echo $document["name"] . "\n";
        }
    ```
- 更新文档
    ```php
        $m = new MongoClient();    
        $db = $m->test;            
        $collection = $db->llllljian;
        // 更新
        $collection->update(
            array(
                "name"=>"llllljian"
            ), 
            array(
                '$set'=>array(
                    "time" => time()
                )
            )
        );
        // 显示更新后的文档
        $cursor = $collection->find();

        foreach ($cursor as $document) {
            echo date("Y-m-d H:i:s", $document["time"]) . "\n";
        }
    ```
- 删除文档
    ```php
        $m = new MongoClient();    
        $db = $m->test;            
        $collection = $db->llllljian; 
        
        // 移除文档
        $collection->remove(
            array(
                "description"=>"test1"
            ), 
            array(
                "justOne" => true
            )
        );

        $cursor = $collection->find();
        foreach ($cursor as $document) {
            echo $document["name"] . "\n";
        }
    ```
- GUI
    推荐使用rockmongo

#### 类封装
- 类
    ```php
        class baseMongodb 
        {
            /**
             * 当前链接
             */
            private $link = NULL;

            /**
             * 配置信息
             */
            private $config = array();


            // 最后一次执行的SQL
            public $lastQuerySql = null;
            public $auto_connect = true;
            protected $dummyTable = 'dual';

            // 自增id表 
            public $incCollection = "auto_increment_id";

            public function __construct($params) 
            {
                $this->config = array(
                    'hostname' => 'localhost',
                    'port' => '3306',
                    'username' => '',
                    'password' => '',
                    'database' => '',
                    'characterset' => 'gbk'
                );
                $this->config = array_merge($this->config, $params);
                if (!empty($this->config['port'])) {
                    $this->config['hostname'] = $this->config['hostname'] . ":" . $this->config['port'];
                }
            }

            /**
             *  连接数据库
             */
            private function _connect() 
            {

                try {
                    MongoCursor::$timeout = -1;
                    $mongoTag = "mongodb://";
                    if ($this->config['username']) {
                        $mongoTag .= $this->config['username'] . ':' . $this->config['password'] . '@';
                    }
                    $mongoTag .= $this->config['hostname'] . '/' . $this->config['database'];

                    $this->link = new MongoClient($mongoTag);
                } catch (Exception $ex) {
                    $this->errors = $ex->getMessage();
                    echo $this->errors;
                }

                return $this->link;
            }

            /**
             * 取数据库配置信息
             *
             */
            public function getConfig() 
            {
                return $this->config;
            }

            /**
             * 获取数据库连接资源
             */
            public function getConnection() 
            {
                if ($this->link == NULL) {
                    $this->_connect();
                }
                return $this->link;
            }

            /**
             * 返回MongoDB表
             */
            public function getCollection($coll_name) 
            {
                $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);
                return $collection;
            }

            /**
             *
             * @param $coll_name 表名
             * @param $values 插入内容
             * @param $returnInsertId 是否返回自增id
             * @param $needIncId 是否需要将_id设置为自增id
             */
            public function insert($coll_name, $values, $returnInsertId = false, $needIncId = false, $options=array()) 
            {
                if ($values) {
                    if ($this->config['characterset'] && ($this->config['characterset'] != 'utf8' || $this->config['characterset'] != 'utf-8')) {
                        $values = iconv_array($this->config['characterset'], 'utf-8', $values);
                    }

                    if ($needIncId) {
                        $condition = array("_id" => $coll_name);
                        $fields = null;
                        $counterIdRow = $this->fetchRow($this->incCollction, $condition, $fields);

                        if (empty($counterIdRow)) {
                            $insertArr = array(
                                "_id" => $coll_name,
                                "maxId" => 1
                            );
                            $this->insert($this->incCollction, $insertArr);
                            $value['_id'] = 1;
                        } else {
                            $new_values['$inc'] = array("maxId" => 1);
                            $value['_id'] = $this->findAndModify($this->incCollction, $new_values, $condition, true);
                        }
                    }

                    $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);

                    $flag = $collection->insert($values,$options);

                    if ($returnInsertId) {
                        if (is_object($values['_id'])) {
                            return $values['_id']->__toString();
                        }
                        else {
                            return $values['_id'];
                        }
                    }
                    return $flag;
                }
                else {
                    throw new Exception('function Mongodb->insert() param $values is not allow null');
                }
            }

            /**
             *
             * 同上,跟insert区别,效率低于insert,但是save的数据存在就修改,不存在就新增
             */
            public function save($coll_name, array $values, $returnInsertId = false,$options = array()) 
            {
                if ($values) {
                    if ($this->config['characterset'] && ($this->config['characterset'] != 'utf8' || $this->config['characterset'] != 'utf-8')) {
                        $values = iconv_array($this->config['characterset'], 'utf-8', $values);
                    }

                    $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);

                    $flag = $collection->save($values, $options);

                    if ($returnInsertId) {
                        if (is_object($values['_id'])) {
                            return $values['_id']->__toString();
                        }
                        else {
                            return $values['_id'];
                        }
                    }
                    return $flag;
                }
                else {
                    throw new Exception('function Mongodb->save() param $values is not allow null');
                }
            }

            /**
             * 批量插入
             */
            public function insertMultiRows($coll_name, $data,$options=array()) 
            {
                if (!$data) {
                    return false;
                }
                if ($this->config['characterset'] && ($this->config['characterset'] != 'utf8' || $this->config['characterset'] != 'utf-8')) {
                    $data = iconv_array($this->config['characterset'], 'utf-8', $data);
                }

                $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);
                $flag = $collection->batchInsert($data,$options);
                return $flag;
            }

            /**
             * 修改数据
             */
            public function update($coll_name, array $newValues, $where, $op = '$set', $affectRows = false,$options = array()) 
            {

                if (!$newValues) {
                    throw new Exception('function Mongodb->update() param $newValues is not allow null');
                }

                if (!$where) {
                    throw new Exception('function Mongodb->update() param $where is not allow null');
                }

                if ($this->config['characterset'] && ($this->config['characterset'] != 'utf8' || $this->config['characterset'] != 'utf-8')) {
                    $newValues = iconv_array($this->config['characterset'], 'utf-8', $newValues);
                }
                $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);

                if (!$options['multiple']) {
                    $option['multiple'] = true;
                }

                $update = array(
                    $op => $newValues
                );

                $rs = $collection->update($where, $update, $option);
                if ($rs['ok'] == 1) {
                    if ($affectRows) {
                        return $rs['nModified'];
                    }
                    else {
                        return true;
                    }
                }
                else {
                    return false;
                }
            }

            /**
             *  取得一行数据
             */
            public function fetchOne($coll_name, $condition = array(), $fields = null) 
            {
                if (!$fields) {
                    $fields = array();
                }
                else if ($fields && is_string($fields)) {
                    $fields = $this->getFieldsArr($fields);
                }
                $result = $this->fetchRow($coll_name, $condition, $fields);
                if ($fields) {
                    $key = array_shift($fields);
                }
                if ($result) {
                    return $result[$key];
                }
                return false;
            }

            /**
             * 返回一条数据
             */
            public function fetchRow($coll_name, $condition = array(), $fields = null) 
            {
                if (!$fields) {
                    $fields = array();
                }
                else if ($fields && is_string($fields)) {
                    $fields = $this->getFieldsArr($fields);
                }

                $result = $this->getConnection()->selectCollection($this->config['database'], $coll_name)->findOne($condition, $fields);
                //Èç¹ûÄ¿±ê×Ö·û¼¯²»ÊÇutf8,Ôò×ª»»³Éutf8
                if ($this->config['characterset'] && ($this->config['characterset'] != 'utf8' || $this->config['characterset'] != 'utf-8')) {
                    $result = iconv_array('utf-8', $this->config['characterset'], $result);
                }
                return $result;
            }

            /**
             * 返回文档条数
             */
            public function count($coll_name, $condition = array())
            {
                $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);
                return $collection->count($condition);
            }

            /**
             * 返回所有数据
             */
            public function fetchAll($coll_name, $condition = array(), $fields = array(), $limit=0, $skip=0, $sort=null) 
            {
                if (!$fields) {
                    $fields = array();
                }
                else if ($fields && is_string($fields)) {
                    $fields = $this->getFieldsArr($fields);
                }

                if (!$condition) {
                    $condition = array();
                }
                if (!$fields) {
                    $fields = array();
                }

                $cursor = $this->getConnection()->selectCollection($this->config['database'], $coll_name)->find($condition, $fields);
                if (is_numeric($skip) && $skip > 0) {
                    $cursor->skip($skip);
                }
                if (is_numeric($limit) && $limit > 0) {
                    $cursor->limit($limit);
                }
                if ($sort) {
                    $cursor->sort($sort);
                }

                if (!empty($result_filter['wrapped'])) {
                    $wrapped = $result_filter['wrapped'];
                }
                $result = array();
                $this->cursor = $cursor;
                try {
                    while ($ret = $cursor->getNext()) {
                        $result[] = $ret;
                    }
                }
                catch (Exception $ex) {
                    $this->errors = $ex->getMessage();
                }
                //Èç¹ûÄ¿±ê×Ö·û¼¯²»ÊÇutf8,Ôò×ª»»³Éutf8
                if ($this->config['characterset'] && ($this->config['characterset'] != 'utf8' || $this->config['characterset'] != 'utf-8')) {
                    $result = iconv_array('utf-8', $this->config['characterset'], $result);
                }
                return $result;
            }

            public function getFetchCursor($coll_name, $condition = array(), $fields = array(),$limit=0,$skip=0,$sort=null)
            {
                if (!$fields) {
                    $fields = array();
                }
                else if ($fields && is_string($fields)) {
                    $fields = $this->getFieldsArr($fields);
                }

                if (!$condition) {
                    $condition = array();
                }
                if (!$fields) {
                    $fields = array();
                }

                $cursor = $this->getConnection()->selectCollection($this->config['database'], $coll_name)->find($condition, $fields);
                if (is_numeric($skip) && $skip > 0) {
                    $cursor->skip($skip);
                }
                if (is_numeric($limit) && $limit > 0) {
                    $cursor->limit($limit);
                }
                if ($sort) {
                    $cursor->sort($sort);
                }

                $this->cursor = $cursor;

                return $this->cursor;
            }

            /*
             * 获取展示字段 
             */
            private function getFieldsArr($field_str)
            {
                $field_arr = explode(',', $field_str);

                $tmp_fields = array();
                if(!empty($field_arr)){
                    foreach($field_arr as $field){
                        $field = trim($field);
                        if(!empty($field)){
                            $tmp_fields[$field] = true;
                        }
                    }
                    unset($field);
                }

                return $tmp_fields;
            }

            /**
             * 删除 
             */
            public function delete($coll_name, $where, $affectRows = false, $options = array('justOne' => false)) 
            {
                if (!$where) {
                    throw new Exception('function Mongodb->update() param $where is not allow null');
                }

                $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);
                $opt['justOne'] = $options['justOne'];
                $rs = $collection->remove($where, $opt);

                if ($rs['ok'] == 1) {
                    if ($affectRows) {
                        return $rs['n'];
                    }
                    else {
                        return true;
                    }
                }
                else {
                    return false;
                }
            }

            /**
             * 设置自增id
             * $affectRows 是否返回修改的行数
             * $options 返回值的内容,默认是更新后的
             */
            public function findAndModify($coll_name, $newValues, $where, $affectRows = false, $options = array("new" => true)) 
            {
                $collection = $this->getConnection()->selectCollection($this->config['database'], $coll_name);
                
                $fields = array("_id" =>0);

                $rs = $collection->findAndModify($where, $newValues, $fields, $options);

                if ($affectRows) {
                    return current($rs);
                }
            }

            /**
             * 取最后一次执行错误的信息
             */
            public function getErrorText() 
            {
                $rs = $this->getErrorArray();
                return $rs['error'];
            }

            /**
             * 获取最后一次执行的sql及错误信息
             */
            public function getErrorArray() 
            {
                $mongodb = $this->getConnection();
                $rs = $mongodb->lastError();

                $result['errno'] = $rs['n'];
                $result['error'] = $rs['err'];
                $result['sql'] = $this->lastQuerySql;
                return $result;
            }

            /**
             * 手动关闭数据库连接
             */
            public function closeConnection() 
            {
                $this->link = null;
            }

            /**
             * 对象被销毁时执行清理操作,关闭数据库连接
             */
            public function __destruct() 
            {
                $this->closeConnection();
            }
        }
    ```

        