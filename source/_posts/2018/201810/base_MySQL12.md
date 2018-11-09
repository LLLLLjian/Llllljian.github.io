---
title: MySQL_基础 (12)
date: 2018-10-26
tags: MySQL
toc: true
---

### MySQL查询优化
    在优化有问题的查询时,目标应该是找到一个更优的方法获得实际需要的结果,而不是移动总是需要从MySQL获取一模一样的结果集

<!-- more -->

#### 一个复杂查询还是多个简单查询
    设计查询的关键问题是,是否需要将一个复杂的查询分成多个简单的查询

#### 切分查询
    将大查询切分成小查询,每个查询功能完全一样,只完成一小部分,每次只返回一小部分查询结果
- eg
    ```sql
        q : 删除旧数据

        a : 
        sql1 : 
        DELETE FROM message WHERE created < DATE(NOW(), INTERVAL 3 MONTH)

        sql2 :
        row_affected = 0
        do {
            row_affected = do_query(
                "DELETE FROM message WHERE created < DATE(NOW(), INTERVAL 3 MONTH) LIMIT10000"
            )
        } while row_affected > 0
    ```

#### 分解关联查询
- eg
    ```sql
        sql1 : 
        SELECT t.*
        FROM tag AS t
        JOIN tag_post AS tp ON tp.tag_id = t.id
        JOIN post AS p ON tp.post_id = p.id
        WHERE t.tag = 'mysql'

        sql2 :
        SELECT * FROM tag WHERE tag = 'mysql';
        SELECT * FROM tag_post WHERE tag_id = 1234;
        SELECT * FROM post WHERE post.id IN (123, 456, 789); 
    ```
- 分解之后的优势
    * 让缓存的效率更高
    * 将查询分解后,执行单个查询可以减少锁的竞争
    * 在应用层做关联,可以更容易对数据库进行拆分,更容易做到高性能和可扩展
    * 查询本身效率也有可能会有所提升
    * 减少冗余记录的查询
    * 相当于在应用中实现了哈希关联,而不是MySQL的嵌套循环关联
