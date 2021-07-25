---
title: Redis_基础 (15)
date: 2021-04-08
tags: 
    - Redis
    - Python
toc: true
---

### 关于队列
    python列表的应用

<!-- more -->

#### 背景
> 假设, 有一个互联网公司, 需要在除夕给10万个注册用户发送祝福 短信.简化起见, 假设一台服务器1秒钟可以发送一条短信, 现有10台 服务器, 需要2.7小时来完成任务.为了保证不漏掉一个用户, 也不能 给一个用户发多条短信, 还要实现发送短信失败后进行重试, 一个用户 最多重试3次, 那么就可以使用Redis的列表来实现
1. code
    ```python
        import redis
        import json

        client = redis.Redis(host="xx.xx.xx.xx")

        while True:
            # 对一个空的列表执行“lpop”, 会返回 None, 说明所 有的短信都已经发送完毕
            phone_info_bytes = client.lpop('phone_queue')
            if not phone_info_bytes:
                print("短信发送完毕")
                break

            phone_info = json.loads(phone_info_bytes)
            # 在初始状态下 phone_info中是没有retry_times字段的
            retry_times = phone_info.get('retry_times', 0)
            phone_number = phone_info['phone_number']
            result = send_sms(phone_number)
            if result:
                print(f"手机号 {phone_number}" 短信发送成功！)
                continue

            if retry_times >= 3:
                print(f"重试超过3次, 放弃手机号: {phone_number}")
                continue
            next_phone_info = {
                "phone_number": phone_number,
                "retry_times": retry_times + 1
            }
            client.rpush(
                'phone_queue',
                json.dumps(next_phone_info)
            )
    ```




