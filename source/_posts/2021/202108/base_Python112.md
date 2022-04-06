---
title: Python_基础 (112)
date: 2021-08-16
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
- 求和
    ```sql
        mysql: 
        select sum(age) as total from user;

        mongo: 
        db.user.aggregate([
            {
                $group: 
                {
                    _id: null,
                    total: {
                        $sum: "$age" 
                    }
                }
            }
        ])
    ```
- 分组求和
    ```sql
        mysql: 
        select type,sum(age) as total from user group by type;

        mongo: 
        db.user.aggregate([
            {
                $group: 
                {
                    _id: "$type",
                    total: {
                        $sum: "$age" 
                    }
                }
            }
        ])
    ```
- 多条件分组求和
    ```sql
        mysql: 
        select type,sex,sum(age) as total from user group by type,sex;

        mongo: 
        db.user.aggregate([
            {
                $group: {
                    _id:{
                        type: "$type",
                        sex: "$sex"
                    },
                    total: {
                        $sum: "$age" 
                    }
                }
            }
        ])
    ```
- 分组后having
    ```sql
        mysql: 
        select type, sum(age) as total from user group by type having total > 100;

        mongo: 
        db.user.aggregate([
            {
                $group: 
                {
                    _id: "$type",
                    total: {
                        $sum: "$age" 
                    }
                }
            },
            {
                $match: {
                    total: { 
                        $gt: 100 
                    }
                }
            }
        ])
    ```
- 条件分组
    ```sql
        mysql: 
        select type,sum(age) as total from user where created > 1577808000 group by type;

        mongo: 
        db.user.aggregate([
            {
                $match: {
                created: { $gt: 1577808000 }
                }
            },
            {
                $group: {
                    _id: "$type",
                    total: { $sum: "$age" }
                }
            }
        ])
    ```
- 条件分组并having筛选
    ```sql
        mysql: 
        select type,sum(age) as total from user where created > 1577808000 group by type having total > 100;

        mongo: 
        db.user.aggregate([
            {
                $match: {
                    created: { $gt: 1577808000 }
                }
            },
            {
                $group: {
                    _id: "$type",
                    total: { $sum: "$age" }
                }
            },
            {
                $match: {
                    total: { $gt: 100 }
                }
            }
        ])
    ```
- unwind
    ```sql
        # 加入你的mongo的每一条记录有一个字段, 存的是一个数组, 数组里面是对象, 类似这样, article字段含有
        [
            { "uid" : 1, "title" : "XXX", "content" : "XXX", "views" : 10 },
            { "uid" : 2, "title" : "XXX", "content" : "XXX", "views" : 11 },
            { "uid" : 3, "title" : "XXX", "content" : "XXX", "views" : 12 }
        ]
        # 使用unwind可以使上面原本一条记录进行展开, 分为三条数据进行展示, 有点像mysql的join查询, 只不过mysql得分开两个表存

        mysql: 
        select * from user as u left join article as a on (u.id=a.uid);

        mongo: 
        db.user.aggregate([
        { $unwind: "$article" }
        ])
    ```
- unwind后求和
    ```sql
        mysql: 
        select sum(views) as total from user as u left join article as a on (u.id=a.uid)) as data

        mongo: 
        db.user.aggregate([

            { $unwind: "$article" },
            {
                $group: {
                    _id: null,
                    total: { $sum: "$article.views" }
                }
            }
        ])
    ```
- 分组后统计总共有多少组
    ```sql
        mysql: 
        select count(*) from (select type from user group by type);

        mongo: 
        db.user.aggregate([
            {
                $group: {
                    _id: "$type"
                }
            },
            {
                $group: 
                {
                    _id : null,
                    count: { $sum: 1 }
                }
            }
        ])
    ```
- aggregate分析
    ```sql
        # aggregate类似linux的grep指令, 像管道处理一样, 一级接一级, 比如: 筛选、分组、过滤等, 最后返回结果
        db.user.aggregate(
            [
                {
                    $match:
                        {
                            sex: "boy"
                        }
                },
                {
                    $group:
                        {
                            _id: "$type",
                            total:
                                {
                                    $sum: "$age" 
                                }
                        }
                }
            ]
        )
    ```
    ![aggregate分析](/img/20210813_1.png)
- 搜索文档数组里边是否存在某元素
    ```sql
        data1 = {
            '_id': xxxxxxxxxxxxxx,
            'dataList': ['apple', 'grape', 'banana']
        }
        data2 = {
            '_id': xxxxxxxxxxxxxx,
            'dataList': ['watermelon', 'mango']
        }

        db.find({'$elemMatch': {'dataList': 'mango'}})
    ```
- 删除文档的某个字段的某些信息
    ```sql
        data = {
            '_id': "xxxxxxxx"
            'userInfo': {"name": "Woody", "age": 24, "weight": 10}
        }

        db.update({'_id': 'xxxxxxxx'}, {'$unset': {'userInfo.weight': 10}})
    ```
- 更新一条数据, 如果数据不存在则插入此数据
    * 关键字: upsert参数置为True
    * 在update,  update_one,  update_many里边都包含这个参数
    * upsert (optional): If True, perform an insert if no documents match the filter.
    * upsert(可选): 如果为True, 则在没有与筛选器匹配的文档时执行插入. 
- 使用正则表达式查询文档里的文本
    ```sql
        data = {
            '_id': "xxxxxxxx",
            'content': 'hello, this is a url for baidu, it is https://www.baidu.com'
        }

        db.find({"content": {"$regex": r"https://[\w\.]+"}})
    ```
- text参数
    ```sql
        { 
            "_id" : ObjectId("59a7aad34680b11dfcdfedba"), 
            "name" : "司导登出功能", 
            "location" : {
                "弹窗内容" : {
                    "method" : "ID", 
                    "value" : "net.yitu8.drivier:id/dialog_tips_content_msg", 
                    "index" : null, 
                    "text" : "确定退出登录?"
                },
                "我的-设置按钮" : {
                    "method" : "ID", 
                    "value" : "net.yitu8.drivier:id/img_manage_setting", 
                    "index" : null, 
                    "text" : null
                }
        }

        可以看到location字段里的key都是不确定的, 而需要获取location\.xx\.value=net\.yitu8\.drivier:id/img_manage_setting的数据document

        db.find(
            {
                "$text": 
                {
                    # search: 需要搜索的文本内容, string类型
                    "$search": "net.yitu8.drivier:id/img_manage_setting",
                    # caseSenstive: true/false 是否大小写敏感
                    "caseSensitive": True
                }
            }
        )
    ```
