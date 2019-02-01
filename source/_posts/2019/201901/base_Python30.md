---
title: Python_基础 (30)
date: 2019-01-17
tags: Python
toc: true
---

### PyMongo
    Python3学习笔记

<!-- more -->

#### 安装
- 使用pip进行安装
    ```bash
        sudo pip install pymongo

        # 测试是否安装成功语句
        import pymongo
    ```

#### 使用
- 创建一个数据库
    * 注意 : 在 MongoDB 中,数据库只有在内容插入后才会创建
    ```python
        from pymongo import MongoClient

        client = MongoClient()
        db = client.llllljian

        或者
        import pymongo
 
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
    ```
- 判断数据库是否已存在
    * 注意 : database_names 在最新版本的 Python 中已废弃,Python3.7+ 之后的版本改为了 list_database_names()
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient('mongodb://localhost:27017/')
        dblist = myclient.list_database_names()
        # dblist = myclient.database_names() 
        if "llllljian" in dblist:
            print("数据库已存在！")
    ```
- 创建一个集合
    * 注意 : 在MongoDB中,集合只有在内容插入后才会创建
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        
        mycol = mydb["phone"]
    ```
- 判断集合是否已存在
    * 注意 : collection_names 在最新版本的 Python 中已废弃,Python3.7+ 之后的版本改为了 list_collection_names()
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient('mongodb://localhost:27017/')
        
        mydb = myclient['llllljian']
        
        collist = mydb. list_collection_names()
        # collist = mydb.collection_names()
        if "phone" in collist:
            print("集合已存在！")
    ```

#### 增
- 插入集合
    ```python
        #!/usr/bin/python3

        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        mycol = mydb["info"]
        
        mydict = { "name": "llllljian", "age": "23", "url": "https://www.llllljian.com" }
        
        x = mycol.insert_one(mydict)
        # 返回 InsertOneResult 对象
        print(x)
        # 返回_id字段
        print(x.inserted_id)
    ```
- 插入多个文档
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        mycol = mydb["sites"]
        
        mylist = [
        { "name": "Taobao", "alexa": "100", "url": "https://www.taobao.com" },
        { "name": "QQ", "alexa": "101", "url": "https://www.qq.com" },
        { "name": "Facebook", "alexa": "10", "url": "https://www.facebook.com" },
        { "name": "知乎", "alexa": "103", "url": "https://www.zhihu.com" },
        { "name": "Github", "alexa": "109", "url": "https://www.github.com" }
        ]
        
        x = mycol.insert_many(mylist)
        
        # 输出插入的所有文档对应的 _id 值
        print(x.inserted_ids)
    ```

#### 删
- 删除单条记录
    ```python
        #!/usr/bin/python3

        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        mycol = mydb["sites"]
        
        myquery = { "name": "Taobao" }
        
        mycol.delete_one(myquery)
        
        # 删除后输出
        for x in mycol.find():
            print(x)
    ```
- 删除多条记录
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        mycol = mydb["sites"]
        
        myquery = { "name": {"$regex": "^F"} }
        
        x = mycol.delete_many(myquery)
        
        print(x.deleted_count, "个文档已删除")
    ```
- 删除集合中所有文档
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        mycol = mydb["sites"]
        
        x = mycol.delete_many({})
        
        print(x.deleted_count, "个文档已删除")
    ```
- 删除集合
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljian"]
        mycol = mydb["sites"]
        
        mycol.drop()
    ```

#### 改
- 修改单个文档
    ```python
        import pymongo
 
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljiandb"]
        mycol = mydb["sites"]
        
        myquery = { "alexa": "10000" }
        newvalues = { "$set": { "alexa": "12345" } }
        
        mycol.update_one(myquery, newvalues)
        
        # 输出修改后的  "sites"  集合
        for x in mycol.find():
            print(x)
    ```
- 修改多个文档
    ```python
        import pymongo

        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljiandb"]
        mycol = mydb["sites"]
        
        myquery = { "name": { "$regex": "^F" } }
        newvalues = { "$set": { "alexa": "123" } }
        
        x = mycol.update_many(myquery, newvalues)
        
        print(x.modified_count, "文档已修改")
    ```

#### 查
- 查询一条数据
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljiandb"]
        mycol = mydb["sites"]
        
        x = mycol.find_one()
        
        print(x)
    ```
- 查询多条数据
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljiandb"]
        mycol = mydb["sites"]
        
        for x in mycol.find():
            print(x)
    ```
- 查询指定字段的数据
    ```python
        #!/usr/bin/python3
 
        import pymongo
        
        myclient = pymongo.MongoClient("mongodb://localhost:27017/")
        mydb = myclient["llllljiandb"]
        mycol = mydb["sites"]
        
        for x in mycol.find({},{ "_id": 0, "name": 1, "alexa": 1 }):
            print(x)
    ```


