---
title: Go_基础 (5)
date: 2022-02-18
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-流程控制语句：for、if、else、switch 和 defer

<!-- more -->

#### switch
switch 是编写一连串 if - else 语句的简便方法.它运行第一个值等于条件表达式的 case 语句.

Go 的 switch 语句类似于 C、C++、Java、JavaScript 和 PHP 中的, 不过 Go 只运行选定的 case, 而非之后所有的 case. 实际上, Go 自动提供了在这些语言中每个 case 后面所需的 break 语句. 除非以 fallthrough 语句结束, 否则分支会自动终止. Go 的另一点重要的不同在于 switch 的 case 无需为常量, 且取值不必为整数.

- code
    ```go
        package main

        import (
            "fmt"
            "runtime"
        )

        func main() {
            fmt.Print("Go runs on ")
            switch os := runtime.GOOS; os {
            case "darwin":
                fmt.Println("OS X.")
            case "linux":
                fmt.Println("Linux.")
            default:
                // freebsd, openbsd,
                // plan9, windows...
                fmt.Printf("%s.\n", os)
            }
        }
    ```

switch 的 case 语句从上到下顺次执行, 直到匹配成功时停止.
(例如, 
```
switch i {
case 0:
case f():
}
```
在 i==0 时 f 不会被调用.)

- code1
    ```go
        package main

        import (
            "fmt"
            "time"
        )

        func main() {
            fmt.Println("When's Saturday?")
            today := time.Now().Weekday()
            switch time.Saturday {
            case today + 0:
                fmt.Println("Today.")
            case today + 1:
                fmt.Println("Tomorrow.")
            case today + 2:
                fmt.Println("In two days.")
            default:
                fmt.Println("Too far away.")
            }
        }
    ```

没有条件的 switch 同 switch true 一样.

这种形式能将一长串 if-then-else 写得更加清晰.

- code2
    ```go
        package main

        import (
            "fmt"
            "time"
        )

        func main() {
            t := time.Now()
            switch {
            case t.Hour() < 12:
                fmt.Println("Good morning!")
            case t.Hour() < 17:
                fmt.Println("Good afternoon.")
            default:
                fmt.Println("Good evening.")
            }
        }
    ```

#### defer 

defer 语句会将函数推迟到外层函数返回之后执行.

推迟调用的函数其参数会立即求值, 但直到外层函数返回前该函数都不会被调用.

- code
    ```go
        package main

        import "fmt"

        func main() {
            defer fmt.Println("world")

            fmt.Println("hello")
        }

        // 输出结果
        // hello
        // world
    ```

推迟的函数调用会被压入一个栈中.当外层函数返回时, 被推迟的函数会按照后进先出的顺序调用.

- code1
    ```go
        package main

        import "fmt"

        func main() {
            fmt.Println("counting")

            for i := 0; i < 10; i++ {
                defer fmt.Println(i)
            }

            fmt.Println("done")
        }

        // 输出结果
        /*
        counting
        done
        9
        8
        7
        6
        5
        4
        3
        2
        1
        0
        */
    ```
