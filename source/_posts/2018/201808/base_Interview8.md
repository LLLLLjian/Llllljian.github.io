---
title: Interview_总结 (8)
date: 2018-08-30
tags: Interview
toc: true
---

### 笔试总结
    没准就是你的面试题

<!-- more -->

#### email正则
    ```php
        q : 通过正则表达式匹配一个正确的邮箱

        a : 
        <?php 
        $mail = 'test@sina.com';  //邮箱地址
        $pattern = "/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$/";
        preg_match($pattern, $mail, $matches);

        //验证可以使用 filter_var($email, FILTER_VALIDATE_EMAIL)
    ```

#### 类型比较
- 函数比较
    <table><caption><strong>使用 PHP 函数对变量 $x</var></var> 进行比较</strong></caption><thead><tr><th>表达式</th><th>gettype()</th><th>empty()</th><th>is_null()</th><th>isset()</th><th>boolean : if($x)</th></tr></thead><tbody class="tbody"><tr><td>$x = "";</td><td>string</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td>$x = null;</td><td>NULL</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td></tr><tr><td>var $x;</td><td>NULL</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td></tr><tr><td>$x is undefined</td><td>NULL</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td></tr><tr><td>$x = array();</td><td>array</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td>$x = false;</td><td>boolean</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td>$x = true;</td><td>boolean</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = 1;</td><td>integer</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = 42;</td><td>integer</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = 0;</td><td>integer</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td>$x = -1;</td><td>integer</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = "1";</td><td>string</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = "0";</td><td>string</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td>$x = "-1";</td><td>string</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = "php";</td><td>string</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = "true";</td><td>string</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td>$x = "false";</td><td>string</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr></tbody></table>
- 松散比较
    <table><caption><strong>松散比较<em>==</em></strong></caption><thead><tr><th></th><th>TRUE</th><th>FALSE</th><th><em>1</em></th><th><em>0</em></th><th><em>-1</em></th><th><em>"1"</em></th><th><em>"0"</em></th><th><em>"-1"</em></th><th>NULL</th><th><em>array()</em></th><th><em>"php"</em></th><th><em>""</em></th></tr></thead><tbody class="tbody"><tr><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td></tr><tr><td><em>1</em></td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>0</em></td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td></tr><tr><td><em>-1</em></td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"1"</em></td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"0"</em></td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"-1"</em></td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td>NULL</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td></tr><tr><td><em>array()</em></td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"php"</em></td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td><em>""</em></td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td></tr></tbody></table>
- 严格比较
    <table><caption><strong>严格比较<em>===</em></strong></caption><thead><tr><th></th><th>TRUE</th><th>FALSE</th><th><em>1</em></th><th><em>0</em></th><th><em>-1</em></th><th><em>"1"</em></th><th><em>"0"</em></th><th><em>"-1"</em></th><th>NULL</th><th><em>array()</em></th><th><em>"php"</em></th><th><em>""</em></th></tr></thead><tbody class="tbody"><tr><td>TRUE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>1</em></td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>0</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>-1</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"1"</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"0"</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"-1"</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td>NULL</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>array()</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td><td>FALSE</td></tr><tr><td><em>"php"</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td><td>FALSE</td></tr><tr><td><em>""</em></td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>FALSE</td><td>TRUE</td></tr></tbody></table>

#### 输出结果
    ```php
        <?php
            echo "PHP版本:".phpversion()."<br />";

            echo (int)((0.1+0.7) * 10);


            PHP版本:5.3.3
            7

            PHP版本:5.4.43
            7

            PHP版本:5.5.9
            7

            PHP版本:5.6.9
            7

            PHP版本:7.0.0
            7
        ?>

        原因
        浮点数转化为2进制时有末位舍入误差,而 (int) 用的是去尾法,7.9999... 也取成 7.
    ```

#### 熟悉的5种设计模式及用单例模式建立一个数据库连接
    单例 工厂 策略 适配器 观察者
- 单例数据库连接
    ```php
        <?php
        class DBHelper
        {
            private $link;
            static private $_instance;

            // 连接数据库
            private function __construct($host, $username, $password)
            {
                $this->link = mysql_connect($host, $username, $password);
                $this->query("SET NAMES 'utf8'", $this->link);
                //echo mysql_errno($this->link) . ": " . mysql_error($link). "n";
                //var_dump($this->link);
                return $this->link;
            }

            private function __clone()
            {
            }

            public static function get_class_nmdb($host, $username, $password)
            {
                //$connector = new nmdb($host, $username, $password);
                //return $connector;

                if (FALSE == (self::$_instance instanceof self)) {
                    self::$_instance = new self($host, $username, $password);
                }
                return self::$_instance;
            }

            // 连接数据表
            public function select_db($database)
            {
                $this->result = mysql_select_db($database);
                return $this->result;
            }

            // 执行SQL语句
            public function query($query)
            {
                return $this->result = mysql_query($query, $this->link);
            }

            // 将结果集保存为数组
            public function fetch_array($fetch_array)
            {
                return $this->result = mysql_fetch_array($fetch_array, MYSQL_ASSOC);
            }

            // 获得记录数目
            public function num_rows($query)
            {
                return $this->result = mysql_num_rows($query);
            }

            // 关闭数据库连接
            public function close()
            {
                return $this->result = mysql_close($this->link);
            }
        }
        
        $connector = DBHelper::get_class_nmdb($host, $username, $password);
        $connector -> select_db($database);
        ?>
    ```


