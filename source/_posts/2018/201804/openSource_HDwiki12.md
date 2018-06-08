---
title: HDwiki_源码分析 (12)
date: 2018-04-09
tags: HDwiki
toc: true
---

### 升级HDwiki6.0
    HDwiki5.1升级到6.0.

<!-- more -->

#### 修改语言包
- 对应功能
    * 语言包编辑功能,修改对应语言内容
- 重写原因
    * 表单提交的时候发现报错,因为post传输的数据大于1000条
- 修改方法
    * 改php.ini文件max_input_vars
    * 将表单中提交的内容转为json格式进行传输
    * 焦点移动到某个输入框的时候,对输入框添加一个属性,表单提交的时候只提交有特定值的那些选项
- 源码分析
    ```php
        // 先说一下上边三个方法的优劣
        1. 本地开发的话直接修改php.ini是最便捷的,但是代码上传到服务器的时候总不能要求所有的配置都符合你的要求
        2. 后台php文件获取post的json花了点时间,别的暂时没有
        3. 理论上说不可能有人点1000个选项,所以3也是比较便捷的

        // 原先的代码就不贴了,贴一点自己写的
        // admin_language.htm js方法重写,将按钮type改为button,添加点击事件
        function check() 
        {
            if(confirm('确定修改语言文件？')==false){
                return false;
            }else{
                // 获取input中name以lang[开头的选项 并将他们转化为数组
                var a = $("input[name^='lang[']").serializeArray();
                // 将数组转为json格式
                var b = JSON.stringify(a);
                
                $.ajax({  
                    type : "POST",  
                    url : 'index.php?admin_language-editlang'+'-'+$('#langtype').val()+'-'+$('#langtag').val(), 
                    data : b,  
                    // 返回的数据类型
                    dataType : "text",
                    // 发送信息至服务器时内容编码类型
                    contentType: "application/json", 
                    success:function(data) {  
                        switch (data) {
                            case '1' :
                                result = "修改成功";
                                break;
                            case '2' : 
                                result = "修改失败 请重试";
                                break;
                            default : 
                                result = "参数错误";
                                break;
                        }
                        // 弹窗
                        $.dialog.box('change_lang', '修改语言包', result);
                        // 5秒之后自动关闭并刷新当前页.
                        setTimeout("$.dialog.close('change_lang');location.reload();", 5000);
                    } 
                });  
            }
        }

        1 admin_language.php
        function doeditlang()
        {
            $tempArr = $lang = array();
            // 读post传过来的json格式的内容,并转化为数组形式
            $formdata = json_decode(file_get_contents('php://input', 1000000), true);

            $lang = array();
            foreach ($formdata as $key => $value) {
                // $value是数组 去除name中的lang[和]
                $lang[rtrim(ltrim($value['name'], "lang["), "]")] = $value['value'];
            }
            ...
            $lang = array_merge($this->view->lang, $lang);
            ...
            echo "1";
        }

        2 admin_language.php
        function doeditlang()
        {
            $tempArr = $lang = array();
            // 读post过来的PHP无法识别的内容,并转化为数组形式
            $formdata = json_decode($GLOBALS['HTTP_RAW_POST_DATA']);

            $lang = array();
            foreach ($formdata as $key => $value) {
                // $value是对象 去除name中的lang[和]
                $lang[rtrim(ltrim($value->name, "lang["), "]")] = $value->value;	
            }
            ...
            $lang = array_merge($this->view->lang, $lang);
            ...
            echo "1";
        }

        2 hdwiki.class.php
        function init_request()
        {
            ...
            // 添加HTTP_RAW_POST_DATA,否则admin_language.php中无法取到值
            $remain = array('_SERVER', '_FILES', '_COOKIE', 'GLOBALS', 'starttime', 'mquerynum', 'HTTP_RAW_POST_DATA');
            foreach ($GLOBALS as $key => $value) {
                if ( !in_array($key,$remain) ) {
                    unset($GLOBALS[$key]);
                }
            }
        }   
    ```
- 题外话 : $_POST  HTTP_RAW_POST_DATA  php://input三者之间的区别
    * $_POST
        * $_POST是我们最常用的获取POST数据的方式,它是以关联数组方式组织提交的数据,并对此进行编码处理.sss
        * 识别的数据类型是PHP默认识别的数据类型 application/x-www.form-urlencoded
        * 无法解析如text/xml, application/json等非application/x-www.form-urlencoded数据类型的内容
    * HTTP_RAW_POST_DATA
        * Content-Type=application/json类型提交的post类型数据\$_POST无法接受,可以使用\$GLOBALS['HTTP_RAW_POST_DATA']获取,因为在PHP无法识别Content-Type的时候,就会把POST数据填入到\$HTTP_RAW_POST_DATA 中
        * 需要设置 php.ini 中的 always_populate_raw_post_data 值为 On 才会生效
        * 当\$_POST 与 php://input可以取到值时$HTTP_RAW_POST_DATA 为空
        * 不能用于 enctype="multipart/form-data"
        * PHP7中已经移除了这个全局变量,用 php://input 替代
    * php://input
        * php://input可通过输入流以文件读取方式取得未经处理的POST原始数据,允许读取 POST 的原始数据.
        * 和 $HTTP_RAW_POST_DATA 比起来,它给内存带来的压力较小
        * 不需要任何特殊的 php.ini 设置
        * 不能用于 enctype="multipart/form-data"
    * 代码示例
        ```php
            // post.html
            <!DOCTYPE html>
            <html>
            <head>
                <title>$POST 、$HTTP_RAW_POST_DATA、php://input三者之间的区别</title>
            </head>
            <body>
                <form action="post.php" method="post">
                    <p>First name: <input type="text" name="fname" /></p>
                    <p>Last name: <input type="text" name="lname" /></p>
                    <input type="submit" value="Submit" />
                </form>
            </body>
            </html>

            // post.php
            <?php
                echo "<pre>";
                print_r($_POST);
                echo "<br>";
                $data = file_get_contents('php://input');   //都要解下码
                print_r(urldecode($data));
                echo "<br>";
                // Undefined index:HTTP_RAW_POST_DATA错误的话,设置php.ini always_populate_raw_post_data=on重启
                print_r(urldecode($GLOBALS['HTTP_RAW_POST_DATA']));
            ?> 

            // 输出结果
            Array
            (
                [fname] => xiao
                [lname] => ming
            )
            fname=xiao&lname=ming
            fname=xiao&lname=ming 
        ```
