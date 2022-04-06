---
title: MySQL_基础 (31)
date: 2019-07-02
tags: MySQL
toc: true
---

### INNER JOIN与 LEFT JOIN之间的区别
    关于INNER JOIN与 LEFT JOIN之间的区别,以前以为自己搞懂了, 这次做项目才发现自己不是很清楚, 所以抓紧记录一下

<!-- more -->

#### 区别
- LEFT JOIN
    * 左联接
    * 返回包括左表中的所有记录和右表中联结字段相等的记录 
- RIGHT JOIN
    * 右联接
    * 返回包括右表中的所有记录和左表中联结字段相等的记录
- INNER JOIN
    * 等值连接
    * 只返回两个表中联结字段相等的行

#### 情景再现
- 表数据
    ```sql
        表A记录如下: 
        aID　　　　　aNum
        1　　　　　a20050111
        2　　　　　a20050112
        3　　　　　a20050113
        4　　　　　a20050114
        5　　　　　a20050115

        表B记录如下:
        bID　　　　　bName
        1　　　　　2006032401
        2　　　　　2006032402
        3　　　　　2006032403
        4　　　　　2006032404
        8　　　　　2006032408
    ```
- 执行语句
- LEFT JOIN
    ```sql
        SELECT * FROM A
        LEFT JOIN B 
        on A.aID = B.bID

        结果如下:
        aID　　　　　aNum　　　　　bID　　　　　bName
        1　　　　　a20050111　　　　1　　　　　2006032401
        2　　　　　a20050112　　　　2　　　　　2006032402
        3　　　　　a20050113　　　　3　　　　　2006032403
        4　　　　　a20050114　　　　4　　　　　2006032404
        5　　　　　a20050115　　　　NULL　　　　　NULL
    ```
- RIGHT JOIN
    ```sql
        SELECT * FROM A
        RIGHT JOIN B 
        on A.aID = B.bID

        结果如下:
        aID　　　　　aNum　　　　　bID　　　　　bName
        1　　　　　a20050111　　　　1　　　　　2006032401
        2　　　　　a20050112　　　　2　　　　　2006032402
        3　　　　　a20050113　　　　3　　　　　2006032403
        4　　　　　a20050114　　　　4　　　　　2006032404
        NULL　　　　　NULL　　　　　8　　　　　2006032408
    ```
- INNER JOIN
    ```sql
        SELECT * FROM A
        INNERJOIN B 
        on A.aID = B.bID
        结果如下:
        aID　　　　　aNum　　　　　bID　　　　　bName
        1　　　　　a20050111　　　　1　　　　　2006032401
        2　　　　　a20050112　　　　2　　　　　2006032402
        3　　　　　a20050113　　　　3　　　　　2006032403
        4　　　　　a20050114　　　　4　　　　　2006032404
    ```