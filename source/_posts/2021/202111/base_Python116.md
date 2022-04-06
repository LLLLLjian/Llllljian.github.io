---
title: Python_基础 (116)
date: 2021-11-18
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=Pymongo
    项目中因为字段多变, 所以觉得用mongo会好一点, 之前学的pymongo太浅了, 这次需要重新看一下

<!-- more -->

#### mongo的小操作
- 存在就更新, 不存在就新增
    ```sql
        #  
        db.products.update(
            {
                "date": "20211118",
                "type": "day"
            },
            {
                $set: {
                    "update_time": int(time.time())
                },
                $setOnInsert: {
                    "create_time": int(time.time())
                }
            },
            {
                upset: true
            }
        )
    ```
- 操作某个字段中的list
    * $in: 存在
        ```sql
            db.inventory.insertMany(
                [
                    { "item": "Pens", "quantity": 350, "tags": [ "school", "office" ] },
                    { "item": "Erasers", "quantity": 15, "tags": [ "school", "home" ] },
                    { "item": "Maps", "tags": [ "office", "storage" ] },
                    { "item": "Books", "quantity": 5, "tags": [ "school", "storage", "home" ] }
                ]
            )

            db.inventory.find( { quantity: { $in: [ 5, 15 ] } }, { _id: 0 } )

            # output
            { item: 'Erasers', quantity: 15, tags: [ 'school', 'home' ] },
            { item: 'Books', quantity: 5, tags: [ 'school', 'storage', 'home' ] }
        ```
    * $nin: 不存在
        ```sql
            db.inventory.insertMany(
                [
                    { "item": "Pens", "quantity": 350, "tags": [ "school", "office" ] },
                    { "item": "Erasers", "quantity": 15, "tags": [ "school", "home" ] },
                    { "item": "Maps", "tags": [ "office", "storage" ] },
                    { "item": "Books", "quantity": 5, "tags": [ "school", "storage", "home" ] }
                ]
            )

            db.inventory.find( { quantity: { $nin: [ 5, 15 ] } }, { _id: 0 } )

            # output
            { item: 'Pens', quantity: 350, tags: [ 'school', 'office' ] },
            { item: 'Maps', tags: [ 'office', 'storage' ] }
        ```


