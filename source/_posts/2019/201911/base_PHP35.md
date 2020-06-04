---
title: PHP_基础 (35)
date: 2019-11-01
tags: PHP 
toc: true
---

### PHP定时任务Crontab结合CLI模式详解
    PHP执行脚本的时候传参, 了解一下.

<!-- more -->

#### 使用argv数组
- eg
    ```bash
        [llllljian@llllljian-cloud-tencent php 11:55:04 #12]$ cat testForPhp.php
        <?php
        /**
         * File Name: testForPhp.php
         * Author: llllljian
         **/
        var_dump($argv);

        [llllljian@llllljian-cloud-tencent php 11:56:38 #13]$ php testForPhp.php arg1 arg2 arg3 4
        array(5) {
            [0]=>
            string(14) "testForPhp.php"
            [1]=>
            string(4) "arg1"
            [2]=>
            string(4) "arg2"
            [3]=>
            string(4) "arg3"
            [4]=>
            string(1) "4"
        }
    ```
- 缺点
    * 使用argv数组, 可以按顺序获取传递的参数.但获取后, 需要做一个对应处理, 上例中需要把argv[1]对应arg1参数,argv[2]对应arg2参数,argv[3]对应arg3参数.而如果在传递的过程中, 参数顺序写错, 则会导致程序出错

#### 使用getopt方法[使用options方法]
- eg
    ```bash
        [llllljian@llllljian-cloud-tencent php 19:55:16 #6]$ cat testForPhp1.php
        <?php
        /**
         * File Name: testForPhp1.php
         * Author: llllljian
         * a,b,c 为需要值
         * d 为可选值
         * e 为不接受值
         **/

        $param = getopt('a:b:c:d::e');
        var_dump($param);

        [llllljian@llllljian-cloud-tencent php 19:55:22 #7]$ php testForPhp1.php -a 1
        array(1) {
        ["a"]=>
        string(1) "1"
        }

        [llllljian@llllljian-cloud-tencent php 20:00:57 #8]$ php testForPhp1.php -b 2
        array(1) {
        ["b"]=>
        string(1) "2"
        }

        [llllljian@llllljian-cloud-tencent php 20:01:53 #9]$ php testForPhp1.php -c 3
        array(1) {
        ["c"]=>
        string(1) "3"
        }

        [llllljian@llllljian-cloud-tencent php 20:02:19 #10]$ php testForPhp1.php -d 4
        array(1) {
        ["d"]=>
        bool(false)
        }

        [llllljian@llllljian-cloud-tencent php 20:02:26 #11]$ php testForPhp1.php -d=4
        array(1) {
        ["d"]=>
        string(1) "4"
        }

        [llllljian@llllljian-cloud-tencent php 21:13:10 #13]$ php testForPhp1.php -e 5
        array(1) {
        ["e"]=>
        bool(false)
        }

        [llllljian@llllljian-cloud-tencent php 21:13:31 #14]$ php testForPhp1.php -e=5
        array(1) {
        ["e"]=>
        bool(false)
        }

        [llllljian@llllljian-cloud-tencent php 21:13:35 #15]$ php testForPhp1.php -a=1 -b 2 -c 3 -d=4 -e=5
        array(5) {
        ["a"]=>
        string(1) "1"
        ["b"]=>
        string(1) "2"
        ["c"]=>
        string(1) "3"
        ["d"]=>
        string(1) "4"
        ["e"]=>
        bool(false)
        }

        [llllljian@llllljian-cloud-tencent php 21:43:26 #16]$ php testForPhp1.php -a=1 -e 2 -c 3 -d=4 -e=5
        array(2) {
        ["a"]=>
        string(1) "1"
        ["e"]=>
        bool(false)
        }
    ```
- 说明
    * 参数说明
        * 单独的字符(不接受值)
        * 后面跟随冒号的字符(此选项需要值)
        * 后面跟随两个冒号的字符(此选项的值可选)
        * 选项的值是字符串后的第一个参数.它不介意值之前是否有空格.
        * 传值的分隔符可以使用空格或=.
        * 可选项的值不接受空格作为分隔符, 只能使用=作为分隔符.
    * 返回值
        * 此函数会返回选项/参数对, 失败时返回 FALSE.
        * 选项的解析会终止于找到的第一个非选项, 之后的任何东西都会被丢弃

#### 使用getopt方式[使用longopts方法]
- eg
    ```bash
        [llllljian@llllljian-cloud-tencent php 00:07:54 #6]$ cat testForPhp2.php
        <?php
        /**
         * File Name: testForPhp2.php
         * Author: llllljian
         * type,is_hot 为需要值
         * limit 为可选值
         * expire 为不接受值
         **/
        $longopt = array (
            'type:',
            'is_hot:',
            'limit::',
            'expire'
        );

        $param = getopt('',$longopt);
        var_dump($param); 

        [llllljian@llllljian-cloud-tencent php 00:08:08 #7]$ php testForPhp2.php -type news
        array(0) {
        }

        [llllljian@llllljian-cloud-tencent php 00:09:31 #8]$ php testForPhp2.php --type news
        array(1) {
        ["type"]=>
        string(4) "news"
        }

        [llllljian@llllljian-cloud-tencent php 00:09:59 #9]$ php testForPhp2.php --is_hot 1 --type news --expire 5 --limit=5
        array(3) {
        ["is_hot"]=>
        string(1) "1"
        ["type"]=>
        string(4) "news"
        ["expire"]=>
        bool(false)
        }
    ```
- 说明
    * options 和 longopts 的格式几乎是一样的, 唯一的不同之处是 longopts 需要是选项的数组(每个元素为一个选项), 而 options 需要一个字符串(每个字符是个选项)

#### 另外附上php执行的一些参数案例
- php -f 运行指定文件
- php -r 直接运行PHP代码
- php -m 内置及Zend加载的模块
- php -i 等价于 phpinfo()
- php -i | grep php.ini 查看php配置文件加载路径
- php –ini 同上
- php -v 查看php版本
- php –version 同上
- php –re 查看是否安装相应的扩展 如 php –re gd

