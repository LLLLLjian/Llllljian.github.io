---
title: Python_基础 (133)
date: 2022-01-18
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=mongoengine
    pymongo来操作mongodb数据库, 但是直接把数据库的操作代码写在脚本中, 使得应用代码的耦合性太强, 不利于代码的优化管理
    mongoengine是一个对象文档映射器(ODM), 相当于基于sql对象关系映射器(ORM)

<!-- more -->

#### 查
- 操作符
    * ne – not equal to, 不等于
    * lt – less than, 小于
    * lte – less than or equal to, 小于或等于
    * gt – greater than, 大于
    * gte – greater than or equal to, 大于或等于
    * not – negate a standard check, may be used before other operators (e.g. Q(age__not__mod=5)), 否, 与其他操作符一起用
    * in – value is in list (a list of values should be provided), 提供一个列表, 数据库值在列表内
    * nin – value is not in list (a list of values should be provided), 提供一个列表, 数据库值不在列表内
    * mod – value % x == y, where x and y are two provided values, 整除
    * all – every item in list of values provided is in array, 提供的列表元素都在数据库数组内
    * size – the size of the array is, 数据库数组的大小
    * exists – value for field exists, field存在
- 字符串检索
    * exact – 字符串型字段完全匹配这个值
    * iexact – 字符串型字段完全匹配这个值(大小写敏感)
    * contains – 字符串字段包含这个值
    * icontains –字符串字段包含这个值(大小写敏感)
    * startswith – 字符串字段由这个值开头
    * istartswith –字符串字段由这个值开头(大小写敏感)
    * endswith – 字符串字段由这个值结尾
    * iendswith –字符串字段由这个值结尾(大小写敏感)
    * match – 使你可以使用一整个document与数组进行匹配查询list
- 普通查询
    ```python
        # username StringField, username是字符串类型, 默认查的是username=llllljian的
        User.objects(username='llllljian')
        # tags ListField, tags是列表类型, 检索所有这个列表域中包含这个元素的文档
        User.objects(tags='mongodb')
        # 检索列表第一个属性是 db 的用户
        User.objects(tags__0='db')
        # 年龄大于19的
        User.objects(age__gt=19)
        # 多条件查询(年龄大于等于20 或者 country=uk并且年龄大于18的用户)
        User.objects((Q(country='uk') & Q(age__gte=18)) | Q(age__gte=20))
        # 年龄大于19的用户人数
        user_number = User.objects(age__gt=19).count()
        # name中包含aa
        user = User.objects.filter(name__contains="aa")
        # name中不包含aa
        user = User.objects.filter(name__not__contains="aa")
        # querySet转dict
        user = User.objects.get(name="xxx")
        user_dict = user.to_mongo().to_dict()
        # 求和
        yearly_expense = Employee.objects.sum('salary')
        # 求平均值
        mean_age = User.objects.average('age')
        # 获取所查询的字段值的列表
        time_list = User.objects.filter(username="aa").scalar("last_login_time")
    ```
- get查询容错
    ```python
        # 查询某个用户时, get方法有则返回queryset,无则报错User.DoesNotExist
        user = User.objects.get(name="xx")
        # 为防止报错, 有则返回queryset, 无则返回None
        user = User.objects.filter(name="xx")
        if user:
            user = user[0]
        # 或者
        user = User.objects.filter(name="xx").first()
        # 进一步优化
        user = User.objects(name="xx").first()
    ```
- with_id使用
    ```python
        # mongo默认id类型为ObjectId, 所以使用id查询时, 需将str转换为ObjectId
        from bson import ObjectId
        user = User.objects.get(id=ObjectId(user_id))
        # 优化
        user = User.objects.with_id(user_id)
    ```
- Serializer处理
    ```python
        # 序列化处理, 排除指定字段
        def m2d_exclude(obj, *args):
            model_dict = obj.to_mongo().to_dict()
            if args:
                list(map(model_dict.pop, list(args)))
            if "_id" in model_dict.keys():
                model_dict["_id"] = str(model_dict["_id"])
            return model_dict

        # 序列化处理, 只返回特定字段
        def m2d_fields(obj, *args):
            model_dict = obj.to_mongo().to_dict()
            if args:
                fields = [i for i in model_dict.keys() if i not in list(args)]
                list(map(model_dict.pop, fields))
            if "_id" in model_dict.keys():
                model_dict["_id"] = str(model_dict["_id"])
            return model_dict

        role = Role.objects.get(name="管理员")
        # 返回的字段中去掉permission staff
        result = m2d_exclude(role, "permission", "staff")
        # 返回的字段中只包含 name desc _id
        result = m2d_fields(role, "name", "desc", "_id")
    ```
- 获取一个在集合里item的频率
    ```python
        class Article(Document):  
            tag = ListField(StringField())  

        # After adding some tagged articles...  
        tag_freqs = Article.objects.item_frequencies('tag', normalize=True)  

        from operator import itemgetter  
        top_tags = sorted(tag_freqs.items(), key=itemgetter(1), reverse=True)[:10] 
    ```
- in_bulk
    ```python
        # 不使用in_bulk
        # 通常情况, 前端发送id列表
        ids = data.json["ids"]
        result = [Role.objects.with_id(i) for i in ids]
        或
        result = Role.objects(pk__in=ids)

        # 使用in_bulk
        ids = data.json("ids")
        ids = [ObjectId(i) for i in ids]
        documents = Role.objects.in_bulk(ids)
        results = [documents.get(obj_id) for obj_id in ids]
    ```
- 使用原生mongo语句
    ```python
        group_by_result = Model._get_collection().aggregate(
            [
                { '$group' : 
                    { 
                        '_id' : {
                            'carrier' : '$carrierA',
                            'category' : '$category' 
                        }, 
                        'count' : {
                            '$sum' : 1 
                        }
                    }
                }
            ]
        )
        result = list(group_by_result)
    ```
- aggregate的使用
    ```python
        # mongo查询
        aggregates = [
            {
                '$match': {
                    'timestamp': {
                        "$gte": s_time,
                        "$lte": e_time + 86399
                    }
                }
            }, {
                '$unwind': {
                    'path': '$uniq'
                }
            }, {
                '$project': {
                    '_id': 0,
                    'timestamp': '$timestamp',
                    'file_line': '$uniq'
                }
            }, {
                '$sort': {
                    'timestamp': -1
                }
            }, {
                '$group': {
                    '_id': '$file_line',
                    'count': {
                        '$sum': 1
                    },
                    'host_list': {
                        # addToSet 是去重的结果
                        # push 不去重
                        '$addToSet': '$host'
                    }
                }
            }
        ]
        # allowDiskUse 参数是防止排序聚合的时候超出内存限制导致报错
        user_list = list(
            models.User.objects.aggregate(
                aggregates, allowDiskUse=True
            )
        )
    ```




