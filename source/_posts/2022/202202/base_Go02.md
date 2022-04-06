---
title: Go_基础 (2)
date: 2022-02-15
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-包、变量和函数

<!-- more -->

#### 短变量声明
在函数中, 简洁赋值语句 := 可在类型明确的地方代替 var 声明.

函数外的每个语句都必须以关键字开始(var, func 等等), 因此 := 结构不能在函数外使用.

- code
    ```go
        package main

        import "fmt"

        func main() {
            var i, j int = 1, 2
            k := 3
            c, python, java := true, false, "no!"
            fmt.Println(i, j, k, c, python, java)
        }
    ```

#### 基本类型
Go 的基本类型有
```
    bool

    string

    int  int8  int16  int32  int64
    uint uint8 uint16 uint32 uint64 uintptr

    byte // uint8 的别名

    rune // int32 的别名
        // 表示一个 Unicode 码点

    float32 float64

    complex64 complex128
```
本例展示了几种类型的变量. 同导入语句一样, 变量声明也可以“分组”成一个语法块.

int, uint 和 uintptr 在 32 位系统上通常为 32 位宽, 在 64 位系统上则为 64 位宽. 当你需要一个整数值时应使用 int 类型, 除非你有特殊的理由使用固定大小或无符号的整数类型.

- code
    ```go
        package main

        import (
            "fmt"
            "math/cmplx"
        )

        var (
            ToBe   bool       = false
            MaxInt uint64     = 1<<64 - 1
            z      complex128 = cmplx.Sqrt(-5 + 12i)
        )

        func main() {
            fmt.Printf("Type: %T Value: %v\n", ToBe, ToBe)
            fmt.Printf("Type: %T Value: %v\n", MaxInt, MaxInt)
	        fmt.Printf("Type: %T Value: %v\n", z, z)
        }
    ```

#### 零值
没有明确初始值的变量声明会被赋予它们的 零值.

零值是：

数值类型为 0, 
布尔类型为 false, 
字符串为 ""(空字符串).

- code
    ```go
        package main

        import "fmt"

        func main() {
            var i int
            var f float64
            var b bool
            var s string
            fmt.Printf("%v %v %v %q\n", i, f, b, s)
        }
    ```

#### 类型转换
表达式 T(v) 将值 v 转换为类型 T.

一些关于数值的转换：
```
    var i int = 42
    var f float64 = float64(i)
    var u uint = uint(f)
    // 或者, 更加简单的形式
    i := 42
    f := float64(i)
    u := uint(f)
```
与 C 不同的是, Go 在不同类型的项之间赋值时需要显式转换.试着移除例子中 float64 或 uint 的转换看看会发生什么.

