---
title: PHP_Yii框架 (29)
date: 2018-03-15
tags: Yii
toc: true
---

### 数组助手类
    更高效地处理数组或者对象

<!-- more -->    
 
#### getValue
- 作用
    * 获取数组或者对象中的值
- 实例
    ```bash
        public function actionView($id)
        {
            $model = $this->findModel($id);
            var_dump(Yii::$app->request->queryParams);
            echo "<hr />";
            $id = ArrayHelper::getValue(Yii::$app->request->queryParams, 'id');
            var_dump($id);
            echo "<hr />";
            var_dump($model);
            echo "<hr />";
            var_dump(ArrayHelper::getValue($model, "classname"));
            echo "<hr />";
            $classInfo = ArrayHelper::getValue($model, function ($model, $defaultValue) {
                return "id为".$model->id.',班级名称为'.$model->classname;
            });
            var_dump($classInfo);
        }

        // 输出结果
        array(1) { ["id"]=> string(1) "3" } 
        string(1) "3" 
        object(common\models\Banji)#101 (8) {...} 
        string(13) "班级名称2" 
        string(35) "id为3,班级名称为班级名称2" 
    ```

#### setValue
- 作用
    * 设置数组或者对象中的值
    * 注意 : yii2.0.13才有这个属性
- 实例
    ```bash
        public function actionView($id)
        {
            $model = $this->findModel($id);
            var_dump(Yii::$app->request->queryParams);
            echo "<hr />";
            ArrayHelper::setValue(Yii::$app->request->queryParams, 'id', '7');
            var_dump($Yii::$app->request->queryParams);
            echo "<hr />";
            var_dump($model);
            echo "<hr />";
            ArrayHelper::setValue($model, "classname", "班级信息7");
            echo "<hr />";
            var_dump($model);
        }

        // 输出结果
        array(1) { ["id"]=> string(1) "3" } 
        array(1) { ["id"]=> string(1) "7" } 
        object(common\models\Banji)#101 (8) {..班级名称2.} 
        object(common\models\Banji)#101 (8) {..班级信息7.} 
    ```

#### remove
- 作用
    * 获得一个值，然后立即从数组中删除它
- 实例
    ```bash
        $paramsArr = Yii::$app->request->queryParams;
        var_dump($paramsArr);
        echo "<br />";
        $type = ArrayHelper::remove($paramsArr, 'abc');
        var_dump($paramsArr);
        echo "<br />";
        var_dump($type);

        // 输出结果
        array(2) { ["id"]=> string(1) "3" ["abc"]=> string(4) "1234" }
        array(1) { ["id"]=> string(1) "3" }
        string(4) "1234" 
    ```

#### keyExists
- 作用
    * key是否存在,支持大小写
- 实例
    ```bash
        $data1 = [
            'first' => null, 
            'second' => 4
        ];

        $data2 = [
            'First' => null, 
            'Second' => 4
        ];
        var_dump(isset($data1['first']));// bool(false) 
        echo "<br />";
        var_dump(isset($data2['first'])); // bool(false) 
        echo "<br />";
        var_dump(array_key_exists('first', $data1)); // bool(true) 
        echo "<br />";
        var_dump(array_key_exists('first', $data2)); // bool(false) 
        echo "<br />";
        var_dump(ArrayHelper::keyExists('first', $data1, false)); // bool(true) 
        echo "<br />";
        var_dump(ArrayHelper::keyExists('first', $data2, false)); // bool(true) 
        echo "<br />";
        var_dump(ArrayHelper::keyExists('first', $data1)); // bool(true) 
        echo "<br />";
        var_dump(ArrayHelper::keyExists('first', $data2)); // bool(false) 
    ```

#### getColumn
- 作用
    * 获取二维数组或者对象中的某一列元素,类似array_column($arr, $key)
- 实例
    ```bash
        $banjiInfo = $dataProvider->getModels();
        $idArr = ArrayHelper::getColumn($banjiInfo, 'classauthorid');
        var_dump($idArr);
        echo "<br />";
        $classmtimeArr = ArrayHelper::getColumn($banjiInfo, ($element) {
            return date("Y-m-d H:i:s", $element['classmtime']);
        });
        var_dump($classmtimeArr);s

        // 输出结果
        array(4) { [0]=> int(17) [1]=> int(19) [2]=> int(17) [3]=> int(17) } 
        array(4) { [0]=> string(19) "2017-09-20 13:31:52" [1]=> string(19) "2017-08-23 13:15:16" [2]=> string(19) "2017-08-23 09:36:03" [3]=> string(19) "2017-08-20 15:05:13" } ss
    ```

#### index
- 作用
    * 取出某一列作为多维数组的key
- 实例
    ```bash
        $array = [
            ['id' => 'a1', 'username' => 'a2', 'nickname' => 'a3'],
            ['id' => 'b1', 'username' => 'b2', 'nickname' => 'b3'],
            ['id' => 'c1', 'username' => 'c2', 'nickname' => 'b3']
        ];
        var_dump($array);
        $result = ArrayHelper::index($array, 'id');
        echo "<br />";
        var_dump($result);
        echo "<br />";
        $result = ArrayHelper::index($array, function ($element) {
            return strtoupper($element['id']);
        });
        var_dump($result);
        echo "<br />";
        $result = ArrayHelper::index($array, null, function ($element) {
            return strtoupper($element['nickname']);
        });
        var_dump($result);
        echo "<br />";

        // 输出结果
        Array ( 
            [0] => Array ( [id] => a1 [username] => a2 [nickname] => a3 ) 
            [1] => Array ( [id] => b1 [username] => b2 [nickname] => b3 ) 
            [2] => Array ( [id] => c1 [username] => c2 [nickname] => b3 ) )
        Array ( 
            [a1] => Array ( [id] => a1 [username] => a2 [nickname] => a3 ) 
            [b1] => Array ( [id] => b1 [username] => b2 [nickname] => b3 ) 
            [c1] => Array ( [id] => c1 [username] => c2 [nickname] => b3 ) )
        Array ( 
            [A1] => Array ( [id] => a1 [username] => a2 [nickname] => a3 ) 
            [B1] => Array ( [id] => b1 [username] => b2 [nickname] => b3 ) 
            [C1] => Array ( [id] => c1 [username] => c2 [nickname] => b3 ) )
        Array ( 
            [A3] => Array ( 
                [0] => Array ( [id] => a1 [username] => a2 [nickname] => a3 ) ) 
            [B3] => Array ( 
                [0] => Array ( [id] => b1 [username] => b2 [nickname] => b3 ) 
                [1] => Array ( [id] => c1 [username] => c2 [nickname] => b3 ) ) )
    ```

#### map
- 作用
    * 取出数组或者对象中的某几列组成一个新的数组
- 实例
    ```bash
        $array = [
            ['id' => 'a1', 'username' => 'a2', 'nickname' => 'a3'],
            ['id' => 'b1', 'username' => 'b2', 'nickname' => 'b3'],
            ['id' => 'c1', 'username' => 'c2', 'nickname' => 'b3']
        ];
        print_r($array);
        echo "<br />";
        $result = ArrayHelper::map($array, 'id', 'username');
        print_r($result);
        echo "<br />";
        $result = ArrayHelper::map($array, 'id', 'username', 'nickname');
        print_r($result);

        // 输出结果
        Array ( 
            [0] => Array ( [id] => a1 [username] => a2 [nickname] => a3 ) 
            [1] => Array ( [id] => b1 [username] => b2 [nickname] => b3 ) 
            [2] => Array ( [id] => c1 [username] => c2 [nickname] => b3 ) )
        Array ( 
            [a1] => a2 
            [b1] => b2 
            [c1] => c2 )
        Array ( 
            [a3] => Array ( 
                [a1] => a2 ) 
            [b3] => Array ( 
                [b1] => b2 
                [c1] => c2 ) ) 
    ```

#### multisort
- 作用
    * 实现二维数组或对象排序
- 实例
    ```bash
        $array = [
            ['id' => '1', 'username' => '3', 'nickname' => 'a3'],
            ['id' => '3', 'username' => '2', 'nickname' => 'b3'],
            ['id' => '3', 'username' => '1', 'nickname' => 'b3']
        ];
        print_r($array);
        echo "<br />";
        // id正序 usernam倒序
        ArrayHelper::multisort($array, ['id', 'username'], [SORT_ASC, SORT_DESC]);
        print_r($array);

        // 输出结果
        Array ( 
            [0] => Array ( [id] => 1 [username] => 3 [nickname] => a3 ) 
            [1] => Array ( [id] => 3 [username] => 2 [nickname] => b3 ) 
            [2] => Array ( [id] => 3 [username] => 1 [nickname] => b3 ) )
        Array ( 
            [0] => Array ( [id] => 1 [username] => 3 [nickname] => a3 ) 
            [1] => Array ( [id] => 3 [username] => 2 [nickname] => b3 ) 
            [2] => Array ( [id] => 3 [username] => 1 [nickname] => b3 ) ) 
    ```

#### isAssociative||isIndexed
- 作用
    * 判断数组是**关联数组**[键值是字符串,并且是人为的规定]还是**索引数组**[键是整数,而且从0开始以此类推]
- 实例
    ```bash
        $indexed = ['aaa', 'bbb'];
        var_dump(ArrayHelper::isIndexed($indexed));
        echo "<br />";
        var_dump(ArrayHelper::isAssociative($indexed));
        echo "<hr />";

        $associative = ['aaa' => 'aaa', 'bbb' => 'bbb'];
        var_dump(ArrayHelper::isIndexed($associative));
        echo "<br />";
        var_dump(ArrayHelper::isAssociative($associative));

        // 输出结果
        bool(true)
        bool(false) 
        bool(false)
        bool(true) 
    ```

#### htmlEncode||htmlDecodes
- 作用
    * 对数组中的内容是否进行Html转义.
    * 第二个参数默认是true,不对key进行处理.false也对key进行处理
- 实例
    ```bash
        $data = array(
            "<strong>html</strong>" => "<br />换行",
            "换行",
            "<br />"
        );
        var_dump($data);
        echo "<hr />";
        $encoded = ArrayHelper::htmlEncode($data, false);
        var_dump($encoded);
        echo "<hr />";
        $decoded = ArrayHelper::htmlDecode($encoded, false);
        var_dump($decoded);

        // 输出内容
        解析成html输出
        原样输出
        解析成html输出
    ```

#### merge
- 作用
    * 合并数组
    * 如果每个数组都有一个具有相同字符串键值的元素,则后者将覆盖前者
    * 如果两个数组都有一个数组类型的元素并且具有相同的键,则将执行递归合并。 
    * 对于整数键的元素,来自后一个数组的元素将被附加到前一个数组.
    * 可以使用 yii\helpers\UnsetArrayValue对象来取消前一个数组的值或 yii\helpers\ReplaceArrayValue以强制替换先前的值而不是递归合并。
- 实例
    ```bash
        $array1 = [
            'name' => 'Yii',
            'version' => '1.1',
            'ids' => [
                1,
            ],
            'validDomains' => [
                'example.com',
                'www.example.com',
            ],
            'emails' => [
                'admin' => 'admin@example.com',
                'dev' => 'dev@example.com',
            ],
        ];

        $array2 = [
            'version' => '2.0',
            'ids' => [
                2,
            ],
            'validDomains' => new \yii\helpers\ReplaceArrayValue([
                'yiiframework.com',
                'www.yiiframework.com',
            ]),
            'emails' => [
                'dev' => new \yii\helpers\UnsetArrayValue(),
            ],
        ];

        $result = ArrayHelper::merge($array1, $array2);

        // 输出结果
        [
            'name' => 'Yii',
            'version' => '2.0',
            'ids' => [
                1,
                2,
            ],
            'validDomains' => [
                'yiiframework.com',
                'www.yiiframework.com',
            ],
            'emails' => [
                'admin' => 'admin@example.com',
            ],
        ]
    ```

#### isSubset||isIn
- 作用
    * 数组中是否存在
    * ？对象中是否存在？ => 验证失败
- 实例
    ```bash
        var_dump(ArrayHelper::isIn('a', ['a'])); // bool(true) 
    ```