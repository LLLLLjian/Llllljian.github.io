---
title: PHP_Yii框架 (16)
date: 2018-02-26
tags: Yii
toc: true
---

### 活动记录
    活动记录(ActiveRecord)提供了数据库与模型(MVC 中的 M,Model) 的交互

<!-- more -->

#### 生命周期
- 实例化生命周期
    * 前提 : new一个AR实例的时候
    * 类的构造函数调用
    * yii\db\ActiveRecord::init()：触发 yii\db\ActiveRecord::EVENT_INIT 事件

- 查询数据生命周期
    * 前提 : find()数据的时候
    * 类的构造函数调用.
    * yii\db\ActiveRecord::init()：触发 yii\db\ActiveRecord::EVENT_INIT 事件。
    * yii\db\ActiveRecord::afterFind()：触发 yii\db\ActiveRecord::EVENT_AFTER_FIND 事件。

- 保存数据生命周期
    * 前提 : save()方法插入或更新 AR 实例
    * yii\db\ActiveRecord::beforeValidate()：触发 yii\db\ActiveRecord::EVENT_BEFORE_VALIDATE 事件。如果这方法返回 false 或者 yii\base\ModelEvent::$isValid 值为 false，接下来的步骤都会被跳过。
    * 执行数据验证。如果数据验证失败，步骤 3 之后的步骤将被跳过。
    * yii\db\ActiveRecord::afterValidate()：触发 yii\db\ActiveRecord::EVENT_AFTER_VALIDATE 事件。
    * yii\db\ActiveRecord::beforeSave()：触发 yii\db\ActiveRecord::EVENT_BEFORE_INSERT 或者 yii\db\ActiveRecord::EVENT_BEFORE_UPDATE 事件。 如果这方法返回 false 或者 yii\base\ModelEvent::$isValid 值为 false，接下来的步骤都会被跳过。
    * 执行真正的数据插入或者更新。
    * yii\db\ActiveRecord::afterSave()：触发 yii\db\ActiveRecord::EVENT_AFTER_INSERT 或者 yii\db\ActiveRecord::EVENT_AFTER_UPDATE 事件。

- 删除数据生命周期
    * 前提 : delete()数据的时候[updateAll(), deleteAll(), updateCounters(), updateAllCounters()]
    * yii\db\ActiveRecord::beforeDelete()：触发 yii\db\ActiveRecord::EVENT_BEFORE_DELETE 事件。 如果这方法返回 false 或者 yii\base\ModelEvent::$isValid 值为 false，接下来的步骤都会被跳过。
    * 执行真正的数据删除。
    * yii\db\ActiveRecord::afterDelete()：触发 yii\db\ActiveRecord::EVENT_AFTER_DELETE 事件。

- 刷新数据生命周期
    * 前提 : refresh() 刷新 AR 实例
    * 刷新成功方法返回 true，那么 yii\db\ActiveRecord::EVENT_AFTER_REFRESH 事件将被触发

#### 声明AR类
    ```bash
        // Customer对应数据库中的customer表
        namespace app\models;

        use yii\db\ActiveRecord;

        class Customer extends ActiveRecord
        {
            const STATUS_INACTIVE = 0;
            const STATUS_ACTIVE = 1;
            
            /**
            * @return string AR 类关联的数据库表名称
            */
            public static function tableName()
            {
                return '{{customer}}';
                // 如果定义了表前缀 则使用
                // return '{{%TableName}}';   
            }
        }
    ```

#### 建立数据库连接
    ```bash
        // 可以在系统配置中直接配置
        return [
            'components' => [
                'db' => [
                    'class' => 'yii\db\Connection',
                    'dsn' => 'mysql:host=localhost;dbname=testdb',
                    'username' => 'demo',
                    'password' => 'demo',
                ],
            ],
        ];

        // 如果使用不同的数据库 需要在相应的AR类中进行设置
        class Customer extends ActiveRecord
        {
            // ...

            public static function getDb()
            {
                // 使用 "db2" 组件
                return \Yii::$app->db2;  
            }
        }
    ```

#### 查询数据
- 查询步骤
    * 通过 yii\db\ActiveRecord::find() 方法创建一个新的查询生成器对象；
    * 使用 查询生成器的构建方法 来构建你的查询；
    * 调用 查询生成器的查询方法 来取出数据到 AR 实例中
- 查询实例
    ```bash
        // 返回 ID 为 123 的客户：
        // SELECT * FROM `customer` WHERE `id` = 123
        $customer = Customer::find()->where(['id' => 123])
                                    ->one();

        // 取回所有活跃客户并以他们的 ID 排序：
        // SELECT * FROM `customer` WHERE `status` = 1 ORDER BY `id`
        $customers = Customer::find()->where(['status' => Customer::STATUS_ACTIVE])
                                     ->orderBy('id')
                                     ->all();

        // 取回活跃客户的数量：
        // SELECT COUNT(*) FROM `customer` WHERE `status` = 1
        $count = Customer::find()->where(['status' => Customer::STATUS_ACTIVE])
                                 ->count();

        // 以客户 ID 索引结果集：
        // SELECT * FROM `customer`
        $customers = Customer::find()->indexBy('id')
                                     ->all();
                                    
        // 返回 id 为 123 的客户 
        // SELECT * FROM `customer` WHERE `id` = 123
        $customer = Customer::findOne(123);

        // 返回 id 是 100, 101, 123, 124 的客户
        // SELECT * FROM `customer` WHERE `id` IN (100, 101, 123, 124)
        $customers = Customer::findAll([100, 101, 123, 124]);

        // 返回 id 是 123 的活跃客户
        // SELECT * FROM `customer` WHERE `id` = 123 AND `status` = 1
        $customer = Customer::findOne([
            'id' => 123,
            'status' => Customer::STATUS_ACTIVE,
        ]);

        // 返回所有不活跃的客户
        // SELECT * FROM `customer` WHERE `status` = 0
        $customers = Customer::findAll([
            'status' => Customer::STATUS_INACTIVE,
        ]);

        // 返回所有不活跃的客户
        $sql = 'SELECT * FROM customer WHERE status=:status';
        $customers = Customer::findBySql($sql, [':status' => Customer::STATUS_INACTIVE])->all();
    ```

#### 访问数据
- 原始数据
    ```bash
        // "id" 和 "email" 是 "customer" 表中的列名.
        // $customer对应于单个 AR 实例
        $customer = Customer::findOne(123);
        $id = $customer->id;
        $email = $customer->email;
    ```
- 数据转换
    ```bash
        // 在PHP代码中，可以访问 $customer->birthdayText获取ymdhs时间类型
        class Customer extends ActiveRecord
        {
            // ...

            public function getBirthdayText()
            {
                return date('Y-m-d H:i:s', $this->birthday);
            }
            
            public function setBirthdayText($value)
            {
                $this->birthday = strtotime($value);
            }
        }
    ```
- 以数组形式获取数据
    ```bash
        // 返回大量数据时，为了防止内存被大量占用，可以使用数据形式获取数据
        // 返回所有客户
        // 每个客户返回一个关联数组
        $customers = Customer::find()
            ->asArray()
            ->all();
    ```
- 批量获取数据
    ```bash
        // 每次获取 10 条客户数据
        foreach (Customer::find()->batch(10) as $customers) {
            // $customers 是个最多拥有 10 条数据的数组
        }

        // 每次获取 10 条客户数据，然后一条一条迭代它们
        foreach (Customer::find()->each(10) as $customer) {
            // $customer 是个 `Customer` 对象
        }

        // 贪婪加载模式的批处理查询
        foreach (Customer::find()->with('orders')->each() as $customer) {
            // $customer 是个 `Customer` 对象，并附带关联的 `'orders'`
        }
    ```

#### 保存数据
- 保存步骤
    * 准备一个 AR 实例
    * 将新值赋给 AR 的属性
    * 调用 yii\db\ActiveRecord::save() 保存数据到数据库中。
- 保存实例
    ```bash
        // 可以通过检查 AR 实例的 yii\db\ActiveRecord::isNewRecord 属性值来区分更新还是新增

        // 插入新记录 insert
        $customer = new Customer();
        $customer->name = 'James';
        $customer->email = 'james@example.com';
        $customer->save();

        // 更新已存在的记录 update
        $customer = Customer::findOne(123);
        $customer->email = 'james@newexample.com';
        $customer->save();
    ```
- 块赋值
    ```bash
        // 只有安全属性才可以批量赋值
        $values = [
            'name' => 'James',
            'email' => 'james@example.com',
        ];

        $customer = new Customer();

        $customer->attributes = $values;
        $customer->save();
    ```
- 更新计数
    ```bash
        // 单个
        $post = Post::findOne(100);
        // UPDATE `post` SET `view_count` = `view_count` + 1 WHERE `id` = 100
        $post->updateCounters(['view_count' => 1]);

        // 多个
        // UPDATE `customer` SET `age` = `age` + 1
        Customer::updateAllCounters(['age' => 1]);
    ```
- 更新
    ```bash
        //update();  
        //runValidation boolen 是否通过validate()校验字段 默认为true   
        //attributeNames array 需要更新的字段   
        $model->update($runValidation , $attributeNames);    
        
        //updateAll();  
        //update customer set status = 1 where status = 2  
        Customer::updateAll(['status' => 1], 'status = 2');   
        
        //update customer set status = 1 where status = 2 and uid = 1;  
        Customer::updateAll(['status' => 1], ['status'=> '2','uid'=>'1']);  

        // UPDATE `customer` SET `status` = 1 WHERE `email` LIKE `%@example.com%`
        Customer::updateAll(['status' => Customer::STATUS_ACTIVE], ['like', 'email', '@example.com']);
    ```

#### 数据验证
    当调用 yii\db\ActiveRecord::save() 时，默认情况下会自动调用 yii\db\ActiveRecord::validate()。 
    只有当验证通过时，它才会真正地保存数据; 否则将简单地返回false
    可以检查 yii\db\ActiveRecord::errors 属性来获取验证过程的错误消息
    如果你确定你的数据不需要验证（比如说数据来自可信的场景）， 你可以调用 save(false) 来跳过验证过程。
- rules 验证规则
    * 位置
        ```bash
            public function rules()
            {
                return [
                    ['title', 'required', 'message'=>'标题不能为空']
                ];
            }
        ```
    * required : 必须值验证属性
        ```bash
            [['字段名'], required, 'requiredValue'=>'必填值', 'message'=>'提示信息'], 
            ['email', 'required']
            [['email', 'name'], 'required']  
        ```
    * email : 邮箱验证
        ```bash
            ['email', 'email']
        ```
    * url : 网址
        ```bash
            ['website', 'url', 'defaultScheme' => 'http'];
        ```
    * safe : 安全
        ```bash
            ['description', 'safe']
        ```
    * trim : 去除首尾空白字符
        ```bash
            ['email', 'trim'] 或 ['email', 'filter', 'filter' => 'trim']  
        ```
    * default : 赋予默认值
        ```bash
            ['age', 'default', 'value' => 20]  
        ```
    * string : 字符串格式长度
        ```bash
            ['email', 'string', 'min' => 3, 'max' => 20] 或 ['email', 'string', 'length' => [3, 20]]  
            ['title','string','min'=>2,'max'=>200,'tooShort'=>'标题不能少于两位','tooLong'=>'标题不能大于200位'],
        ```
    * 格式类型验证
        ```bash
            ['age', 'integer'] // 整数格式  
            ['salary', 'double'] // 浮点数格式  
            ['temperature', 'number'] // 数字格式  
            ['isAdmin', 'boolean'] // 布尔格式  
            ['email', 'email'] // email格式  
            ['birthday', 'date'] // 日期格式  
            ['website', 'url', 'defaultScheme' => 'http'] // URL格式  
        ```
    * 验证码
        ```bash
            ['verificationCode', 'captcha']  
        ```
    * unique : 值在数据表中是唯一的
        ```bash
            ['email', 'unique', 'targetClass' => 'commonmodelsUsers']  
        ```
    * exist : 值在数据表中已存在
        ```bash
            ['email', 'exist', 'targetClass' => 'commonmodelsUser', 'filter' => ['status' => User::STATUS_ACTIVE], 'message' => 'There is no user with such email.']  
        ```
    * 检查输入的两个值是否一致
        ```bash
            // 必须要加上这一句
            ['passwordRepeat', 'required'],
            ['passwordRepeat', 'compare', 'compareAttribute' => 'password', 'operator' => '===']  
        ```
    * 数值范围检查
        ```bash
            ['age', 'compare', 'compareValue' => 30, 'operator' => '>=']  
            ['level', 'in', 'range' => [1, 2, 3]]  
        ```
    * 文件上传
        ```bash
            ['textFile', 'file', 'extensions' => ['txt', 'rtf', 'doc'], 'maxSize' => 1024 * 1024 * 1024]
        ```
    * 图片上传
        ```bash
            ['avatar', 'image', 'extensions' => ['png', 'jpg'], 'minWidth' => 100, 'maxWidth' => 1000,     'minHeight' => 100, 'maxHeight' => 1000, ] 
        ```
    * 正则验证
        ```bash
            [['字段名'],'match','pattern'=>'/正则表达式/','message'=>'提示信息'];      
            [['字段名'],'match','not'=>ture,'pattern'=>'/正则表达式/','message'=>'提示信息'];
            ['username', 'match', 'pattern' => '/^[a-z]w*$/i']  
        ```
- validator
    ```bash
        打印 Validator::$builtInValidators,可以看到所有rules的验证规则源码
        [boolean] => yii\validators\BooleanValidator  
        [captcha] => yii\captcha\CaptchaValidator  
        [compare] => yii\validators\CompareValidator  
        [date] => yii\validators\DateValidator  
        [default] => yii\validators\DefaultValueValidator  
        [double] => yii\validators\NumberValidator  
        [each] => yii\validators\EachValidator  
        [email] => yii\validators\EmailValidator  
        [exist] => yii\validators\ExistValidator  
        [file] => yii\validators\FileValidator  
        [filter] => yii\validators\FilterValidator  
        [image] => yii\validators\ImageValidator  
        [in] => yii\validators\RangeValidator  
        [integer] => Array  
            (  
                [class] => yii\validators\NumberValidator  
                [integerOnly] => 1  
            )  
    
        [match] => yii\validators\RegularExpressionValidator  
        [number] => yii\validators\NumberValidator  
        [required] => yii\validators\RequiredValidator  
        [safe] => yii\validators\SafeValidator  
        [string] => yii\validators\StringValidator  
        [trim] => Array  
            (  
                [class] => yii\validators\FilterValidator  
                [filter] => trim  
                [skipOnArray] => 1  
            )  
    
        [unique] => yii\validators\UniqueValidator  
        [url] => yii\validators\UrlValidator  
        [ip] => yii\validators\IpValidator
    ```

#### 删除数据
    ```bash
        $customer = Customer::findOne(123);
        $customer->delete();
  
        $customer->deleteAll(['id'=>1]);  

        Customer::deleteAll(['status' => Customer::STATUS_INACTIVE]);
    ```

#### 使用关联数据
- 声明关联关系
    ```bash
        // 对应关系有两种 hasOne[一对一] hasMany[一对多]
        // 每个关联方法必须这样命名：getXyz。然后通过 xyz（首字母小写）调用这个关联名[大小写敏感]
        class Customer extends ActiveRecord
        {
            // ...

            public function getOrders()
            {
                // 一个客户可以有很多订单

                // (相关联AR类名, [当前要声明关联的AR类的列, 相关数据的列])
                // [先附表的主键, 后主表的主键]
                // customer_id 是 Order 的属性，而 id是 Customer 的属性
                return $this->hasMany(Order::className(), ['customer_id' => 'id']);
            }
        }

        class Order extends ActiveRecord
        {
            // ...

            public function getCustomer()
            {
                // 每个订单只有一个客户

                // (相关联AR类名, [当前要声明关联的AR类的列, 相关数据的列])
                // [先附表的主键, 后主表的主键]
                // customer_id 是 Order 的属性，而 id是 Customer 的属性
                return $this->hasOne(Customer::className(), ['id' => 'customer_id']);
            }
        }
    ```
- 访问关联数据
    ```bash
        // SELECT * FROM `customer` WHERE `id` = 123
        $customer = Customer::findOne(123);

        // SELECT * FROM `order` WHERE `customer_id` = 123
        // $orders 是由 Order 类组成的数组
        $orders = $customer->orders;

        $customer->orders; // 获得 `Order` 对象的数组
        $customer->getOrders(); // 返回 ActiveQuery 类的实例
    ```
- 动态关联查询
    ```bash
        class Customer extends ActiveRecord
        {
            public function getBigOrders($threshold = 100) // 老司机的提醒：$threshold 参数一定一定要给个默认值
            {
                return $this->hasMany(Order::className(), ['customer_id' => 'id'])
                    ->where('subtotal > :threshold', [':threshold' => $threshold])
                    ->orderBy('id');
            }
        }

        // SELECT * FROM `order` WHERE `customer_id` = 123 AND `subtotal` > 200 ORDER BY `id`
        $orders = $customer->getBigOrders(200)->all();

        // SELECT * FROM `order` WHERE `customer_id` = 123 AND `subtotal` > 100 ORDER BY `id`
        $orders = $customer->bigOrders;
    ```
