---
title: PHP_基础 (43)
date: 2020-05-25
tags: PHP 
toc: true
---

### 深入理解PHP7
    深入理解PHP7内核之zval

<!-- more -->

#### PHP5中的zval
- PHP5中zval的定义
    ```php
        struct _zval_struct {
            union {
                long lval;                       // 用于 bool 类型、整型和资源类型
                double dval;                     // 用于浮点类型
                struct {                         // 用于字符串
                    char *val;
                    int len;
                } str;
                HashTable *ht;                   // 用于数组
                zend_object_value obj;           // 用于对象
                zend_ast *ast;                   // 用于常量表达式(PHP5.6 才有)
            } value;
            zend_uint refcount__gc;
            zend_uchar type;
            zend_uchar is_ref__gc;
        };
    ```
- value 
    * 是个联合体, 用于存储不同类型的值
- type
    ```php
        #define IS_NULL     0      /* Doesn't use value */
        #define IS_LONG     1      /* Uses lval */
        #define IS_DOUBLE   2      /* Uses dval */
        #define IS_BOOL     3      /* Uses lval with values 0 and 1 */
        #define IS_ARRAY    4      /* Uses ht */
        #define IS_OBJECT   5      /* Uses obj */
        #define IS_STRING   6      /* Uses str */
        #define IS_RESOURCE 7      /* Uses lval, which is the resource ID */
        /* Special types used for late-binding of constants */
        #define IS_CONSTANT 8
        #define IS_CONSTANT_AST 9
    ```
- refcount
    * 引用计数, 为了减少 内存池的开销和垃圾回收, 加入了该字段, 这样在下一次用到同一个值的时候就会直接引用该值, 然后refcount++就好, 当你unset掉某个变量是也是会相应refcount--, 直到为0时则会回收把它干掉
- is_ref
    * 是否为引用, 1为引用, 0为否.php中可以分为两种变量, 引用和非引用, 非引用就是正常的赋值, 但是引用的话是传递地址, 需要在前面加上“&”, 相当于指针, 改变引用的值是会改变原来改地址的变量的值的

#### PHP5中的引用计数
> 在PHP5中, zval 的内存是单独从堆(heap)中分配的, PHP 需要知道哪些 zval 是正在使用的, 哪些是需要释放的.所以这就需要用到引用计数：zval 中 refcount__gc 的值用于保存 zval 本身被引用的次数, 比如 $a = $b = 42 语句中, 42 被两个变量引用, 所以它的引用计数就是 2.如果引用计数变成 0, 就意味着这个变量已经没有用了, 内存也就可以释放了
- 写时复制
    * 对于多个引用来说, zaval 只有在没有变化的情况下才是共享的, 一旦其中一个引用改变 zval 的值, 就需要复制(”separated”)一份 zval, 然后修改复制后的 zval
    ```php
        <?php
        $a = 42;                // $a         -> zval_1(type=IS_LONG, value=42, refcount=1)
        $b = $a;                // $a, $b     -> zval_1(type=IS_LONG, value=42, refcount=2)
        $c = $b;                // $a, $b, $c -> zval_1(type=IS_LONG, value=42, refcount=3)
        // 下面几行是关于 zval 分离的
        $a += 1;                // $b, $c -> zval_1(type=IS_LONG, value=42, refcount=2)
                                // $a     -> zval_2(type=IS_LONG, value=43, refcount=1)
        unset($b);              // $c -> zval_1(type=IS_LONG, value=42, refcount=1)
                                // $a -> zval_2(type=IS_LONG, value=43, refcount=1)
        unset($c);              // zval_1 is destroyed, because refcount=0
                                // $a -> zval_2(type=IS_LONG, value=43, refcount=1)
    ```
- 存在的主要问题
    * zval 总是单独从堆中分配内存；
    * zval 总是存储引用计数和循环回收的信息, 即使是整型这种可能并不需要此类信息的数据；
    * 在使用对象或者资源时, 直接引用会导致两次计数；
    * 某些间接访问需要一个更好的处理方式.比如现在访问存储在变量中的对象间接使用了四个指针(指针链的长度为四).这个问题也放到下一部分讨论；
    * 直接计数也就意味着数值只能在 zval 之间共享.如果想在 zval 和 hashtable key 之间共享一个字符串就不行(除非 hashtable key 也是 zval).

#### PHP7中的zval
- PHP7中zval的定义
    ```php
        struct _zval_struct {
            union {
                zend_long         lval;             /* long value */
                double            dval;             /* double value */
                zend_refcounted  *counted;
                zend_string      *str;
                zend_array       *arr;
                zend_object      *obj;
                zend_resource    *res;
                zend_reference   *ref;
                zend_ast_ref     *ast;
                zval             *zv;
                void             *ptr;
                zend_class_entry *ce;
                zend_function    *func;
                struct {
                    uint32_t w1;
                    uint32_t w2;
                } ww;
            } value;
            union {
                struct {
                    ZEND_ENDIAN_LOHI_4(
                        zend_uchar    type,         /* active type */
                        zend_uchar    type_flags,
                        zend_uchar    const_flags,
                        zend_uchar    reserved)     /* call info for EX(This) */
                } v;
                uint32_t type_info;
            } u1;
            union {
                uint32_t     var_flags;
                uint32_t     next;                 /* hash collision chain */
                uint32_t     cache_slot;           /* literal cache slot */
                uint32_t     lineno;               /* line number (for ast nodes) */
                uint32_t     num_args;             /* arguments number for EX(This) */
                uint32_t     fe_pos;               /* foreach position */
                uint32_t     fe_iter_idx;          /* foreach iterator index */
            } u2;
        };
    ```
- 类型(Types)
    ```php
        /* regular data types */
        #define IS_UNDEF                    0
        #define IS_NULL                     1
        #define IS_FALSE                    2
        #define IS_TRUE                     3
        #define IS_LONG                     4
        #define IS_DOUBLE                   5
        #define IS_STRING                   6
        #define IS_ARRAY                    7
        #define IS_OBJECT                   8
        #define IS_RESOURCE                 9
        #define IS_REFERENCE                10
        /* constant expressions */
        #define IS_CONSTANT                 11
        #define IS_CONSTANT_AST             12
        /* internal types */
        #define IS_INDIRECT                 15
        #define IS_PTR                      17
    ```
> 最基础的变化就是 zval 需要的内存不再是单独从堆上分配, 不再自己存储引用计数.复杂数据类型(比如字符串、数组和对象)的引用计数由其自身来存储
- 优点
    * 简单数据类型不需要单独分配内存, 也不需要计数
    * 不会再有两次计数的情况.在对象中, 只有对象自身存储的计数是有效的
    * 由于现在计数由数值自身存储, 所以也就可以和非 zval 结构的数据共享, 比如 zval 和 hashtable key 之间
    * 间接访问需要的指针数减少了

#### PHP7中的内存管理
> zval需要的内存不再单独从堆上分配, 实际上大多时候它还是位于堆中(重点不是堆, 而是单独分配), 只不过是嵌入到其他的数据结构中的, 比如 hashtable 和 bucket 现在就会直接有一个 zval 字段而不是指针.所以函数表编译变量和对象属性在存储时会是一个 zval 数组并得到一整块内存而不是散落在各处的 zval 指针.之前的 zval * 现在都变成了 zval
- PHP7中的写时复制
    ```php
        <?php
        /**
         *  整数不再是共享的, 变量直接就会分离成两个单独的 zval, 由于现在 zval 是内嵌的所以也不需要单独分配内存, 所以这里的注释中使用 = 来表示的而不是指针符号 ->, unset 时变量会被标记为 IS_UNDEF
         */
        $a = 42;   // $a = zval_1(type=IS_LONG, value=42)
        $b = $a;   // $a = zval_1(type=IS_LONG, value=42)
                // $b = zval_2(type=IS_LONG, value=42)
        $a += 1;   // $a = zval_1(type=IS_LONG, value=43)
                // $b = zval_2(type=IS_LONG, value=42)
        unset($a); // $a = zval_1(type=IS_UNDEF)
                // $b = zval_2(type=IS_LONG, value=42)

        /**
         * 每个变量变量有一个单独的 zval, 但是是指向同一个(有引用计数) zend_array 的结构体.修改其中一个数组的值时才会进行复制 
         */
        $a = [];   // $a = zval_1(type=IS_ARRAY) -> zend_array_1(refcount=1, value=[])
        $b = $a;   // $a = zval_1(type=IS_ARRAY) -> zend_array_1(refcount=2, value=[])
                // $b = zval_2(type=IS_ARRAY) ---^
        // zval 分离在这里进行
        $a[] = 1   // $a = zval_1(type=IS_ARRAY) -> zend_array_2(refcount=1, value=[1])
                // $b = zval_2(type=IS_ARRAY) -> zend_array_1(refcount=1, value=[])
        unset($a); // $a = zval_1(type=IS_UNDEF),   zend_array_2 被销毁
                // $b = zval_2(type=IS_ARRAY) -> zend_array_1(refcount=1, value=[])
    ```

#### 引用
- PHP5中的引用
    ```php
        <?php
        $a = [];  // $a         -> zval_1(type=IS_ARRAY, refcount=1, is_ref=0) -> HashTable_1(value=[])
        $b = $a;  // $a, $b     -> zval_1(type=IS_ARRAY, refcount=2, is_ref=0) -> HashTable_1(value=[])
        $c = $b   // $a, $b, $c -> zval_1(type=IS_ARRAY, refcount=3, is_ref=0) -> HashTable_1(value=[])
        $d =& $c; // $a, $b -> zval_1(type=IS_ARRAY, refcount=2, is_ref=0) -> HashTable_1(value=[])
                // $c, $d -> zval_1(type=IS_ARRAY, refcount=2, is_ref=1) -> HashTable_2(value=[])
                // $d 是 $c 的引用, 但却不是 $a 的 $b, 所以这里 zval 还是需要进行复制
                // 这样我们就有了两个 zval, 一个 is_ref 的值是 0, 一个 is_ref 的值是 1.
        $d[] = 1; // $a, $b -> zval_1(type=IS_ARRAY, refcount=2, is_ref=0) -> HashTable_1(value=[])
                // $c, $d -> zval_1(type=IS_ARRAY, refcount=2, is_ref=1) -> HashTable_2(value=[1])
                // 因为有两个分离了的 zval, $d[] = 1 的语句就不会修改 $a 和 $b 的值.
    ```
- PHP5demo
    ```php
        echo substr(PHP_VERSION,0,3) . "<br />";
        $array = range(1, 100000);
        function dummy($array) {}
        $i = 0;
        $start = microtime(true);
        while($i++ < 100) {
            dummy($array);
        }
        echo sprintf("%.10f", microtime(true) - $start). "<br />";
        $b = &$array; //注意这里, 假设我不小心把这个Array引用给了一个变量
        $i = 0;
        $start = microtime(true);
        while($i++ < 100) {
            dummy($array);
        }
        echo sprintf("%.10f", microtime(true) - $start). "<br />";

        /**
         * 输出结果
         */
        5.6
        0.0000278950
        1.2939770222
    ```
- PHP7中的引用
    ```php
        $a = [];  // $a         -> zend_array_1(refcount=1, value=[])
        $b = $a;  // $a, $b,    -> zend_array_1(refcount=2, value=[])
        $c = $b   // $a, $b, $c -> zend_array_1(refcount=3, value=[])
        $d =& $c; // $a, $b                                 -> zend_array_1(refcount=3, value=[])
                // $c, $d -> zend_reference_1(refcount=2) ---^
                // 注意所有变量共享同一个 zend_array, 即使有的是 PHP 引用有的不是
        $d[] = 1; // $a, $b                                 -> zend_array_1(refcount=2, value=[])
                // $c, $d -> zend_reference_1(refcount=2) -> zend_array_2(refcount=1, value=[1])
                // 只有在这时进行赋值的时候才会对 zend_array 进行赋值
    ```
    * 与PHP5中的引用差异
        * 所有的变量都可以共享同一个数组, 即使有的是 PHP 引用有的不是.只有当其中某一部分被修改的时候才会对数组进行分离.这也意味着使用 count() 时即使给其传递一个很大的引用数组也是安全的, 不会再进行复制.不过引用仍然会比普通的数值慢, 因为存在需要为 zend_reference 结构体分配内存(间接)并且引擎本身处理这一块儿也不快的的原因
- PHP7demo
    ```php
        echo substr(PHP_VERSION,0,3) . "<br />";
        $array = range(1, 100000);
        function dummy($array) {}
        $i = 0;
        $start = microtime(true);
        while($i++ < 100) {
            dummy($array);
        }
        echo sprintf("%.10f", microtime(true) - $start). "<br />";
        $b = &$array; //注意这里, 假设我不小心把这个Array引用给了一个变量
        $i = 0;
        $start = microtime(true);
        while($i++ < 100) {
            dummy($array);
        }
        echo sprintf("%.10f", microtime(true) - $start). "<br />";

        /**
         * 输出结果
         */
        7.0
        0.0000100136
        0.0000030994
    ```


