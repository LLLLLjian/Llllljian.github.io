---
title: PHP_ThinkPHP框架 (4)
date: 2019-04-10
tags: ThinkPHP
toc: true
---

### ThinkPHP5学习笔记-模型
    PHP框架学习之路

<!-- more -->

#### 模型定义
- eg
    ```php
        namespace app\index\model;

        class User extends \think\Model
        {
            // 设置当前模型对应的完整数据表名称
            protected $table = 'think_user';
            // 设置当前模型的数据库连接
            protected $connection = [
                // 数据库类型
                'type' => 'mysql',
                // 服务器地址
                'hostname' => '127.0.0.1',
                // 数据库名
                'database' => 'thinkphp',
                // 数据库用户名
                'username' => 'root',
                // 数据库密码
                'password' => '',
                // 数据库编码默认采用utf8
                'charset' => 'utf8',
                // 数据库表前缀
                'prefix' => 'think_',
                // 数据库调试模式
                'debug' => false,
            ];
        }
    ```

#### 模型初始化
- eg
    ```php
        // 重写Model的initialize
        namespace app\index\model;

        use think\Model;

        class Index extends Model
        {
            //自定义初始化
            protected function initialize()
            {
                //需要调用`Model`的`initialize`方法
                parent::initialize();
                //TODO:自定义的初始化
            }
        }
    ```
- eg1
    ```php
        // init 只在第一次实例化的时候执行
        namespace app\index\model;

        use think\Model;

        class Index extends Model
        {
            //自定义初始化
            protected static function init()
            {
            //TODO:自定义的初始化
            }
        }
    ```

#### 获取器
    在获取数据的字段值后自动进行处理,还可以定义数据表中不存在的字段
- eg
    ```php
        class User extends Model
        {
            public function getStatusAttr($value)
            {
                $status = [-1=>'删除',0=>'禁用',1=>'正常',2=>'待审核'];
                return $status[$value];
            }
        }

        $user = User::get(1);
        echo $user->status; // 例如输出“正常”
    ```
- eg1
    ```php
        class User extends Model
        {
            public function getStatusTextAttr($value,$data)
            {
                $status = [-1=>'删除',0=>'禁用',1=>'正常',2=>'待审核'];
                return $status[$data['status']];
            }
        }

        $user = User::get(1);
        echo $user->status_text; // 例如输出“正常”
    ```
- eg2
    ```php
        // 获取原始数据
        $user = User::get(1);
        // 通过获取器获取字段
        echo $user->status;
        // 获取原始字段数据
        echo $user->getData('status');
        // 获取全部原始数据
        dump($user->getData());
    ```

#### 修改器
    可以在数据赋值的时候自动进行转换处理
- eg
    ```php
        class User extends Model
        {
            public function setNameAttr($value)
            {
                return strtolower($value);
            }

            public function setAgeAttr($value,$data)
            {
                return serialize($data);
            }
        }

        $user = new User();
        $user->name = 'THINKPHP';
        $user->age = 'serialize';
        $user->save();
        echo $user->name; // thinkphp
    ```

#### 时间戳
- 配置
    * 在数据库配置文件中添加全局设置
        ```php
            // 开启自动写入时间戳字段.默认插入的是int
            'auto_timestamp' => true,
            // 将插入类型改为datetime
            'auto_timestamp' => 'datetime',
            // 关闭全局自动写入时间字段
            'auto_timestamp' => false,
        ```
    * 直接在单独的模型类里面设置
        * protected $autoWriteTimestamp = true;
        * protected $autoWriteTimestamp = 'datetime';
        * protected $autoWriteTimestamp = false;// 关闭
- 定义数据表字段
    * 默认是create_time和update_time字段
    * 修改默认值
        ```php
            class User extends Model
            {
                // 定义时间戳字段名
                protected $createTime = 'create_at';
                protected $updateTime = 'update_at';
            }
        ```

#### 只读字段
    只读字段用来保护某些特殊的字段值不被更改,这个字段的值一旦写入,就无法更改
- eg
    ```php
        namespace app\index\model;

        use think\Model;
        class User extends Model
        {
            protected $readonly = ['name','email'];
        }

        $user = User::get(5);
        // 更改某些字段的值
        $user->name = 'TOPThink';
        $user->email = 'Topthink@gmail.com';
        $user->address = '上海静安区';
        // 保存更改后的用户数据
        // 只有 address 字段的值被更新了
        $user->save();
    ```

#### 软删除
    把数据加上删除标记,而不是真正的删除,同时也便于需要的时候进行数据的恢复
- eg
    ```php
        namespace app\index\model;
        
        use think\Model;
        use traits\model\SoftDelete;
        
        class User extends Model
        {
            use SoftDelete;
            protected $deleteTime = 'delete_time';
        }

        // 软删除
        User::destroy(1);
        // 真实删除
        User::destroy(1,true);
        $user = User::get(1);
        // 软删除
        $user->delete();
        // 真实删除
        $user->delete(true);

        // 默认情况下查询的数据不包含软删除数据,如果需要包含软删除的数据,可以使用下面的方式查询: 
        User::withTrashed()->find();
        User::withTrashed()->select();
        // 如果仅仅需要查询软删除的数据,可以使用: 
        User::onlyTrashed()->find();
        User::onlyTrashed()->select();
    ```

#### 类型转换
    在写入和读取的时候自动进行类型转换处理
- eg
    ```php
        class User extends Model
        {
            protected $type = [
                'status' => 'integer',
                'score' => 'float',
                'birthday' => 'datetime',
                'info' => 'array',
            ];
        }
    ```

#### 数据完成
    系统支持auto、insert和update三个属性,可以分别在写入、新增和更新的时候进行字段的自动完成机制,auto属性自动完成包含新增和更新操作
- eg
    ```php
        namespace app\index\model;

        use think\Model;

        class User extends Model
        {
            protected $auto = [];
            protected $insert = ['ip','status' => 1];
            protected $update = ['login_ip'];

            protected function setIpAttr()
            {
                return request()->ip();
            }
        }

        // 在新增数据的时候,会对 ip 和 status 字段自动完成或者处理.
        $user = new User;
        $user->name = 'ThinkPHP';
        $user->save();
        echo $user->name; // thinkphp
        echo $user->status; // 1
        
        // 在保存操作的时候,会自动完成 ip 字段的赋值.
        $user = User::find(1);
        $user->name = 'THINKPHP';
        $user->save();
        echo $user->name; // thinkphp
        echo $user->ip; // 127.0.0.1
    ```
