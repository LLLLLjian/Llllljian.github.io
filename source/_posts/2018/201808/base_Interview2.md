---
title: Interview_总结 (2)
date: 2018-08-14
tags: Interview
toc: true
---

### 笔试总结
    列一下今天笔试题

<!-- more -->

#### 状态码
- 200
    * 处理成功
- 303
    * 跳转到其它页面
- 304
    * 从缓存中取相关信息
- 403
    * 没有权限访问此站
- 404
    * 找不到页面
- 500
    * 服务器出现问题

#### sort() asort() ksort()的区别
- asort()
    * 关联数组 以值升序
- ksort()
    * 关联数组 以键升序

#### 魔术方法
- __construct()
    * 构造函数,每次创建新对象时先调用此方法
- __destruct()
    * 析构函数,会在到某个对象的所有引用都被删除或者当对象被显式销毁时执行
- __call()
    * 在对象中调用一个不可访问方法时,__call() 会被调用
- __callStatic()
    * 用静态方式中调用一个不可访问方法时,__callStatic()会被调用
- __set()
    * 在给不可访问属性赋值时,__set()会被调用. 
- __get()
    * 读取不可访问属性的值时,__get()会被调用. 
- __isset()
    * 当对不可访问属性调用isset()或empty()时,__isset()会被调用. 
- __unset()
    * 当对不可访问属性调用unset()时,__unset()会被调用.
- __sleep()
    * 序列化serialize()之前会检查类中是否存在一个魔术方法__sleep(),如果存在,该方法会先被调用
- __wakeup()
    * 反序列化unserialize()会检查是否存在一个__wakeup()  

#### 正则验证邮箱
    ```php
        function validMail($mail) {
            if (empty($mail)) {
                return false;
            } else {
                // ^ 匹配开始
                // + 表示1个或多个前面的字符
                // \. 将特殊字符(.)当成普通字符
                // * 表示0个或多个前面的字符
                // $ 匹配结束
                $pattern = "/^[a-z0-9-]+(\.[a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$/";
                preg_match($pattern, $mail, $matches);

                if ($matches) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```
- 指定预定义的字符集
    <table><thead><tr><th>字符</th><th align="center">含义</th></tr></thead><tbody><tr><td>\d</td><td align="center">任意一个十进制数字[0-9]</td></tr><tr><td>\D</td><td align="center">任意一个非十进制数字</td></tr><tr><td>\s</td><td align="center">任意一个空白字符(空格、换行符、换页符、回车符、字表符)</td></tr><tr><td>\S</td><td align="center">任意一个非空白字符</td></tr><tr><td>\w</td><td align="center">任意一个单词字符</td></tr><tr><td>\W</td><td align="center">任意个非单词字符</td></tr></tbody></table>

#### 编码题1
    ```php
        q : 约瑟夫环

        a :
        
        function killMonkey($monkeys , $m , $current = 0)
        {
            $number = count($monkeys);
            $num = 1;
            if(count($monkeys) == 1){
                echo $monkeys[0]."成为猴王了";
                return;
            }
            else{
                while($num++ < $m){
                    $current++ ;
                    $current = $current%$number;
                }
                echo $monkeys[$current]."的猴子被踢掉了<br/>";
                array_splice($monkeys , $current , 1);
                killMonkey($monkeys , $m , $current);
            }
        }
        $monkeys = array(1 , 2 , 3 , 4 , 5 , 6 , 7, 8 , 9 , 10); //monkeys的编号
        $m = 3; //数到第几只猴子被踢出
        killMonkey($monkeys , $m);
    ```

#### 编码题2
    ```php
        q : 微信分红包

        a :

        class CBonus
        {
            public $bonus;//红包
            public $bonus_num;//红包个数
            public $bonus_money;//红包总金额
            public $money_single_max;//单个红包限额
        
            public function __construct($bonus_num, $bonus_money)
            {
                $this->bonus_num = $bonus_num ? $bonus_num : 10;
                $this->bonus_money = $bonus_money ? $bonus_money : 200;
                $this->money_single_max = $bonus_money ? $bonus_money / 2 : 100;
            }
        
            private function randomFloat($min = 0, $max = 1) 
            {
                $mt_rand = mt_rand();
                $mt_getrandmax = mt_getrandmax();
                echo 'mt_rand=' . $mt_rand . ', mt_getrandmax=' . $mt_getrandmax . '<hr/>';
                return $min + $mt_rand / $mt_getrandmax * ($max - $min);
            }

            //计算
            public function compute()
            {
                $this->bonus = array();
                $bonus_money_temp = $this->bonus_money;
                $money_single_max = $this->money_single_max;
                $i = 1;
                while($i < $this->bonus_num)
                {
                if ($money_single_max > $bonus_money_temp)
                {
                    $money_single_max = floatval(sprintf("%01.2f", $bonus_money_temp / 2));//剩余金额不够分时,把剩余金额的一半作为备用金
                }
                $bonus_money_rad = $this->randomFloat(0.01, $money_single_max);//一个红包随机金额 最小的1分钱
                $bonus_money_rad = floatval(sprintf("%01.2f", $bonus_money_rad));
                $bonus_money_temp = $bonus_money_temp - $bonus_money_rad ;//待分配的总剩余金额
                $bonus_money_temp = floatval(sprintf("%01.2f", $bonus_money_temp));
                $this->bonus[] = $bonus_money_rad;
                //echo $bonus_money_rad . ',' . $bonus_money_temp . '<hr/>';
                $i++;
                }
                $this->bonus[] = $bonus_money_temp;//分配剩余金额给最后一个红包
            }

            //打印
            public function output()
            {
                $total = 0;
                foreach($this->bonus as $k => $v)
                {
                echo '红包' . ($k+1) . '=' . $v . '<br/>';
                $total += $v;
                }
                echo '红包总金额:'.$total;
            }
        }
        
        $CBonus = new CBonus(5, 100);
        $CBonus->compute();
        $CBonus->output();
    ```

    ```php
        // 自己的想法

        function fenHongBao($num, $money)
        {
            $returnArr = $tempArr = $tempKey = array();

            if ($num == 1) {
                $returnArr[] = $money;

                return $returnArr;
            }

            do 
            {
                $returnArr[] = 0.01;
            } while(count($returnArr) < $num);
            
            $i=1;
            while($i <= ($money / 0.01)){
                //写入数组
                $tempArr[] = 0.01;
                //递增
                $i++;
            }
            
            foreach ($tempArr as $value) {
                $tempKey[] = array_rand($returnArr);
            }
            
            $tempValue = array_count_values($tempKey);
            
            foreach ($returnArr as $key=>$value) {
                $returnArr[$key] = $value * $tempValue[$key];
            }
            
            $returnArr['alllMoney'] = $money;
            return $returnArr;
        }

        $return = fenHongBao(5, 100);

        foreach ($return as $key=>$value) {
            $allMoney = $return['alllMoney'];
            if ($key != 'alllMoney') {
                echo '红包总共'.$allMoney.'元,第'.$key;
                echo "个接到的红包数目为".$value."元<br />";
            }
        }

        红包总共100元,第1个接到的红包数目为19.55元
        红包总共100元,第2个接到的红包数目为19.89元
        红包总共100元,第3个接到的红包数目为19.91元
        红包总共100元,第4个接到的红包数目为20.38元
    ```

