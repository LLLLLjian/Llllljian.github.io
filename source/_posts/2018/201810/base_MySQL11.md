---
title: MySQL_基础 (11)
date: 2018-10-25
tags: MySQL
toc: true
---

### MySQL优化
    Mysql中的force index和ignore index
    force index[强制MySQL 使用一个特定的索引]
    ignore index[MySQL 忽略一个或者多个索引]
    去使用你觉得最合适的索引吧！！！

<!-- more -->

#### 优化过程
- 问题
    * 需要通过脚本从一个一亿五千万的数据表中取半年的数据导入到另一个库的四张表中
    * 条件有6个左右,两个关于时间的,剩下四个都要使用不等于
- 解决方法
    * 将过滤条件全转到PHP循环中处理
    * 强制使用单个索引

#### 知识点
- force
    * eg
        * select * from table force index(PRI) limit 2;(强制使用主键)
        * select * from table force index(ziduan1_index) limit 2;(强制使用索引”ziduan1_index”)
        * select * from table force index(PRI,ziduan1_index) limit 2;(强制使用索引”PRI和ziduan1_index”)
- ignore
    * eg
        * select * from table ignore index(PRI) limit 2;(禁止使用主键)
        * select * from table ignore index(ziduan1_index) limit 2;(禁止使用索引”ziduan1_index”)
        * select * from table ignore index(PRI,ziduan1_index) limit 2;(禁止使用索引”PRI,ziduan1_index”)


