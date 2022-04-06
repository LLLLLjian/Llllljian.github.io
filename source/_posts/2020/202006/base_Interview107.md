---
title: Interview_总结 (107)
date: 2020-06-29
tags: Interview
toc: true
---

### 面试题
    面试题汇总-海量数据查找中位数

<!-- more -->

#### 海量数据查找中位数
- 问题描述
    * 现在有10亿个int型的数字(java中int型占4B), 以及一台可用内存为1GB的机器, 如何找出这10亿个数字的中位数？所谓中位数就是有序列表中间的数.如果列表长度是偶数, 中位数则是中间两个数的平均值
- 解题思路
    * 假设将这10亿个数字保存在一个大文件中, 依次读一部分文件到内存(不超过内存的限制: 1GB), 将每个数字用二进制表示, 比较二进制的最高位(第32位), 如果数字的最高位为0, 则将这个数字写入file_0文件中；如果最高位为1, 则将该数字写入file_1文件中, 通过这样的操作, 这10亿个数字分成了两个文件, 假设file_0文件中有6亿个数字, 而file_1文件中有4亿个数字, 10亿个数字的中位数是10亿个数排序之后的第5亿个数, 中位数就在file_0文件中, 并且是file_0文件中所有数字排序之后的第1亿个数字
    * 接下来我们只需要操作文件file_0文件就可以了, 对于file_0文件, 可以同样的采取上面的措施处理: 将file_0文件依次读一部分到内存(不超内存限制: 1GB), 将每个数字用二进制表示, 比较二进制的次高位(第31位), 如果数字的次高位为0, 写入file_0_0文件中；如果次高位为1, 写入file_0_1 文件中
    * 继续分割文件即可
- 实例
    * 想模仿一下这种海量数据的操作,  我先写了往文件中追加随机数0-500000的php程序
        ```php
            <?php
            /**
             * File Name: roundNum.php
             **/
            file_put_contents('./roundNum.log', rand(1, 500000)."\r\n", FILE_APPEND);  
        ```
    * 写了shell脚本去循环执行该php文件
        ```bash
            #!/bin/bash
            #########################################################################
            # 文件名: roundNumCrontab.sh
            #########################################################################
            #!/bin/bash
            for((i=0;i<100000;i++));
            do
            eval $(php /home/llllljian/php/roundNum.php);
            done
        ```
    * 设置了crontab定时任务
        ```bash
            # 每隔5分钟执行一次 产生10w个数字
            */5 * * * * /bin/bash /home/llllljian/shell/roundNumCrontab.sh
        ```
    * 海量数据成果
        ```bash
            [llllljian@llllljian-cloud-tencent php 14:45:52 #31]$ du -sh *
            9.9G	roundNum.log
            [llllljian@llllljian-cloud-tencent php 14:45:55 #32]$ wc -l roundNum.log
            1363989312 roundNum.log
        ```
    * 分割脚本
        ```php
            <?php
            /**
             * File Name: largeFile.php
             **/

            set_time_limit(0);
            ini_set("memory_limit", "-1");//去除内存限制
            ini_set('max_execution_time', 0);

            $file = fopen("./roundNum.log","r");
            while(!feof($file))
            {
                $tempDecStr = fgets($file);
                // 因为是0-50w的数字 所以只要判断19位二进制即可
                $tempBinStr = sprintf("%019b", $tempDecStr);
                if ($tempBinStr[0] == 0) {
                    file_put_contents('./roundNum_0.log', $tempDecStr, FILE_APPEND);
                } else {
                    file_put_contents('./roundNum_1.log', $tempDecStr, FILE_APPEND);
                }
            }

            fclose($file);
        ```
    * 分割成果
        ```bash
            [llllljian@llllljian-cloud-tencent php 14:49:41 #34]$ du -sh *
            4.3G	roundNum_0.log
            4.2G	roundNum_1.log
            [llllljian@llllljian-cloud-tencent php 14:51:43 #35]$ wc -l roundNum_0.log roundNum_1.log
            602822368 roundNum_0.log
            557162652 roundNum_1.log
        ```
    * 根据解题思路可得, 中位数在roundNum_0.log中, 且在排序后的第6亿个数字
    * 第二次分割,  只需操作roundNum_0.log即可.....




