---
title: PHP_基础 (46)
date: 2020-08-03
tags: PHP 
toc: true
---

### MVC框架理解
    看你也用了挺多框架的 你能简单给我讲一下你对框架的理解吗以及各个框架的优劣

<!-- more -->

#### MVC工作原理
- Model模型: 数据操作层
- View视图: 视图层
- Controller控制器: 业务处理层

#### 单一入口的工作原理
- 工作原理
    * 用一个处理程序文件处理所有的HTTP请求,根据请求时的参数的不同区分不同模块和操作的请求
- 优势
    * 可以进行统一的安全性检查
    * 集中处理程序
- 劣势
    * URL不美观(URL重写)
    * 处理效率会稍低

#### 模版引擎的理解
- 对模版引擎的理解
    * PHP是一种HTML内嵌式的在服务端执行的脚本语言,但是PHP有很多可以使PHP代码和HTML代码分开的模版引擎
- 工作原理
    * 模版引擎就是庞大的完善的正则表达式替换库

#### PHP框架差异及优缺点
- yaf框架
    * 使用PHP扩展的形式写的一个PHP框架,也就是以C语言为底层编写的,性能上要比PHP代码写的框架要快一个数量级
    * 优点: 执行效率高、轻量级框架、可扩展性强
    * 缺点: 高版本兼容性差、底层代码可读性差、需要安装扩展、功能单一、开发需要编写大量的插件
- yii2框架
    * 是一个非常优秀的通用Web后端框架,结构简单优雅、实用功能丰富、扩展性强、性能高是它最突出的优点
    * 缺点: 学习成本高、相比yaf,量级较重

#### yaf路由
- Yaf_Route_Static
    * /module/controller/action/param1/value1/param2/value2
    * 访问的是module模块下的controller控制器action方法, 参数param1 值是value1, 参数param2 值是value2 
    ```php    
        <?php
        /**
         * 默认的路由协议Yaf_Route_Static, 就是分析请求中的request_uri, 在去除掉base_uri以后, 获取到真正的负载路由信息的request_uri片段, 
        * 具体的策略是, 根据"/"对request_uri分段, 依次得到Module,Controller,Action, 
        * 在得到Module以后, 还需要根据Yaf_Application::$modules来判断Module是否是合法的Module, 
        * 如果不是, 则认为Module并没有体现在request_uri中, 而把原Module当做Controller, 原Controller当做Action:
        *
        * 当只有一段路由信息的时候, 比如对于以下的例子, 请求的URI为/ap/foo, 
        * 则默认路由和下面要提到的Yaf_Route_Supervar会首先判断ap.action_prefer, 如果为真, 则把foo当做Action, 否则当做Controller
        */
        /**
         * 对于请求request_uri为"/ap/foo/bar/dummy/1"
        * base_uri为"/ap"
        * 则最后参加路由的request_uri为"/foo/bar/dummy/1"
        * 然后, 通过对URL分段, 得到如下分节
        * foo, bar, dummy, 1
        * 然后判断foo是不是一个合法的Module, 如果不是, 则认为结果如下:
        */
        array(
            'module'     => '默认模块',
            'controller' => 'foo',
            'action'     => 'bar',
            'params'     => array(
                'dummy' => 1,
            )
        )

        /**
         * 而如果在配置文件中定义了ap.modules="Index,Foo",
        * 则此处就会认为foo是一个合法模块, 则结果如下
        */
        array(
            'module'     => 'foo',
            'controller' => 'bar',
            'action'     => 'dummy',
            'params'     => array(
                1 => NULL,
            )
        )
    ```
- Yaf_Route_Simple
    * ?m=module&c=controller&a=action&param1=value1&param2=value2
    * 访问的是module模块下的controller控制器action方法, 参数param1 值是value1, 参数param2 值是value2
    ```php
        // 可以写在index.php ->run之前 也可以写在Bootstrap.php的_initRoute中
        $router = Yaf_Application::app()->getDispatcher()->getRouter();
        $simpleRoute = new Yaf_Route_Simple('m', 'c', 'a');
        $router->addRoute('simple_route', $simpleRoute);
    ```
- Yaf_Route_Supervar
    * ?r=/module/controller/action/param1/value1/param2/value2
    ```php
        // 可以写在index.php ->run之前 也可以写在Bootstrap.php的_initRoute中
        $supervarRoute = new Yaf_Route_Supervar('r');
        $router->addRoute('supervar_route', $supervarRoute);
    ```
- Yaf_Route_Regex
    * product/1, product/2, product/12
    * 访问的是app模块下的 goods控制器里的detail方法, 参数是 1,2,12
    ```php
        $regexRoute = new Yaf_Route_Regex(
            '#product/([0-9]+)/([0-9]+)#', // 必须要用定界符(本例子为"#"),否则报错.鸟哥的Yaf手册中,该例子的正则表达式没有用定界符.版本原因？
            array(
                'module' => 'app',
                'controller' => 'goods',
                'action' => 'detail',
            ),
            array(
                1 => 'cid',
                2 => 'id'
            )
        );
        $router->addRoute('regex_route', $regexRoute);
    ```
- Yaf_Route_Rewrite
    * /user/a, /user/bc, /user/1/id/3
    * 访问的是user控制器的index方法, 访问的参数是name=a, name=bc, name=1&id=3
    ```php
        $rewriteRoute = new Yaf_Route_Rewrite(
            'user/:name/*',
            array(
                'controller' => 'user',
                'action' => 'index'
            )
        );
        $router->addRoute('rewrite_route', $rewriteRoute);
    ```
- 踩坑1
    * Yaf框架访问路由时始终访问的是index模块下index控制器中的index方法
    * 关闭nginx中的PATH_INFO

#### yii2验证规则
- 内置验证规则
    ```php
        [['sex', 'partner_id'], 'integer'],
        [['partner_id', 'camp_id',], 'required'],
        [['created_at', 'pics'], 'safe'],
        [['name'], 'string', 'max' => 16],
        [['interest', 'quota'], 'number'],
        [['path'], 'unique'],
        ['email', 'email'],　　['website', 'url', 'defaultScheme' => 'http']; #说明:CUrlValidator 的别名, 确保了特性是一个有效的路径. 
        ['username', 'unique', 'targetClass' => '\backend\models\User', 'message' => '用户名已存在.'],
        [['file'], 'file', 'skipOnEmpty' => true, 'extensions' => 'png, jpg'],
    ```
- 正则验证规则
    ```php
        //默认值 
        ['status', 'default', 'value' => self::STATUS_ACTIVE],
        //区间 
        ['status', 'in', 'range' => [self::STATUS_ACTIVE, self::STATUS_DELETED]],
        //正则
        ['mobile','match','pattern' => '/^1[3456789]{1}\d{9}$/','message'=>'请输入正确的手机号'],
        ['name', 'match','not'=>true, 'pattern' => '/^[0-9]+/','message'=>'不能全为数字或以数字开头'],
    ```
- 过滤
    ```php
        ['desc', 'filter', 'filter' => function ($value) {
                if (empty($value)){
                    return null;
                }
                //过滤特殊字符
                return Str::purify($value);
        }],
        ['name', 'test', 'message'=> '请填写姓名']     
        public function test($object, $attributes) {         
            if($this->name != '张先森') {             
                $this->addError($object, $attributes['message']);         
            }
        }
        //去空格
        ['username', 'password', 'repassword', 'captcha', 'age', 'sex', 'phone','email'], 'filter', 'filter'=>'trim', 'on'=>'register'],
    ```
- 验证码
    ```php
        ['yzm', 'captcha'],
    ```
- 适用场景(自定义场景、或方法)
    ```php
        ['shop_id', 'required','on'=>self::SCENARIO_ADMIN_CREATE],
    ```
- 比较
    ```php
        ['quota', 'compare', 'compareValue' => 9999.99,'type'=>'number', 'operator' => '<='],
        [['discount','payment','pay_method'],'default','value'=>0],
        // 新修改的状态必须大于原有的状态
        ['status', 'compare', 'compareValue' =>$this->oldAttributes['status'],'type'=>'number', 'operator' => '>=','message'=>'状态不能回撤'],
        数值大小
        // 说明:compareValue(比较常量值) - operator(比较操作符) #说明:CCompareValidator 的别名,确保了特性的值等于另一个特性或常量.
        ['age', 'compare', 'compareValue' => 30, 'operator' => '>='];
    ```
- 时间
    ```php
        ['uptime', 'date','format'=>'yyyy-MM-dd', 'timestampAttribute'=>'uptime'],
    ```
- 条件唯一
    ```php
        ['name', 'required', 'message' => '请选择门店！'],
        ['shop_id', 'required', 'message' => '请输入菜品名称！'],
        ['name', //只有 name 能接收错误提示,数组['name','shop_id']的场合,都接收错误提示
         'unique', 'targetAttribute'=>['name','shop_id'] ,
         'targetClass' => '\models\Dishes', // 模型,缺省时默认当前模型.
         'comboNotUnique' => '选择的门店内,该菜品名称已经存在！' //错误信息
        ],

        //自定义函数
        ['name', 'check','on'=>['create']],//定义规则,在create场景中对name进行check方法验证,下面是方法的定义函数
        public function check($attribute,$params){
            if (empty($this->shop_id)) {
                return $this->addError($attribute,'请选择门店！');
            }
            $dish=Dishes::findOne(['name'=>$this->name,'shop_id'=>$this->shop_id]);
            if($dish){
                $this->addError($attribute, '该菜品名称已存在!');
            }else{
                $this->clearErrors($attribute);
            }
        }
    ```
- 默认值
    ```php
        ['updated_at','default','value'=>time(),'on'=>[self::SCENARIO_ADD],'skipOnEmpty'=>false],
        ['updated_at','editUpdatedAt',on'=>[self::SCENARIO_ADD],'skipOnEmpty'=>false],
    ```
