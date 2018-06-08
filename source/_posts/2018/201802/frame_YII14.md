---
title: PHP_Yii框架 (14)
date: 2018-02-11
tags: Yii
toc: true
---

### 数据访问层
    数据访问层(DAO)提供了简单高效的SQL查询,可以用在与数据库交互的各个地方

<!-- more -->

#### 创建数据库连接
    ```php
        // 写在应用组件配置中
        return [
            // mysql
            'components' => [
                // ...
                'db' => [
                    'class' => 'yii\db\Connection',
                    'dsn' => 'mysql:host=localhost;dbname=example',
                    'username' => 'root',
                    'password' => '',
                    // 表前缀
                    'tablePrefix' => 'tbl_',
                    // 字符编码
                    'charset' => 'utf8',
                ],
            ],
            // ...
        ];

        // 通过 dsn 属性来指明它的数据源名称
        MySQL, MariaDB: mysql:host=localhost;dbname=mydatabase
        SQLite: sqlite:/path/to/database/file
        PostgreSQL: pgsql:host=localhost;port=5432;dbname=mydatabase
        CUBRID: cubrid:dbname=demodb;host=localhost;port=33000
        MS SQL Server (via sqlsrv driver): sqlsrv:Server=localhost;Database=mydatabase
        MS SQL Server (via dblib driver): dblib:host=localhost;dbname=mydatabase
        MS SQL Server (via mssql driver): mssql:host=localhost;dbname=mydatabase
        Oracle: oci:dbname=//localhost:1521/mydatabase
    ```

#### 执行SQL查询
    ```php
        // 返回多行. 每行都是列名和值的关联数组.
        // 如果该查询没有结果则返回空数组
        $posts = Yii::$app->db->createCommand('SELECT * FROM post')
                              ->queryAll();

        // 返回一行 (第一行)
        // 如果该查询没有结果则返回 false
        $post = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=1')
                             ->queryOne();

        // 返回一列 (第一列)
        // 如果该查询没有结果则返回空数组
        $titles = Yii::$app->db->createCommand('SELECT title FROM post')
                               ->queryColumn();

        // 返回一个标量值
        // 如果该查询没有结果则返回 false
        $count = Yii::$app->db->createCommand('SELECT COUNT(*) FROM post')
                              ->queryScalar();

        // 绑定一个参数bindValue
        $post = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id AND status=:status')
                             ->bindValue(':id', $_GET['id'])
                             ->bindValue(':status', 1)
                             ->queryOne();
                        
        // 在一次调用中绑定多个参数值bindValues
        $params = [':id' => $_GET['id'], ':status' => 1];

        $post = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id AND status=:status')
                             ->bindValues($params)
                             ->queryOne();
        $post = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id AND status=:status', $params)
                             ->queryOne();

        // 使用不同的绑定参数 多次执行
        $command = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id');
        $post1 = $command->bindValue(':id', 1)->queryOne();
        $post2 = $command->bindValue(':id', 2)->queryOne();

        $command = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id')
                                ->bindParam(':id', $id);
        $id = 1;
        $post1 = $command->queryOne();

        $id = 2;
        $post2 = $command->queryOne();
    ```

#### 非查询SQL执行
    ```php
        // execute() 方法返回执行 SQL 所影响到的行数.

        // INSERT (table name, column values)
        Yii::$app->db->createCommand()
                     ->insert('user', ['name' => 'Sam', 'age' => 30,])
                     ->execute();

        // UPDATE (table name, column values, condition)
        Yii::$app->db->createCommand()
                     ->update('user', ['status' => 1], 'age > 30')
                     ->execute();

        // DELETE (table name, condition)
        Yii::$app->db->createCommand()
                     ->delete('user', 'status = 0')
                     ->execute();

        // table name, column names, column values
        Yii::$app->db->createCommand()
                     ->batchInsert('user', ['name', 'age'], [['Tom', 30], ['Jane', 20], ['Linda', 25],])
                     ->execute();
    ```