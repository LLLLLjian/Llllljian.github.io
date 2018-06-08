---
title: PHP_Yii框架 (22)
date: 2018-03-06
tags: Yii
toc: true
---

### 数据提供器
    数据提供者是一个实现了 yii\data\DataProviderInterface 接口的类. 它主要用于获取分页和数据排序.它经常用在 data widgets 小物件里,方便终端用户进行分页与数据排序

<!-- more -->

#### 活动数据提供者
- 活动数据提供者[ActiveDataProvider]
    ```php
        use yii\data\ActiveDataProvider;

        $query = Banji::find();
        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            // 分页
            'pagination' => [
                'pageSize' => 4,
            ],
            // 排序
            'sort' => [
                  'defaultOrder' => [
                      'classctime' => SORT_DESC,
                      'id' => SORT_ASC,
                  ],
                  // 允许排序的字段
                  'attribute' => ['id'. 'classctime']
              ],
        ]);

        $this->load($params);

        if (!$this->validate()) {
            // 搜索有问题时是否展示数据,下边的条件永远不会成立,所以会返回空
            // $query->where('0=1');
            return $dataProvider;
        }

        // 额外过滤条件 $this->id为空将不加入条件
        // rule中需要定义这些字段都是safe安全的
        $query->andFilterWhere([
            'id' => $this->id,
        ]);

        if (!empty($this->classctime)) {
            $query->andFilterWhere(['between', 'classctime', strtotime($this->classctime), strtotime($this->classctime) + 86399]);//正确
        }

        if (!empty($this->classauthorid)) {
            $query->andFilterWhere(['in', 'classauthorid', User::getUseridArrByLikeNickname($this->classauthorid)]);
        }

        $query->andFilterWhere(['like', 'classname', $this->classname]) 
              ->andFilterWhere(['like', 'classnotice', $this->classnotice]);

        // 自己添加 目的是将创建者id改为创建者名字
        // 小表的话可以直接使用表关联的方式在视图上展示
        //$banjiInfo = $dataProvider->models;
        $banjiInfo = $dataProvider->getModels();
        if (!empty($banjiInfo)) {
            foreach ($banjiInfo as $key => $value) {
                $idArr[] = $value->classauthorid;
            }
            $nicknameArr = User::getUsernicknameByidArr($idArr);
            
            foreach ($banjiInfo as $key => $value) {
                if (array_key_exists($value->classauthorid, $nicknameArr)) {
                    $value->classauthorid = $nicknameArr[$value->classauthorid];
                }
            }
        }
        return $dataProvider;
    ```

#### SQL数据提供者
- SQL数据提供者[SqlDataProvider]
    ```php
        use yii\data\SqlDataProvider;

        // 获取总数
        $count = Yii::$app->db->createCommand('SELECT COUNT(*) FROM post WHERE status=:status', [':status' => 1])->queryScalar();

        $provider = new SqlDataProvider([
            // SQL语句
            'sql' => 'SELECT * FROM post WHERE status=:status',
            // 绑定的参数
            'params' => [':status' => 1],
            // 总数
            'totalCount' => $count,
            // 每页展示的数据条数
            'pagination' => [
                'pageSize' => 10,
            ],
            // 排序
            'sort' => [
                'attributes' => [
                    'title',
                    'view_count',
                    'created_at',
                ],
            ],
        ]);

        // 返回包含每一行的数组
        $models = $provider->getModels();
    ```

#### 数组数据提供者
- 数组数据提供者[ArrayDataProvider]
    ```php
        use yii\data\ArrayDataProvider;

        $data = [
            ['id' => 1, 'name' => 'name 1', ...],
            ['id' => 2, 'name' => 'name 2', ...],
            ...
            ['id' => 100, 'name' => 'name 100', ...],
        ];

        $provider = new ArrayDataProvider([
            // 基本数组
            'allModels' => $data,
            // 每页展示的条数
            'pagination' => [
                'pageSize' => 10,
            ],
            // 排序字段
            'sort' => [
                'attributes' => ['id', 'name'],
            ],
        ]);

        // 获取当前请求页的每一行数据
        $rows = $provider->getModels();
    ```