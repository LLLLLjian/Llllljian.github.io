---
title: PHP_基础 (10)
date: 2018-08-10
tags: PHP 
toc: true
---

### 日志类
    封装一个写日志的类

<!-- more -->

#### 示例代码
    ```php
        class Log 
        {
            private $type = 'File';
            // 默认日志大小2Gb
            private $size = 2147483648; 

            private $validTypeArr = ['File'];
            // 日志大小上限2Gb
            private $maxSize = 2147483648;

            private $warningP = 0.95;

            public function __construct() 
            {
                $this->warningLimit = (int)($this->size * $this->warningP);
            }

            public function setSize($value) 
            {
                $value = (int)$value;
                if ($value > $this->maxSize) {
                    throw new Exception("ERROR : Size large more than maxSize");
                } else {
                    $this->size = $value;
                    $this->warningLimit = (int)($this->size * $this->warningP);
                }
            }

            public function getSize() 
            {
                return $this->size;
            }

            public function setType($value) 
            {
                if (in_array($value, $this->validTypeArr)) {
                    $this->type = $value;
                } else {
                    throw new Exception("ERROR : Type is not Valid");
                }
            }

            public function getType() 
            {
                return $this->type;
            }

            public function getValidTypeArr() 
            {
                return $this->validTypeArr;
            }

            public function getMaxSize() 
            {
                return $this->maxSize;
            }

            public function getDate() 
            {
                $date = date("Y-m-d H:i:s");
                return $date;
            }

            /**
             * 转换数组编码
             */
            public function iconv_array($inCharset, $outCharset, $v)
            {
                if (is_array($v)) {
                    // 如果传递的是数组,则进行循环编码转换
                    foreach ($v as $key => $val) {
                        // 对key做转换
                        if (is_string($key)) {
                            $key_tmp=iconv($inCharset, $outCharset, $key);
                        } else {
                            $key_tmp = $key;
                        }

                        $v[$key_tmp] = $this->iconv_array($inCharset, $outCharset, $val);
                        if ($key != $key_tmp) {
                            // 如果编码之后的key和原来的key不一样,则把编码前的key数据删除
                            unset($v[$key]);
                        }
                    }
                } else {
                    // 如果不是数组,就用iconv进行转换
                    if (is_string($v)) {
                        $v = iconv($inCharset, $outCharset, $v);
                    }
                }
                return $v;
            }

            public function getJson($data, $charset = "gbk")
            {
                if (strtolower($charset) != "utf8") {
                    $data = $this->iconv_array($charset, "utf8", $data);
                }
                $json=json_encode($data);
                $json = preg_replace("/(:)\s*null\s*([,\}])/is", '$1""$2', $json);
                return $json;
            }

            /**
             * 处理数据为字符串
             */
            public function handleData($value) 
            {
                if (is_array($value) || is_object($value)) {
                    $value = $this->getJson($value, "gbk");
                }
                return $value;
            }

            /**
             * 处理目录
             */
            public function handleDir($value) 
            {
                $value = str_replace(["\\", "\\\\"], "/", $value);
                $lastPos = strripos($value, "/");
                $dir = substr($value, 0, $lastPos);
                if (!is_dir($dir)) {
                    mkdir($dir, 0777, true);
                }
                return $dir.substr($value, $lastPos);
            }

            /**
             * 日志记录
             * $filename    文件名
             * $data        数据
             * $type        记录类型
             * $append      是否内容追加
             */
            public function write($filename, $data, $type = "Log", $append = true) 
            {
                $date = $this->getDate();
                $filename = $this->handleDir($filename);
                $type = strtoupper($type);
                $data = "[{$date}][{$type}]:".$this->handleData($data).PHP_EOL;
                if (is_file($filename)) {
                    if (filesize($filename) >= $this->warningLimit && filesize($filename) < $this->size) {
                        ($append) ? file_put_contents($filename, $data, FILE_APPEND) : file_put_contents($filename, $data);
                        return "Warning : File close to MaxSize, Last less than 5%";
                    } else if (filesize($filename) >= $this->size) {
                        throw new Exception("Error : File large than MaxSize");
                    } else {
                        ($append) ? file_put_contents($filename, $data, FILE_APPEND) : file_put_contents($filename, $data);
                    }
                } else {
                    ($append) ? file_put_contents($filename, $data, FILE_APPEND) : file_put_contents($filename, $data);
                }
                return true;
            }

            /**
             * 返回单个日志文件的全部日志
             */
            public static function descAll($filename) 
            {
                if (!is_file($filename)) {
                    throw new Exception("ERROR : File is not exist");
                }
                $file = fopen($filename, "r");
                $content = [];
                while (!feof($file)) {
                    $temp = fgets($file);
                    if ($temp == "") continue;
                    $content[] = $temp;
                }
                return $content;
            }

            /**
             * 返回单个日志文件内时间范围内的日志
             */
            public static function descByTime($filename, $start, $end) 
            {
                if (!is_file($filename)) {
                    throw new Exception("ERROR : File is not exist");
                }
                $file = fopen($filename, "r");
                $content = [];
                $start = strtotime($start);
                $end = strtotime($end);
                while (!feof($file)) {
                    $temp = fgets($file);
                    if ($temp == "") continue;
                    $time = strtotime(substr(explode("]", $temp)[0], 1));
                    if ($time >= $start && $time <= $end) {
                        $content[] = $temp;
                    } else {
                        continue;
                    }
                }
                return $content;
            }

            /**
             * 返回单个日志文件内时间范围内的指定类型的日志
             */
            public static function descByTimeAndType($filename, $start, $end, $type)
            {
                if (!is_file($filename)) {
                    throw new Exception("ERROR : File is not exist");
                }
                $file = fopen($filename, "r");
                $content = [];
                $start = strtotime($start);
                $end = strtotime($end);
                $type = strtoupper($type);
                while (!feof($file)) {
                    $temp = fgets($file);
                    if ($temp == "") continue;
                    $tempArr = explode("]", $temp);
                    $time = strtotime(substr($tempArr[0], 1));
                    $tempType = substr($tempArr[1], 1);
                    if ($time >= $start && $time <= $end && $type == $tempType) {
                        $content[] = $temp;
                    } else {
                        continue;
                    }
                }
                return $content;
            }
        }
    ```
