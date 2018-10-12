---
title: Interview_总结 (13)
date: 2018-09-06
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
    ```php
        q : 使对象可以像数组一样进行foreach循环,要求属性必须是私有

        a : 
        class sample implements Iterator
        {
            private $_items = array(1,2,3,4,5,6,7);
        
            public function __construct($arr) 
            {
                if (!empty($arr) && is_array($arr)) {
                    $this->$_items = $arr;
                }
            }

            public function rewind() 
            { 
                reset($this->_items); 
            }

            public function current() 
            { 
                return current($this->_items); 
            }

            public function key() 
            { 
                return key($this->_items); 
            }

            public function next() 
            { 
                return next($this->_items); 
            }

            public function valid() 
            { 
                return ( $this->current() !== false ); 
            }
        }
        
        $sa = new sample();
        foreach($sa as $key => $val){
            print $key . "=>" .$val
        }
    ```

#### 问题2
    ```php
        q : 求一个数组中出现最多的值

        a : 
        function getMaxCountForArr($arr)
        {
            if (empty($arr) || !is_array($arr)) {
                return false;
            }

            // 统计数组中所有值出现的次数
            $arr2 = array_count_values($arr); 
            // 按照键值对关联数组进行降序排序
            arsort($arr2); 
            $first = reset($array2);
            $first_key = key($array2);
            echo "数组中{$first_key}重复次数最多,为:{$first}次";
        }

        $array = array(1, 1, 1, 54, 3, 4, 3, 4, 3, 14, 3, 4, 3, 7, 8, 9, 12, 45, 66, 5, 7, 8, 9, 2, 45);
    ```

#### 问题3
    ```php
        q : 创建多级目录的函数

        a : 
        function createDirList($path, $mode)
        {
            if (is_dir($path)) {
                // 判断目录存在否,存在不创建
                echo "目录'" . $path . "'已经存在";
                // 已经存在则输入路径
            } else { 
                // 不存在则创建目录
                $re = mkdir($path, $mode, true);
                // 第三个参数为true即可以创建多极目录
                if ($re) {
                    // 目录创建成功
                    echo "目录创建成功";
                } else {
                    echo "目录创建失败";
                }
            }
        }

        $path="/a/x/cc/cd"; //要创建的目录
        $mode=0755; //创建目录的模式,即权限.
        createDirList($path, $mode);//测试
    ```

#### 问题4
    ```php
        q : static与global的使用

        a : 
        static 静态
        global 全局

        <?php	
            function index()
            {	
                //初始化静态变量
                static $phphubei = 0; 	
                $phphubei += 1;		
                echo $phphubei.'<br />';	
            }	

            for($i=1;$i<10;$i++) {	
                index();	
            } 	
            //输出 1-10 	
            //如果不加static,输出10个1,因为循环执行的时候,每次都是从0开始加1,而无法保存  
        ?> 

        <?php
            $phphubei='1';  
            function index()
            {      
                global $phphubei;     
                echo $phphubei;  
            } 
            index(); 
        ?>
    ```
