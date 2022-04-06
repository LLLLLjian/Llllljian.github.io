---
title: Python_基础 (135)
date: 2022-01-20
tags: 
    - MongoDB
    - Python
toc: true
---

### 今日份填坑
    记一下自己今日份学到的知识

<!-- more -->

#### 知识点1
> 解决ReferenceError: weakly-referenced object no longer exists
- 问题代码1
    ```python
        import mysql.connector

        db_info = dict()
        db_info['host'] = ‘127.0.0.1’
        db_info['port'] = 3306
        db_info['user'] = ‘root’
        db_info['passwd'] = 'root'
        db_info['database'] = 'test'
        cur = mysql.connector.connect(**db_info).cursor()
        cur.execute("SHOW databases;")

        File "/usr/lib64/python2.7/site-packages/mysql/connector/cursor_cext.py", line 232, in execute
            if not self._cnx:
        ReferenceError: weakly-referenced object no longer exists
    ```
- 解决方案1
    ```python
        # 需要分开两步写
        conn = mysql.connector.connect(**db_info)
        cur = conn.cursor()
    ```
- 问题代码1
    ```python
        user_queryset = User.objects.filter(username="xxx")
        if user_queryset:
            user_detail = user_queryset.get().detail
        else:
            user_detail = "xxxx"
        # 反正就是要修改 user_detail, 然后就会报错
        user_detail = user_detail.split(",")
    ```
- 解决方案2
    ```python
        # 需要分开两步写
        user_queryset = User.objects.filter(username="xxx").get()
        user_detail = user_queryset.detail
    ```

#### 知识点2
> 我把mongo和mysql关联用做了优化, 做完之后需要列出优化之后的表大小, 数据化一下优化结果. 怎么显示mongo各个表大小和mysql各个表大小
1. mongo显示整个数据库
    * 默认是bytes单位
    ```sql
        db.stats();

        {
            "db" : "xxx",   //当前数据库
            "collections" : 27,  //当前数据库多少表 
            "objects" : 18738550,  //当前数据库所有表多少条数据
            "avgObjSize" : 1153.54876188392, //每条数据的平均大小
            "dataSize" : 21615831152.0,  //所有数据的总大小
            "storageSize" : 23223312272.0,  //所有数据占的磁盘大小 
            "numExtents" : 121,
            "indexes" : 26,   //索引数 
            "indexSize" : 821082976,  //索引大小 
            "fileSize" : 25691160576.0,  //预分配给数据库的文件大小
            "nsSizeMB" : 16,
            "dataFileVersion" : {
                "major" : 4,
                "minor" : 5
            },
            "extentFreeList" : {
                "num" : 1,
                "totalSize" : 65536
            },
            "ok" : 1.0
        }

        scale参数: 可以通过传参数, 比如
        db.stats(1024) //得到的是 KB 单位的
        db.stats(1073741824); //得到的是 G 单位的
    ```
2. mongo查看数据库表
    ```sql
        db.posts.stats(); 

        { 
            "ns" : "test.posts", 
            "count" : 1, 
            "size" : 56, 
            "avgObjSize" : 56, 
            "storageSize" : 8192, 
            "numExtents" : 1, 
            "nindexes" : 1, 
            "lastExtentSize" : 8192, 
            "paddingFactor" : 1, 
            "systemFlags" : 1, 
            "userFlags" : 0, 
            "totalIndexSize" : 8176, 
            "indexSizes" : { 
                "_id_" : 8176 
            }, 
            "ok" : 1 
        }
    ```
3. mysql查看所有数据库
    ```sql
        SELECT
            table_schema,
            SUM( data_length + index_length ) / 1024 / 1024 AS total_mb,
            SUM( data_length ) / 1024 / 1024 AS data_mb,
            SUM( index_length ) / 1024 / 1024 AS index_mb,
            COUNT( * ) AS TABLES,
            CURDATE( ) AS today 
        FROM
            information_schema.TABLES 
        GROUP BY
            table_schema 
        ORDER BY
            2 DESC;
    ```
4. mysql查看某个库
    ```sql
        SELECT
            CONCAT( TRUNCATE ( SUM( data_length ) / 1024 / 1024, 2 ), 'mb' ) AS data_size,
            CONCAT( TRUNCATE ( SUM( max_data_length ) / 1024 / 1024, 2 ), 'mb' ) AS max_data_size,
            CONCAT( TRUNCATE ( SUM( data_free ) / 1024 / 1024, 2 ), 'mb' ) AS data_free,
            CONCAT( TRUNCATE ( SUM( index_length ) / 1024 / 1024, 2 ), 'mb' ) AS index_size 
        FROM
            information_schema.TABLES 
        WHERE
            table_schema = 'test';
    ```

