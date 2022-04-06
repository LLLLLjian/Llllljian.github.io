---
title: PHP_Yii框架 (15)
date: 2018-02-12
tags: Yii
toc: true
---

### 查询生成器
    查询生成器(QueryBuilder)用于创建动态的查询语句

<!-- more -->

#### 创建查询
- SELECT
    ```php
        $query->select(['id', 'email']);
        // 等同于: 
        $query->select('id, email');
        // 等同于: 
        "SELECT id, email"

        $query->select(['user.id AS user_id', 'email']);
        // 等同于: 
        $query->select('user.id AS user_id, email');
        // 等同于: 
        $query->select(['user_id' => 'user.id', 'email']);
        // 等同于: 
        "SELECT user.id AS user_id, email"

        //没有调用select()方法,那么选择的将是 '*' 
    ```

- DISTINCT
    ```php
        // 去除重复行      
        $query->select('user_id')->distinct();
        // 等同于 
        SELECT DISTINCT `user_id`
    ```

- FROM
    ```php
        $query->from('user');
        // 等同于 
        SELECT * FROM `user`

        $query->from(['public.user u', 'public.post p']);
        // 等同于: 
        $query->from('public.user u, public.post p');
        // 等同于 
        $query->from(['u' => 'public.user', 'p' => 'public.post']);
        // 等同于 
        SELECT * FROM `public.user u, public.post p`
    ```

- WHERE
    ```php
        // 等同于 (type = 1) AND (status = 2).  
        ['type' => 1, 'status' => 2]   
        
        // 等同于 (id IN (1, 2, 3)) AND (status = 2)  
        ['id' => [1, 2, 3], 'status' => 2]   
        
        // 等同于 status IS NULL  
        ['status' => null]  
    ```
    * 字符串格式,例如: 'status=1'
        ```php
            $query->where('status=1');

            // or use parameter binding to bind dynamic parameter values
            $query->where('status=:status', [':status' => $status]);
            $query->where('status=:status')->addParams([':status' => $status]);

            // raw SQL using MySQL YEAR() function on a date field
            $query->where('YEAR(somedate) = 2015');           
        ```
    * 哈希格式,例如:  ['status' => 1, 'type' => 2]
        ```php
            $query->where(['status' => 10, 'type' => null, 'id' => [4, 8, 15],]);
            // 等同于
            WHERE (`status` = 10) AND (`type` IS NULL) AND (`id` IN (4, 8, 15))
        ```
    * 操作符格式,例如: ['like', 'name', 'test']
        * and  
            ```php
                ['and', 'id=1', 'id=2']
                // 等同于
                id=1 AND id=2

                ['and', 'type=1', ['or', 'id=1', 'id=2']]
                // 等同于
                type=1 AND (id=1 OR id=2)
            ```
        * or
            ```php
                // 等同于 `(type IN (7, 8, 9) OR (id IN (1, 2, 3)))`  
                ['or', ['type' => [7, 8, 9]], ['id' => [1, 2, 3]] 
            ```
        * not
            ```php
                // 等同于 `NOT (attribute IS NULL)`
                ['not', ['attribute' => null]]  
            ```
        * between
            ```php
                ['between', 'id', 1, 10] 
                // 等同于
                id BETWEEN 1 AND 10
            ```
        * not between : 类似between
        * in
            ```php
                ['in', 'id', [1, 2, 3]]
                // 等同于
                id IN (1, 2, 3)
            ```
        * not in : 类似in
        * like
            ```php
                ['like', 'name', 'tester']
                // 等同于
                name LIKE '%tester%'

                ['like', 'name', ['test', 'sample']]
                // 等同于
                name LIKE '%test%' AND name LIKE '%sample%'
            ```
        * or like
        * not like
        * or not like
        * exists
            ```php
                // 等同于 EXISTS (SELECT "id" FROM "users" WHERE "active"=1)  
                ['exists', (new Query())->select('id')->from('users')->where(['active' => 1])] 
            ```
        * not exists
        * \>, <=
            ```php
                ['>', 'age', 10]
                // 等同于
                age > 10

                // 等同于 `id != 10`  
                ['!=', 'id', 10]  
            ```
    * 附加条件,例如: andWhere() orWhere()
        ```php
            // 可以多次调用来追加不同的条件
            $status = 10;
            $search = 'yii';
            $query->where(['status' => $status]);
            if (!empty($search)) {
                $query->andWhere(['like', 'title', $search]);
            }
            // 如果$search不为空 等同于
            WHERE (`status` = 10) AND (`title` LIKE '%yii%')
        ```
    * 过滤条件
        ```php
            // filterWhere()和where()唯一的不同就在于,前者将忽略在条件当中的hash format的空值

            // $username 和 $email 来自于用户的输入
            $query->filterWhere([
                'username' => $username,
                'email' => $email,		
            ]);
            // 如果$email为空而$username 不为空,等同于
            WHERE username=:username.
        ```
        * 可以用 andFilterWhere() orFilterWhere() 追加额外的过滤条件

- ORDER BY
    ```php
        $query->orderBy([
            'id' => SORT_ASC,
            'name' => SORT_DESC,
        ]);
        // 等同于
        $query->orderBy('id ASC, name DESC');
        // 等同于
        ORDER BY `id` ASC, `name` DESC
    ```
    * 还可以用 addOrderBy 添加额外的排序

- GROUP BY
    ```php
        $query->groupBy(['id', 'status']);
        // 等同于
        $query->groupBy('id, status');
        // 等同于
        GROUP BY `id`, `status`
    ```
    * 还可以用 addGroupBy 添加额外的字段

- HAVING
    ```php
        $query->having(['status' => 1]);
        // 等同于
        HAVING `status` = 1
    ```
    * 还可以用 andHaving() orHaving() 添加额外的字段

- LIMIT
    ```php
        $query->limit(10)->offset(20);
        // 等同于
        LIMIT 10 OFFSET 20
    ```

- JOIN

- UNION

#### 查询方法
- one(): 根据查询结果返回查询的第一条记录.  
- all(): 根据查询结果返回所有记录.  
- count(): 返回记录的数量.  
- sum(): 返回指定列的总数.  
- average(): 返回指定列的平均值.  
- min(): 返回指定列的最小值.  
- max(): 返回指定列的最大值.  
- scalar(): 返回查询结果的第一行中的第一列的值.  
- column(): 返回查询结果中的第一列的值.  
- exists(): 返回一个值,该值指示查询结果是否有数据.  
- asArray(): 以数组的形式返回每条记录.
- with(): 该查询应执行的关系列表.  
- indexBy(): 根据索引的列的名称查询结果.   