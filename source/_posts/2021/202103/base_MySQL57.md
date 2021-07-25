---
title: MySQL_基础 (57)
date: 2021-03-08
tags: MySQL
toc: true
---

### 更好的理解MySQL
    嘻嘻嘻 数据库弄好了 下一步就是迁移数据了呀

<!-- more -->

#### 故事背景
> 之前的数据库在docker容器里, 现在我重新在物理机上搞了一个mysql,得把之前的数据迁移出来呀

#### 导出导入所有数据库的数据
1. 导出
    ```sql
        mysqldump -u root -p123456 --all-databases > all.sql
    ```
2. 导入
    ```sql
        mysql -u root -p123456 < ./all.sql
    ```

#### 导出导入指定数据库的数据
1. 导出
    ```sql
        mysqldump -u root -p123456 test > test.sql
    ```
2. 导入
    ```sql
        mysql -u root -p123456 test < ./test.sql
    ```

#### 导入导出指定表的数据
1. 导出
    ```sql
        mysqldump -u root -p123456 scistock calcgsdata_once > calcgsdata_once.sql
    ```
2. 导入
    ```sql
        mysql -u root -p123456 scistock < ./calcgsdata_once.sql
    ```

#### 导入的其它办法
- source
    1. 登录MySQL
    2. use dbname
    3. source ./calcgsdata_once.sql;



