---
title: Go_基础 (4)
date: 2022-02-17
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-流程控制语句：for、if、else、switch 和 defer

<!-- more -->

#### for
Go 只有一种循环结构：for 循环.

基本的 for 循环由三部分组成, 它们用分号隔开：

初始化语句：在第一次迭代前执行
条件表达式：在每次迭代前求值
后置语句：在每次迭代的结尾执行
初始化语句通常为一句短变量声明, 该变量声明仅在 for 语句的作用域中可见.

一旦条件表达式的布尔值为 false, 循环迭代就会终止.

注意：和 C、Java、JavaScript 之类的语言不同, Go 的 for 语句后面的三个构成部分外没有小括号,  大括号 { } 则是必须的.

- code
    ```go
        package main

        import "fmt"

        func forContinued() int {
            sum := 1
            // 初始化语句和后置语句是可选的
            for ; sum < 1000; {
                sum += sum
            }
            return sum
        }

        func forWhile() int {
            sum := 1
            // 可以去掉分号
            for sum < 1000 {
                sum += sum
            }
            return sum
        }

        func forForever() int {
            // 无限循环
            for {
	        }
        }

        func main() {
            sum := 0
            for i := 0; i < 10; i++ {
                sum += i
            }
            fmt.Println(sum)
        }
    ```

#### if
Go 的 if 语句与 for 循环类似, 表达式外无需小括号 ( ) , 而大括号 { } 则是必须的

- code
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        func sqrt(x float64) string {
            if x < 0 {
                return sqrt(-x) + "i"
            }
            return fmt.Sprint(math.Sqrt(x))
        }

        func main() {
            fmt.Println(sqrt(2), sqrt(-4))
        }
    ```
- code1
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        func pow(x, n, lim float64) float64 {
            // 同 for 一样,  if 语句可以在条件表达式前执行一个简单的语句
            // 该语句声明的变量作用域仅在 if 之内
            if v := math.Pow(x, n); v < lim {
                return v
            }
            return lim
        }

        func main() {
            fmt.Println(
                pow(3, 2, 10),
                pow(3, 3, 20),
            )
        }
    ```
- code2
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        func pow(x, n, lim float64) float64 {
            if v := math.Pow(x, n); v < lim {
                return v
            } else {
                // 在 if 的简短语句中声明的变量同样可以在任何对应的 else 块中使用
                fmt.Printf("%g >= %g\n", v, lim)
            }
            // 这里开始就不能使用 v 了
            // ./if-and-else.go:15:14: undefined: v
            // fmt.Println(v)
            return lim
        }

        func main() {
            fmt.Println(
                pow(3, 2, 10),
                pow(3, 3, 20),
            )
        }
    ```

