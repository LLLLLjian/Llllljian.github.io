---
title: Go_基础 (9)
date: 2022-02-24
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-方法和接口

<!-- more -->

#### 方法

Go 没有类.不过你可以为结构体类型定义方法.

方法就是一类带特殊的 接收者 参数的函数.

方法接收者在它自己的参数列表内, 位于 func 关键字和方法名之间.

在此例中, Abs 方法拥有一个名为 v, 类型为 Vertex 的接收者.

- code
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        type Vertex struct {
            X, Y float64
        }

        func (v Vertex) Abs() float64 {
            return math.Sqrt(v.X*v.X + v.Y*v.Y)
        }

        func main() {
            v := Vertex{3, 4}
            fmt.Println(v.Abs())
        }
    ```

方法即函数
记住：方法只是个带接收者参数的函数.

现在这个 Abs 的写法就是个正常的函数, 功能并没有什么变化.

- code1
    ```go
        // 和 code 实现的功能是一样的 
        package main

        import (
            "fmt"
            "math"
        )

        type Vertex struct {
            X, Y float64
        }

        func Abs(v Vertex) float64 {
            return math.Sqrt(v.X*v.X + v.Y*v.Y)
        }

        func main() {
            v := Vertex{3, 4}
            fmt.Println(Abs(v))
        }
    ```

#### 记录
> 剩下的先放一放, 我先干干别的
