---
title: MySQL_基础 (1)
date: 2018-07-09
tags: MySQL
toc: true
---

### 了解SQL
    mysql必知必会学习笔记
    MySQL版本 5538

<!-- more -->

#### 基础概念
- 数据库
    * database
    * 保存有组织的数据的容器,通常是一个文件或一组文件
- 表
    * table
    * 储存某种特定类型的数据,某种特定类型数据的结构化清单
- 列
    * column
    * 表中的一个字段,所有表都是由一个或多个列组成的
- 数据类型
    * datatype
    * 所允许的数据的类型,限制(或允许)该列中存储的数据
- 行
    * row
    * 表中的一条记录
- 主键
    * primary key
    * 一列(或一组列),其值能够唯一区分表中的每一行
- 关键字
    * key word
    * 作为MySQL语言组成部分的一个保留字.绝不要用关键字命名一个表或列
- 外键
    * foreign key
    * 外键为某个表中的一列,它包含另一个表的主键值,定义了两个表之间的关系

#### 函数
- 文本处理函数
    * RTrim()
        * 去除列值右边的空格
        ```sql
            SELECT name, RTrim(name) Rname
            FROM user
            ORDER BY id
        ```
    * Upper()
        * 将文本转换为大写
        ```sql
            SELECT name, Upper(name) Uname
            FROM user
            ORDER BY id
        ```
    * Left()
        * 返回串左边的字符
    * Length()
        * 返回串的长度
    * Locate()
        * 找出串的一个子串
    * Lower()
        * 将串转换为小写
    * LTrim()
        * 去除串左边的空格
    * Right()
        * 返回串右边的字符
    * Soundex()
        * 返回串的SOUNDEX值
    * SubString()
        * 返回子串的字符
- 日期和时间处理函数
    * AddDate()
        * 增加一个日期(天、周等)
    * AddTime()
        * 增加一个时间(时、分等)
    * CurDate()
        * 返回当前日期
    * CurTime()
        * 返回当前时间
    * Date()
        * 返回日期时间的日期部分
    * DateDiff()
        * 计算两个日期之差
    * Date_Add()
        * 高度灵活的日期运算函数
    * Date_Format()
        * 返回一个格式化的日期或时间串
    * Day()
        * 返回一个日期的天数部分
    * DayOfWeek()
        * 对于一个日期,返回对应的星期几
    * Hour()
        * 返回一个时间的小时部分
    * Minute()
        * 返回一个时间的分钟部分
    * Month()
        * 返回一个日期的月份部分
    * Now()
        * 返回当前日期和时间
    * Second()
        * 返回一个时间的秒部分
    * Time()
        * 返回一个日期时间的时间部分
    * Year()
        * 返回一个日期的年份部分
- 数值处理函数
    * Abs()
        * 返回一个数的绝对值
    * Cos()
        * 返回一个角度的余弦
    * Exp()
        * 返回一个数的指数值
    * Mod()
        * 返回除操作的余数
    * Pi()
        * 返回圆周率
    * Rand()
        * 返回一个随机数
    * Sin()
        * 返回一个角度的正弦
    * Sqrt()
        * 返回一个数的平方根
    * Tan()
        * 返回一个角度的正切
- 聚集函数
    * AVG()
        * 返回某列的平均值
    * COUNT()
        * 返回某列的行数
    * MAX()
        * 返回某列的最大值
    * MIN()
        * 返回某列的最小值
    * SUM()
        * 返回某列值的和
