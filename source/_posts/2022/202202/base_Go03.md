---
title: Go_基础 (3)
date: 2022-02-16
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-包、变量和函数

<!-- more -->

#### 类型推导
在声明一个变量而不指定其类型时(即使用不带类型的 := 语法或 var = 表达式语法), 变量的类型由右值推导得出.

当右值声明了类型时, 新变量的类型与其相同
```
    var i int
    j := i // j 也是一个 int
    // 不过当右边包含未指明类型的数值常量时, 新变量的类型就可能是 int, float64 或 complex128 了, 这取决于常量的精度：
    i := 42           // int
    f := 3.142        // float64
    g := 0.867 + 0.5i // complex128
```
尝试修改示例代码中 v 的初始值, 并观察它是如何影响类型的.

- code
    ```go
        package main

        import "fmt"

        func main() {
            // v := 42 // 修改这里！
            // v := 3.142 // 修改这里！
            v := 0.867 + 0.5i // 修改这里！
            fmt.Printf("v is of type %T\n", v)
        }
    ```

#### 常量
常量的声明与变量类似, 只不过是使用 const 关键字.

常量可以是字符、字符串、布尔值或数值.

常量不能用 := 语法声明.

- code
    ```go
        package main

        import "fmt"

        const Pi = 3.14

        func main() {
            const World = "世界"
            fmt.Println("Hello", World)
            fmt.Println("Happy", Pi, "Day")

            const Truth = true
            fmt.Println("Go rules?", Truth)
        }
    ```

