---
title: Python_基础 (113)
date: 2021-08-17
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=Pymongo
    项目中因为字段多变, 所以觉得用mongo会好一点, 之前学的pymongo太浅了, 这次需要重新看一下

<!-- more -->

#### pyMongo操作
> 基础的增删改查就不写了, 之前写过
- $project
    * 在 MongoDB 中可以使用 "$project" 来控制数据列的显示规则, 可以执行的规则如下
        * 普通列({成员: 1 | true}): 表示要显示的内容
        * "_id" 列({"_id": 0 | false}): 表示 "_id" 列是否显示
        * 条件过滤列({成员: 表达式}): 满足表达式之后的数据可以进行显示
    * data
        ```
            db.getCollection('sales').insertMany([
                { "_id" : 1, "item" : "abc", "price" : 10, "quantity" : 2, "date" : ISODate("2014-03-01T08:00:00Z") },
                { "_id" : 2, "item" : "jkl", "price" : 20, "quantity" : 1, "date" : ISODate("2014-03-01T09:00:00Z") },
                { "_id" : 3, "item" : "xyz", "price" : 5, "quantity" : 10, "date" : ISODate("2014-03-15T09:00:00Z") },
                { "_id" : 4, "item" : "xyz", "price" : 5, "quantity" : 20, "date" : ISODate("2014-04-04T11:21:39.736Z") },
                { "_id" : 5, "item" : "abc", "price" : 10, "quantity" : 10, "date" : ISODate("2014-04-04T21:23:13.331Z") }
            ]);
        ```
    * demo
        ```sql
            // 只显示出 item、price列
            db.sales.aggregate([
                {
                    $project : {
                        _id: 0,
                        item : 1 ,
                        price : 1 
                    }
                } 
            ])

            // 设置别名 quantity AS qty
            db.sales.aggregate([
                {
                    $project : {
                        _id: 0,
                        item : 1,
                        price : 1,
                        qty: "$quantity"
                    }
                }
            ])
        ```
- $add
    * 加法运算
    * 基础语法:{ $add :  [ < expression1 > ,  < expression2 > ,  ... ] }
    * demo
        ```sql
            // $quantity + 2
            db.sales.aggregate([
                {
                    $project : {
                        _id: 0,
                        item : 1 ,
                        price : 1,
                        quantity: {
                            "new_qty" : {
                                "$add" : ["$quantity", 2] 
                            },
                            "quantity": "$quantity"
                        }
                    }
                }
            ]);

            // 输出
            {
                "item" : "abc",
                "price" : 10.0,
                "quantity" : {
                    "new_qty" : 4.0,
                    "quantity" : 2.0
                }
            }

            // 直接别名返回
            db.sales.aggregate([
                {
                    $project : {
                        _id:0,
                        item: 1 ,
                        price: 1,
                        "new_qty": {
                                "$add" : ["$quantity", 2] 
                        },
                        quantity: 1
                    }
                }
            ]);

            // 输出
            {
                "item" : "abc",
                "price" : 10.0,
                "quantity" : 2.0,
                "new_qty" : 4.0
            }
        ```
- $subtract
    * 减法运算
    * 基础语法:{ $subtract: [ < expression1 >, < expression2 > ] } expression1减去expression2
- $multiply
    * 乘法运算
    * 基础语法:{ $multiply :  [ < expression1 > ,  < expression2 > ,  ... ] }
- $divide
    * 除法运算
    * 基础语法:{ $divide: [ < expression1 >, < expression2 > ] }expression1为被除数, expression2为除数
- 注意
    * 上述4个基础语法中 < expression >是需要运算的字段或数字, add 和multiply 的< expression >可以多于2个. 见例三
    * 以上4个都只支持对数字类型的的字段进行运算, 字符串类型不可以. 见例一
    * Int类型和Double之间可以运算. 见例二
    * 当 < expression >中有一个不存在或为null时, 运算结果皆为空. 见例二
    * 时间(DateTime)可以计算, 加减的最终结果是毫秒. 
    * 若是String类型的时间, 需用$dateFromString转换为时间类型在计算. 
- 关系运算: 大小比较("$cmp")、等于("$eq")、大于("$gt")、大于等于("$gte")、小于("$le")、小于等于("$lte")、不等于("$ne")、判断 null ("$ifNull"), 这些返回值都是 boolean 值类型的
    * demo
        ```sql
            // 查询价格大于 5 的数据
            db.sales.aggregate([
                {
                    $project : {
                        _id: 0,
                        item : 1,
                        price: "$price",
                        priceBoolean: {"$gt" : ["$quantity", 5]}
                    }
                }
            ]);

            // 输出
            {
                "item" : "jkl",
                "price" : 20.0,
                "quantity": 1.0,
                "priceBoolean" : false
            }
            {
                "item" : "xyz",
                "price" : 5.0,
                "quantity": 10.0,
                "priceBoolean" : true
            }
        ```
- 逻辑运算: 与("$and")、或("$or")、非 ("$not")
- 字符串操作: 连接("$concat")、截取("$substr")、转小写("$toLower")
    * demo
        ```sql
            // 连接字符串
            db.sales.aggregate([{
                $project : {
                    _id: 0,
                    item : 1,
                    price: 1,
                    itemStr: {
                        "$concat" : ["$item", "_title"]
                    }
                } 
            }]);

            // 输出
            {
                "item" : "abc",
                "price" : 10.0,
                "itemStr" : "abc_title"
            }
        ```
- $sum
    * 计算并返回数值的总和
    * demo
        ```sql
            // 按日期分组并计算价钱及个数
            db.sales.aggregate([
                {
                    $group: {
                        _id: {
                            day: {
                                $dayOfYear: "$date"
                            },
                            year: {
                                $year: "$date"
                            }
                        },
                        totalAmount: { 
                            $sum: { $multiply: [ "$price", "$quantity" ] }
                        },
                        count: { $sum: 1 }
                    }
                }
            ])

            // 输出
            {
                "_id" : {
                    "day" : 94,
                    "year" : 2014
                },
                "totalAmount" : 200.0,
                "count" : 2.0
            }
            {
                "_id" : {
                    "day" : 60,
                    "year" : 2014
                },
                "totalAmount" : 40.0,
                "count" : 2.0
            }
            {
                "_id" : {
                    "day" : 74,
                    "year" : 2014
                },
                "totalAmount" : 50.0,
                "count" : 1.0
            }
        ```
- $group
    * data
        ```
            {
                'campaign_id': 'A',
                'campaign_name': 'A',
                'subscriber_id': '123'
            },
            {
                'campaign_id': 'A',
                'campaign_name': 'A',
                'subscriber_id': '123'
            },
            {
                'campaign_id': 'A',
                'campaign_name': 'A',
                'subscriber_id': '456'
            },
        ```
    * mysql
        * 按照campaign_id与campaign_name分组, 并查询出每个分组下的记录条数及subscriber_id不同记录的个数
        ```sql
            SELECT campaign_id, campaign_name, count(subscriber_id), count(distinct subscriber_id)
            FROM campaigns
            GROUP BY campaign_id, campaign_name
        ```
    * mongodb
        ```sql
            db.campaigns.aggregate([
                {
                    "$match": {
                        "subscriber_id": {
                            "$ne": null
                        }
                    }
                },
                // Count all occurrences
                {
                    "$group": {
                        "_id": {
                            "campaign_id": "$campaign_id",
                            "campaign_name": "$campaign_name",
                            "subscriber_id": "$subscriber_id"
                        },
                        "count": {
                            "$sum": 1
                        }
                    }
                },
                // Sum all occurrences and count distinct
                {
                    "$group": {
                        "_id": {
                            "campaign_id": "$_id.campaign_id",
                            "campaign_name": "$_id.campaign_name",
                        },
                        "totalCount": {
                            "$sum": "$count"
                        },
                        "distinctCount": {
                            "$sum": 1
                        }
                    }
                }
            ])
        ```
- $look
    * 对同一数据库中的未分片集合执行左外部联接, 以从“联接”集合中过滤文档以进行处理
    * 语法
        ```sql
            {
                $lookup: {
                    from: <collection to join>,
                    localField: <field from the input documents>,
                    foreignField: <field from the documents of the "from" collection>,
                    as: <output array field>
                }
            }
        ```
    * data
        ```
            db.getCollection('goods').insertMany([
                { "_id" : 1, "good" : "abc", "good_name" : "abc_name"},
                { "_id" : 2, "good" : "jkl", "good_name" : "jkl_name"},
                { "_id" : 3, "godd" : "xyz", "good_name" : "xyz_name"},
            ]);
        ```
    * demo
        ```sql
            db.goods.aggregate([
                {
                    "$lookup": {
                        "from": "sales",
                        "localField": "good",
                        "foreignField": "item",
                        "as": "sales_info"
                    }
                }
            ])

            // 输出
            {
                "_id" : 1.0,
                "good" : "abc",
                "good_name" : "abc_name",
                "sales_info" : [ 
                    {
                        "_id" : 1.0,
                        "item" : "abc",
                        "price" : 10.0,
                        "quantity" : 2.0,
                        "date" : ISODate("2014-03-01T08:00:00.000Z")
                    }, 
                    {
                        "_id" : 5.0,
                        "item" : "abc",
                        "price" : 10.0,
                        "quantity" : 10.0,
                        "date" : ISODate("2014-04-04T21:23:13.331Z")
                    }
                ]
            }
            {
                "_id" : 2.0,
                "good" : "jkl",
                "good_name" : "jkl_name",
                "sales_info" : [ 
                    {
                        "_id" : 2.0,
                        "item" : "jkl",
                        "price" : 20.0,
                        "quantity" : 1.0,
                        "date" : ISODate("2014-03-01T09:00:00.000Z")
                    }
                ]
            }
            {
                "_id" : 3.0,
                "good" : "xyz",
                "good_name" : "xyz_name",
                "sales_info" : [ 
                    {
                        "_id" : 3.0,
                        "item" : "xyz",
                        "price" : 5.0,
                        "quantity" : 10.0,
                        "date" : ISODate("2014-03-15T09:00:00.000Z")
                    }, 
                    {
                        "_id" : 4.0,
                        "item" : "xyz",
                        "price" : 5.0,
                        "quantity" : 20.0,
                        "date" : ISODate("2014-04-04T11:21:39.736Z")
                    }
                ]
            }
        ```
    * demo1
        ```sql
            db.sales.aggregate([
                {
                    "$lookup": {
                        "from": "goods",
                        "localField": "item",
                        "foreignField": "good",
                        "as": "goods_info"
                    }
                }
            ])

            // 输出结果
            {
                "_id" : 1.0,
                "item" : "abc",
                "price" : 10.0,
                "quantity" : 2.0,
                "date" : ISODate("2014-03-01T08:00:00.000Z"),
                "goods_info" : [ 
                    {
                        "_id" : 1.0,
                        "good" : "abc",
                        "good_name" : "abc_name"
                    }
                ]
            }
            {
                "_id" : 2.0,
                "item" : "jkl",
                "price" : 20.0,
                "quantity" : 1.0,
                "date" : ISODate("2014-03-01T09:00:00.000Z"),
                "goods_info" : [ 
                    {
                        "_id" : 2.0,
                        "good" : "jkl",
                        "good_name" : "jkl_name"
                    }
                ]
            }
            {
                "_id" : 3.0,
                "item" : "xyz",
                "price" : 5.0,
                "quantity" : 10.0,
                "date" : ISODate("2014-03-15T09:00:00.000Z"),
                "goods_info" : [ 
                    {
                        "_id" : 3.0,
                        "good" : "xyz",
                        "good_name" : "xyz_name"
                    }
                ]
            }
            {
                "_id" : 4.0,
                "item" : "xyz",
                "price" : 5.0,
                "quantity" : 20.0,
                "date" : ISODate("2014-04-04T11:21:39.736Z"),
                "goods_info" : [ 
                    {
                        "_id" : 3.0,
                        "good" : "xyz",
                        "good_name" : "xyz_name"
                    }
                ]
            }
            {
                "_id" : 5.0,
                "item" : "abc",
                "price" : 10.0,
                "quantity" : 10.0,
                "date" : ISODate("2014-04-04T21:23:13.331Z"),
                "goods_info" : [ 
                    {
                        "_id" : 1.0,
                        "good" : "abc",
                        "good_name" : "abc_name"
                    }
                ]
            }
        ```






