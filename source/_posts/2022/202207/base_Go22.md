---
title: Go_基础 (22)
date: 2022-07-04
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-panic函数、recover函数以及defer语句

<!-- more -->

#### panic
- 引子
    ```go
        package main

        func main() {
            s1 := []int{0, 1, 2, 3, 4}
            e5 := s1[5]
            _ = e5
        }
    ```
- 从 panic 被引发到程序终止运行的大致过程是什么
    * 某个函数中的某行代码有意或无意地引发了一个 panic.这时, 初始的 panic 详情会被建立起来, 并且该程序的控制权会立即从此行代码转移至调用其所属函数的那行代码上, 也就是调用栈中的上一级
    * 这也意味着, 此行代码所属函数的执行随即终止.紧接着, 控制权并不会在此有片刻的停留, 它又会立即转移至再上一级的调用代码处.控制权如此一级一级地沿着调用栈的反方向传播至顶端, 也就是我们编写的最外层函数那里.
    * 这里的最外层函数指的是go函数, 对于主 goroutine 来说就是main函数.但是控制权也不会停留在那里, 而是被 Go 语言运行时系统收回.
    * 随后, 程序崩溃并终止运行, 承载程序这次运行的进程也会随之死亡并消失.与此同时, 在这个控制权传播的过程中, panic 详情会被逐渐地积累和完善, 并会在程序终止之前被打印出来.
- 证明 
    ```go
        package main

        import (
            "fmt"
        )

        func main() {
            fmt.Println("Enter function main.")
            caller1()
            fmt.Println("Exit function main.")
        }

        func caller1() {
            fmt.Println("Enter function caller1.")
            caller2()
            fmt.Println("Exit function caller1.")
        }

        func caller2() {
            fmt.Println("Enter function caller2.")
            s1 := []int{0, 1, 2, 3, 4}
            e5 := s1[5]
            _ = e5
            fmt.Println("Exit function caller2.")
        }
    ```
- 输出结果
    ```
        Enter function main.
        Enter function caller1.
        Enter function caller2.
        panic: runtime error: index out of range [5] with length 5

        goroutine 1 [running]:
        main.caller2()
            D:/code/test/demo48.go:22 +0x5f
        main.caller1()
            D:/code/test/demo48.go:15 +0x5b
        main.main()
            D:/code/test/demo48.go:9 +0x5f
        exit status 2
    ```

![panic执行顺序](/img/20220704_1.jpg)

- 怎样让 panic 包含一个值, 以及应该让它包含什么样的值
    ```go
        panic(errors.New("something wrong"))
    ```
- 怎样施加应对 panic 的保护措施, 从而避免程序崩溃
    * 利用defer和revcover
    * Go 语言的内建函数recover专用于恢复 panic, 或者说平息运行时恐慌.recover函数无需任何参数, 并且会返回一个空接口类型的值.
    * defer语句就是被用来延迟执行代码的.延迟到什么时候呢？这要延迟到该语句所在的函数即将执行结束的那一刻, 无论结束执行的原因是什么
    * code
        ```go
            package main

            import (
                "errors"
                "fmt"
            )

            func main() {
                fmt.Println("Enter function main.")

                defer func() {
                    fmt.Println("Enter defer function.")

                    // recover函数的正确用法.
                    if p := recover(); p != nil {
                        fmt.Printf("panic: %s\n", p)
                    }

                    fmt.Println("Exit defer function.")
                }()

                // recover函数的错误用法.
                fmt.Printf("no panic: %v\n", recover())

                // 引发panic.
                panic(errors.New("something wrong"))

                // recover函数的错误用法.
                p := recover()
                fmt.Printf("panic: %s\n", p)

                fmt.Println("Exit function main.")
            }
        ```
    * 执行结果
        ```
            Enter function main
            no panic: <nil>
            Enter defer function
            panic defer : something wrong
            Exit defer function
        ```
    * 如果一个函数中有多条defer语句, 那么那几个defer函数调用的执行顺序是怎样的
        * 在同一个函数中, defer函数调用的执行顺序与它们分别所属的defer语句的出现顺序(更严谨地说, 是执行顺序)完全相反.
    * code
        ```go
            package main

            import "fmt"

            func main() {
                defer fmt.Println("first defer")
                for i := 0; i < 3; i++ {
                    defer fmt.Printf("defer in for [%d]\n", i)
                }
                defer fmt.Println("last defer")
            }
        ```
    * 执行结果
        ```
            last defer
            defer in for [2]
            defer in for [1]
            defer in for [0]
            first defer
        ```
    * 执行结果分析
        * 在defer语句每次执行的时候, Go 语言会把它携带的defer函数及其参数值另行存储到一个链表中.这个链表与该defer语句所属的函数是对应的, 并且, 它是先进后出(FILO)的, 相当于一个栈.在需要执行某个函数中的defer函数调用的时候, Go 语言会先拿到对应的链表, 然后从该链表中一个一个地取出defer函数及其参数值, 并逐个执行调用.

