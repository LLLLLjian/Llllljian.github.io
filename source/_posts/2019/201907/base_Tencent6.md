---
title: Tencent_基础 (6)
date: 2019-07-05
tags: 
    - Tencent
    - Linux
    - Wechat
    - ThinkPHP
    - Mongo
toc: true
---

### 公众号支持手机号归属地查询
    公众号实现手机归属地查询

<!-- more -->

#### 实现的思路
    服务器本身有crontab任务去执行mongoPythonForPhone.py
    mongoPythonForPhone.py支持两种方式的手机号归属地查询：
    1. 如果没有传递参数, 将生成随机的手机号码, 插入到库中
    2. 如果传递了参数, 默认该参数为待查询手机号进行查询
    方式1每隔10s执行一次, 将随机手机号插入到phone_log中
    方式2是PHP调用python生成

    建议先将测试走通, 将exec执行的所有信息都打印出来

#### 可能遇到的问题
- python包没有找到
    * 第三方模块安装在www用户没有权限访问的某个用户的根目录下
    * 执行的命令
        ```bash
            [llllljian@llllljian-cloud-tencent ~ 16:17:18 #7]$ python3.5
            Python 3.5.2 (default, Nov 12 2018, 13:43:14) 
            [GCC 5.4.0 20160609] on linux
            Type "help", "copyright", "credits" or "license" for more information.
            >>> import sys
            >>> sys.path
            ['', '/usr/lib/python35.zip', '/usr/lib/python3.5', '/usr/lib/python3.5/plat-x86_64-linux-gnu', '/usr/lib/python3.5/lib-dynload', '/home/llllljian/.local/lib/python3.5/site-packages', '/usr/local/lib/python3.5/dist-packages', '/usr/lib/python3/dist-packages']

            #用pip命令把python包安装到指定目录
            [ubuntu@llllljian-cloud-tencent ~ 16:24:59 #3]$ sudo pip3 install pymongo --target=/usr/local/lib/python3.5/dist-packages
        ```

#### 已经实现的功能
    查询未知手机号归属地并入库[Mysql && mongo]

#### Index.php
    ```php
        // 测试用
        public function testphone1($mobile = '18634678077')
        {
            $a = $this->getPhoneInfo($mobile, 2);
            dump($a);
            exit();
        }

        public function getPhoneInfo($mobile, $sqlType = 1)
        {
            $res = array();
            if ($sqlType == 2) {
                $res = Db::connect("db_mongo")->name("phone_log")
                    ->where("mobile", $mobile)
                    ->find();
            } else {
                $res = "";
            }
            
            if (! empty($res)) {
                $resStr = "";
                $resStr .= "你查询的手机号为:" . $res['mobile'];
                $resStr .= ", 该手机号运营商为:" . $res['phone_type'];
                $resStr .= ", 该手机号的归属地为:" . $res['province'] . $res['city'];
                $resStr .= ", 归属地的邮编为:" . $res['zip_code'];
                $resStr .= ", 归属地的区号为:" . $res['area_code'];
                $res = $resStr;
            } else {
                exec("/usr/bin/python3.5 /var/nginx/html/tp5/python/mongoPythonForPhone.py {$mobile} 2>&1");
                return $this->getPhoneInfo($mobile, 2);
            }
            return $res;
        }

        // 在PHP中执行python脚本 将不存在的手机号导入到库中
        public function getPwd()
        {
            exec("/usr/bin/python3.5 /var/nginx/html/tp5/python/mongoPythonForPhone.py 13834895301 2>&1", $out, $res);
            return dump($out);
        }
    ```

#### Wechat.php
    ```php
        <?php
        namespace app\wechat\controller;

        use think\Controller;
        use think\Db;

        class Wechat extends Controller
        {

            public $table_name = "wechat_log";

            public function index()
            {
                // 先初始化微信
                $app = app('wechat.official_account');
                $app->server->push(function ($message) {
                    if ($message['MsgType'] == "event" && $message['Event'] == 'subscribe') {
                        return "你终于关注我了呀！";
                    }
                    $message['_id'] = Db::connect("db_mongo")->findAndModify($this->table_name);
                    Db::connect("db_mongo")->name($this->table_name)
                        ->insert($message);
                    if (preg_match("/^1[3-8]{1}\d{9}$/", $message['Content'])) {
                        $res = array();
                        $res = $this->getPhoneInfo($message['Content'], 2);
                        return $res;
                    }
                    return "你说的消息我接收记录到了";
                });
                
                $app->server->serve()->send();
            }
            
            // 处理手机号相关信息
            protected function getPhoneInfo($mobile, $sqlType = 1)
            {
                $res = array();
                if ($sqlType == 2) {
                    $res = Db::connect("db_mongo")->name("phone_log")
                        ->where("mobile", $mobile)
                        ->find();
                } else {
                    $res = "";
                }
                
                if (! empty($res)) {
                    $resStr = "";
                    $resStr .= "你查询的手机号为:" . $res['mobile'];
                    $resStr .= ", 该手机号运营商为:" . $res['phone_type'];
                    $resStr .= ", 该手机号的归属地为:" . $res['province'] . $res['city'];
                    $resStr .= ", 归属地的邮编为:" . $res['zip_code'];
                    $resStr .= ", 归属地的区号为:" . $res['area_code'];
                    $res = $resStr;
                } else {
                    exec("/usr/bin/python3.5 /var/nginx/html/tp5/python/mongoPythonForPhone.py {$mobile} 2>&1");
                    return $this->getPhoneInfo($mobile, 2);
                }
                return $res;
            }
        }
    ```

#### mongoPythonForPhone.py
    ```bash
        [llllljian@llllljian-cloud-tencent ~ 16:08:42 #4]$ cat /var/nginx/html/tp5/python/mongoPythonForPhone.py
        # 随机数
        import random
        # json相关
        import json
        # 第三方手机相关信息
        from phone import Phone
        # mongo相关模块
        from pymongo import MongoClient
        from pymongo import ReturnDocument
        # 时间模块
        import time
        # 导入mysql相关模块
        import pymysql
        import sys

        # 随机生成手机号码
        def createPhone():
            prelist=["130","131","132","133","134","135","136","137","138","139","147","150","151","152","153","155","156","157","158","159","186","187","188"]
            return random.choice(prelist)+"".join(random.choice("0123456789") for i in range(8))

        def insertPhone(mobile):
            global dbForMongo, cursor, dbForMysql

            collectionForPhone = dbForMongo.phone_log
            resultForRow = collectionForPhone.find_one({'mobile': mobile})
            if resultForRow:
                return
                    
            result = p.find(mobile)
            result1 = json.dumps(result)
            result2 = json.loads(result1)
                    
            now = int(time.time())
            timeStruct = time.localtime(now)
            strTime = time.strftime("%Y-%m-%d %H:%M:%S", timeStruct)
            strDate = time.strftime("%Y-%m-%d", timeStruct)
            data = {"strTime" : strTime, "strDate" : strDate, "now" : now }
            data['area_code'] = result2['area_code']
            data['mobile'] = result2['phone']
            data['city'] = result2['city']
            data['phone_type'] = result2['phone_type']
            data['province'] = result2['province']
            data['zip_code'] = result2['zip_code']

            result = dbForMongo.counters.find_one_and_update({'_id': 'phone_log'},{'$inc': {'seq': 1}},projection={'seq': True,'_id': False},upsert=True,return_document=ReturnDocument.AFTER)
            data["_id"] = result["seq"]

            collectionForPhone.insert_one(data)
            
            sql = "INSERT INTO phone_log(mobile, phone_type, province, city, zip_code, area_code, create_time) VALUES (%s,%s,%s,%s,%s,%s,%s)" % (data['mobile'], repr(data['phone_type']), repr(data['province']), repr(data['city']), data['zip_code'], data['area_code'], data['now'])
            cursor.execute(sql)
            dbForMysql.commit()

        client = MongoClient()
        dbForMongo = client.llllljian
        # 打开数据库连接
        dbForMysql = pymysql.connect("127.0.0.1", "root", "liujian", "tentcent_tp", charset='utf8')
        # 使用cursor方法获取操作游标
        cursor = dbForMysql.cursor()
        p = Phone()

        if __name__ == '__main__':
            if len(sys.argv) < 2 :
                mobile = createPhone()
            else:
                mobile = sys.argv[1]
            #print(mobile)
            insertPhone(mobile)
    ```
