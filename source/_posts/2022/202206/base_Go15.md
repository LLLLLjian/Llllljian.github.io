---
title: Go_基础 (15)
date: 2022-06-23
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-Go语言进阶技术

<!-- more -->

#### 数组和切片
> 数组类型的值(以下简称数组)的长度是固定的, 而切片类型的值(以下简称切片)是可变长的

切片是基于数组的, 可变长的, 并且非常轻快.一个切片的容量总是固定的, 而且一个切片也只会与某一个底层数组绑定在一起.

此外, 切片的容量总会是在切片长度和底层数组长度之间的某一个值, 并且还与切片窗口最左边对应的元素在底层数组中的位置有关系.那两个分别用减法计算切片长度和容量的方法你一定要记住

另外, 如果新的长度比原有切片的容量还要大, 那么底层数组就一定会是新的, 而且append函数也会返回一个新的切片.还有, 你其实不必太在意切片“扩容”策略中的一些细节, 只要能够理解它的基本规律并可以进行近似的估算就可以了.

```go
    package main

    import "fmt"

    func main() {
        s1 := make([]int, 5)
        // The length of s1: 5
        fmt.Printf("The length of s1: %d\n", len(s1))
        // The capacity of s1: 5
        fmt.Printf("The capacity of s1: %d\n", cap(s1))
        // The value of s1: [0 0 0 0 0]
        fmt.Printf("The value of s1: %d\n", s1)
        s2 := make([]int, 5, 8)
        // The length of s2: 5
        fmt.Printf("The length of s2: %d\n", len(s2))
        // The capacity of s2: 8
        fmt.Printf("The capacity of s2: %d\n", cap(s2))
        // The value of s2: [0 0 0 0 0]
        fmt.Printf("The value of s2: %d\n", s2)
        s3 := []int{1, 2, 3, 4, 5, 6, 7, 8}
        s4 := s3[3:6]
        // The length of s4: 3
        fmt.Printf("The length of s4: %d\n", len(s4))
        // The capacity of s4: 5
        fmt.Printf("The capacity of s4: %d\n", cap(s4))
        // The value of s4: [4 5 6]
        fmt.Printf("The value of s4: %d\n", s4)
    }
```

#### 字典的操作和约束
- 先看问题
    * 为什么字典的键类型会受到约束
    * 通常应该选取什么样的类型作为字典的键类型
- 字典底层
    * Go 语言的字典类型其实是一个**哈希表(hash table)**的特定实现, 在这个实现中, 键和元素的最大不同在于, 键的类型是受限的, 而元素却可以是任意类型的.
- 字典查找方式
    * 首先将key通过哈希函数(hash function)把键值转换为哈希值.哈希值通常是一个无符号的整数.一个哈希表会持有一定数量的桶(bucket), 我们也可以叫它哈希桶, 这些哈希桶会均匀地储存其所属哈希表收纳的键 - 元素对.因此, 哈希表会先用这个键哈希值的低几位去定位到一个哈希桶, 然后再去这个哈希桶中, 查找这个键.由于键 - 元素对总是被捆绑在一起存储的, 所以一旦找到了键, 就一定能找到对应的元素值.随后, 哈希表就会把相应的元素值作为结果返回.返回前还有一步是要比较原key和查找出来的key是不是同一个, 目的是为了防止hash冲突
- 字典的key不能是哪些类型
    * 字典的key之间必须可以施加操作符==和!=.换句话说, 键类型的值必须要支持判等操作.由于函数类型、字典类型和切片类型的值并不支持判等操作, 所以字典的键类型不能是这些类型.

#### 通道的基本操作
- 基本特性
    * 对于同一个通道, 发送操作之间是互斥的, 接收操作之间也是互斥的
    * 发送操作和接收操作中对元素值的处理都是不可分割的
    * 发送操作在完全完成之前会被阻塞.接收操作也是如此
- 基本操作
    ```go
        package main

        import "fmt"

        func main() {
            ch1 := make(chan int, 3)
            ch1 <- 2
            ch1 <- 1
            ch1 <- 3
            elem1 := <-ch1
            fmt.Printf("The first element received from channel ch1: %v\n",
                elem1)
        }
    ```


