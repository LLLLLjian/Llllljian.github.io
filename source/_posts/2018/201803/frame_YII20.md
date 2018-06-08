---
title: PHP_Yii框架 (20)
date: 2018-03-02
tags: Yii
toc: true
---

### 数据格式器
#### 配置Formatter
    ```php
        return [
            'charset' => 'utf-8',
            'language' => 'zh-CN',
            'timeZone' => 'Asia/Shanghai',
            'components' => [
                'formatter' => [
                    'dateFormat' => 'yyyy-MM-dd',
                    'timeFormat' => 'HH:mm:ss',
                    'datetimeFormat' => 'yyyy-MM-dd HH:mm:ss',
                    // 十分位之前的隔开符
                    'decimalSeparator' => '.',
                    // 千位隔开符
                    'thousandSeparator' => ',',
                    'locale' => 'zh-CN',
                    'currencyCode' => 'CNY',
                ],
            ],
        ];
    ```

<!-- more -->

#### 时间/日期数据
    ```php
        // 控制器中输出
        echo Yii::$app->formatter->asDate('now');
        // 对应配置中的dateFormat
        // 2018-03-02
        
        echo Yii::$app->formatter->asTime('now');
        // 对应配置中的timeFormat
        // 15:44:59
        
        echo Yii::$app->formatter->asDatetime('now');
        // 对应配置中的datetimeFormat
        // 2018-03-02 15:44:59

        echo Yii::$app->formatter->asTimestamp('2016-12-20 00:00:00');
        // 输出某个时间的时间戳
        // 1519977180

        echo Yii::$app->formatter->asRelativeTime('2018-03-02');
        echo Yii::$app->formatter->asRelativeTime('2018-03-01');
        // 人可以理解的相对时间
        // 刚刚; 一天前

        echo Yii::$app->formatter->asDuration(86399);
        echo Yii::$app->formatter->asDuration(360);
        // 人可以理解的时间
        // 23 小时, 59 分钟, 59 秒; 6分钟

        // 视图页面 GridView中[针对时间戳]
        <?= GridView::widget([
            'columns' => [
                'classctime : date',
                // 对应配置中的dateFormat
                // 2018-03-02 

                'classctime : time',
                // 对应配置中的timeFormat
                // 15:44:59

                'classctime : datetime',
                // 对应配置中的datetimeFormat
                // 2018-03-02 15:44:59s
            ]
        ]); ?>  
    ```

#### 格式化数字
    ```php
        echo Yii::$app->formatter->asInteger(86399);
        // 格式化为整型
        // 86,399

        echo Yii::$app->formatter->asDecimal(86399);
        // 格式化为浮点型
        // 86,399.00

        echo Yii::$app->formatter->asPercent('0.125');
        echo Yii::$app->formatter->asPercent('0.125', 2);
        // 格式化为百分数
        // 13%; 12.50%

        echo Yii::$app->formatter->asScientific(86399);
        // 格式化为科学计数法
        // 8.639900E+4

        var_dump(extension_loaded('intl'));
        echo Yii::$app->formatter->asCurrency(86399);
        // 格式化为货币
        // bool(true) ￥86,399.00
        // 出现货币单位有两个要点.1.开启intl扩展;2.设置货币单位currencyCode

        echo Yii::$app->formatter->asSize(150);
        // 人可读的字节数
        // 150 字节

        echo Yii::$app->formatter->asShortSize(150);
        // 人可读的字节数[缩写]
        // 150 B
    ```

#### 其他格式化
    ```php
        echo Yii::$app->formatter->asRaw(1463606983);
        // 简单输出输入值
        // 1463606983

        echo Yii::$app->formatter->asText('<h3>hello</h3>');
        // 将字符串中html标签当做字符串输出.同时这也是 GridView DataColumn 默认使用的方法
        // <h3>hello</h3>
        
        echo Yii::$app->formatter->asHtml('<h3>hello</h3>');
        // 作为Html的文档输出
        // hello

        echo Yii::$app->formatter->asNtext("<h3>hello.\nword</h3>");
        // 在字符串中遇到\n可以将它作为换行符实现
        // <h3>hello.
        // word</h3>

        echo Yii::$app->formatter->asEmail('admin@example.com');
        // 输出: <a href="mailto:admin@example.com">admin@example.com</a>

        echo Yii::$app->formatter->asParagraphs('hello');
        // 值会转换成HTML编码的文本段落,用<p>标签包裹；
        // hello

        echo Yii::$app->formatter->asUrl('www.baidu.com');
        // 值会格式化成url的连接

        echo Yii::$app->formatter->asImage('my2.jpeg',['alt'=>'图片无法显示']);
        // 图片的链接会转化成<img src='my.jpg'/>

        echo Yii::$app->formatter->asBoolean(true);
        // 输出是
        // 是
    ```