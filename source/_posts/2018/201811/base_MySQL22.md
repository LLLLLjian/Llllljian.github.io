---
title: MySQL_基础 (22)
date: 2018-11-12
tags: MySQL
toc: true
---

### 自定义函数
    突然觉得应该系统地再去学一遍MySQL,从零开始.

<!-- more -->

#### 自定义函数简介
    自定义函数 (user-defined function UDF)是一种对MySQL扩展的途径,其用法和内置函数相同.
    自定义函数的两个必要条件：
    A、参数
    B、返回值(必须有).函数可以返回任意类型的值

#### 自定义函数的使用
- 自定义函数语法
    ```sql
        CREATE FUNCTION function_name(parameter_nametype,[parameter_name type,...])
        RETURNS {STRING|INTEGER|REAL}
        runtime_body

        CREATE FUNCTION function_name(parameter_nametype,[parameter_name type,...])
        RETURNS {STRING|INTEGER|REAL}
        BEGIN
        //body
        END
    ```
- 流程控制
    * IF语句
        * IF语句用来进行条件判断
        * eg
            ```sql
                IF search_condition THEN statement_list 
                    [ELSEIF search_condition THEN statement_list] ... 
                    [ELSE statement_list] 
                END IF 

                IF age>20 THEN SET @count1=@count1+1;  
                    ELSEIF age=20 THEN SET @count2=@count2+1;  
                    ELSE SET @count3=@count3+1;  
                END IF;
            ```
    * CASE语句
        * CASE语句也用来进行条件判断
        * eg
            ```sql
                CASE 
                    WHEN search_condition THEN statement_list 
                    [WHEN search_condition THEN statement_list] ... 
                    [ELSE statement_list] 
                END CASE 

                CASE 
                    WHEN age=20 THEN SET @count1=@count1+1; 
                    ELSE SET @count2=@count2+1; 
                END CASE ; 

                CASE case_value 
                    WHEN when_value THEN statement_list 
                    [WHEN when_value THEN statement_list] ... 
                    [ELSE statement_list] 
                END CASE 

                CASE age 
                    WHEN 20 THEN SET @count1=@count1+1; 
                    ELSE SET @count2=@count2+1; 
                END CASE ; 
            ```
    * LOOP语句
        * LOOP语句可以使某些特定的语句重复执行,实现一个简单的循环
        * eg
            ```sql
                [begin_label:] LOOP 
                statement_list 
                END LOOP [end_label] 

                add_num: LOOP  
                SET @count=@count+1;  
                END LOOP add_num ; 
            ```
    * LEAVE语句
        * LEAVE语句主要用于跳出循环控制
        * LEAVE语句是跳出整个循环,然后执行循环后面的程序
        * eg
            ```sql
                LEAVE label

                add_num: LOOP 
                SET @count=@count+1; 
                IF @count=100 THEN 
                LEAVE add_num ; 
                END LOOP add_num ; 
            ```
    * ITERATE语句
        * TERATE语句也是用来跳出循环的语句
        * ITERATE语句是跳出本次循环
        * eg
            ```sql
                ITERATE label

                add_num: LOOP 
                SET @count=@count+1; 
                IF @count=100 THEN 
                LEAVE add_num ; 
                ELSE IF MOD(@count,3)=0 THEN 
                ITERATE add_num; 
                SELECT * FROM employee ; 
                END LOOP add_num ; 
            ```
    * REPEAT语句
        * REPEAT语句是有条件控制的循环语句.当满足特定条件时,就会跳出循环语句
        * eg
            ```sql
                [begin_label:] REPEAT 
                statement_list 
                UNTIL search_condition 
                END REPEAT [end_label] 
            ```
    * WHILE语句
        * WHILE语句是当满足条件时,执行循环内的语句
        * eg
            ```sql
                [begin_label:] WHILE search_condition DO 
                statement_list 
                END WHILE [end_label] 

                WHILE @count<100 DO 
                SET @count=@count+1; 
                END WHILE ; 
            ```
- 删除自定义函数
    * DROP FUNCTION functionName;
- 自定义函数的调用
    * SELECT function_name(parameter_value,...);

