---
title: Python_基础 (87)
date: 2021-03-15
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之aes加密

<!-- more -->

#### 简单的aes加密类
> 不能明文存放密码, 我就想用aes加密保护一下
- code
    ```python
        # -*- coding: utf-8 -*-
        # !/usr/bin/python3
        """
        aes加密/解密
        """

        import base64
        from Crypto.Cipher import AES


        class AESCrypto(object):
            """
            AES handler
            """
            def __init__(
                self,
                secret_key=b"61581af471b166682a37efe6",
                mode=AES.MODE_CFB,
                iv=b'RandomInitVector',
                segment_size=128,
                is_split=True
            ):
                """
                aes类初始化 默认CFB
                """
                self.secret_key = secret_key
                self.mode = mode
                self.iv = iv
                self.segment_size = segment_size
                self.is_split = is_split

            def encrypt(self, source_str):
                """
                AES CFB encryptor
                加密
                """
                generator = AES.new(self.secret_key, self.mode, IV=self.iv, segment_size=self.segment_size)
                space_len = 16 - len(source_str) % 16
                crypt = generator.encrypt(source_str + space_len * '\0')
                if self.is_split:
                    crypt = crypt[:(0 - space_len)]
                crypted_str = base64.b64encode(crypt)
                return str(crypted_str, encoding='utf-8')

            def decrypt(self, crypted_str):
                """
                AES CFB decryptor
                解密
                """
                generator = AES.new(self.secret_key, self.mode, IV=self.iv, segment_size=self.segment_size)
                crypted_str = base64.b64decode(crypted_str)
                space_len = 16 - len(crypted_str) % 16
                source_str = generator.decrypt(crypted_str + space_len * b'\0')[:(0 - space_len)]
                return str(source_str, encoding='utf-8')


        if __name__ == '__main__':
            data = AESCrypto().encrypt("helloworld")
            print(data)

            password = AESCrypto().decrypt(data)
            print(password)
    ```



