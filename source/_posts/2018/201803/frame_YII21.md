---
title: PHP_Yii框架 (21)
date: 2018-03-05
tags: Yii
toc: true
---

#### 分页
    当一次要在一个页面上显示很多数据时, 通常需要将其分成几部分, 每个部分都包含一些数据列表并且一次只显示一部分.使用条件：数据量过多或者表过大,否则直接使用ActiveDataProvider即可

<!-- more -->

- Search
    ```php
        use yii\data\Pagination;

        // 创建一个 DB 查询来获得所有 status 为 1 的文章
        $query = Article::find()->where(['status' => 1]);

        // 得到文章的总数(但是还没有从数据库取数据)
        $count = $query->count();

        // 使用总数来创建一个分页对象
        $pagination = new Pagination(['totalCount' => $count]);
        // 设置每页展示的数量,默认为20
        $pagination->setPageSize(10);

        // 使用分页对象来填充 limit 子句并取得文章数据
        $articles = $query->offset($pagination->offset)
                          ->limit($pagination->limit)
                          ->asArray()
                          ->all();
    ```

- views
    ```php
        use yii\widgets\LinkPager;

        echo LinkPager::widget([
            'pagination' => $pagination,
        ]);
    ```

#### 排序
    展示多条数据时,通常需要对数据按照用户指定的列进行排序

- Search
    ```php
        use yii\data\Sort;

        $sort = new Sort([
            'attributes' => [
                'age',
                'name' => [
                    'asc' => ['first_name' => SORT_ASC, 'last_name' => SORT_ASC],
                    'desc' => ['first_name' => SORT_DESC, 'last_name' => SORT_DESC],
                    // 第一次请求时按什么排序,默认为降序方向
                    'default' => SORT_DESC,
                    'label' => 'Name',
                ],
            ],
        ]);

        $articles = Article::find()->where(['status' => 1])
                                   ->orderBy($sort->orders)
                                   ->asArray()
                                   ->all();
    ```

- Active Record
    ```php
        public function attributeLabels()
        {
            return [
                'age' => [
                    'asc' => ['age' => SORT_ASC],
                    'desc' => ['age' => SORT_DESC],
                    'default' => SORT_ASC,
                    'label' => Inflector::camel2words('age'),
                ]
            ];
        }
    ```
