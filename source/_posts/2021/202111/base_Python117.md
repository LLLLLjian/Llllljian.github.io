---
title: Python_基础 (117)
date: 2021-11-19
tags: 
    - MongoDB
    - Python
toc: true
---

### Python+mongoDB=Pymongo
    项目中因为字段多变, 所以觉得用mongo会好一点, 之前学的pymongo太浅了, 这次需要重新看一下

<!-- more -->

#### mongo的索引
- create_index
    * 创建索引
    ```sql
        collection.create_index([('x',1)], unique = True, background = True)
    ```
    * 可选参数
        * <table><thead><tr><th>参数名</th><th>类型</th><th>描述</th></tr></thead><tbody><tr><td>background</td><td>Boolean</td><td>建索引过程会<strong>阻塞其它数据库操作</strong>,background可指定以后台方式创建索引,即增加 “background” 可选参数.  “background” 默认值为False. </td></tr><tr><td>unique</td><td>Boolean</td><td>建立的索引是否唯一. 指定为True来创建唯一索引. 默认值为False. 默认情况下,MongoDB在创建集合时会生成唯一索引字段_id. </td></tr><tr><td>name</td><td>string</td><td>索引的名称. 如果未指定,MongoDB的通过连接索引的字段名和排序顺序生成一个索引名称. 例如create_index([(‘x’,1)]在不指定name时会生成默认的索引名称 ‘x_1’</td></tr><tr><td>expireAfterSeconds</td><td>integer</td><td>指定一个以秒为单位的数值,完成 TTL设定,设定集合的生存时间. 需要在值为日期或包含日期值的数组的字段的创建. </td></tr></tbody></table>
- drop_index
    * 删除索引
    ```sql
        collection.create_index([('x',1)], name = 'idx_x')
        collection.drop_index('idx_x')
    ```
- index_information
    * 展示索引相关信息
    ```sql
        collection.index_infomation()
        #{ 
        # '_id_': {'key' ['_id',1)], 'ns':'my_db.my_collection', 'v':1},
        # 'x_1' : { 'unique':True, 'key': [('x',1)],  'ns':'my_db.my_collection', 'v':1}
        #}
    ```
- demo
    ```python
        have_index = False
        # 没有办法直接判断某个索引是否存在, 只能获取list再判断
        for index in collection.list_indexes():
            if "type_1_name_1_merge_date_1" == index.get("name"):
                have_index = True
        if have_index:
            pass
        else:
            # 创建一个 类型-容器/机器-聚合日期 的唯一索引
            collection.create_index(
                # (‘x’,1), x 值为要创建的索引字段名,1 为指定按升序创建索引,也可以用pymongo.ASCENDING代替
                # 如果你想按降序来创建索引,则指定为 -1 或 pymongo.DESCENDING.
                # 没有理解升序降序创建索引有什么区别, 这里先设置成升序
                [("type", 1), ("name", 1), ("merge_date", 1)],
                unique=True
            )
    ```

