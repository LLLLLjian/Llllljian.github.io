---
title: Python_基础 (115)
date: 2021-11-17
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=Pymongo
    项目中因为字段多变, 所以觉得用mongo会好一点, 之前学的pymongo太浅了, 这次需要重新看一下

<!-- more -->

#### mongo的聚合
> 得学一下mongo里的聚合 还挺常见、重要的
- 几个常见的操作
    * $project: 修改输入文档的结构. 可以用来重命名、增加或删除域,也可以用于创建计算结果以及嵌套文档
    * $match: 用于过滤数据,只输出符合条件的文档. 使用 MongoDB 的标准查询操作
    * $limit: 用来限制 MongoDB 聚合管道返回的文档数
    * $skip: 在聚合管道中跳过指定数量的文档,并返回余下的文档
    * $unwind: 将文档中的某一个数组类型字段拆分成多条,每条包含数组中的一个值
    * $group: 将集合中的文档分组,可用于统计结果
    * $sort: 将输入文档排序后输出
    * $geoNear: 输出接近某一地理位置的有序文档
- demo
    ```sql
        # 求和
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    num_tutirial: {
                        $sum: "$likes"
                    }
                }
            }
        ])

        # 计算平均值
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    num_tutirial: {
                        $avg: "$likes"
                    }
                }
            }
        ])

        # 最大值
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    num_tutirial: {
                        $max: "$likes"
                    }
                }
            }
        ])

        # 最小值
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    num_tutirial: {
                        $min: "$likes"
                    }
                }
            }
        ])

        # 将值插入到一个数组中
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    url: {
                        $push: "$url"
                    }
                }
            }
        ])

        # 将值插入到一个数组中(去重)
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    url: {
                        $addToSet: "$url"
                    }
                }
            }
        ])

        # 取排序后的第一个值
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    first_url: {
                        $first: "$url"
                    }
                }
            }
        ])

        # 取排序后的最后一个值
        db.mycol.aggregate([
            {
                $group: {
                    _id: "$by_user",
                    last_url: {
                        $first: "$url"
                    }
                }
            }
        ])
    ```
- demo1
    ```sql
        [
            {
                # 查询条件
                '$match': query
            }, {
                # 将文档中的某一个数组类型字段拆分成多条,每条包含数组中的一个值
                '$unwind': {
                    'path': '$allocate_data'
                }
            }, {
                # 修改输入文档的结构
                '$project': {
                    '_id': 0,
                    'cluster': '$cluster',
                    'host_ip': '$host_ip',
                    'timestamp': '$allocate_data.query_timestamp',
                    'cpu': '$allocate_data.cpu',
                    'date': date
                }
            }, {
                # 对上一个结果做过滤
                '$match': {
                    'timestamp': {
                        "$gte": start_time,
                        "$lte": end_time
                    }
                }
            }, {
                # 对上一个结果做聚合
                '$group': {
                    # group by 多个字段
                    '_id': {
                        'cluster': '$cluster',
                        'host_ip': '$host_ip'
                    },
                    'cpu': {
                        '$avg': '$cpu'
                    },
                    'date': {
                        '$first': '$date'
                    }
                }
            }
        ]
    ```















