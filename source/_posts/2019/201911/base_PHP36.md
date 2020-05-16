---
title: PHP_基础 (36)
date: 2019-11-11
tags: PHP 
toc: true
---

### 输入输出处理静态类
    之前系统中处理接口获取参数的时候, 方法比较原始, 用的都是post传输+token加密的方式, 每个人写的自己的, 优化一下, 写一个统一的接口类处理参数. 

<!-- more -->

#### 代码实例
    ```php
        class Io
        {
	        protected static $error_log = 1;	//是否记录技术故障报错日志
	        public static $input_filter_log = 1;	//是否记录输入参数因过滤发生变化的日志

            /*
             * 直接输出显示结果信息$msg并结束程序
             * $msg 要输出的信息
             * $headers header头字符串或各行数组
             * $is_error代表是否发现技术故障（1为是，0为否）
             */
            public static function result_exit_raw($msg = '', $headers = '', $is_error = 0)
            {
                if ($headers) {
                    if (is_string($headers)) {
                        header($headers);
                    } elseif (is_array($headers)) {
                        foreach($headers as $header)
                        {
                            header($header);
                        }
                    }
                }
                echo $msg;
                if ($is_error && self::$error_log) {
                    @self::save_error_log($msg);
                }
                exit;
            }

            /*
             * 输出显示json格式结果信息并结束程序
             * $code为返回码
             * $msg为提示消息
             * $data为除resource之外类型的数据
             * $json_options为json_encode选项
             * $json_error_code为json报错时的返回码
             * $is_error代表是否发现技术故障（1为是，0为否）
             */
            public static function result_exit_json($code = 0, $msg = '', $data = '', $json_options = '', $json_error_code = '', $is_error = 0)
            {
                header("Content-Type: application/json; charset=utf-8");
                $temp = array('code' => intval($code), 'msg' => strval($msg), 'data' => $data);
                $temp_encode = ($json_options === '') ? json_encode($temp) : json_encode($temp, $json_options);
                if ($temp_encode === false) {
                    $json_error_code = ($json_error_code === '') ? -100 : intval($json_error_code);
                    $result = json_encode(array('code' => $json_error_code, 'msg' => '技术故障：json编码失败，' . json_last_error_msg(), 'data' => ''));
                    $is_error = 1;
                } else {
                    $result = $temp_encode;
                }
                echo $result;
                if ($is_error && self::$error_log) {
                    @self::save_error_log($result);
                }
                exit;
            }

            /*
             * 输出显示xml格式结果信息并结束程序
             * code 返回码
             * msg 提示消息
             * data 除resource之外类型的数据
             * $xml_encoding为xml编码格式，默认utf-8
             * $is_error代表是否发现技术故障（1为是，0为否）
             */ 
            public static function result_exit_xml($code = 0, $msg = '', $data = '', $xml_encoding = '', $is_error = 0)
            {
                header("Content-Type: application/xml");
                $result = self::xml_encode(array('code' => intval($code), 'msg' => strval($msg), 'data' => $data), $xml_encoding ? $xml_encoding : 'utf-8');
                echo $result;
                if ($is_error && self::$error_log) {
                    @self::save_error_log($result);
                }
                exit;
            }

            //数据$data转为完整的XML码，XML数据编码为$encoding（默认utf-8），XML根节点名$root
            public static function xml_encode($data, $encoding = '', $root = 'root')
            {
                $xml = '<?xml version="1.0" encoding="' . ($encoding ? $encoding : 'utf-8') . '"?>';
                $xml .= '<' . $root . '>';
                $xml .= self::data_to_xml($data);
                $xml .= '</' . $root . '>';
                return $xml;
            }

            //数据$data转为XML格式
            
            public static function data_to_xml($data)
            {
                $xml = '';
                foreach ($data as $key => $val) {
                    is_numeric($key) && $key = "item id=\"$key\"";
                    $xml .= "<$key>";
                    $xml .= (is_array($val) || is_object($val)) ? self::data_to_xml($val) : $val;
                    list($key, ) = explode(' ', $key);
                    $xml .= "</$key>";
                }
                return $xml;
            }

            /* 输出接口返回结果并结束程序【待弃用，目前用这个方法的要换成之后定义的专门格式的方法】
             * string	$format 输出格式：raw/json/xml（默认raw代表仅直接原生输出显示$msg；json代表json数组array('code' => 返回码, 'msg' => '返回消息', 'data' => 返回数据）；xml代表xml格式（根目录标签 为root），标签同json数组下标
             * int	$is_error 是否发现技术故障，1是，0否
             * mixed	$msg 返回消息（json/xml仅限字符串，raw格式不限）
             * mixed	$data 返回resource类型之外任何类型的数据；对于json格式，所有字符串的编码必须是UTF-8；仅json/xml格式用
             * int	$code 返回码（输出格式不是raw时有效），仅json/xml格式用
             * array $options 其它选项设置数组，支持的数组下标：
             *	(string/array) headers header头字符串或各行数组，仅raw格式用
             *	(int) json_options json_encode的常量选项，例如JSON_UNESCAPED_UNICODE等等，仅json格式用
             *	(int) json_error_code	json_encode报错时的返回码，仅json格式用
             *	(string) xml_encoding xml编码，默认utf-8，仅xml格式用
             */
            public static function result_exit($format = 'raw', $is_error = 0, $msg = '', $data = '', $code = 0, $options = array())
            {
                switch ($format) {
                    default:
                    case 'raw':
                        $headers = isset($options['headers']) ? $options['headers'] : '';
                        self::result_exit_raw($msg, $headers, $is_error);
                    case 'json':
                        $json_options = isset($options['json_options']) ? $options['json_options'] : '';
                        $json_error_code = isset($options['json_error_code']) ? $options['json_error_code'] : -100;
                        self::result_exit_json($code, $msg, $data, $json_options, $json_error_code, $is_error);
                    case 'xml':
                        $xml_encoding = isset($options['xml_encoding']) ? $options['xml_encoding'] : 'utf-8';
                        self::result_exit_xml($code, $msg, $data, $xml_encoding, $is_error);
                }
            }

            //获取全部输入参数的过滤掉特殊字符（预防SQL注入）的数值，$method为输入参数请求方式get/post/cookie/request
            public static function get_req_value_all($method = 'all')	
            {
                $result = array();
                switch ($method) {
                    case 'get':
                        $input = isset($_GET) ? $_GET : array();
                        break;
                    case 'post':
                        $input = isset($_POST) ? $_POST : array();
                        break;
                    case 'cookie':
                        $input = isset($_COOKIE) ? $_COOKIE : array();
                        break;
                    case 'input':
                        if ($temp = @file_get_contents('php://input')) {
                            if (self::is_json($temp) && $temp_decode = json_decode($temp, true)) {
                                $input = $temp_decode;
                            } elseif ($temp_decode = self::xml_decode($temp)) {
                                $input = $temp_decode;
                            } else {
                                $input = array();
                            }
                        } else {
                            $input = array();
                        }
                        break;
                    case 'request':
                        $input = isset($_REQUEST) ? $_REQUEST : array();
                        break;
                    default:
                    case 'all':
                        $input = isset($_REQUEST) ? $_REQUEST : array();
                        if ($temp = @file_get_contents('php://input')) {
                            if (self::is_json($temp) && $temp_decode = json_decode($temp, true)) {
                                $input = array_merge($input, $temp_decode);
                            } elseif ($temp_decode = self::xml_decode($temp)) {
                                $input = array_merge($input, $temp_decode);
                            }
                        }
                        break;
                }
                foreach ($input as $k => $v) {
                    $result[$k] = self::filter_req_value($v);
                }
                return $result;
            }

	        //获取输入参数名为$value_name的过滤掉特殊字符（预防SQL注入）的数值，$value_name为输入参数名，$method为输入参数请求方式get/post/cookie/request，$default为输入参数不存在时的默认返回值
            public static function get_req_value($var_name, $method = 'all', $default = '')
            {
                switch ($method) {
                    case 'get':
                        $input = isset($_GET[$var_name]) ? $_GET[$var_name] : $default;
                        break;
                    case 'post':
                        $input = isset($_POST[$var_name]) ? $_POST[$var_name] : $default;
                        break;
                    case 'cookie':
                        $input = isset($_COOKIE[$var_name]) ? $_COOKIE[$var_name] : $default;
                        break;
                    case 'request':
                        $input = isset($_REQUEST[$var_name]) ? $_REQUEST[$var_name] : $default;
                        break;
                    case 'input':
                        if ($temp = @file_get_contents('php://input')) {
                            if (self::is_json($temp) && $temp_decode = json_decode($temp, true)){
                                $input = isset($temp_decode[$var_name]) ? $temp_decode[$var_name] : $default;
                            } elseif ($temp_decode = self::xml_decode($temp)) {
                                $input = isset($temp_decode[$var_name]) ? $temp_decode[$var_name] : $default;
                            } else {
                                $input = $default;
                            }
                        } else {
                            $input = $default;
                        }
                        break;
                    default:
                    case 'all':
                        if (isset($_REQUEST[$var_name])) {
                            $input = $_REQUEST[$var_name];
                        } elseif ($temp = @file_get_contents('php://input')) {
                            if (self::is_json($temp) && $temp_decode = json_decode($temp, true)) {
                                $input = isset($temp_decode[$var_name]) ? $temp_decode[$var_name] : $default;
                            } elseif ($temp_decode = self::xml_decode($temp)) {
                                $input = isset($temp_decode[$var_name]) ? $temp_decode[$var_name] : $default;
                            } else {
                                $input = $default;
                            }
                        } else {
                            $input = $default;
                        }
                        break;
                }
                $result = self::filter_req_value($input);
                return $result;
            }

            //过滤请求参数$input，返回过滤结果
            public static function filter_req_value($input)
            {
                if (is_array($input)) {
                    $result = array();
                    $filtered = false;
                    foreach ($input as $key => $val) {
                        if (is_int($val) || is_float($val)) {
                            $result[$key] = $val;
                        } else {
                            $result[$key] = trim(addslashes(self::content_filter($val)));
                            if (self::$input_filter_log && strcmp($result[$key], $val) !== 0) {
                                @self::save_input_filter_log($key, $val, $result[$key]);
                            }
                        }
                    }
                } else {
                    if (is_null($input)) {
                        $result = $input;
                    } elseif (is_int($input) || is_float($input)) {
                        $result = $input;
                    } else {
                        $result = trim(addslashes(self::content_filter($input)));
                        if (self::$input_filter_log && strcmp($result, $input) !== 0) {
                            @self::save_input_filter_log($var_name, $input, $result);
                        }
                    }
                }
                return $result;
            }

            //调试模式输出显示变量值$message，当URL参数$debug_var_name等于$debug_var_value或者$debug_var_value为空字符串时，输出显示$message，如果此时URL还含有名为$exit_var_name的参数，则程序中断
            public static function debug_echo($message, $debug_var_name = 'debug_echo', $debug_var_value = '', $exit_var_name = 'debug_echo_exit')
            {
                $var = self::get_req_value($debug_var_name, 'request', null);
                if (!is_null($var) && ($debug_var_value === '' || $var === $debug_var_value)) {
                    echo $message;
                    if (self::get_req_value($exit_var_name, 'request', null) !== null) {
                        exit;
                    }
                }
            }

            //对字符串$str进行内容过滤
            public static function content_filter($str)
            {
                $str = trim($str);
                if (!is_numeric($str) && $str !== '') {
                    $str = preg_replace('/[\a\f\e\0\t\x0B]/is', '', $str );
                    $str = htmlspecialchars($str, ENT_QUOTES);
                    $str = self::tag_filter($str);
                    $str = self::common_filter($str);
                    $str = self::line_filter($str);
                }
                return $str;
            }

            //标签过滤
            protected static function tag_filter($str)
            {
                $str = preg_replace("/javascript/i" , "j&#097;v&#097;script", $str);
                $str = preg_replace("/alert/i"      , "&#097;lert"          , $str);
                $str = preg_replace("/about:/i"     , "&#097;bout:"         , $str);
                $str = preg_replace("/onmouseover/i", "&#111;nmouseover"    , $str);
                $str = preg_replace("/onclick/i"    , "&#111;nclick"        , $str);
                $str = preg_replace("/onload/i"     , "&#111;nload"         , $str);
                $str = preg_replace("/onsubmit/i"   , "&#111;nsubmit"       , $str);
                $str = preg_replace("/<script/i"	 , "&#60;script"		 , $str);
                $str = preg_replace("/document\./i" , "&#100;ocument."      , $str);
                return $str;
            }

            //通用过滤
            protected static function common_filter($str)
            {
                $str = str_replace("&#032;", ' ', $str);
                $str = preg_replace("/\\\$/", "&#036;", $str);
                return $str;
            }

            //换行符过滤
            protected static function line_filter($str)
            {
                return strtr($str, array("\r" => '', "\n" => '<br />'));
            }

            //保存输入参数过滤日志
            protected static function save_input_filter_log($var_name, $input_raw, $input_filtered)
            {
                is_dir(IO_LOG_PATH) or mkdir(IO_LOG_PATH);
                $filepath = IO_LOG_PATH . 'inner_api_input_var_filtered_' . date('Y-m-d') . '.log';
                $content = $_SERVER['PHP_SELF'] . ', name: ' . $var_name . ', raw: ' . var_export($input_raw, true) . ', filtered: ' . var_export($input_filtered, true);
                $result = self::save_log($filepath, $content);
                return $result;
            }

            //保存报错日志
            protected static function save_error_log($message)
            {
                is_dir(IO_ERROR_PATH) or mkdir(IO_ERROR_PATH);
                $filepath = IO_ERROR_PATH . 'inner_api_error_' . date('Y-m-d') . '.log';
                $content = $_SERVER['PHP_SELF'] . ', ' . var_export($message, true);
                $result = self::save_log($filepath, $content);
                return $result;
            }

            //保存日志
            protected static function save_log($filepath, $content)
            {
                if ($fp = fopen($filepath, 'a')) {
                    $line = date('Y-m-d H:i:s') . ', ' . $content . "\n";
                    if (strlen($line) <= 4096) {
                        $result = fwrite($fp, $line);	//不超4K不需加flock
                    } else {
                        flock($fp, LOCK_EX);
                        $result = fwrite($fp, $line);
                        flock($fp, LOCK_UN);
                    }
                    fclose($fp);
                } else {
                    $result = false;
                }
                return $result;
            }

            //判断字符串是否是json格式
            public static function is_json($string)
            {
                return (is_string($string) && preg_match('/[^,:{}\\[\\]0-9.\-+Eaeflnr-u \n\r\t]/', $string)) ? true : false;
            }

            //将XML格式字符串$str解析为数组格式，失败则返回false
            public static function xml_decode($xml_str)
            {
                $xml_parser = xml_parser_create(); 
                $result = xml_parse($xml_parser, $xml_str, true) ? self::object_to_array(simplexml_load_string($xml_str)) : false;
                xml_parser_free($xml_parser);
                unset($xml_parser);
                return $result;
            }

            //标准类对象$object转数组
            public static function object_to_array($object)
            {
                $_array = is_object($object) ? get_object_vars($object) : $object;
                foreach ($_array as $key => $value) {
                    $value = (is_array($value) || is_object($value)) ? self::object_to_array($value) : $value;
                    $array[$key] = $value;
                }
                return $array;
            }
        }

        常用示例：
        $msg = Io::get_req_value('msg');
        $para = Io::get_req_value_all();
        Io::debug_echo($msg);
        Io::result_exit_raw($msg, $headers, $is_error);
        Io::result_exit_json($code, $msg, $data, $json_options, $json_error_code, $is_error);
        Io::result_exit_xml($code, $msg, $data, $xml_encoding, $is_error);
    ```


