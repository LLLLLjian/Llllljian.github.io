---
title: MongoDB_基础 (3)
date: 2018-07-27
tags: MongoDB
toc: true
---

### MongoDB-CRUD
    CRUD操作就是创建,读取,更新,删除文档.

<!-- more -->

#### 创建C
- 创建
    * MySQL
        ```sql
            1. 建表语句
            CREATE TABLE users (
                id MEDIUMINT NOT NULL AUTO_INCREMENT,
                user_id Varchar(30),
                age Number,
                status char(1),
                PRIMARY KEY (id)
            )
        ```
    * MongoDB
        ```sql
            1. 第一次执行insert操作时隐式创建.如果文档中不指定_id,那么会自动添加_id列并默认为主键
            > show collections
            counters
            system.indexes
            system.js
            test1
            test2
            > db.users.insert( {
            ...     user_id: "abc123",
            ...     age: 55,
            ...     status: "A"
            ...  } )
            WriteResult({ "nInserted" : 1 })
            > show collections
            counters
            system.indexes
            system.js
            test1
            test2
            users

            2. 显式创建
            > db.createCollection("users1")
            { "ok" : 1 }
            > show collections
            counters
            system.indexes
            system.js
            test1
            test2
            users
            users1
        ```
- 修改表结构
    * MySQL
        ```sql
            1. 添加列
            ALTER TABLE users ADD join_date DATETIME

            2. 删除列
            ALTER TABLE users DROP COLUMN join_date

            3. 添加单个索引
            CREATE INDEX idx_user_id_asc ON users(user_id)

            4. 添加组合索引
            CREATE INDEX idx_user_id_asc_age_desc ON users(user_id, age DESC)
        ```
    * MongoDB
        ```sql
            1. 添加列
            db.users.update(
                { },
                { $set: { join_date: new Date() } },
                { multi: true }
            )

            2. 删除列
            db.users.update(
                { },
                { $unset: { join_date: "" } },
                { multi: true }
            )

            3. 添加单个索引
            db.users.createIndex( { user_id: 1 } )

            4. 添加组合索引
            db.users.createIndex( { user_id: 1, age: -1 } ) 
        ```      
- 新增数据
    * MySQL
        ```sql
            1. 添加数据
            INSERT INTO users(user_id, age, status) VALUES ("bcd001", 45, "A")
        ```
    * MongoDB
        ```sql
            1. 添加数据
            db.users.insert({ user_id: "bcd001", age: 45, status: "A" })
        ```

#### 读取R
- MySQL
    ```sql
        1. 展示所有内容
        SELECT * FROM users

        2. 列出指定字段
        SELECT id, user_id, status FROM users
        SELECT user_id, status FROM users

        3. 列出status等于A的
        SELECT * FROM users WHERE status = "A"

        4. 列出status不等于A的
        SELECT * FROM users WHERE status != "A"

        5. 条件且
        SELECT * FROM users WHERE status = "A" AND age = 50

        6. 条件或
        SELECT * FROM users WHERE status = "A" OR age = 50

        7. 大于等于小于
        SELECT * FROM users WHERE age > 25 AND age <= 50

        8. 模糊查询
        SELECT * FROM users WHERE user_id like "%bc%"
        SELECT * FROM users WHERE user_id like "bc%"

        9. 排序
        SELECT *FROM users WHERE status = "A" ORDER BY user_id ASC
        SELECT * FROM users WHERE status = "A" ORDER BY user_id DESC

        10. 得到[指定字段或全部字段]条数
        SELECT COUNT(*) FROM users
        SELECT COUNT(user_id) FROM users
        SELECT COUNT(*) FROM users WHERE age > 30

        11. 去重
        SELECT DISTINCT(status) FROM users

        12. 取部分
        SELECT * FROM users LIMIT 1
        SELECT * FROM users LIMIT 5 SKIP 10
        SELECT * FROM users LIMIT 10,5

        13. 慢查询分析
        EXPLAIN SELECT * FROM users WHERE status = "A"
    ```
- MongoDB
    ```sql
        1. 展示所有内容
        db.users.find()

        2. 列出指定字段
        db.users.find({ },{ user_id: 1, status: 1 })
        db.users.find({ }, { user_id: 1, status: 1, _id: 0 })

        3. 列出status等于A的
        db.users.find({ status: "A" })

        4. 列出status不等于A的
        db.users.find({ status: { $ne: "A" } })

        5. 条件且
        db.users.find({ status: "A", age: 50 })

        6. 条件或
        db.users.find({ $or: [ { status: "A" } , { age: 50 } ] })

        7. 大于等于小于
        db.users.find({ age: { $gt: 25, $lte: 50 } })

        8. 模糊查询
        db.users.find( { user_id: /bc/ } )
        db.users.find( { user_id: /^bc/ } )

        9. 排序
        db.users.find( { status: "A" } ).sort( { user_id: 1 } )
        db.users.find( { status: "A" } ).sort( { user_id: -1 } )

        10. 得到[指定字段或全部字段]条数
        db.users.count()
        db.users.find().count()
        db.users.count( { user_id: { $exists: true } } )
        db.users.find( { user_id: { $exists: true } } ).count()
        db.users.count( { age: { $gt: 30 } } )
        db.users.find( { age: { $gt: 30 } } ).count()

        11. 去重
        db.users.distinct( "status" )

        12. 取部分
        db.users.findOne()
        db.users.find().limit(1)
        db.users.find().limit(5).skip(10)

        13. 慢查询分析
        db.users.find( { status: "A" } ).explain()
    ```

#### 更新U
- MySQL
    ```sql
        1. 指定条件修改
        UPDATE users SET status = "C" WHERE age > 25

        2. 自增[自减]指定数值
        UPDATE users SET age = age + 3 WHERE status = "A"
    ```
- MongoDB
    ```sql
        1. 指定条件修改
        db.users.update(
            { age: { $gt: 25 } },
            { $set: { status: "C" } },
            { multi: true }
        )

        2. 自增[自减]指定数值
        db.users.update(
            { status: "A" } ,
            { $inc: { age: 3 } },
            { multi: true }
        )
    ```

#### 删除D
- MySQL
    ```sql
        1. 删除表
        DROP TABLE users

        2. 指定数据删除
        DELETE FROM users WHERE status = "D"

        3. 删除全部数据
        DELETE FROM users
    ```
- MongoDB
    ```sql
        1. 删除表
        db.users.drop()

        2. 指定数据删除
        db.users.remove( { status: "D" } )

        3. 删除全部数据
        db.users.remove({})
    ```