---
title: Python_基础 (114)
date: 2021-11-16
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=Pymongo
    项目中因为字段多变, 所以觉得用mongo会好一点, 之前学的pymongo太浅了, 这次需要重新看一下

<!-- more -->

#### mongo的聚合管道
> 得学一下mongo里的聚合 还挺常见、重要的
- collection
    ```
        {
            "_id" : ObjectId("5951c5de567ebff0d5011fba"),
            "name" : "小明",
            "address" : "北京",
            "weekday" : [ 
                1, 
                2, 
                3, 
                4, 
                5
            ]
        }
    ```
- code
    ```sql
        db.getCollection('test').aggregate(
            [
                {
                    $unwind:"$weekday"
                }
            ]
        )

        /* 1 */
        {
            "_id" : ObjectId("5951c5de567ebff0d5011fba"),
            "name" : "小明",
            "address" : "北京",
            "weekday" : 1
        }
        
        /* 2 */
        {
            "_id" : ObjectId("5951c5de567ebff0d5011fba"),
            "name" : "小明",
            "address" : "北京",
            "weekday" : 2
        }
        
        /* 3 */
        {
            "_id" : ObjectId("5951c5de567ebff0d5011fba"),
            "name" : "小明",
            "address" : "北京",
            "weekday" : 3
        }
        
        /* 4 */
        {
            "_id" : ObjectId("5951c5de567ebff0d5011fba"),
            "name" : "小明",
            "address" : "北京",
            "weekday" : 4
        }
        
        /* 5 */
        {
            "_id" : ObjectId("5951c5de567ebff0d5011fba"),
            "name" : "小明",
            "address" : "北京",
            "weekday" : 5
        }
    ```
- collection1
    ```
        {
            "_id" : ObjectId("5951ca15567ebff0d5011fbb"),
            "name" : "小明",
            "address" : "北京",
            "lunch" : [ 
                {
                    "food" : "baozi",
                    "fruit" : "taozi"
                }, 
                {
                    "food" : "miaotiao",
                    "fruit" : "xigua"
                }
            ]
        }
    ```
- code1
    ```sql
        db.getCollection('test').aggregate(
            [
                {
                    $unwind:"$lunch"
                }
            ]
        )

        /* 1 */
        {
            "_id" : ObjectId("5951ca15567ebff0d5011fbb"),
            "name" : "小明",
            "address" : "北京",
            "lunch" : {
                "food" : "baozi",
                "fruit" : "taozi"
            }
        }
        
        /* 2 */
        {
            "_id" : ObjectId("5951ca15567ebff0d5011fbb"),
            "name" : "小明",
            "address" : "北京",
            "lunch" : {
                "food" : "miaotiao",
                "fruit" : "xigua"
            }
        }
    ```



