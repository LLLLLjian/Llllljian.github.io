---
title: Interview_总结 (18)
date: 2019-02-28
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * file_get_contents读取文件的时候需要注意的地方
- A
    * file_get_contents() 函数把整个文件读入一个字符串中
    * 语法
        * file_get_contents(path,include_path,context,start,max_length)
    * 参数
        * path[必需] 规定要读取的文件.
        * include_path[可选] 如果也想在 include_path 中搜寻文件的话,可以将该参数设为 "1".
        * context[可选] 规定文件句柄的环境.context 是一套可以修改流的行为的选项.若使用 null,则忽略.
        * start[可选] 规定在文件中开始读取的位置.该参数是 PHP 5.1 新加的.
        * max_length[可选] 规定读取的字节数.该参数是 PHP 5.1 新加的.

#### 问题2
- Q
    * Mysql的datetime timestamp的区别
- A
    * datetime的默认值为null,timestamp的默认值不为null,且为系统当前时间（current_timestatmp）.如果不做特殊处理,且update没有指定该列更新,则默认更新为当前时间.
    * datetime占用8个字节,timestamp占用4个字节.timestamp利用率更高.
    * 二者存储方式不一样,对于timestamp,它把客户端插入的时间从当前时区转化为世界标准时间（UTC）进行存储,查询时,逆向返回.但对于datetime,基本上存什么是什么.
    * 二者范围不一样.timestamp范围：‘1970-01-01 00:00:01.000000’ 到 ‘2038-01-19 03:14:07.999999’； datetime范围：’1000-01-01 00:00:00.000000’ 到 ‘9999-12-31 23:59:59.999999’.原因是,timestamp占用4字节,能表示最大的时间毫秒为2的31次方减1,也就是2147483647,换成时间刚好是2038-01-19 03:14:07.999999.

#### MySQL得到百分数
    ```sql
        SELECT
        T1.countA AS '成单数', T2.countB AS '总订单数', concat(ROUND(T1.countA/T2.countB*100, 2), "%") AS '成单率'
        FROM 
        (SELECT count(*) AS countA FROM orderinfo WHERE status = 2) AS T1,
        (SELECT count(*) AS countB FROM orderinfo) AS T2
    ```

#### MySQL随机取数据
- 方式一
    ```sql
        SELECT * FROM 表名 ORDER BY RAND() LIMIT 1;
    ```
- 方式二
    ```sql
        SELECT * 
        FROM 表名
        WHERE id >= (SELECT FLOOR(RAND() * ((SELECT MAX(id) FROM `que_bank`) - (SELECT MIN(id) FROM `que_bank`)) + (SELECT MIN(id) FROM `que_bank`))) ORDER BY id LIMIT 1 ;
    ```
- 方式三
    ```sql
        SELECT q1.*
        FROM que_bank AS q1
        JOIN
            (SELECT ROUND(RAND() * (
                (SELECT MAX(id)
                FROM que_bank)- 
                    (SELECT MIN(id)
                    FROM que_bank))+
                        (SELECT MIN(id)
                        FROM que_bank)) AS id) AS q2
                    WHERE q1.id >= q2.id
                ORDER BY  q1.id LIMIT 1;
    ```
- 总结
    * 方案一: 在数据量很大的情况下,万条以上就不能使用这种方式了,所以方案一基本上处于不可行的情况.
    * 方案二：效率还可以,但是还有提升的空间,数据量小的情况下是可行的.
    * 方案三：效率是三种方式中最高的,建议使用.

