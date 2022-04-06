---
title: Interview_总结 (26)
date: 2019-09-06
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题
    
<!-- more -->

#### 问题1
- Q
    * 给定二维数组,根据某个字段排序
    * 一组学生信息,要按年龄大小升序或降序排序(类似与sql语句的order by功能)
- A
    ```php
        $arr = [
            ['id' => 6, 'name' => '小明'],
            ['id' => 1, 'name' => '小亮'],
            ['id' => 13, 'name' => '小红'],
            ['id' => 2, 'name' => '小强'],
        ];

        // function 1 S
        function arraySort($arr, $sortField, $sort = 'asc') 
        {
            $newArr = array();
            foreach ($arr as $key => $value) {
                $newArr[$key] = $value[$sortField];
            }
            ($sort == 'asc') ? asort($newArr) : arsort($newArr);
            foreach ($newArr as $k => $v) {
                $newArr[$k] = $arr[$k];
            }
            return $newArr;
        }
        // function 1 E

        // function 2 S
        foreach ($arr as $key => $value) {
            $id[$key] = $value['id'];
        }
        array_multisort($id, SORT_ASC, $arr); // 返回True or False
        // function 2 E
    ```

#### 问题2
- Q
    * 如何判断上传文件类型,如: 仅允许 jpg 上传
- A
    ```php
        //判断mime类型及文件后缀名
        $allowedExts = array("gif", "jpeg", "jpg", "png"); // 限定可上传的文件后缀名
        $extension = end(explode(".", $_FILES["file"]["name"])); // 从文件名中获取文件后缀      
        // 判断上传文件mime类型是下列之一且大小小于20000B且文件后缀名也符合要求
        if ((($_FILES["file"]["type"] == "image/gif")|| ($_FILES["file"]["type"] == "image/jpeg")|| ($_FILES["file"]["type"] == "image/jpg")|| ($_FILES["file"]["type"] =="image/pjpeg")|| ($_FILES["file"]["type"] == "image/x‐png")|| ($_FILES["file"]["type"] == "image/png"))&& ($_FILES["file"]["size"] < 20000)&& in_array($extension, $allowedExts)) {
            if ($_FILES["file"]["error"] > 0) {
                echo "Return Code: " . $_FILES["file"]["error"] . "<br>";
            } else {
                echo "Upload: " . $_FILES["file"]["name"] . "<br>";
                echo "Type: " . $_FILES["file"]["type"] . "<br>";
                echo "Size: " . ($_FILES["file"]["size"] / 1024) . " kB<br>";
                echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br>"; //临时文件名
                if (file_exists("upload/" . $_FILES["file"]["name"])) { 
                    // 同名文件已存在时提示文件已存在
                    echo $_FILES["file"]["name"] . " already exists. ";
                } else {
                    move_uploaded_file($_FILES["file"]["tmp_name"],"upload/" . $_FILES["file"]["name"]);
                    echo "Stored in: " . "upload/" . $_FILES["file"]["name"];
                }
            }
        } else { 
            // 文件类型或大小不合适时提示无效文件
            echo "Invalid file";
        }
    ```

#### 问题3
- Q
    * 不使用临时变量交换两个变量的值$a=1; $b=2; => $a=2; $b=1;
- A
    ```php
        // 1.字符串截取法: 
        function myExchange(&$a = '', &$b = '') {
            $a = $a . $b;
            $b = substr($a,0,‐strlen($b));
            $a = substr($a,strlen($a)‐strlen($b),strlen($b));
            return true;
        }
        // 2.数组法: 
        private function myExchange(&$a = '', &$b = '') {
            $a = array($a, $b);
            $b = $a[0];
            $a = $a[1];
            return true;
        }
    ```
