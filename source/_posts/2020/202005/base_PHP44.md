---
title: PHP_基础 (44)
date: 2020-05-26
tags: PHP 
toc: true
---

### 深入理解PHP
    深入理解PHP之数组

<!-- more -->

#### PHP中的数组
> 在PHP中, 数组是用一种HASH结构(HashTable)来实现的, PHP使用了一些机制, 使得可以在O(1)的时间复杂度下实现数组的增删, 并同时支持线性遍历和随机访问
- HashTable的结构定义
    ```bash
        typedef struct _hashtable {
        uint nTableSize;        /* 散列表大小, Hash值的区间 */
        uint nTableMask;        /* 等于nTableSize -1, 用于快速定位 */
        uint nNumOfElements;    /* HashTable中实际元素的个数 */
        ulong nNextFreeElement; /* 下个空闲可用位置的数字索引 */
        Bucket *pInternalPointer;   /* 内部位置指针, 会被reset, current这些遍历函数使用 */
        Bucket *pListHead;      /* 头元素, 用于线性遍历 */
        Bucket *pListTail;      /* 尾元素, 用于线性遍历 */
        Bucket **arBuckets;     /* 实际的存储容器 */
        dtor_func_t pDestructor;/* 元素的析构函数(指针) */
        zend_bool persistent;
        unsigned char nApplyCount; /* 循环遍历保护, 为了防治循环引用导致的无限循环而设立 */
        zend_bool bApplyProtection;
        #if ZEND_DEBUG
        int inconsistent;
        #endif
        } HashTable;
    ```
    * arBuckets的结构定义
        ```php
            typedef struct bucket {
            ulong h;                        /* 数字索引/hash值 */
            uint nKeyLength;                /* 字符索引的长度 */
            void *pData;                    /* 数据 */
            void *pDataPtr;                 /* 数据指针 */
            struct bucket *pListNext;               /* 下一个元素, 用于线性遍历 */
            struct bucket *pListLast;       /* 上一个元素, 用于线性遍历 */
            struct bucket *pNext;                   /* 处于同一个拉链中的下一个元素 */
            struct bucket *pLast;                   /* 处于同一拉链中的上一个元素 */
            char arKey[1]; /* 节省内存,方便初始化的技巧 */
            } Bucket;
        ```
- PHP 数组的基本实现
> 散列表主要由两部分组成:存储元素数组、散列函数.PHP 中的数组除了具备散列表的基本特点之外, 还有一个特别的地方, 那就是它是有序的(与Java中的HashMap的无序有所不同):数组中各元 素的顺序和插入顺序一致.这个是怎么实现的呢?为了实现 PHP 数组的有序性, PHP 底层的散列表在散列函数与元素数组之间加了一层映射表, 这个映射表也是一个数组, 大小和存储元素的数 组相同, 存储元素的类型为整型, 用于保存元素在实际存储的有序数组中的下标 —— 元素按照先后顺序依次插入实际存储数组, 然后将其数组下 标按照散列函数散列出来的位置存储在新加的映射表中.这样, 就可以完成最终存储数据的有序性了.PHP 数组底层结构中并没有显式标识这个中间映射表, 而是与 arData 放到了一起, 在数组初始化的时候并不仅仅分配用于存储 Bucket 的内 存, 还会分配相同数量的 uint32_t 大小的空间, 这两块空间是一起分配的, 然后将 arData 偏移到存储元素数组的位置, 而这个中间映射表就可 以通过 arData 向前访问到

#### PHP数组foreach原理
> 首先有个FE_RESET来重置数组的内部指针, 也就是pInternalPointer, 然后通过每次FE_FETCH来递增pInternalPointer,从而实现顺序遍历.类似的, 当我们使用, each/next系列函数来遍历的时候, 也是通过移动数组的内部指针而实现了顺序遍历
- foreach核心函数
    * zend_do_foreach_begin
        1. 记录当前的opline行数(为以后跳转而记录)
        2. 对数组进行RESET(讲内部指针指向第一个元素)
        3. 获取临时变量 ($val)
        4. 设置获取变量的OPCODE FE_FETCH, 结果存第3步的临时变量
        5. 记录获取变量的OPCODES的行数
    * zend_do_foreach_cont
        1. 根据foreach_variable的u.EA.type来判断是否引用
        2. 根据是否引用来调整zend_do_foreach_begin中生成的FE_FETCH方式
        3. 根据zend_do_foreach_begin中记录的取变量的OPCODES的行数, 来初始化循环(主要处理在循环内部的循环:do_begin_loop)
    * zend_do_foreach_end
        1. 根据zend_do_foreach_begin中记录的行数信息, 设置ZEND_JMP OPCODES
        2. 根据当前行数, 设置循环体下一条opline, 用以跳出循环
        3. 结束循环(处理循环内循环:do_end_loop)
        4. 清理临时变量

