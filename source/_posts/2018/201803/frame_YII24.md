---
title: PHP_Yii框架 (24)
date: 2018-03-08
tags: Yii
toc: true
---

### GridView
    主要使用在views\xxx\index.php,展示表中的部分数据

<!-- more -->

#### 方式1
- 说明
    * 通过在继承AR的类中书写关联关系,相当于对每一个message中都添加了对应的用户的属性receUsername、sendUsername,而nickname是其中的一个属性
- 基本查询次数
    * SELECT COUNT(*) FROM `message`
    * SELECT * FROM `message` LIMIT 20
    * SELECT `nickname` FROM `user` WHERE `id`=1
    * SELECT * FROM `user` WHERE `id`=2
    * 每一条记录都会去查发送人和请求人,上边两条sql执行测试 = 当页数据条数 * 2
- 使用实例
    ```php
    // index.php
        use yii\grid\GridView;
        use yii\widgets\Pjax;

        <?php yii\widgets\Pjax::begin() ?>
            <?= GridView::widget([
                'dataProvider' => $dataProvider,
                'filterModel' => $searchModel,
                'columns' => [
                    'id',
                    [
                        // 关联表数据展示
                        'attribute' => 'senderid',
                        // 对应的是继承AR类的Message中的getSendUsername方法
                        'value' => 'sendUsername.nickname'
                    ],
                    [
                        // 关联表数据展示
                        'attribute' => 'receiverid',
                        // 对应的是继承AR类的Message中的getReceUsername方法
                        'value' => 'receUsername.nickname'
                    ],
                    'sendmsg',
                    'sendtime:datetime',
                    ['class' => 'yii\grid\ActionColumn'],
                ],
            ]); ?>
        <?php Pjax::end();?>

    // Message.php
        class Message extends \yii\db\ActiveRecord
        {
            public function getSendUsername()
            {
                // SELECT nickname
                return $this->hasOne(User::className(), ['id' => 'senderid'])->select("nickname");
            }

            public function getReceUsername()
            {
                // SELECT * 
                return $this->hasOne(User::className(), ['id' => 'receiverid']);
            }
        }
    ```

#### 方式2
- 说明
    在映射到视图之前对数据进行操作,用一个in查询查出所有相关数据然后分别填充到对应的对象中
- 基本查询次数
    * SELECT COUNT(*) FROM `message`
    * SELECT * FROM `message` LIMIT 20
    * SELECT `id`, `nickname` FROM `user` WHERE `id` IN (1, 2, 4, 3)
- 使用实例
    ```php
    // index.php
        use yii\grid\GridView;
        use yii\widgets\Pjax;

        <?php yii\widgets\Pjax::begin() ?>
            <?= GridView::widget([
                'dataProvider' => $dataProvider,
                'filterModel' => $searchModel,
                'columns' => [
                    'id',
                    'senderid',
                    'receiverid',
                    'sendmsg',
                    'sendtime:datetime',
                    ['class' => 'yii\grid\ActionColumn'],
                ],
            ]); ?>
        <?php Pjax::end();?>

    // MessageSearch.php
        use yii\helpers\ArrayHelper;

        public function search($params)
        {
            ...

            // 获取所有查询到的对象
            $messageInfoArr = $dataProvider->models;
            if (!empty($messageInfoArr)) {
                // 通过ArrayHelper::map获取对象中的senderid,receiverid
                $senderIdArr = ArrayHelper::map($messageInfoArr, 'senderid', 'senderid');
                $receiverIdArr = ArrayHelper::map($messageInfoArr, 'receiverid', 'receiverid');
                $idArr = ArrayHelper::merge($senderIdArr, $receiverIdArr);
                $nicknameArr = User::getUsernicknameByidArr($idArr);
                
                foreach ($messageInfoArr as $key => $value) {
                    if (array_key_exists($value->senderid, $nicknameArr)) {
                        $value->senderid = $nicknameArr[$value->senderid];
                    }
                    if (array_key_exists($value->receiverid, $nicknameArr)) {
                        $value->receiverid = $nicknameArr[$value->receiverid];
                    }
                }
            }

            return $dataProvider;
        }
    
    // User.php
        class User extends \yii\db\ActiveRecord
        {
            static function getUsernicknameByidArr($id) 
            {
                $id = array_unique($id);
                $nicknameArr = User::find()->select(['id','nickname'])->where(['in','id',$id])->asArray()->all();
                return array_filter(array_column($nicknameArr, 'nickname', 'id'));
            }
        }
    ```

#### 表格列
- yii\grid\Column
    * 基础列
    * 属性
        * options：列组标记的HTML属性
        * header：允许为头部行设置内容.
        * footer：允许为尾部行设置内容.
        * visible：定义某个列是否可见
        * content：允许你传递一个有效的PHP回调来为一行返回数据
            ```php
                function ($model, $key, $index, $column) {
                    return 'a string';
                }
            ```
- yii\grid\DataColumn
    * 默认列表,从yii\grid\Column扩展而来
    * 属性
        * attribute：与此列关联的属性名称
        * filter：表示用于此数据列的过滤器输入(例如文本字段,下拉列表）的HTML代码
        * format：每个数据模型的值以何种格式显示
        * label：显示标签,并在为此列启用排序时用作排序链接标签,可对应继承AR类中的attribute
        * value：一个匿名函数或用于确定要显示在当前列中的值的字符串
- yii\grid\SerialColumn
    * 序号自增列,从yii\grid\Column扩展而来
    * 渲染行号,以1起始并自动增长
- yii\grid\ActionColumn
    * 动作列,从yii\grid\Column扩展而来
    * 属性
        * template：展示哪些按钮,默认是
            * `查看` `view` &lt;span class="glyphicon glyphicon-eye-open">&lt;/span>
            * `修改` `update` &lt;span class="glyphicon glyphicon-pencil">&lt;/span>
            * `删除` `delete` &lt;span class="glyphicon glyphicon-trash">&lt;/span>
        * buttons：回调函数相关
            ```php
                function ($url, $model, $key) {
                    // return the button HTML code
                    // $url：列为按钮创建的URL
                    // $model：为当前行呈现的模型对象
                    // $key：数据提供者数组中模型的关键字
                }
            ```
        * header：活动列表头展示的文字
        * headerOptions：活动列拥有的css样式
- yii\grid\CheckboxColumn
    * 多选按钮列,从yii\grid\Column扩展而来
    * 属性
        * name：输入复选框输入字段的名称
    * 获取
        * var keys = $('#grid').yiiGridView('getSelectedRows');

#### 数据过滤
- 要点:只有该属性是安全的才能被搜索
- 使用实例[方式1]
    * search
        ```php
            <?php
            namespace app\models;

            use Yii;
            use yii\base\Model;
            use yii\data\ActiveDataProvider;

            class PostSearch extends Post
            {
                public function attributes()
                {
                    // 添加关联字段到可搜索属性集合
                    return array_merge(parent::attributes(), ['author.name']);
                }


                public function rules()
                {
                    // 只有在 rules() 函数中声明的字段才可以搜索
                    return [
                        [['id'], 'integer'],
                        [['title', 'creation_date', 'author.name'], 'safe'],
                    ];
                }

                public function scenarios()
                {
                    // 旁路在父类中实现的 scenarios() 函数
                    return Model::scenarios();
                }

                public function search($params)
                {
                    $query = Post::find();

                    $dataProvider = new ActiveDataProvider([
                        'query' => $query,
                    ]);

                    $query->joinWith(['author' => function($query) { $query->from(['author' => 'users']); }]);
                    
                    $dataProvider->sort->defaultOrder = ['author.name' => SORT_ASC];
                    // 使得关联字段可以排序
                    $dataProvider->sort->attributes['author.name'] = [
                        'asc' => ['author.name' => SORT_ASC],
                        'desc' => ['author.name' => SORT_DESC],
                    ];

                    // 从参数的数据中加载过滤条件,并验证
                    if (!($this->load($params) && $this->validate())) {
                        return $dataProvider;
                    }

                    // 增加过滤条件来调整查询对象
                    $query->andFilterWhere(['id' => $this->id]);
                    $query->andFilterWhere(['like', 'title', $this->title])
                        ->andFilterWhere(['like', 'creation_date', $this->creation_date]);

                    $query->andFilterWhere(['LIKE', 'author.name', $this->getAttribute('author.name')]);

                    return $dataProvider;
                }
            }
        ```
    * controller
        ```php
            $searchModel = new PostSearch();
            $dataProvider = $searchModel->search(Yii::$app->request->get());

            return $this->render('myview', [
                'dataProvider' => $dataProvider,
                'searchModel' => $searchModel,
            ]);
        ```
    * view
        ```php
            echo GridView::widget([
                'dataProvider' => $dataProvider,
                'filterModel' => $searchModel,
                'columns' => [
                    // ...
                ],
            ]);
        ```
- 使用实例[方式2]
    * search
        ```php
            namespace common\models;

            use Yii;
            use yii\base\Model;
            use yii\data\ActiveDataProvider;
            use common\models\Liuyan;

            class LiuyanSearch extends Liuyan
            {
                public function rules()
                {
                    return [
                        [['id', 'lyid', 'lytime', 'ispublic','lycontent'], 'safe'],
                    ];
                }

                public function scenarios()
                {
                    // bypass scenarios() implementation in the parent class
                    return Model::scenarios();
                }

                public function search($params)
                {
                    $query = Liuyan::find();

                    $dataProvider = new ActiveDataProvider([
                        'query' => $query,
                        'pagination' => [
                            'pageSize' => 4,
                        ],
                        // 何种字段可以进行排序
                        'sort' => [
                            'attributes' => ['id', 'lytime', 'ispublic'],
                        ],
                    ]);

                    $this->load($params);

                    if (!$this->validate()) {
                        // 没有通过验证的话可以利用0=1的条件直接返回为空
                        // $query->where('0=1');
                        return $dataProvider;
                    }

                    $query->andFilterWhere([
                        'id' => $this->id,
                        'ispublic' => $this->ispublic,
                    ]);

                    if (!empty($this->lytime)) {
                        $query->andFilterWhere(['between', 'lytime', strtotime($this->lytime), strtotime($this->lytime) + 86399]);//正确
                    }

                    if (!empty($this->lyid)) {
                        $query->andFilterWhere(['in', 'lyid', User::getUseridArrByLikeNickname($this->lyid)]);
                    }

                    $query->andFilterWhere(['like', 'lycontent', $this->lycontent]);

                    // 获取所有查询到的对象
                    $liuyanInfoArr = $dataProvider->models;
                    if (!empty($liuyanInfoArr)) {
                        $lyIdArr = ArrayHelper::map($liuyanInfoArr, 'lyid', 'lyid');
                        $nicknameArr = User::getUsernicknameByidArr($lyIdArr);
                        
                        foreach ($liuyanInfoArr as $key => $value) {
                            if (array_key_exists($value->lyid, $nicknameArr)) {
                                $value->lyid = $nicknameArr[$value->lyid];
                            }
                        }
                    }

                    return $dataProvider;
                }
            }
        ```
    * controller
        ```php
            $searchModel = new PostSearch();
            $dataProvider = $searchModel->search(Yii::$app->request->get());

            return $this->render('myview', [
                'dataProvider' => $dataProvider,
                'searchModel' => $searchModel,
            ]);
        ```
    * view
        ```php
            echo GridView::widget([
                'dataProvider' => $dataProvider,
                'filterModel' => $searchModel,
                'columns' => [
                    // ...
                ],
            ]);
        ```


#### 实例整理
    ```php
        use yii\helpers\Html;
        use yii\helpers\Url;
        use yii\grid\GridView;
        use common\models\Photo;
        use yii\helpers\StringHelper;

        <?= GridView::widget([
            'dataProvider' => $dataProvider,
            'filterModel' => $searchModel,
            'options' => [
                'class' => 'grid-view',
                'style' => 'overflow:auto',
                'id' => 'grid'
            ],
            'columns' => [
                [
                    'attribute' => 'url',
                    'format' => 'raw',
                    'value' => function($searchModel) {
                        return Html::img($searchModel->url, ['alt' => '上传图片', 'width' => '100px']);
                    }
                ],
                'cid',
                // 格式化时间
                'ctime : datetime',
                [
                    'attribute' => 'state',
                    'value' => function($searchModel){
                        return Photo::$state[$searchModel->state];
                    },
                    'filter' => Html::activeDropDownList(
                        $searchModel, 'state', Photo::$state, ['prompt' => '全部', 'class' => 'form-control', 'id' => null]
                    )
                ],
                [
                    'attribute' => 'role',
                    'value' => 'user.role',
                    'filter' => Html::activeTextInput($searchModel, 'role', [
                        'class' => 'form-control', 'id' => null
                    ]),
                ],
                [
                    'attribute' => 'notice',
                    'format' => 'ntext',                
                    'value' => function($searchModel){
                        return StringHelper::truncate_utf8_string($searchModel->notice,5,'...');
                    }
                ],
                ['class' => 'yii\grid\ActionColumn',
                'header' => '操作',
                'headerOptions' => ['width' => '100',  'class' => 'text-center'],
                'template' => '{view}&nbsp;{update}&nbsp;{delete}&nbsp;{changestateok}&nbsp;{changestateremove}',
                'buttons' => [
                    'changestateok' => function($url, $model, $key) {
                        $options = [
                            'title' => Yii::t('yii', 'Changestateok'),
                            'aria-label' => Yii::t('yii', 'Changestateok'),
                            'data-confirm' => Yii::t('yii', '确定图片通过审核吗?'),
                            'data-method' => 'post',
                            'data-pjax' => '0',
                        ];
                        return $model->state==0 ? Html::a('<span class="glyphicon glyphicon-ok"></span>', $url, $options) : "";
                    },
                    'changestateremove' => function($url, $model, $key) {
                        $options = [
                            'title' => Yii::t('yii', 'Changestateremove'),
                            'aria-label' => Yii::t('yii', 'Changestateremove'),
                            'data-confirm' => Yii::t('yii', '确定图片取消审核吗?'),
                            'data-method' => 'post',
                            'data-pjax' => '0',
                        ];
                        return $model->state==1 ? Html::a('<span class="glyphicon glyphicon-remove"></span>', $url, $options) : "";
                    },
                ],
                ],
            ],
            'pager' => [
                'options' => ['class' => ['pull-right','pagination']]
            ]
        ]); ?>

        <script>
            $(document).ready(function () {
                $("按钮").click(function () {
                    var url = '<? Url::to(['c/a']) ?>';
                    var param = $("#grid").yiiGridView("getSelectedRows");

                    if (param.length > 0) {
                        if (confirm("确定要进行操作吗？")) {

                        }
                    } else {
                        alert("请至少选择一项纪录！");
                    }
                })
            })
        </script>
    ```
