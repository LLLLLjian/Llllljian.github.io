---
title: Python_基础 (31)
date: 2019-03-15
tags: Python
toc: true
---

### Python获取手机号归属地
    Python3练习

<!-- more -->

#### 代码部分
    ```python
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

        # 随机生成手机号码
        def createPhone():
            prelist=["130","131","132","133","134","135","136","137","138","139","147","150","151","152","153","155","156","157","158","159","186","187","188"]
            return random.choice(prelist)+"".join(random.choice("0123456789") for i in range(8))

        def insertPhone():
            global db

            mobile=createPhone()
            collectionForPhone = db.phone
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
            # {'area_code': '0874', 'phone': '15391438014', 'city': '曲靖', 'phone_type': '电信', 'province': '云南', 'zip_code': '655000', '_id': 851}
            data['area_code'] = result2['area_code']
            data['mobile'] = result2['phone']
            data['city'] = result2['city']
            data['phone_type'] = result2['phone_type']
            data['province'] = result2['province']
            data['zip_code'] = result2['zip_code']

            result = db.counters.find_one_and_update({'_id': 'phoneId'},{'$inc': {'seq': 1}},projection={'seq': True,'_id': False},upsert=True,return_document=ReturnDocument.AFTER)
            data["_id"] = result["seq"]

            collectionForPhone.insert_one(data)
            time.sleep(1)

        client = MongoClient()
        db = client.llllljian
        p = Phone()

        if __name__ == '__main__':
            while 1:
                try:
                    insertPhone()
                except TypeError:
                    insertPhone()
    ```

#### 目前遇到的难题
    因为是使用的32位的mongo,单个数据库的存储量为2G,超出2G之后就会报错提示数据不能再插入,需要换一个表进行插入
    换表插入的话,为了保证手机号只插入一次就要保证去查所有的表中有没有这个手机号

    其实换成64位就没问题了

