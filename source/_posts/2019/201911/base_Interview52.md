---
title: Interview_总结 (52)
date: 2019-11-07
tags: Interview
toc: true
---

### 笔试总结
    列一下你的笔试题 

<!-- more -->

#### 垃圾回收机制
- 引用计数基本知识
    * 每个php变量存在一个叫"zval"的变量容器中。一个zval变量容器，除了包含变量的类型和值，还包括两个字节的额外信息。第一个是"is_ref"，是个bool值，用来标识这个变量是否是属于引用集合(reference set)。通过这个字节，php引擎才能把普通变量和引用变量区分开来，由于php允许用户通过使用&来使用自定义引用，zval变量容器中还有一个内部引用计数机制，来优化内存使用。第二个额外字节是"refcount"，用以表示指向这个zval变量容器的变量(也称符号即symbol)个数。
    * eg1
        ```php
            <?php
                $a = "new string";
                xdebug_debug_zval('a');
                // a: (refcount=1, is_ref=0)='new string'

                $b = $a;
                xdebug_debug_zval('a');
                // a: (refcount=2, is_ref=0)='new string'

                $c = $a;
                xdebug_debug_zval( 'a' );
                // a: (refcount=3, is_ref=0)='new string'

                unset( $b, $c );
                xdebug_debug_zval( 'a' );
                // a: (refcount=1, is_ref=0)='new string'
            ?>
        ```
    * eg2
        ```php
            <?php
                $a = array( 'meaning' => 'life', 'number' => 42 );
                xdebug_debug_zval( 'a' );
                // a: (refcount=1, is_ref=0)=array ('meaning' => (refcount=1, is_ref=0)='life','number' => (refcount=1, is_ref=0)=42)

                $a['life'] = $a['meaning'];
                xdebug_debug_zval( 'a' );
                // a: (refcount=1, is_ref=0)=array ('meaning' => (refcount=2, is_ref=0)='life',   'number' => (refcount=1, is_ref=0)=42,   'life' => (refcount=2, is_ref=0)='life')

                unset( $a['meaning'], $a['number'] );
                xdebug_debug_zval( 'a' );
                // a: (refcount=1, is_ref=0)=array ('life' => (refcount=1, is_ref=0)='life')
            ?>
        ```
- 回收周期(Collecting Cycles)
    * 如果一个引用计数增加，它将继续被使用，当然就不再在垃圾中。如果引用计数减少到零，所在变量容器将被清除(free)。就是说，仅仅在引用计数减少到非零值时，才会产生垃圾周期(garbage cycle)。其次，在一个垃圾周期中，通过检查引用计数是否减1，并且检查哪些变量容器的引用次数是零，来发现哪部分是垃圾。
    * 为避免不得不检查所有引用计数可能减少的垃圾周期，这个算法把所有可能根(possible roots 都是zval变量容器),放在根缓冲区(root buffer)中(用紫色来标记，称为疑似垃圾)，这样可以同时确保每个可能的垃圾根(possible garbage root)在缓冲区中只出现一次。仅仅在根缓冲区满了时，才对缓冲区内部所有不同的变量容器执行垃圾回收操作。看上图的步骤 A。
    * 在步骤 B 中，模拟删除每个紫色变量。模拟删除时可能将不是紫色的普通变量引用数减"1"，如果某个普通变量引用计数变成0了，就对这个普通变量再做一次模拟删除。每个变量只能被模拟删除一次，模拟删除后标记为灰（原文说确保不会对同一个变量容器减两次"1",不对的吧）。
    * 在步骤 C 中，模拟恢复每个紫色变量。恢复是有条件的，当变量的引用计数大于0时才对其做模拟恢复。同样每个变量只能恢复一次，恢复后标记为黑，基本就是步骤 B 的逆运算。这样剩下的一堆没能恢复的就是该删除的蓝色节点了，在步骤 D 中遍历出来真的删除掉。
    ![回收周期图解](/img/20191107_1.png)
- 性能方面考虑的因素
    * 通常，PHP中的垃圾回收机制，仅仅在循环回收算法确实运行时会有时间消耗上的增加。但是在平常的(更小的)脚本中应根本就没有性能影响。然而，在平常脚本中有循环回收机制运行的情况下，内存的节省将允许更多这种脚本同时运行在你的服务器上。因为总共使用的内存没达到上限。 

#### 垃圾回收算法
- 通俗理解
    * 大概意思就是申请了一块地儿挖了会儿坑，挖完后不收拾，那么那块儿地就算是糟蹋了，地越用越少，最后一地全是坑。说到底一句，用了记得填。一定程度上说，垃圾回收机制就是用来填坑的。
- 核心说明
    * PHP进行内存管理的核心算法一共两项：一是引用计数，二是写时拷贝，请理（bei）解（song）。当你声明一个PHP变量的时候，C语言就在底层给你搞了一个叫做zval的struct（结构体）；如果你还给这个变量赋值了，比如“hello world”，那么C语言就在底层再给你搞一个叫做zend_value的union（联合体）
    * demo
        ```bash
            zval {
                string "a" //变量的名字是a
                value zend_value //变量的值
                type string //变量是字符串类型
            }

            zend_value {
                string "hello916" //值的内容
                refcount 1 //引用计数
            }
        ```
- 回收周期内容
    * 对每个根缓冲区中的根zval按照深度优先遍历算法遍历所有能遍历到的zval，并将每个zval的refcount减1，同时为了避免对同一zval多次减1(因为可能不同的根能遍历到同一个zval)，每次对某个zval减1后就对其标记为“已减”。
    * 再次对每个缓冲区中的根zval深度优先遍历，如果某个zval的refcount不为0，则对其加1，否则保持其为0。
    * 清空根缓冲区中的所有根(注意是把这些zval从缓冲区中清除而不是销毁它们)，然后销毁所有refcount为0的zval，并收回其内存。
- 要点
    * 并不是每次refcount减少时都进入回收周期，只有根缓冲区满额后在开始垃圾回收。
    * 可以解决循环引用问题。
    * 可以总将内存泄露保持在一个阈值以下。

