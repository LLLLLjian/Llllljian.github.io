---
title: MySQL_基础 (45)
date: 2020-05-22
tags: 
    - MySQL 
    - Interview
toc: true
---

### 更好的理解MySQL
    SQL执行顺序

<!-- more -->

#### SQL语句的执行顺序
> 一条SQL查询语句由SELECT 、DISTINCT (select_field)、FROM (table)、(join_type) JOIN (table)、ON (join_condition)、WHERE (where_condition)、GROUP BY (group_by_field)、HAVING (having_condition)、ORDER BY (order_by_field)、LIMIT (limit_number)等10部分组成
1. FROM
2. ON
3. JOIN
4. WHERE
5. GROUP BY
6. HAVING
7. SELECT
8. DISTINCT
9. ORDER BY
10. LIMIT 
![SQL语句的执行顺序](/img/20200522_1.jpeg)
- 需要注意的点
    * SQL语句是从FROM开始执行的, 而不是SELECT.MySQL在执行SQL查询语句的时, 首先是将数据从硬盘加载到数据缓冲区中, 以便对这些数据进行操作.
    * SELECT是在FROM和GROUP BY 之后执行的.这就导致了无法在WHERE中使用SELECT中设置字段的别名作为查询条件.
    * UNION是排在ORDER BY之前的.虽然数据库允许SQL语句对UNION段中的子查询或者派生表进行排序, 但是这并不能说明在 UNION 操作过后仍保持排序后的顺序
    * 在MySQL中SQL的逻辑查询是根据上述进行查询, 但MySQL可能并不完全会按照逻辑查询处理方式进行查询.MySQL有2个组件：1), 分析SQL语句的Parser；2)、优化器Optimizer；MySQL在执行查询之前, 都会选择一条自认为最优的查询方案去执行, 获取查询结果.一般情况下都能计算出最优的查询方案, 但在某些情况下, MySQL给出的查询方案并不是很好的查询方案.
    * 存在索引时, 优化器优先使用索引的插叙条件, 当索引为多个时, 优化器会直接选择效率最高的索引去执行
