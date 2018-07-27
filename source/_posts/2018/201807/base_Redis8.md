---
title: Redis_基础 (8)
date: 2018-07-24
tags: Redis
toc: true
---

### PHP与Redis
    Redis官方推荐的是Predis和phpredis.
    Predis PHP代码实现的原生客户端,相当于类库
    phpredis C语言写的PHP扩展,性能比Predis高,但除非执行大量Redis命令,否则很难区分二者性能

<!-- more -->

#### Predis
- 安装
    * 下载Predis压缩包,或者克隆其版本库
- 加载依赖包
    * 引入autoload.php文件
    * require './predis/autoload.php';
- 连接Redis
    * 不加参数
        ```php
            // 默认会把 127.0.0.1 和 6379 作为默认的host 和 port 并且连接超时时间是 5 秒
            $client = new Predis\Client();
            $client->set('foo', 'bar');
            $value = $client->get('foo');
        ```
    * 添加连接参数
        ```php
            // 数组形式
            $client = new Predis\Client([
                'scheme' => 'tcp',
                'host'   => '10.0.0.1',
                'port'   => 6379,
            ]);
            
            // URI 形式:
            $client = new Predis\Client('tcp://10.0.0.1:6379');

            // 混合
            $client = new Predis\Client([
                'tcp://10.0.0.1?alias=first-node',
                ['host' => '10.0.0.2', 'alias' => 'second-node'],
            ]);
        ```
- Client配置
    * eg
        ```php
            $parameters = ['tcp://10.0.0.1?alias=master', 'tcp://10.0.0.2?alias=slave-01'];
            $options    = ['replication' => true];
            
            $client = new Predis\Client($parameters, $options);
        ```
    * param
        * profile: 针对特定版本的配置,因为不同版本对同样操作可能有差异.
        * prefix: 自动给要处理的key前面加上一个前缀.
        * exceptions: Redis 出错时是否返回结果.
        * connections: 客户端要使用的连接工厂.
        * cluster: 集群中使用哪个后台 (predis, redis 或者客户端配置).
        * replication: 主/从中使用哪个后台 (predis 或者 客户端配置).
        * aggregate: 合并连接方式 (覆盖 cluster 和 replication).
- eg
    ```php
        // Redis做页面数据缓存和session缓存

        // redis操作类
        class handleRedis 
        {
            // 缓存类型
            private $type;
            // 前缀
            private $prefix;
            // 连接时间
            private $time;
            // redis客户端
            private $client;
            // 声明一个静态变量(保存在类中唯一的一个实例)
            private static $Intance;
            // 配置
            protected static $config;

            // 构造函数
            public function __construct($type = 'default', $prefix = '') 
            {
                if (!isset(self::$config[$type])) {
                    $type = 'default';
                }

                $this->type = $type;
                $this->prefix = $prefix;
                $this->time = time();
                $this->client = new Predis\Client(self::$config[$type], array('cluster' => 'redis', 'prefix' => $prrefix));
            }

            // 单例
            public static function getIntance($type = 'default', $prefix = '') 
            {
                self::$config = require './redisConfig.php';
                $key = $type.$prefix;
                if (!isset(self::$Intance[$key])) {
                    self::$Intance[$key] = new handleRedis($type, $prefix);
                }
                return self::$Intance[$key];
            }

            // 连接超过250后重新连接,防止超时报错
            public function __get($property) 
            {
                if ($property === 'client' && (time() - $this->time) > 250) {
                    $this->__construct($this->type, $this->prefix);
                }

                return $property === 'client' ? $this->client : $this->$property;
            }

            /**
             * @desc 获取值
             * @param $key  需要获取键值的键名
             */
            public function get($key) 
            {
                try {
                    return $this->client->get($key);
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 设置值
             * @param $key  键名
             * @param $value  键值
             * @param $expiretime  生存时间
             */
            public function set($key, $value, $expiretime = 0) 
            {
                try {
                    $this->client->set($key, $value);
                    if ($expiretime > 0) {
                        $this->client->expire($key, $expiretime);
                    }
                    return true;
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 设置一个存储时效
             * @param $key  键名
             * @param $value  键值
             * @param $expiretime  生存时间
             */
            public function setex($key, $expiretime, $value)
            {
                try {
                    $this->client->setex($key, $expiretime, $value);
                    return true;
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 删除值
             * @param $key  需要删除键值的键名
             */
            public function del($key) 
            {
                try {
                    return $this->client->del($key);
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 判断键名是否存在
             * @param $key  需要判断的键名
             */
            public function exists($key) 
            {
                try {
                    return $this->client->exists($key);
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 自增
             * @param $key  需要自增键值的键名
             * @param $step  需要自增的数值
             */
            public function incr($key, $step = "") 
            {
                try {
                    if (is_numeric($step)) {
                        return $this->client->incrby($key, $step);
                    } else {
                        return $this->client->incr($key);
                    }
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 自减
             * @param $key  需要自减键值的键名
             * @param $step  需要自减的数值
             */
            public function decr($key, $step = "") 
            {
                try {
                    if (is_numeric($step)) {
                        return $this->client->decrby($key, $step);
                    } else {
                        return $this->client->decr($key);
                    }
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 获取生存时间
             * @param $key  需要获取生存时间的键名
             */
            public function ttl($key) 
            {
                try {
                    return $this->client->ttl($key);
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }

            /**
             * @desc 设置键值的生存时间
             * @param $key  需要设置生存时间的键名
             * @param $expiretime  生存时间
             */
            public function expire($key, $expiretime)
            {
                try {
                    $this->client->expire($key, $expiretime);
                    return true;
                }
                catch (Exception $e) {
                    throw new Exception($e->getMessage());
                }
            }
        }

        // redis配置
        $redisConfigArr = array(
            'default' => array(
                'tcp://127.0.0.1:6379',
                'tcp://127.0.0.1:6380',
                'tcp://127.0.0.1:6381'
            ),
            'sessionid' => array(
                'tcp://127.0.0.1:6382',
                'tcp://127.0.0.1:6383',
                'tcp://127.0.0.1:6384'
            )
        );

        // 页面数据缓存
        $redis = handleRedis::getIntance('default', 'DATA_');
        // GET DATA_redisDemoKey1
        $redisDemoValue1 = $redis->get('redisDemoKey1');

        // session操作类
        class Session
        {
            private static $Intance;
            var $lifeTime;
            var $redisHandle;

            private function __construct()
            {

            }

            public static function getIntance() 
            {
                if (!self::$Intance) {
                    self::$Intance = new Jgb_Other_Session();
                }
                return self::$Intance;
            }

            /**
             * 自动开始会话或者session_start()开始会话后第一个调用的函数
             * 类似构造函数的作用
             * @param $savePath 默认的保存路径
             * @param $sessName 默认的参数名PHPSESSION
             */
            function open($savePath, $sessName) 
            {
                $this->lifeTime = get_cfg_var("session.gc_maxlifetime");
                if ($this->lifeTime > 0) {
                
                } else {
                    $this->lifeTime = 3600 * 24;
                }

                $redisHandle = Jgb_Other_Redis::getIntance('sessionid', 'SESSION_');
                if (!$redisHandle) {
                    return false;
                }
                $this->redisHandle = $redisHandle;
                return true;
            }

            /**
             * 在write()或者session_write_close()函数之后调用
             * 类似析构函数
             * @return bool
             */
            function close() 
            {
                return true;
            }

            /**
             * 读取session信息
             * @param $sessID   通过该ID唯一确定对应的session数据
             */
            function read($sessID) 
            {
                return $this->redisHandle->get($sessID);
            }

            /**
             * 写入或修改session数据
             * @param $sessID   要写入数据的session对应的id
             * @param $sessData 要写入的数据,已经序列化过
             */
            function write($sessID,$sessData) 
            {
                $newExp = $this->lifeTime;
                return $this->redisHandle->setex($sessID, $newExp, $sessData);
            }

            /**
             * 主动销毁session会话
             * @param $sessID   要销毁的会话的唯一id
             */
            function destroy($sessID) 
            {
                if ($this->redisHandle->del($sessID)) {
                    return true;
                }
                return false;
            }

            /**
             * 清除会话中的过期数据
             * @param $sessMaxLifeTime  有效期
             */
            function gc($sessMaxLifeTime) 
            {
                return true;
            }

            /**
             * 开始使用redis驱动session
             */
            function begin()
            {
                session_set_save_handler(
                    array($this,"open"),
                    array($this,"close"),
                    array($this,"read"),
                    array($this,"write"),
                    array($this,"destroy"),
                    array($this,"gc")
                );
                session_start();
            }
        }

        // session缓存开启
        Session::getIntance()->begin();

        // 获取session数据
        $redis = Session::getIntance('sessionid', 'SESSION_');
    ```
