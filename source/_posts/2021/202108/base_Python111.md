---
title: Python_基础 (111)
date: 2021-08-13
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
- 只想查出某些数据, 不想全部数据都查出来
    ```sql
        mysql: 
        select name from user;

        mongo: 
        db.user.find(
            # where条件
            {},
            # 想展示的字段, 0代表不显示, 1代表显示
            projection = {_id : 0, name : 1}
        )
    ```
- 分页查询
    ```sql
        mysql: 
        select * from user limit 0,10;

        mongo: 
        # mongo的skip和limit与mysql同理, mysql的limit第一个参数是跳过的数据量与mongo的skip类似, 比如第三页的数据是从20开始的, mysql: limit 20,10, 即: limit (page-1)*size,size
        db.user.find({}).skip(0).limit(10)
    ```
- 条件查询
    ```sql
        mysql: 
        select name from user where id = 1;

        mongo: 
        db.user.find(
            # where id = 1
            { id : 1 },
            # select name
            { name : 1 }
        )
    ```
- 范围查询
    ```sql
        mysql: 
        select name from user where id > 1 and id < 10;

        mongo: 
        db.user.find(
            {
                id : {
                    $gt : 1,
                    $lt : 10
                }
            },
            { name : 1 }
        )
    ```

    <table><tbody><tr><td style="text-align: center">MySQL</td><td style="text-align: center">MongoDB</td><td style="text-align: center">remark</td></tr><tr><td style="text-align: center">&gt;</td><td style="text-align: center">$gt</td><td style="text-align: center">大于</td></tr><tr><td style="text-align: center">&lt;</td><td style="text-align: center">$lt</td><td style="text-align: center">小于</td></tr><tr><td style="text-align: center">&gt;=</td><td style="text-align: center">$gte</td><td style="text-align: center">大于等于</td></tr><tr><td style="text-align: center">&lt;=</td><td style="text-align: center">$lte</td><td style="text-align: center">小于等于</td></tr><tr><td style="text-align: center">!=</td><td style="text-align: center">$ne</td><td style="text-align: center">不等于</td></tr></tbody></table>
- in查询
    ```sql
        mysql: 
        select name from user where id in (1,2);

        mongo: 
        db.user.find(
            {
                id : {
                    # not in查询就把in换成nin
                    $in : [1, 2]
                }
            },
            { name : 1 }
        )
    ```
- 条件统计count
    ```sql
        mysql: 
        select count(*) from user where id > 1;

        mongo: 
        db.user.find(
            {
                id :  {
                    $gt: 1
                }
            }
        ).count()
    ```
- all查询
    ```sql
        db.user.find(
            {
                # detail是个数组, 查询条件是数组中同时包含a和b
                detail: {
                    $all : ["7", "8"]
                }
            }
        )
    ```
- exists查询
    ```sql
        db.user.find(
            {
                # 查询所有包含字段name_real的结果集, 改成false的话就变成不包含
                name_real : {
                    $exists : true
                }
            }
        )
    ```
- is null查询
    ```sql
        db.user.find(
            {
                age: {
                    $in : [null], 
                    # 为了防止将age字段不存在的数据查找出来, 所以添加了exists字段
                    $exists : true
                }
            }
        )
    ```
- 查询is not null
    ```sql
        db.user.find(
            {
                age: {
                    $ne : null,
                    $exists : true
                }
            }
        )
    ```
- 取模运算
    ```sql
        mysql: 
        select * from user where age % 10 = 0;

        mongo: 
        db.user.find(
            {
                age:{
                    $mod : [ 10 , 0 ]
                }
            }
        )
    ```
- 查询数据元素个数
    ```sql
        db.user.find(
            {
                # favorite是个list, 通过size可以查询list中元素个数为3的记录
                favorite: {
                    $size: 3
                }
            }
        )
    ```
- 正则匹配查询
    ```sql
        db.user.find(
            {
                age: {
                    # 匹配年龄是10以下的用户
                    $regex: /^([1-9])$/
                }
            }
        )
    ```
- 只取一部分数据
    ```sql
        mysql: 
        select * from user limit 10;

        mongo: 
        db.user.find().limit(10)
    ```
- 排序
    ```sql
        mysql: 
        select * from user order by age asc;

        mongo: 
        db.user.find().sort(
            {age: 1}
        )
    ```
    <table><tbody><tr><td style="text-align: center">MySQL</td><td style="text-align: center">MongoDB</td><td style="text-align: center">说明</td></tr><tr><td style="text-align: center">asc</td><td style="text-align: center">1</td><td style="text-align: center">升序</td></tr><tr><td style="text-align: center">desc</td><td style="text-align: center">-1</td><td style="text-align: center">降序</td></tr></tbody></table>
