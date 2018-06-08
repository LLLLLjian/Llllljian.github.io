---
title: PHP_Yii框架 (27)
date: 2018-03-13
tags: Yii
toc: true
---

### 安全_加密
    有些数据是需要处理之后才能存储的.

<!-- more -->

#### 生成伪随机数据
    ```php
        // string(5) "nVgMZ" 生成随机字符串,参数是生成位数,默认是32位
        $key = Yii::$app->getSecurity()->generateRandomString(5);
    ```

#### 加密和解密
- 加密
    ```php
        // 获取当前用户id
        $id = Yii::$app->user->getId();
        // $encryptedData = Yii::$app->getSecurity()->encryptByPassword($data, $secretKey);
        // $data 是要加密的内容
        // $secretKey 是设置的密码
        // 要加密的内容为当前用户id,密码为空
        $id1 = Yii::$app->getSecurity()->encryptByPassword($id, '');
        $id2 = base64_encode(yii::$app->security->encryptByPassword($id,''));
        var_dump($id);
        echo "<br />";
        var_dump($id1);
        echo "<br />";
        var_dump($id2);

        // 输出结果
        int(1) 
        string(112) "�)��.�ҝ�O�07651e4f8eefe7e6a119ce39d2032c2edfbc1b3e98386f97d048524956d7cfadӒ����gy��Z� `�`���+mC�" 
        string(152) "LlKyUtEHgqYnYAdngfqhkWQxZmJkM2QyMDZlZjNjYTRhODI4ODFmNzE4MjY2MzQ5NDRiZDlhNjc1OGZiYjY4OTE3Y2Y5OTczNzU5ODc4MWUI76J6ekcFQt/49tT6ajCzo1DVj3VBPWGs28pTlZHcSg==" 
        
        加密后的字符串是一串乱码,不利于下一步操作
        可以使用base64处理加密后的字符串, 处理后的字符串是由字母和数字组成
    ```
- 解密
    ```php
        // 和上边的加密过程想对应
        $id3 = yii::$app->security->decryptByPassword($id1, '');
        $id4 = yii::$app->security->decryptByPassword(base64_decode($id2), '');

        var_dump($id3);
        echo "<br />";
        var_dump($id4);

        // 输出结果
        string(1) "1"
        string(1) "1" 
    ```
- 密码相关
    ```php
        // 注册时对密码哈希化
        // 密码应从表单中接受,这里简写表单接受密码的过程
        $password = 'username';
        $password1 = 'username1';
        $hash = Yii::$app->getSecurity()->generatePasswordHash($password);
        var_dump($hash);
        echo "<br />";
        var_dump(Yii::$app->getSecurity()->validatePassword($password, $hash));
        echo "<br />";
        var_dump(Yii::$app->getSecurity()->validatePassword($password1, $hash));

        // 输出结果. 这里要注意 哈希化之后是一个60长度的字符串,数据库中对应的密码长度应该大于60[varchar(65)]
        // 还可以对密码再次进行加密
        string(60) "$2y$13$HZM3bu3vxL1an7G4ZDmfde1CJ/msSiuW9ThUDMbY1pjKT/P6dfadS"
        bool(true)
        bool(false) 
    ```

#### 确认数据完整性
    ```php
        // $secretKey 是我们的应用程序或用户密钥,$genuineData 是从可靠来源获得的
        // $data = Yii::$app->getSecurity()->hashData($genuineData, $secretKey);

        $id = Yii::$app->user->getId();
        $id1 = Yii::$app->getSecurity()->hashData($id, '');
        var_dump($id);
        echo "<br />";
        var_dump($id1);
        echo "<br />";

        // 输出结果
        int(1)
        string(65) "41e0a9448f91edba4b05c6c2fc0edb1d6418aa292b5b2942637bec43a29b95231" 

        // $secretKey 我们的应用程序或用户密钥,$data 从不可靠的来源获得
        // $data = Yii::$app->getSecurity()->validateData($data, $secretKey);
        // 正确的数据
        $isvalid = Yii::$app->getSecurity()->validateData($id1, '');
        // 错误的数据[用php函数去除了最后一位]
        $isvalid1 = Yii::$app->getSecurity()->validateData(substr($id1, 0, strlen($id1) - 1), '');
        var_dump($isvalid);
        echo "<br />";
        var_dump($isvalid1);

        // 输出结果
        string(1) "1"
        bool(false) 
    ```