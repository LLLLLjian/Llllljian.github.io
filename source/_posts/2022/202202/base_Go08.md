---
title: Go_基础 (8)
date: 2022-02-23
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-更多类型：struct、slice 和映射

<!-- more -->

#### 函数值

函数也是值.它们可以像其它值一样传递.

函数值可以用作函数的参数或返回值.

- code
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        func compute(fn func(float64, float64) float64) float64 {
            return fn(3, 4)
        }

        func hypot1(x, y float64) float64 {
            return x*x + y*y
        }

        func main() {
            hypot := func(x, y float64) float64 {
                return math.Sqrt(x*x + y*y)
            }
            // 5 * 5 + 12 * 12 开方 = 13
            fmt.Println(hypot(5, 12))
            // 将函数传进去 3 * 3 + 4 * 4 开方 = 5
            fmt.Println(compute(hypot))
            // 将函数传进去 3 * 3 + 4 * 4 = 25
            fmt.Println(compute(hypot1))
            // 平方 3 * 3 * 3 * 3 = 81
            fmt.Println(compute(math.Pow))
        }
    ```

#### 函数的闭包

Go 函数可以是一个闭包.闭包是一个函数值, 它引用了其函数体之外的变量.该函数可以访问并赋予其引用的变量的值, 换句话说, 该函数被这些变量“绑定”在一起.

例如, 函数 adder 返回一个闭包.每个闭包都被绑定在其各自的 sum 变量上.

- code
    ```go
        package main

        import "fmt"

        func adder() func(int) int {
            sum := 0
            return func(x int) int {
                sum += x
                return sum
            }
        }

        func main() {
            pos, neg := adder(), adder()
            for i := 0; i < 10; i++ {
                fmt.Println(
                    pos(i),
                    neg(-2*i),
                )
            }
        }
    ```

#### 斐波纳契闭包
- Q
    ```
        实现一个 fibonacci 函数, 它返回一个函数(闭包), 该闭包返回一个斐波纳契数列 
        (0, 1, 1, 2, 3, 5, ...).
    ```
- A
    ```go
        package main

        import "fmt"

        // 返回一个“返回int的函数”
        func fibonacci() func() int {
            back1, back2:= 0, 1  // 预先定义好前两个值

            return func() int {

                //记录(back1)的值
                temp := back1

                // 重新赋值(这个就是核心代码)
                back1, back2 = back2, (back1 + back2)

                //返回temp
                return temp
            }
        }

        func main() {
            f := fibonacci()
            for i := 0; i < 10; i++ {
                fmt.Println(f())
            }
        }
    ```
