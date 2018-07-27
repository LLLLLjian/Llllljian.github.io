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
        b.test1.insert(
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

        for (var i = 0; i < 20000; i++) {
            db.test1.insert({_id: getNextSequence("id1"), timestamp: ISODate().valueOf()})
        }
    ```

#### demo
    ```sql
        
    ```

