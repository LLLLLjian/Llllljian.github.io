---
title: PHP_基础 (4)
date: 2017-12-25
tags: PHP
toc: true
---

## 页面跳转

### PHP
    header('Loacation: url')
    header()执行完毕后,后面的代码也会继续执行,故需在该语句后加die结束
    无法给出提示,直接跳转

### JS方法
    location.href = url

### HTML
    <meta http-equiv="Refresh" content="表示时间的数值; url=要跳转的URI"> 

<!-- more -->

## 函数

### 字符串函数
    addslashes($str)    //使用反斜线转移字符串
    stripcslashes($str) //反引用一个使用addcslashes转义的字符串
    stripslashes($str)  //反引用一个引用字符串
    chr($ascii) //返回ASCII码的字符
    ord($char)  //返回字符的ASCII码
    substr_count($haystack, $needle)    //计算子串出现的次数
    count_chars($str [,$mode])  统计每个字节值出现的次数
        //0 - 以所有的每个字节值作为键名,出现次数作为值的数组.  
        //1 - 与0相同,但只列出出现次数大于零的字节值.  
        //2 - 与0相同,但只列出出现次数等于零的字节值.  
        //3 - 返回由所有使用了的字节值组成的字符串.  
        //4 - 返回由所有未使用的字节值组成的字符串. 
    crypt($str, [$salt])    //单向字符串散列
    str_split($str [,$len]) //将字符串按长度分割为数组
    explode($separ, $str)   //使用一个字符串分割另一个字符串
    implode([$glue,] $arr)  //将数组元素的值根据$glue连接成字符串
    chunk_split($str [,$len [,$end]])   //将字符串分割成小块
        $len：每段字符串的长度,$end：每段字符串末尾加的字符串(如"\r\n")
    html_entity_decode($str [,$flags [,$encoding]]) //将HTML实体转成字符信息
    htmlentities($str [,$flags [,$encoding]])   //将字符信息转成HTML实体
    htmlspecialchars_decode($str)   //将特殊HTML实体转成字符信息
    htmlspecialchars($str [,$flags [,$encoding]])   //将字符信息转成特殊HTML实体
    lcfirst($str)   //将字符串首字母转成小写
    ucfirst($str)   //将字符串首字母转成大写
    ucwords($str)   //将字符串中每个单词的首字母转换为大写
    strtolower($str)    //将字符串转化为小写
    strtoupper($str)    //将字符串转化为大写
    trim($str [,$charlist]) //去除字符串首尾处的空白字符(或者其他字符）
    ltrim($str [,$charlist])    //去除字符串首段的空白字符(或者其他字符）
    rtrim($str [,$charlist])    //去除字符串末端的空白字符(或者其他字符）
    md5_file($file) //计算指定文件的MD5散列值
    md5($str)   //计算字符串的MD5散列值
    money_format($format, $num) //将数字格式化为货币形式
    number_format($num) //格式化数字
    nl2br($str) //在字符串所有新行之前插入HTML换行标记<br />
    parse_str($str, [$arr]) //解析字符串
    print($str) //输出字符串
    printf      //输出格式化字符串
    sprintf($format [,$args...])    //格式化字符串
    sha1_file   //计算文件的sha1散列值
    sha1        //计算字符串的sha1散列值
    similar_text($first, $second [,$percent])   //计算两个字符串的相似度
        返回在两个字符串中匹配字符的数目,$percent存储相似度百分比
    str_replace($search, $replace, $str [,$count [,$type]])  //子字符串替换
    str_ireplace    //字符串替换(忽略大小写)
    str_pad($str, $len [,$pad [,$type]])  //使用另一个字符串填充字符串为指定长度
        $type：在何处填充.STR_PAD_RIGHT,STR_PAD_LEFT 或 STR_PAD_BOTH
    str_repeat($str, $num)  //重复一个字符串
    str_shuffle($str)   //随机打乱一个字符串
    str_word_count($str [,$format [,$charlist]])    //返回字符串中单词的使用情况
    strcasecmp($str1, $str2)    //二进制安全比较字符串(不区分大小写）
        如果str1小于str2,返回负数；如果str1大于str2,返回正数；二者相等则返回0.
    strcmp($str1, $str2)    //二进制安全字符串比较
    strcoll($str1, $str1)   //基于区域设置的字符串比较(区分大小写,非二进制安全)
    strcspn($str1, $str1 [,$start [,$len]])   //获取不匹配遮罩的起始子字符串的长度
    strip_tags($str)    //从字符串中去除HTML和PHP标记
    strpos($haystack, $needle [,$offset])   //查找字符串首次出现的位置
    stripos($haystack, $needle [,$offset])    //查找字符串首次出现的位置(不区分大小写）
    strripos($haystack, $needle [,$offset])   //计算指定字符串在目标字符串中最后一次出现的位置(不区分大小写）
    strrpos($haystack, $needle [,$offset])   //计算指定字符串在目标字符串中最后一次出现的位置
    strlen($str)    //获取字符串长度
    strpbrk($haystack, $str)    //在字符串中查找一组字符的任何一个字符
    strrev($str)    //反转字符串
        join('', array_reverse(preg_split("//u", $str))); //实现对UTF-8字符串的反转
    strspn$subject, $mask)  //计算字符串中全部字符都存在于指定字符集合中的第一段子串的长度.
    strstr($haystack, $needle)   //查找字符串的首次出现
    stristr($haystack, $needle)   //查找字符串的首次出现(不区分大小写)
    strrchr($haystack, $needle) //查找指定字符在字符串中的最后一次出现
    strtok($str, $token)    //标记分割字符串
    substr_compare($main_str, $str, $offset [,$len) //二进制安全比较字符串(从偏移位置比较指定长度）
    substr_replace$str, $replace, $start [,$len]    //替换字符串的子串
    strtr($str, $from, $to) //转换指定字符
    substr($str, $start [,$len])    //返回字符串的子串
    vfprintf$handle, $format, $args)    //将格式化字符串写入流
    vprintf($format, $args) //输出格式化字符串
    vsprintf($format, $args) //返回格式化字符串
    wordwrap($str [,$width=75 [,$break='\n']])  //打断字符串为指定数量的字串

    crc32($str) //计算一个字符串的crc32多项式
        crc32算法[循环冗余校验算法]
        生成str的32位循环冗余校验码多项式.将数据转换成整数.

    /* mbstring(多字节字符串) */
    //需开启mbstring扩展
    mb_strimwidth($str, $start, $width [,$trim [,$encoding]])   //保留指定的子串(并补充)
    mb_stripos($str, $needle [,$offset [,$encoding]])   //查找子串首次出现的位置(忽略大小写)
    mb_strpos($str, $needle [,$offset [,$encoding]])   //查找子串首次出现的位置
    mb_strripos($str, $needle [,$offset [,$encoding]])   //查找子串最后一次出现的位置(忽略大小写)
    mb_strrpos($str, $needle [,$offset [,$encoding]])   //查找子串最后一次出现的位置
    mb_strstr($str, $needle [,$before [,$encoding]])    //返回子串首次出现位置之后(前)的字符串
    mb_stristr($str, $needle [,$before [,$encoding]])    //返回子串首次出现位置之后(前)的字符串(忽略大小写)
    mb_strrchr($str, $needle [,$before [,$encoding]])    //返回字符最后一次出现位置之后(前)的字符串
    mb_strrichr($str, $needle [,$before [,$encoding]])    //返回字符最后一次出现位置之后(前)的字符串(忽略大小写)

    mb_strtoupper($str [,$encoding])    //转换成大写
    mb_strtolower($str [,$encoding])    //转换成小写

    mb_strlen($str [,$encoding])    //获取字符串长度
    mb_split($pattern, $str [,$limit])  //将字符串分割成数组
    mb_substr($str, $start [,$len [,$encoding]])    //获取字符串的子串
    mb_strcut($str, $start [,$len [,$encoding]])    //获取字符串的子串
    mb_strwidth($str [,$encoding])  //获取字符串的宽度
    mb_substr_count($str, $needle [,$encoding]) //子串在字符串中出现的次数

### PCRE函数
    preg_filter($pattern, $replace, $subject [,$limit [,&$count]])  执行一个正则表达式搜索和替换
    preg_replace($pattern, $replace, $subject [,$limit [,&$count]])  执行一个正则表达式搜索和替换
    preg_replace_callback($pattern, $callback, $subject [,$limit [,&$count]])   执行一个正则表达式搜索并且使用一个回调进行替换
    preg_grep($pattern, $input [,$flags])   返回匹配模式的数组条目
    preg_match($pattern, $subject [,&$matches [,$flags [,$offset]]]) 执行一个正则表达式匹配
    preg_match_all($pattern, $subject [,&$matches [,$flags [,$offset]]]) 执行一个全局正则表达式匹配
        $matches存放返回的结果
            $matches[0][n] (n>=0) 表示存放第n+1个匹配到的结果
            $matches[m][n] (m>=1, n>=0) 表示存放第n+1个匹配到结果的第m个表达式的内容
    preg_split($pattern, $subject [,$limit [,$flags]])  通过一个正则表达式分隔字符串
        $limit表示限制分隔得到的子串最多只有limit个,-1表示不限制
        $flags参数：
            PREG_SPLIT_NO_EMPTY：将返回分隔后的非空部分
            PREG_SPLIT_DELIM_CAPTURE：用于分隔的模式中的括号表达式将被捕获并返回
            PREG_SPLIT_OFFSET_CAPTURE：对于每一个出现的匹配返回时将会附加字符串偏移量
    preg_quote($str [,$delimiter])  转义正则表达式字符
    preg_last_error()   返回最后一个PCRE正则执行产生的错误代码

### Math函数
    base_convert($number, $frombase, $tobase)   //在任意进制之间转换数字
    ceil($float)    //向上取整
    floor($float)   //向下取整
    exp($float) //计算e的指数
    hypot($x, $y)   //计算直角三角形的斜边长
    is_nan($val)    //判断是否为合法数值
    log($arg [,$base=e])  //自然对数
    max($num1, $num2, ...)  //找出最大值
        max($arr)   //找出数组中的最大值
    min($num1, $num2, ...)  //找出最小值
    rand([$min], $max)  //产生一个随机整数
    srand([$seed])  //播下随机数发生器种子
    mt_rand([$min], $max)   //生成更好的随机数
    mt_srand($seed)     //播下一个更好的随机数发生器种子
    pi()    //得到圆周率值
    pow($base, $exp)    //指数表达式
    sqrt($float)    //求平方根
    deg2rad($float) //将角度转换为弧度
    rad2deg($float) //将弧度数转换为相应的角度数
    round($val [,$pre=0]) //对浮点数进行四舍五入
    fmod($x, $y) //返回除法的浮点数余数

### MySQL函数
    mysql_client_encoding([$link])  //返回字符集的名称
    mysql_set_charset($charset [,$link])    //设置客户端字符集编码
    mysql_connect($host, $user, $pass)  //打开一个到MySQL服务器的连接
    mysql_create_db($db [,$link])   //新建一个MySQL数据库
    mysql_pconnect($host, $user, $pass) //打开一个到MySQL服务器的持久连接
    mysql_ping([$link]) //Ping一个服务器连接,如果没有连接则重新连接
    mysql_close([$link])    //关闭MySQL连接

    mysql_data_seek($result, $row)  //移动内部结果的指针
    mysql_errno([$link])    //返回上一个MySQL操作中的错误信息的数字编码
    mysql_error([$link])    //返回上一个MySQL操作产生的文本错误信息
    mysql_affected_rows([$link])  //取得前一次MySQL操作所影响的记录行数
    mysql_info([$link]) //取得最近一条查询的信息
    mysql_insert_id([$link])    //取得上一步INSERT操作产生的ID

    mysql_query($sql [,$link])  //发送一条MySQL查询
    mysql_unbuffered_query($sql [,$link])   //向MySQL发送一条SQL查询,并不获取和缓存结果的行
    mysql_db_query($db, $sql [,$link])  //发送一条MySQL查询

    mysql_escape_string($str)   //转义一个字符串用于mysql_query
    mysql_real_escape_string($str)  //转义SQL语句中使用的字符串中的特殊字符,并考虑到连接的当前字符集

    mysql_fetch_array($result [,$type]) //从结果集中取得一行作为关联数组,或数字数组,或二者兼有
    mysql_fetch_assoc($result)  //从结果集中取得一行作为关联数组
    mysql_fetch_object($result) //从结果集中取得一行作为对象
    mysql_fetch_row($result)    //从结果集中取得一行作为枚举数组
    mysql_fetch_field($result)  //从结果集中取得列信息并作为对象返回
    mysql_num_fields($result)   //取得结果集中字段的数目
    mysql_num_rows($result) //取得结果集中行的数目

    mysql_fetch_lengths($result)    //取得结果集中每个输出的长度
    mysql_field_flags($result, $field_offset)    //从结果中取得和指定字段关联的标志
    mysql_field_len($result, $field_offset)    //返回指定字段的长度
    mysql_field_name($result, $field_offset)    //取得结果中指定字段的字段名
    mysql_field_seek($result, $field_offset)    //将结果集中的指针设定为制定的字段偏移量
    mysql_field_table($result, $field_offset)   //取得指定字段所在的表名
    mysql_field_type($result, $field_offset)    //取得结果集中指定字段的类型
    mysql_free_result($result)  //释放结果内存

    mysql_list_dbs([$link]) //列出MySQL服务器中所有的数据库
    mysql_list_fields($db, $table [,$link]) //列出MySQL结果中的字段
    mysql_list_processes([$link])   //列出MySQL进程
    mysql_list_tables($db [,$link]) //列出MySQL数据库中的表

    mysql_result($result, $row [$field])    //取得结果数据
    mysql_select_db($db [,$link])   //选择MySQL数据库
    mysql_tablename($result, $i)    //取得表名
    mysql_db_name($result, $row [,$field])  //取得mysql_list_dbs()调用所返回的数据库名

    mysql_stat([$link]) //取得当前系统状态
    mysql_thread_id([$link])    //返回当前线程的ID
    mysql_get_client_info() //取得MySQL客户端信息
    mysql_get_host_info()   //取得MySQL主机信息
    mysql_get_proto_info()  //取得MySQL协议信息
    mysql_get_server_info() //取得MySQL服务器信息

### 数组函数
    count        计算数组中的单元数目或对象中的属性个数
    array_count_values  统计数组中所有的值出现的次数
    array_product       计算数组中所有值的乘积
    array_sum           计算数组中所有值的和
    range        建立一个包含指定范围单元的数组

    //获取数组内容
    array_chunk        将一个数组分割成多个
        array array_chunk(array $input, int $size[, bool $preserve_keys]) 
    array_filter    用回调函数过滤数组中的单元
    array_slice     从数组中取出一段
        array array_slice($arr, $offset [,$len [,$preserve_keys]])
    array_keys        返回数组中所有的键名
        array array_keys(array $input[, mixed $search_value[, bool $strict]] )
        如果指定了可选参数 search_value,则只返回该值的键名.否则input数组中的所有键名都会被返回.
    array_values    返回数组中所有的值,并建立数字索引

    array_merge        合并一个或多个数组
        一个数组中的值附加在前一个数组的后面.
        如果输入的数组中有相同的字符串键名,则该键名后面的值将覆盖前一个值.
        如果数组包含数字键名,后面的值将不会覆盖原来的值,而是附加到后面.
        如果只给了一个数组并且该数组是数字索引的,则键名会以连续方式重新索引. 
    array_merge_recursive    递归地合并一个或多个数组
    array_column 获取二维数组指定的某一项,array_column($array, $value, $key);

    //搜索
    in_array            检查数组中是否存在某个值
        bool in_array(mixed $needle, array $haystack[, bool $strict])
    array_key_exists    检查给定的键名或索引是否存在于数组中
        isset()对于数组中为NULL的值不会返回TRUE,而 array_key_exists()会
    array_search        在数组中搜索给定的值,如果成功则返回相应的键名

    array_combine    创建一个数组,用一个数组的值作为其键名,另一个数组的值作为其值
        如果两个数组的单元数不同或者数组为空时返回FALSE.
    array_rand        从数组中随机取出一个或多个单元,返回键名或键名组成的数组,下标是自然排序的
    array_fill      用给定的值填充数组
        array_fill($start, $num, $value)
    array_flip      交换数组中的键和值
    array_pad       用值将数组填补到指定长度
    array_reverse   返回一个单元顺序相反的数组
    array_unique    移除数组中重复的值
    array_splice    把数组中的一部分去掉并用其它值取代

    implode            将数组元素值用某个字符串连接成字符串
    explode($delimiter, $str [,$limit])    //使用一个字符串分割另一个字符串
        $delimiter不能为空字符串""

    array_map        将回调函数作用到给定数组的单元上,只能处理元素值,可以处理多个数组
        如果callback参数设为null,则合并多个数组为一个多维数组
    array_walk        对数组中的每个成员应用用户函数,只能处理一个数组,键和值均可处理,与foreach功能相同
        bool array_walk ( array &$array , callback $funcname [, mixed $userdata ] )

    //栈：后进先出
    入栈和出栈会重新分配索引下标
    array_push        将一个或多个单元压入数组的末尾(入栈）
    array_pop        将数组最后一个单元弹出(出栈）        使用此函数后会重置(reset())array 指针.

    //队列：先进先出
    队列函数会重新分配索引下标
    array_unshift    在数组开头插入一个或多个单元
    array_shift        将数组开头的单元移出数组            使用此函数后会重置(reset())array 指针.

    //排序函数
    sort            对数组排序
    rsort            对数组逆向排序
    asort            对数组进行排序并保持索引关系
    arsort            对数组进行逆向排序并保持索引关系
    ksort            对数组按照键名排序
    krsort            对数组按照键名逆向排序
    usort            使用用户自定义的比较函数对数组中的值进行排序
    uksort            使用用户自定义的比较函数对数组中的键名进行排序
    uasort            使用用户自定义的比较函数对数组中的值进行排序并保持索引关联
    natsort            用用“自然排序”算法对数组排序
    natcasesort        用“自然排序”算法对数组进行不区分大小写字母的排序
    array_multisort 对多个数组或多维数组进行排序
    shuffle            将数组打乱
        引用传递参数,返回bool值.
        重新赋予索引键名,删除原有键名

    //差集
    array_udiff_assoc   带索引检查计算数组的差集,用回调函数比较数据
    array_udiff_uassoc  带索引检查计算数组的差集,用回调函数比较数据和索引
    array_udiff         用回调函数比较数据来计算数组的差集
    array_diff_assoc    带索引检查计算数组的差集
    array_diff_key      使用键名比较计算数组的差集
    array_diff_uassoc   用用户提供的回调函数做索引检查来计算数组的差集
    array_diff_ukey     用回调函数对键名比较计算数组的差集
    array_diff          计算数组的差集
    //交集
    array_intersect_assoc 带索引检查计算数组的交集
    array_intersect_key 使用键名比较计算数组的交集
    array_intersect_uassoc 带索引检查计算数组的交集,用回调函数比较索引
    array_intersect_ukey 用回调函数比较键名来计算数组的交集
    array_intersect 计算数组的交集
    array_key_exists 用回调函数比较键名来计算数组的交集
    array_uintersect_assoc 带索引检查计算数组的交集,用回调函数比较数据
    array_uintersect 计算数组的交集,用回调函数比较数据

    extract($arr [,$type [,$prefix]])   从数组中将变量导入到当前的符号表(接受结合数组$arr作为参数并将键名当作变量名,值作为变量的值)
    compact($var [,...])   建立一个数组,包括变量名和它们的值(变量名成为键名而变量的内容成为该键的值)

### 进制转换函数
    hexdec()    十六进制转十进制       也可写hex2dec()
    dechex()    十进制转十六进制       也可写dec2hex()
    bindec()    二进制转十进制        也可写bin2dec()
    decbin()    十进制转二进制        也可写dex2bin()
    octdec()    八进制转十进制        也可写oct2dec()
    decoct()    十进制转八进制        也可写dec2oct()

### 类型操作函数
    //获取/设置类型
    gettype($var) //获取变量的数据类型
    settype($var, $type) //设置变量的数据类型

    //类型判断
    is_int
    is_float
    is_null
    is_string
    is_resource
    is_array
    is_bool
    is_object       
    is_numeric      检测变量是否为数字或数字字符串

    //转换成指定的数据类型
    boolval
    floatval
    intval
    strval

    //强制转换类型
    (int)
    (float)
    (string)
    (bool)
    (array)
    (object)
    (unset) //转换为NULL
    (binary) 转换和 b前缀转换  //转换成二进制

    var_dump        打印变量的相关信息.
                    显示关于一个或多个表达式的结构信息,包括表达式的类型与值.
                    数组将递归展开值,通过缩进显示其结构.
    var_export($var [,bool $return]) //输出或返回一个变量的字符串表示
        $return：为true,则返回变量执行后的结果
    print_r         打印关于变量的易于理解的信息
    empty           检查一个变量是否为空
    isset           检测变量是否存在

### 时间函数
    date($format [,$timestamp]) //格式化一个本地时间／日期,$timestamp默认为time()
    Y：4位数字完整表示的年份
    m：数字表示的月份,有前导零
    d：月份中的第几天,有前导零的2位数字
    j：月份中的第几天,没有前导零
    H：小时,24小时格式,有前导零
    h：小时,12小时格式,有前导零
    i：有前导零的分钟数
    s：秒数,有前导零
    L：是否为闰年,如果是闰年为1,否则为0
    M：三个字母缩写表示的月份,Jan到Dec
    W：年份中的第几周,每周从星期一开始
    z：年份中的第几天
    N：数字表示的星期中的第几天
    w：星期中的第几天,数字表示
    e：时区标识
    T：本机所在的时区
    U：从Unix纪元开始至今的秒数(时间戳)
    time() //返回当前的Unix时间戳(秒)
    strtotime($time [,$now]) //将任何英文文本的日期时间描述解析为Unix时间戳
        date("Y-m-d H:i:s", strtotime("-1 day")); //格式化前一天的时间戳
        "now"
        "10 September 2000"
        "+1 week"
        "+1 week -2 days 4 hours 2 seconds"
        "last Monday"
        "next Thursday"
    eg : 指定日期一个月后的时间戳：strtotime('+1 month', strtotime($date));
