---
title: MongoDB_基础 (2)
date: 2018-07-26
tags: MongoDB
toc: true
---

### 实现自增_id
    习惯了mysql,想把主键_id换成自增的

<!-- more -->

#### 存储id信息
- 首先需要建立一个表结构,用于存储id信息
    ```sql
        db.counters.insert({_id: "id1",seq: 0})
        db.counters.insert({_id: "id2",seq: 0})
    ```

#### 实现自定义函数
    为防止重启MongoDB后函数失效或者需重新定义所以放在专门保存js函数的表中system.js
    每次重启之后都要通过db.loadServerScripts()将自定义函数引入
    ```sql
        db.system.js.insert(
            {_id:"getNextSequence",value:function getNextSequence(name) {
                var ret = db.counters.findAndModify(
                {
                    query: { _id: name },
                    update: { $inc: { seq: 1 } },
                    new: true
                }
            );
            return ret.seq;
            }
        });
    ```

#### 新增数据
    ```sql
        db.test1.insert(
        {
            _id: getNextSequence("id1"),
            timestamp: ISODate().valueOf()
        }
        )

        db.test2.insert(
        {
            _id: getNextSequence("id2"),
            timestamp: ISODate().valueOf()
        }
        )

        // 采用循环新增
        for (var i = 0; i < 20000; i++) {
            db.test2.insert({_id: getNextSequence("id2"), timestamp: ISODate().valueOf()})
        }

        for (var i = 0; i < 30000; i++) {
            db.test1.insert({_id: getNextSequence("id1"), timestamp: ISODate().valueOf()})
        }
    ```

#### demo
    ```sql
        [llllljian@llllljian-virtual-machine ~ 17:22:48 #6]$ mongo
        MongoDB shell version: 3.2.11
        connecting to: test
        ...
        > db
        test
        > use llllljian
        switched to db llllljian
        > db
        llllljian
        > db.counters.insert({_id: "id1",seq: 0})
        WriteResult({ "nInserted" : 1 })
        > db.counters.insert({_id: "id2",seq: 0})
        WriteResult({ "nInserted" : 1 })
        > db.system.js.insert(
        ...             {_id:"getNextSequence",value:function getNextSequence(name) {
        ...                 var ret = db.counters.findAndModify(
        ...                 {
        ...                     query: { _id: name },
        ...                     update: { $inc: { seq: 1 } },
        ...                     new: true
        ...                 }
        ...             );
        ...             return ret.seq;
        ...             }
        ...         });
        WriteResult({ "nInserted" : 1 })
        > db.test1.insert(
        ...         {
        ...             _id: getNextSequence("id1"),
        ...             timestamp: ISODate().valueOf()
        ...         }
        ...         )
        2018-07-26T20:06:34.724+0800 E QUERY    [thread1] ReferenceError: getNextSequence is not defined :@(shell):3:13
        > db.loadServerScripts();
        > db.test1.insert(         {             _id: getNextSequence("id1"),             timestamp: ISODate().valueOf()         }         )
        WriteResult({ "nInserted" : 1 })
        > db.test2.insert(
        ...         {
        ...             _id: getNextSequence("id2"),
        ...             timestamp: ISODate().valueOf()
        ...         }
        ...         )
        WriteResult({ "nInserted" : 1 })
        > for (var i = 0; i < 20000; i++) {
        ...             db.test2.insert({_id: getNextSequence("id2"), timestamp: ISODate().valueOf()})
        ...         }
        WriteResult({ "nInserted" : 1 })
        > for (var i = 0; i < 30000; i++) {
        ...             db.test1.insert({_id: getNextSequence("id1"), timestamp: ISODate().valueOf()})
        ...         }
        WriteResult({ "nInserted" : 1 })
        > db.getCollection('test1').stats()
        {
            "ns" : "llllljian.test1",
            "count" : 30001,
            "size" : 1440112,
            "avgObjSize" : 48,
            "numExtents" : 5,
            "storageSize" : 2793472,
            "lastExtentSize" : 2097152,
            "paddingFactor" : 1,
            "paddingFactorNote" : "paddingFactor is unused and unmaintained in 3.0. It remains hard coded to 1.0 for compatibility only.",
            "userFlags" : 1,
            "capped" : false,
            "nindexes" : 1,
            "totalIndexSize" : 842128,
            "indexSizes" : {
                "_id_" : 842128
            },
            "ok" : 1
        }
        > db.getCollection('test2').stats()
        {
            "ns" : "llllljian.test2",
            "count" : 20001,
            "size" : 960112,
            "avgObjSize" : 48,
            "numExtents" : 5,
            "storageSize" : 2793472,
            "lastExtentSize" : 2097152,
            "paddingFactor" : 1,
            "paddingFactorNote" : "paddingFactor is unused and unmaintained in 3.0. It remains hard coded to 1.0 for compatibility only.",
            "userFlags" : 1,
            "capped" : false,
            "nindexes" : 1,
            "totalIndexSize" : 564144,
            "indexSizes" : {
                "_id_" : 564144
            },
            "ok" : 1
        }
    ```

### 自定义MongoDB操作函数
    可以把自己写的js代码保存在某个地方,让MongoDB加载它,然后就可以在MongoDB的命令行里操作它们
    mongodb shell默认会加载~/.mongorc.js文件
- eg
    ```bash
        [llllljian@llllljian-virtual-machine html 00:08:44 #51]$ cat ~/.mongorc.js
        // 启动提示文字修改
        var compliment = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
        var index = Math.floor(Math.random() * 9);
        print("你好,你的随机数字是" + compliment[index] + ",欢迎使用MongoDB!");

        cmdCount = 1;
        host = db.serverStatus().host;

        // 左侧提示文字
        prompt = function(){

            if (typeof db == "undefined") {
                return "(nodb)> ";
            }

            try {
                db.runCommand({getLastError: 1});
                db.loadServerScripts();
            } catch (e) {
                print(e);
            }

            return db + "@" + (cmdCount++) + "#" + host +"$" + "> ";
        }

        // 自增加2
        function incNum(name) {
            var ret = db.counters.findAndModify(
                {
                    query: { _id: name },
                    update: { $inc: { seq: 2 } },
                    new: true
                }
            );
            return ret.seq;
        }
    ```
- result
    ```sql
        [llllljian@llllljian-virtual-machine ~ 00:04:40 #14]$ mongo
        MongoDB shell version: 3.2.11
        connecting to: test
        你好,你的随机数字是7,欢迎使用MongoDB!
        ...
        test@1#llllljian-virtual-machine$> use llllljian
        switched to db llllljian
        llllljian@2#llllljian-virtual-machine$> show collections
        counters
        system.indexes
        system.js
        test1
        test2
        test3
        llllljian@3#llllljian-virtual-machine$> db.counters.find()
        { "_id" : "id1", "seq" : 30006 }
        { "_id" : "id2", "seq" : 20001 }
        llllljian@4#llllljian-virtual-machine$> db.test2.insert({ _id: incNum("id1"),timestamp: ISODate().valueOf()})
        WriteResult({ "nInserted" : 1 })
        llllljian@5#llllljian-virtual-machine$> db.test3.insert({_id: incNum("id1"),timestamp: ISODate().valueOf()})
        WriteResult({ "nInserted" : 1 })
    ```
