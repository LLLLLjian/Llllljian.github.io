---
title: Tencent_基础 (4)
date: 2019-06-27
tags: 
    - Tencent
    - Linux
    - Wechat
    - ThinkPHP
    - MongoDB
toc: true
---

### 腾讯云操作
    easywechat与TP5.1结合使用

<!-- more -->

#### 想实现的功能
    将用户发给微信公众号的信息存储起来

#### 功能思路
    因为不同的消息内容会有不同的数据, 所以不适合存在mysql中, 所以打算存在mongo中

#### 功能代码
- TP集成mongo
    ```bash
        sudo composer require topthink/think-mongo=2.0.*

        [ubuntu@llllljian-cloud-tencent ~ 17:25:58 #15]$ cd /var/nginx/html/tp5/vendor/topthink/
        [ubuntu@llllljian-cloud-tencent topthink 17:30:38 #16]$ ll
        total 16
        drwxrwxrwx  4 root root 4096 Jun 30 20:43 ./
        drwxrwxrwx 14 root root 4096 Jun 30 20:43 ../
        drwxrwxrwx  3 root root 4096 Jun 30 11:19 think-installer/
        drwxrwxrwx  3 root root 4096 Jun 30 20:43 think-mongo/
    ```
- TP同时支持MySQL和mongo
    ```bash
        [ubuntu@llllljian-cloud-tencent config 17:35:28 #29]$ cat database.php
        <?php
        // +----------------------------------------------------------------------
        // | ThinkPHP [ WE CAN DO IT JUST THINK ]
        // +----------------------------------------------------------------------
        // | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
        // +----------------------------------------------------------------------
        // | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
        // +----------------------------------------------------------------------
        // | Author: liu21st <liu21st@gmail.com>
        // +----------------------------------------------------------------------

        return [
            // 数据库类型
            'type'            => 'mysql',
            // 服务器地址
            'hostname'        => '127.0.0.1',
            // 数据库名
            'database'        => 'tentcent_tp',
            // 用户名
            'username'        => 'root',
            // 密码
            'password'        => '',
            // 端口
            'hostport'        => '',
            // 连接dsn
            'dsn'             => '',
            // 数据库连接参数
            'params'          => [],
            // 数据库编码默认采用utf8
            'charset'         => 'utf8',
            // 数据库表前缀
            'prefix'          => '',
            // 数据库调试模式
            'debug'           => true,
            // 数据库部署方式:0 集中式(单一服务器),1 分布式(主从服务器)
            'deploy'          => 0,
            // 数据库读写是否分离 主从式有效
            'rw_separate'     => false,
            // 读写分离后 主服务器数量
            'master_num'      => 1,
            // 指定从服务器序号
            'slave_no'        => '',
            // 自动读取主库数据
            'read_master'     => false,
            // 是否严格检查字段是否存在
            'fields_strict'   => true,
            // 数据集返回类型
            'resultset_type'  => 'array',
            // 自动写入时间戳字段
            'auto_timestamp'  => false,
            // 时间字段取出后的默认时间格式
            'datetime_format' => 'Y-m-d H:i:s',
            // 是否需要进行SQL性能分析
            'sql_explain'     => false,
            // Builder类
            'builder'         => '',
            // Query类
            'query'           => '\\think\\db\\Query',
            // 是否需要断线重连
            'break_reconnect' => false,
            // 断线标识字符串
            'break_match_str' => [],
            // mongo配置
            'db_mongo' => [
                'type'    =>   '\think\mongo\Connection', 
                'query'    =>   '\think\mongo\Query',
                'hostname'    =>   '127.0.0.1',
                'database'    =>   'llllljian',
                'username'    =>   '',
                'password'     =>   '',
                'hostport'    =>   27017,
                'charset'    =>   'utf8',
                // 我自己加的 自增ID表名
                'inc_table' => 'counters',
                // 我自己加的 自增ID列名
                'inc_column' => 'seq'
            ],
        ];
    ```
- mongo类修改
    ```bash
        [ubuntu@llllljian-cloud-tencent src 17:42:25 #36]$ vim /var/nginx/html/tp5/vendor/topthink/think-mongo/src/Builder.php
        /**
         * value分析
         * @access protected
         * @param Query     $query 查询对象
         * @param mixed     $value
         * @param string    $field
         * value分析
         * @access protected
         * @param Query     $query 查询对象
         * @param mixed     $value
         * @param string    $field
         * @return string
         */
        protected function parseValue(Query $query, $value, $field = '')
        {
            if ('_id' == $field && 'ObjectID' == $this->connection->getConfig('pk_type') && is_string($value)) {
                try {
                    $options = $query->getOptions();
                    // 判断当前操作的表是否为自增ID的表, 如果是的话就直接返回 否则就转化为16位的ObjectID
                    if ($options['table'] == $this->connection->getConfig('inc_table')) {
                        return $value;
                    }
                    return new ObjectID($value);
                } catch (InvalidArgumentException $e) {
                    return new ObjectID();
                }
            }

            return $value;
        }

        [ubuntu@llllljian-cloud-tencent src 17:52:01 #47]$ vim /var/nginx/html/tp5/vendor/topthink/think-mongo/src/Query.php
        public function findAndModify($id = 'uid')
        {
            $cmd = array(
                'findandmodify' => $this->connection->getConfig('inc_table'),
                'query' => array('_id' => $id),
                'update' => array('$inc' => array($this->connection->getConfig('inc_column') => 2)), //更新
                'new' => true,
                'upsert' => true
            );
            $cmdObj = new Command($cmd);
            $res = $this->command($cmdObj);
            return $res[0]['value'][$this->connection->getConfig('inc_column')];
        }
    ```

