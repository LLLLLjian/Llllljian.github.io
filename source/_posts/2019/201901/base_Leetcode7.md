---
title: Leetcode_基础 (7)
date: 2019-01-29
tags: Leetcode
toc: true
---

### 组合两个表
    Leetcode学习-175

<!-- more -->

#### Q
    表1: Person
    +-------------+---------+
    | 列名         | 类型     |
    +-------------+---------+
    | PersonId    | int     |
    | FirstName   | varchar |
    | LastName    | varchar |
    +-------------+---------+
    PersonId 是上表主键
    表2: Address
    +-------------+---------+
    | 列名         | 类型    |
    +-------------+---------+
    | AddressId   | int     |
    | PersonId    | int     |
    | City        | varchar |
    | State       | varchar |
    +-------------+---------+
    AddressId 是上表主键
    编写一个 SQL 查询,满足条件: 无论 person 是否有地址信息,都需要基于上述两表提供 person 的以下信息: 
    FirstName, LastName, City, State

#### A
    ```sql
        # Write your MySQL query statement below

        SELECT p.FirstName, p.LastName, a.City, a.State
        FROM Person AS p
        LEFT JOIN Address AS a ON p.PersonId = a.PersonId
        LIMIT 10
    ```
