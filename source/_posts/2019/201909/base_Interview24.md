---
title: Interview_总结 (24)
date: 2019-09-04
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * 什么是MVC
- A
    * 最上面的一层，是直接面向最终用户的"视图层"（View）。它是提供给用户的操作界面，是程序的外壳。
    * 最底下的一层，是核心的"数据层"（Model），也就是程序需要操作的数据或信息。
    * 中间的一层，就是"控制层"（Controller），它负责根据用户从"视图层"输入的指令，选取"数据层"中的数据，然后对其进行相应的操作，产生最终结果。

#### 问题2
- Q
    * 如何实现链式操作 $obj->w()->m()->d();
- A
    * 简单实现[关键通过做完操作后return $this;]
        ```php
            class Sql{
                private $sql = array("from"=>"",
                    "where"=>"",
                    "order"=>"",
                    "limit"=>""
                );
            
                public function from($tableName) {
                    $this‐>sql["from"]="FROM ".$tableName;
                    return $this;
                }
                public function where($_where='1=1') {
                    $this‐>sql["where"]="WHERE ".$_where;
                    return $this;
                }
                public function order($_order='id DESC') {
                    $this‐>sql["order"]="ORDER BY ".$_order;
                    return $this;
                }
                public function limit($_limit='30') {
                    $this‐>sql["limit"]="LIMIT 0,".$_limit;
                    return $this;
                }
                public function select($_select='*') {
                    return "SELECT ".$_select." ".(implode(" ",$this‐>sql));
                }
            }
        
            $sql =new Sql();
            echo $sql‐>from("testTable")‐>where("id=1")‐>order("id DESC")‐>limit(10)‐>select();
            //输出 SELECT * FROM testTable WHERE id=1 ORDER BY id DESC LIMIT 0,10
            ?>
        ```
    * 利用__call()方法实现
        ```php
            class String
            {
                public $value;

                public function __construct($str=null)
                {
                    $this‐>value = $str;
                }

                public function __call($name, $args)
                {
                    $this‐>value = call_user_func($name, $this‐>value, $args[0]);
                    return $this;
                }

                public function strlen()
                {
                    return strlen($this‐>value);
                }
            }
            $str = new String('01389');
            echo $str‐>trim('0')‐>strlen();
            // 输出结果为 4；trim('0')后$str为"1389"
        ```





