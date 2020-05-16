---
title: Interview_总结 (56)
date: 2019-11-18
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 问题1
- Q
    * 不断在文件hello.txt的开头插入hello world
- A
    * eg
        ```php
            // 1. 打开文件
            // 2. 将文件内容读出来 在开头加入hello world
            // 3. 将内容再写进文件中

            $file = "./hello.txt";
            $handle = fopen($file, "r");
            $content = fread($handle, filesize($file));
            $content = "hello world" . $content;
            fclose($handle);

            $handle = fopen()$file, "w");
            fwrite($handle, $content);
            fclose($handle);
        ```

#### 问题2
- Q
    * 遍历目录
- A
    * eg
        ```php
            // 1 打开目录
            // 2 读取目录中的文件
            // 3 如果文件类型是目录 继续打开目录
            // 4 读取子目录的文件
            // 5 如果文件类型是文件 输出文件名称
            // 6 关闭目录   
            $path = "./test";

            function loopDir($path)
            {
                if (is_dir($path)) {
                    $handle = opendir($path);

                    while (false !== ($file = readdir($handle))) {
                        if (($file != ".") && ($file != "..")) {
                            echo $file . "\n";
                            if (is_dir($dir."/".$file)) {
                                loopDir($dir."/".$file);
                            }
                        }
                    }
                } else {
                    return "非文件夹";
                }
            }
            
        ```


