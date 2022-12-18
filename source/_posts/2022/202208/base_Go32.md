---
title: Go_基础 (32)
date: 2022-08-22
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记

<!-- more -->

#### 结构体和指针
> 指针存储值的存储器地址.在 Go 中, 类型 *T 是指向 T 值的指针.指针的默认值为 nil

```go
    package main

    import "fmt"

    // 地址运算符 ( &) 提供值的内存地址.它用于将指针绑定到一个值
    // 类型前缀的星号运算符 (*) 表示指针类型, 而变量前缀的星号用于取消引用变量指向的值
    func main() {
        var address *int  // declare an int pointer
        number := 42      // int
        address = &number // address stores the memory address of number
        value := *address // dereferencing the value 

        fmt.Printf("address: %v\n", address) // address: 0xc0000ae008
        fmt.Printf("value: %v\n", value)     // value: 42
    }
```

```go
    package main

    import "fmt"

    /* Define a stack type using a struct */
    type stack struct {
        index int
        data  [5]int
    }

    /* Define push and pop methods */
    func (s *stack) push(k int) {
        s.data[s.index] = k
        s.index++
    }

    /* Notice the stack pointer s passed as an argument */
    func (s *stack) pop() int {
        s.index--
        return s.data[s.index]
    }

    func main() {
        /* Create a pointer to the new stack and push 2 values */
        s := new(stack)
        s.push(23)
        s.push(14)
        fmt.Printf("stack: %v\n", *s) // stack: {2 [23 14 0 0 0]}
    }
```

#### 并发

Goroutines, 它是 Go 中轻量级线程.如果你不熟悉线程, 可以理解它们只不过是程序中的顺序控制流.当多个线程并发运行以便程序可以使用多个 CPU 内核时, 事情会变得有趣.Goroutines 是使用 go 关键字启动的.除了 goroutines 之外, Go 还内置了用于在 goroutines 之间共享数据的 channel.通常, 跨通道的发送和接收操作会阻塞执行, 直到另一端准备就绪.

```go
    // 饭店做菜 肯定不能串行 要并行
    package main

    import (
        "fmt"
    )

    func main() {
        c := make(chan int) // Create a channel to pass ints
        for i := 0; i < 5; i++ {
            go cookingGopher(i, c) // Start a goroutine
        }

        for i := 0; i < 5; i++ {
            gopherID := <-c // Receive a value from a channel
            fmt.Println("gopher", gopherID, "finished the dish")
        } // All goroutines are finished at this point
    }

    /* Notice the channel as an argument */
    func cookingGopher(id int, c chan int) {
        fmt.Println("gopher", id, "started cooking")
        c <- id // Send a value back to main
    }
```

