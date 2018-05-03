---
title: PHP_Yii框架 (32)
date: 2018-03-20
tags: Yii
toc: true
---

### 关于无限分类
    无限分类的基础前提:需要有一个分类表,必须字段为id,name,pid

<!-- more -->

#### 分类1
    ```bash
        class Menu extends \yii\db\ActiveRecord
        {
            ....
            /**
            * 获取所有的分类
            */
            public function getCategories()
            {
                $data = self::find()->select('id, menuname, pid')->all();
                $data = ArrayHelper::toArray($data);
                return $data;
            }

            /**
            *遍历出各个子类 获得树状结构的数组
            */
            public static function getTree($data, $name = 'name', $pid = 0, $lev = 1)
            {
                $tree = [];
                foreach($data as $value){
                    if($value['pid'] == $pid){
                        $value[$name] = str_repeat('|___',$lev).$value[$name];
                        $tree[] = $value;
                        $tree = array_merge($tree,self::getTree($data, $name, $value['id'], $lev+1));
                    }
                }
                return $tree;
            }

            /**
            * 得到相应id对应的分类名数组
            */
            public function getOptions()
            {
                $data = $this->getCategories();
                $tree = $this->getTree($data, "menuname");
                $list = ['添加顶级分类'];
                foreach($tree as $value){
                    $list[$value['id']] = $value['menuname'];
                }
                return $list;
            }

            //通过id查menuname，主要用于部分页面展示 
            static function getMenunameByidArr($id) 
            {
                $id = array_unique($id);
                $nicknameArr = Menu::find()->select(['id','menuname'])->where(['in','id',$id])->asArray()->all();
                return array_filter(array_column($nicknameArr, 'menuname', 'id'));
            }
            ...
        }

        // 控制器页面
        public function actionCreate()
        {
            $model = new Menu();
            $list = $model->getOptions();
            if ($model->load(Yii::$app->request->post()) && $model->save()) {
                return $this->redirect(['view', 'id' => $model->id]);
            } else {
                return $this->render('create', [
                    'model' => $model,
                    'list' => $list
                ]);
            }
        }

        // 视图页面
        <?= $form->field($model, 'pid')->dropDownList($list) ?>
    ```

#### 分类2
    ```bash
        // 控制器页面
        public function actionCreate()
        {
            $model = new Menu();
            $menuArr = Menu::find()->select(['id', 'menuname as name', 'pid as pId'])->asArray()->all();

            if ($model->load(Yii::$app->request->post()) && $model->add()) {
                return $this->redirect(['view', 'id' => $model->id]);
            } else {
                return $this->render('create', [
                    'tree' => $menuArr,
                    'model' => $model
                ]);
            }
        }

        // 视图页面[封装了一个ztree数小部件]
        <?= $form->field($model, 'pid')->widget(ZtreeFormWidget::className(), [
            'data' => $tree,
            'hiddeninputname' => 'hide_menuname',
            'hiddeninputid' => 'pid',
            'clearvalbtn' => true,
            'select_parent' => true,
            'options' => [
                'readonly' => 'readonly',
                'value' => $model->hide_menuname,
            ],
            'selectedname' => isset($model->hide_menuname) ? $model->hide_menuname : '',
        ]) ?>
    ```
