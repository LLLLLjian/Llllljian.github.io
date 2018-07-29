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
        $collection = $db->createCollection("runoob");
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
        $collection = $db->runoob;
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
        $collection = $db->runoob; 
        
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
