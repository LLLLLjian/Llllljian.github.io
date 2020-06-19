---
title: Interview_总结 (78)
date: 2020-03-19
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列-mysql联合索引

<!-- more -->

#### 最左前缀
> 所谓最左原则指的就是如果你的 SQL 语句中用到了联合索引中的最左边的索引,那么这条 SQL 语句就可以利用这个联合索引去进行匹配,值得注意的是,当遇到范围查询(>、<、between、like)就会停止匹配.
- eg
    * 假设,我们对(a, b, c)字段建立一个索引
    * 可以用到索引的
    ```sql
        a = 1
        a = 1 and b = 2
        a = 1 and b = 2 and c = 3
        b = 2 and a = 1
    ```
    * 用不到索引的
    ```sql
        b = 2
        a = 1 and b > 2 and c = 3 
    ```

#### 联合索引
    假设,我们创建了一个联合索引(年龄, 姓氏, 名字), 它的存储如下, 可以看到年龄是有序的, 姓氏和名字都是相对有序的. 比如说 如果年龄是固定的 那么姓氏是有序的, 比如说 年龄和姓氏是固定的, 那么名字是有序的
    最左前缀就是遵循的这个规则
![联合索引](/img/20200319_1.png)

#### 实战
- Q1 : 下面的sql如何建立索引
    ```sql
        SELECT * FROM table WHERE a = 1 and b = 2 and c = 3;
    ```
- A1
    * (a,b,c)或者(c,b,a)或者(b,a,c)都可以,重点要的是将区分度高的字段放在前面,区分度低的字段放后面.像性别、状态这种字段区分度就很低,我们一般放后面
- Q2 : 下面的sql如何建立索引
    ```sql
        SELECT * FROM table WHERE a > 1 and b = 2; 
    ```
- A2
    * 对(b,a)建立索引.如果你建立的是(a,b)索引,那么只有a字段能用得上索引,毕竟最左匹配原则遇到范围查询就停止匹配.如果对(b,a)建立索引那么两个字段都能用上,优化器会帮我们调整where后a,b的顺序,让我们用上索引
- Q3 : 下面的sql如何建立索引
    ```sql
        SELECT * FROM `table` WHERE a > 1 and b = 2 and c > 3; 
    ```
- A3
    *  (b,a)或者(b,c)都可以
- Q4 : 下面的sql如何建立索引
    ```sql
        SELECT * FROM `table` WHERE a = 1 ORDER BY b;
    ```
- A4
    * 对(a,b)建索引,当a = 1的时候,b相对有序,可以避免再次排序
- Q5 : 下面的sql如何建立索引
    ```sql
        SELECT * FROM `table` WHERE a > 1 ORDER BY b; 
    ```
- A5
    * 对(a)建立索引,因为a的值是一个范围,这个范围内b值是无序的
- Q6 : 下面的sql如何建立索引
    ```sql
        SELECT * FROM `table` WHERE a IN (1,2,3) and b > 1;
    ```
- A6
    * 对(a,b)建立索引,因为IN在这里可以视为等值引用,不会中止索引匹配



