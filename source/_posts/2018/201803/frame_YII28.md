---
title: PHP_Yii框架 (28)
date: 2018-03-14
tags: Yii
toc: true
---

### 核心验证器
觉得麻烦可以直接看[数据验证](/2018/201802/frame_YII16/#数据验证)
    Yii 提供一系列常用的核心验证器，位于 yii\validators 命名空间之下。 为了避免使用冗长的类名，你可以直接用别名来指定相应的核心验证器
    ```bash
        public function rules()
        {
            return [

            ];
        }
    ```
<!-- more -->

#### boolean（布尔型）
- 验证内容
    * 该验证器检查输入值是否为一个布尔值
- 验证属性
    * trueValue : 代表真的值.默认为'1'
    * falseValue : 代表假的值.默认为 '0'
    * strict : 是否要求待测输入必须严格匹配trueValue或falseValue.默认为 false
    * 注意 : 因为通过HTML表单传递的输入数据都是字符串类型，所以一般strict属性为假。
- 验证实例
    ```bash
        [
            // 检查 "selected" 是否为 0 或 1，无视数据类型
            ['selected', 'boolean'],

            // 检查 "deleted" 是否为布尔类型，即 true 或 false
            ['deleted', 'boolean', 'trueValue' => true, 'falseValue' => false, 'strict' => true],
        ]
    ```

#### compare（比对）
- 验证内容
    * 该验证器比对两个特定输入值之间的关系 是否与 operator 属性所指定的相同
- 验证属性
    * compareAttribute : 用于与原属性相比对的属性名称
    * compareValue : 用于与输入值相比对的常量值.当该属性与compareAttribute属性同时被指定时，该属性优先被使用
    * operator
        * ==：检查两值是否相等。比对为非严格模式
        * ===：检查两值是否全等。比对为严格模式
        * !=：检查两值是否不等。比对为非严格模式
        * !==：检查两值是否不全等。比对为严格模式
        * >：检查待测目标值是否大于给定被测值
        * >=：检查待测目标值是否大于等于给定被测值
        * <：检查待测目标值是否小于给定被测值
        * <=：检查待测目标值是否小于等于给定被测值
    * type : 默认的比对类型是'string',此时将按照字节逐个对比.当需要比对的值是数字时，需要设置类型$type为'number',启用数字对比模式
- 验证实例
    ```bash
        [
            // 检查 "password" 属性的值是否与 "password_repeat" 的值相同
            ['password', 'compare'],

            // 和上一个相同，只是明确指定了需要对比的属性字段
            ['password', 'compare', 'compareAttribute' => 'password_repeat'],
            
            // 检查年龄是否大于等于 30
            ['age', 'compare', 'compareValue' => 30, 'operator' => '>='],
        ]
    ```

#### captcha（验证码）
- 验证内容
    * 该验证器通常配合 yii\captcha\CaptchaAction 以及 yii\captcha\Captcha 使用，以确保某一输入与 CAPTCHA 小部件所显示的验证代码（verification code）相同
- 验证属性
    * caseSensitive：对验证码的比对是否要求大小写敏感。默认为 false。
    * captchaAction：指向用于渲染 CAPTCHA 图片的 CAPTCHA action 的 路由。默认为 'site/captcha'。
    * skipOnEmpty：当输入为空时，是否跳过验证。 默认为 false，也就是输入值为必需项。
- 验证实例
    ```bash
        [
            ['verificationCode', 'captcha'],
        ]
    ```

#### date（日期）
- 验证内容
    * 该验证器检查输入值是否为适当格式的 date，time，或者 datetime。 另外，它还可以帮你把输入值转换为一个 UNIX 时间戳并保存到 timestampAttribute 所指定的属性里
- 验证属性
    * format : 被验证值的日期/时间格式
    * timestampAttribute : 输入的日期时间将被转换为时间戳后设置到的属性的名称.可以设置为和被验证的属性相同.如果相同,原始值将在验证结束后被时间戳覆盖
- 验证实例
    ```bash
        [
            [['from_date', 'to_date'], 'date'],
            [['from_datetime', 'to_datetime'], 'datetime'],
            [['some_time'], 'time'],
            ['fromDate', 'date', 'timestampAttribute' => 'fromDate'],
            ['toDate', 'date', 'timestampAttribute' => 'toDate'],
            ['fromDate', 'compare', 'compareAttribute' => 'toDate', 'operator' => '<', 'enableClientValidation' => false],
            [['from_date', 'to_date'], 'default', 'value' => null],
            [['from_date', 'to_date'], 'date'],
        ]
    ```

#### default（默认值）
- 验证内容
    * 不进行数据验证.给为空的待测属性分配默认值
- 验证属性
    * value : 默认值或者一个返回默认值的php回调函数
- 验证实例
    ```bash
        [
            // 若 "age" 为空，则将其设为 null
            ['age', 'default', 'value' => null],

            // 若 "country" 为空，则将其设为 "USA"
            ['country', 'default', 'value' => 'USA'],

            // 若 "from" 和 "to" 为空，则分别给他们分配自今天起，3 天后和 6 天后的日期。
            [['from', 'to'], 'default', 'value' => function ($model, $attribute) {
                return date('Y-m-d', strtotime($attribute === 'to' ? '+3 days' ：'+6 days'));
            }],
        ]
    ```

#### double（双精度浮点型）
- 验证内容
- 验证属性
    * max : 上限值(含界点).若不设置,则验证器不检查上限
    * min : 下限值(含界点).若不设置,则验证器不检查下限
- 验证实例
    ```bash
        [
            // 检查 "salary" 是否为浮点数
            ['salary', 'double'],
        ]
    ```

#### each（循环验证）
- 验证内容
    * 此验证器只能验证数组格式的属性.此验证器将判断数组中的每个元素是否都符合验证规则
- 验证属性
    * rule : 保存验证规则的数组
    * allowMessageFromRule : 是否使用规则中指定的验证器返回的错误信息.默认值为true.如果设置为false,将使用message作为错误信息
- 验证实例
    ```bash
        [
            // 检查是否每个分类编号都是一个整数
            // categoryIDs属性必须是一个数组且每个元素将被使用integer验证器进行验证。
            ['categoryIDs', 'each', 'rule' => ['integer']],
        ]
    ```

#### email（电子邮件）
- 验证内容
    * 检查输入值是否为有效的邮箱地址
- 验证属性
    * allowName : 检查是否允许带名称的电子邮件地址
    * checkDNS : 检查邮箱域名是否存在,且有没有对应的A或MX记录,默认是false
    * enableIDN : 默认是false
- 验证实例
    ```bash
        [
            // 检查 "email" 是否为有效的邮箱地址
            ['email', 'email'],
        ]
    ```

#### exist（存在性）
- 验证内容
    * 该验证器检查输入值是否在某表字段中存在
- 验证属性
    * targetClass : 用于查找输入值的目标AR类.若不设置,则会使用正在进行验证的当前模型类
    * targetAttribute : 用于检查输入值存在性的targetClass的模型属性
    * filter : 用于检查输入值存在性必然会进行数据库查询
    * allowArray : 是否允许输入值为数组.默认为false.若该属性为true且输入值为数组,则数组的每个元素都必须在目标字段中存在
- 验证实例
    ```bash
        [
            // a1 需要在 "a1" 属性所代表的字段内存在
            ['a1', 'exist'],

            // a1 必需存在，但检验的是 a1 的值在字段 a2 中的存在性
            ['a1', 'exist', 'targetAttribute' => 'a2'],

            // a1 和 a2 的值都需要存在，且它们都能收到错误提示
            [['a1', 'a2'], 'exist', 'targetAttribute' => ['a1', 'a2']],

            // a1 和 a2 的值都需要存在，只有 a1 能接收到错误信息
            ['a1', 'exist', 'targetAttribute' => ['a1', 'a2']],

            // 通过同时在 a2 和 a3 字段中检查 a2 和 a1 的值来确定 a1 的存在性
            ['a1', 'exist', 'targetAttribute' => ['a2', 'a1' => 'a3']],

            // a1 必需存在，若 a1 为数组，则其每个子元素都必须存在。
            ['a1', 'exist', 'allowArray' => true],
        ]
    ```

#### file（文件）
- 验证内容
    * 检查输入值是否为一个有效的上传文件
- 验证属性
    * extensions : 可接受上传的文件扩展名列表.默认为null,意味着所有扩展名都被接受
    * mimeTypes : 可接受上传的MIME类型列表.默认为null,意味着所有 MIME 类型都被接受
    * minSize : 上传文件所需最少多少Byte的大小.默认为null,代表没有下限
    * maxSize : 上传文件所需最多多少Byte的大小.默认为null,代表没有上限
    * maxFiles : 给定属性最多能承载多少个文件.默认为1,代表只允许单文件上传.若值大于一,那么输入值必须为包含最多maxFiles个上传文件元素的数组
    * checkExtensionByMimeType : 是否通过文件的MIME类型来判断其文件扩展
- 验证实例
    ```bash
        [
            // 检查 "primaryImage" 是否为 PNG, JPG 或 GIF 格式的上传图片。
            // 文件大小必须小于  1MB
            ['primaryImage', 'file', 'extensions' => ['png', 'jpg', 'gif'], 'maxSize' => 1024*1024*1024],
        ]
    ```

#### filter（过滤器）
- 验证内容
    * 给输入值应用一个过滤器,并在验证后把它赋值回原属性变量
- 验证属性
    * filter : 用于定义过滤器的PHP回调函数
    * skipOnArray : 是否在输入值为数组时跳过过滤器.默认为false
- 验证实例
    ```bash
        [
            // trim 掉 "username" 和 "email" 输入
            [['username', 'email'], 'filter', 'filter' => 'trim', 'skipOnArray' => true],

            // 标准化 "phone" 输入
            ['phone', 'filter', 'filter' => function ($value) {
                // 在此处标准化输入的电话号码
                return $value;
            }],
        ]
    ```

#### image（图片）
- 验证内容
    * 检查输入值是否为代表有效的图片文件
- 验证属性
    * minWidth ：图片的最小宽度.默认为null,代表无下限
    * maxWidth ：图片的最大宽度.默认为 null,代表无上限
    * minHeight ：图片的最小高度.默认为 null,代表无下限
    * maxHeight ：图片的最大高度.默认为 null,代表无上限
- 验证实例
    ```bash
        [
            // 检查 "primaryImage" 是否为适当尺寸的有效图片
            ['primaryImage', 'image', 'extensions' => 'png, jpg',
                'minWidth' => 100, 'maxWidth' => 1000,
                'minHeight' => 100, 'maxHeight' => 1000,
            ],
        ]
    ```

#### ip（IP地址）
- 验证内容
    * 检查属性的值是否是一个有效的 IPv4/IPv6 地址或子网地址
- 验证属性
- 验证实例
    ```bash
        [
            // 检查 "ip_address" 是否为一个有效的 IPv4 或 IPv6 地址
            ['ip_address', 'ip'],

            // 检查 "ip_address" 是否为一个有效的 IPv6 地址或子网地址，
            // 被检查的值将被展开成为一个完整的 IPv6 表示方法。
            ['ip_address', 'ip', 'ipv4' => false, 'subnet' => null, 'expandIPv6' => true],

            // 检查 "ip_address" 是否为一个有效的 IPv4 或 IPv6 地址，
            // 允许地址存在一个表示非的字符 `!`
            ['ip_address', 'ip', 'negation' => true],
        ]
    ```

#### in（范围）
- 验证内容
    * 检查输入值是否存在于给定列表的范围之中
- 验证属性
    * range ：用于检查输入值的给定值列表
    * strict ：输入值与给定值直接的比较是否为严格模式.默认为 false。
    * not ：是否对验证的结果取反.默认为false.当该属性被设置为true,验证器检查输入值是否不在给定列表内
    * allowArray ：是否接受输入值为数组.当该值为true且输入值为数组时,数组内的每一个元素都必须在给定列表内存在，否则返回验证失败。
- 验证实例
    ```bash
        [
            // 检查 "level" 是否为 1、2 或 3 中的一个
            ['level', 'in', 'range' => [1, 2, 3]],
        ]
    ```

#### integer（整数）
- 验证内容
    * 检查输入值是否为整形
- 验证属性
    * max ：上限值(含界点).若不设置,则验证器不检查上限
    * min ：下限值(含界点).若不设置,则验证器不检查下限
- 验证实例
    ```bash
        [
            // 检查 "age" 是否为整数
            ['age', 'integer'],
        ]
    ```

#### match（正则表达式）
- 验证内容
    * 检查输入值是否匹配指定正则表达式
- 验证属性
    * pattern ：用于检测输入值的正则表达式.该属性是必须的,若不设置则会抛出异常
    * not ：是否对验证的结果取反
- 验证实例
    ```bash
        [
            // 检查 "username" 是否由字母开头，且只包含单词字符
            ['username', 'match', 'pattern' => '/^[a-z]\w*$/i']
        ]
    ```

#### number（数字）
- 验证内容
    * 检查输入值是否为数字
- 验证属性
    * max ：上限值(含界点).若不设置,则验证器不检查上限
    * min ：下限值(含界点).若不设置,则验证器不检查下限
- 验证实例
    ```bash
        [
            // 检查 "salary" 是否为数字
            ['salary', 'number'],
        ]
    ```

#### required（必填）
- 验证内容
    * 检查输入值是否为空
- 验证属性
    * requiredValue ：所期望的输入值.若没设置,意味着输入不能为空
    * strict ：检查输入值时是否检查类型
- 验证实例
    ```bash
        [
            // 检查 "username" 与 "password" 是否为空
            [['username', 'password'], 'required'],
        ]
    ```

#### safe（安全）
- 备注
    * 只有是安全的才能在页面进行搜索排序
- 验证实例
    ```bash
        [
            // 标记 "description" 为安全属性
            ['description', 'safe'],
        ]
    ```

#### string（字符串）
- 验证内容
    * 检查输入值是否为特定长度的字符串.并检查属性的值是否为某个特定长度
- 验证属性
    * length ：指定待测输入字符串的长度限制
    * min ：输入字符串的最小长度.若不设置,则代表不设下限
    * max ：输入字符串的最大长度.若不设置,则代表不设上限
    * encoding ：待测字符串的编码方式.若不设置,则使用应用自身的charset属性值,该值默认为 UTF-8
- 验证实例
    ```bash
        [
            // 检查 "username" 是否为长度 4 到 24 之间的字符串
            ['username', 'string', 'length' => [4, 24]],
        ]
    ```

#### trim（译为修剪/裁边）
- 验证内容
    * 去掉字符串两端的空格,数组会忽略该验证器
- 验证实例
    ```bash
        [
            // trim 掉 "username" 和 "email" 两侧的多余空格
            [['username', 'email'], 'trim'],
        ]
    ```

#### unique（唯一性）
- 验证内容
    * 检查输入值是否在某表字段中唯一
- 验证属性
    * targetClass ：用于查找输入值的目标AR类.若不设置,则会使用正在进行验证的当前模型类
    * targetAttribute ：用于检查输入值唯一性的targetClass的模型属性
    * filter ：用于检查输入值唯一性必然会进行数据库查询,而该属性为用于进一步筛选该查询的过滤条件
- 验证实例
    ```bash
        [
            // a1 需要在 "a1" 属性所代表的字段内唯一
            ['a1', 'unique'],

            // a1 需要唯一，但检验的是 a1 的值在字段 a2 中的唯一性
            ['a1', 'unique', 'targetAttribute' => 'a2'],

            // a1 和 a2 的组合需要唯一，且它们都能收到错误提示
            [['a1', 'a2'], 'unique', 'targetAttribute' => ['a1', 'a2']],

            // a1 和 a2 的组合需要唯一，只有 a1 能接收错误提示
            ['a1', 'unique', 'targetAttribute' => ['a1', 'a2']],

            // 通过同时在 a2 和 a3 字段中检查 a2 和 a3 的值来确定 a1 的唯一性
            ['a1', 'unique', 'targetAttribute' => ['a2', 'a1' => 'a3']],
        ]
    ```

#### url（网址）
- 验证内容
    * 检查输入值是否为有效URL
- 验证属性
    * validSchemes ：用于指定那些URI方案会被视为有效的数组。默认为 ['http', 'https'],代表http和https URLs会被认为有效
    * defaultScheme ：若输入值没有对应的方案前缀,会使用的默认URI方案前缀.默认为null,代表不修改输入值本身
    * enableIDN
- 验证实例
    ```bash
        [
            // 检查 "website" 是否为有效的 URL。若没有 URI 方案，
            // 则给 "website" 属性加 "http://" 前缀
            ['website', 'url', 'defaultScheme' => 'http'],
        ]
    ```
