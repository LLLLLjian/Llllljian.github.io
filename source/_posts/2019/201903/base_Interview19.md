---
title: Interview_总结 (19)
date: 2019-03-01
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * 写出js运行结果[Date可简写为秒数]
- A
    ```javascript
        <script type="text/javascript">
            for (var i=0;i<5;i++) {
                setTimeout(function(){console.log(new Date, i)}, 1000);
            }
            console.log(new Date, i);
        </script>

        输出结果 :
        Tue Mar 12 2019 16:07:46 GMT+0800 (中国标准时间) 5
        Tue Mar 12 2019 16:07:47 GMT+0800 (中国标准时间) 5
        Tue Mar 12 2019 16:07:47 GMT+0800 (中国标准时间) 5
        Tue Mar 12 2019 16:07:47 GMT+0800 (中国标准时间) 5
        Tue Mar 12 2019 16:07:47 GMT+0800 (中国标准时间) 5
        Tue Mar 12 2019 16:07:47 GMT+0800 (中国标准时间) 5

        结果解析 :
        setTimeout是异步执行的,1000毫秒后向任务队列里添加一个任务,只有主线上的全部执行完才会执行任务队列里的任务,所以当主线程for循环执行完之后 i 的值为5,这个时候再去任务队列中执行任务,i全部为5；

        每次for循环的时候setTimeout都会执行,但是里面的function则不会执行被放入任务队列,因此放了5次；for循环的5次执行完之后不到1000毫秒；

        1000毫秒后全部执行任务队列中的函数,所以就是输出五个5啦



        假如把var换成let,那么输出结果为0,1,2,3,4；

        因为let  i  的是区块变量,每个i只能存活到大括号结束,并不会把后面的for循环的  i  值赋给前面的setTimeout中的i；而var i  则是局部变量,这个 i 的生命周期不受for循环的大括号限制；
    ```
    
#### JS中的let和var的区别
- 区别
    * var 是全局变量
    * let 是局部变量
    * let变量不能重复声明
- eg
    ```javascript
        for (var i = 0; i <10; i++) {  
            setTimeout(function() {  // 同步注册回调函数到 异步的 宏任务队列.
                console.log(i);        // 执行此代码时,同步代码for循环已经执行完成
            }, 0);
        }
        // 输出结果
        10   共10个

        // i虽然在全局作用域声明,但是在for循环体局部作用域中使用的时候,变量会被固定,不受外界干扰.
        for (let i = 0; i < 10; i++) { 
            setTimeout(function() {
                console.log(i);    //  i 是循环体内局部作用域,不受外界影响.
            }, 0);
        }
        // 输出结果：
        0  1  2  3  4  5  6  7  8 9
    ```

#### setInterval与setTimeout的区别
- setInterval
    * setInterval()方法可按照指定的周期来调用函数或者计算表达式（以毫秒为单位）
    * 语法：setInterval(函数表达式,毫秒数)；
    * setInterval()会不停的调用函数,直到clearInterval()被调用或者窗口被关闭,由 setInterval()返回的ID值可用作clearInterval()方法的参数.
- setTimeout
    * setTimeout()方法用于在指定毫秒数后再调用函数或者计算表达式（以毫秒为单位）
    * 语法：setTimeout(函数表达式,毫秒数)；
    * setTimeout()只执行函数一次,如果需要多次调用可以使用setInterval(),或者在函数体内再次调用setTimeout()
- 区别
    * setTimeout()方法只运行一次,也就是说当达到设定的时间后就出发运行指定的代码,运行完后就结束了,如果还想再次执行同样的函数,可以在函数体内再次调用setTimeout(),可以达到循环调用的效果.
    * setInterval()是循环执行的,即每达到指定的时间间隔就执行相应的函数或者表达式,是真正的定时器.

#### json格式的字符转转为tree
- Q
    ```php
        [
            {
                "name" : "a1",
                "children" : [
                    {
                        "name" : "a11",
                        "children" : [
                            {
                                "name" : "a111",
                                "children" : [
                                    {
                                        "name" : "a1111",
                                        "children" : []
                                    }
                                ]
                            },
                            {
                                "name" : "a112",
                                "children" : []
                            }
                        ]
                    },
                    {
                        "name" : "a12",
                        "children" : []
                    }
                ]
            },
            {
                "name" : "a2",
                "children" : [
                    {
                        "name" : "a21",
                        "children" : []
                    }
                ]
            }
        ]
        生成如下个格式
        a1
        *a11
        **a111
        ***a1111
        **a112
        *a12
        a2
        *a21
    ```
- A
    ```php
        <?php
            $str = '
            [
                {
                    "name" : "a1",
                    "children" : [
                        {
                            "name" : "a11",
                            "children" : [
                                {
                                    "name" : "a111",
                                    "children" : [
                                        {
                                            "name" : "a1111",
                                            "children" : []
                                        }
                                    ]
                                },
                                {
                                    "name" : "a112",
                                    "children" : []
                                }
                            ]
                        },
                        {
                            "name" : "a12",
                            "children" : []
                        }
                    ]
                },
                {
                    "name" : "a2",
                    "children" : [
                        {
                            "name" : "a21",
                            "children" : []
                        }
                    ]
                }
            ]';
            echo getTree(json_decode($str, true));
            
            function getTree($data, $count = 0) {
                $str = $tempStr = "";
                foreach ($data as $key=>$value) {
                    
                    $str .= str_repeat('*', $count).$value['name']."<br />";
                    
                    if (!empty($value['children'])) {
                        $str .= getTree($value['children'], $count + 1);
                    }
                }
                return $str;
            }
    ?>
    ```

