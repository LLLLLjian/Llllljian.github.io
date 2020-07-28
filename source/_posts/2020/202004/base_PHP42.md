---
title: PHP_基础 (42)
date: 2020-04-17
tags: PHP 
toc: true
---

### 关于PHP中哈希函数
    PHP哈希自己只知道概念从来没用过, 得看一下.

<!-- more -->

#### hash()函数
> 调用指定的哈希算法来运算
hash ( string $algo , string $data [, bool $raw_output = FALSE ] ) : string

#### $algo取值
> hash_algos() 函数返回当前php版本提供的所有哈希算法,而且很多哈希算法都已封装了函数
```php
    Array
    (
        [0] => md2
        [1] => md4
        [2] => md5
        [3] => sha1
        [4] => sha224
        [5] => sha256
        [6] => sha384
        [7] => sha512/224
        [8] => sha512/256
        [9] => sha512
        [10] => sha3-224
        [11] => sha3-256
        [12] => sha3-384
        [13] => sha3-512
        [14] => ripemd128
        [15] => ripemd160
        [16] => ripemd256
        [17] => ripemd320
        [18] => whirlpool
        [19] => tiger128,3
        [20] => tiger160,3
        [21] => tiger192,3
        [22] => tiger128,4
        [23] => tiger160,4
        [24] => tiger192,4
        [25] => snefru
        [26] => snefru256
        [27] => gost
        [28] => gost-crypto
        [29] => adler32
        [30] => crc32
        [31] => crc32b
        [32] => fnv132
        [33] => fnv1a32
        [34] => fnv164
        [35] => fnv1a64
        [36] => joaat
        [37] => haval128,3
        [38] => haval160,3
        [39] => haval192,3
        [40] => haval224,3
        [41] => haval256,3
        [42] => haval128,4
        [43] => haval160,4
        [44] => haval192,4
        [45] => haval224,4
        [46] => haval256,4
        [47] => haval128,5
        [48] => haval160,5
        [49] => haval192,5
        [50] => haval224,5
        [51] => haval256,5
    )
```

#### 初使用
- demo
    ```php
        <?php
            $res = array();

            for ($i=1;$i<=200;$i++) {
                // 哈希加密
                $a = hash("sha256", $i);
                // 50取余
                $b = $a%50;
                $res[] = $b;
                echo $a . "<br />";
                echo $b . "<br />";
                echo "<br />";
            }

        ?>
    ```

#### 常用的哈希函数
- crc32()
    * 计算一个字符串的 crc32 多项式,返回一个32位(4字节)整数,尽量使用 sprintf("%u", crc32($str))获得正整数的结果
- md5()
    * 计算字符串的 MD5 散列值
- sha1()
    * 计算字符串的 sha1 散列值
- md5_file()
    * 计算指定文件的 MD5 散列值
- sha1_file()
    * 计算文件的 sha1 散列值
