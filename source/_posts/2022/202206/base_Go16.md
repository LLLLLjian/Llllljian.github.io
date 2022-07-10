---
title: Go_基础 (16)
date: 2022-06-24
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-函数

<!-- more -->

#### 使用函数的正确姿势

函数不但可以用于封装代码、分割功能、解耦逻辑, 还可以化身为普通的值, 在其他函数间传递、赋予变量、做类型判断和转换等等, 就像切片和字典的值那样.

而更深层次的含义就是：函数值可以由此成为能够被随意传播的独立逻辑组件(或者说功能模块).

- 高阶函数
    ```go
        package main

        import (
            "errors"
            "fmt"
        )

        type operate func(x, y int) int

        func calculate(x, y int, op operate) (int, error) {
            if op == nil {
                return 0, errs.New("invalid operation")
            }
            return op(x, y), nil
        }

        func calculate(x int, y int, op operate) (int, error) {
            if op == nil {
                return 0, errors.New("invalid operation")
            }
            return op(x, y), nil
        }

        func genCalculator(op operate) calculateFunc {
            return func(x int, y int) (int, error) {
                if op == nil {
                    return 0, errors.New("invalid operation")
                }
                return op(x, y), nil
            }
        }

        func main() {
            x, y = 56, 78

            // 加
            add := func(x, y int) int {
                return x + y
            }
            if result, err := calculate(x, y, add); err == nil {
                fmt.Println(result, err)
            } else {
                fmt.Println("add error")
            }

            // 减
            reduce := func(x, y int) int {
                return x - y
            }
            if result, err := calculate(x, y, reduce); err == nil {
                fmt.Println(result, err)
            } else {
                fmt.Println("reduce error")
            }

            // 乘
            ride := func(x, y int) int {
                return x * y
            }
            if result, err := calculate(x, y, ride); err == nil {
                fmt.Println(result, err)
            } else {
                fmt.Println("ride error")
            }

            // 除
            except := func(x, y int) int {
                return x / y
            }
            if result, err := calculate(x, y, except); err == nil {
                fmt.Println(result, err)
            } else {
                fmt.Println("except error")
            }

            op := func(x, y int) int {
                return x + y
            }
            add1 := genCalculator(op)
            result, err = add1(x, y)
            fmt.Printf("The result: %d (error: %v)\n", result, err)

            op1 := func(x, y int) int {
                return x * y
            }
            multi := genCalculator(op1)
            result, err = multi(x, y)
            fmt.Printf("The multi result: %d (error: %v)\n", result, err)
        }
    ```

从上边的例子可以看出高阶函数满足的两个条件
1. 接受其他的函数作为参数传入；
2. 把其他的函数作为结果返回.

![高阶函数](/img/20220624_1.jpg)

在 Go 语言中, 函数可是一等的(first-class)公民.它既可以被独立声明, 也可以被作为普通的值来传递或赋予变量.除此之外, 我们还可以在其他函数的内部声明匿名函数并把它直接赋给变量.

你需要记住 Go 语言是怎样鉴别一个函数的, 函数的签名在这里起到了至关重要的作用.

函数是 Go 语言支持函数式编程的主要体现.我们可以通过“把函数传给函数”以及“让函数返回函数”来编写高阶函数, 也可以用高阶函数来实现闭包, 并以此做到部分程序逻辑的动态生成.

我们在最后还说了一下关于函数传参的一个注意事项, 这很重要, 可能会关系到程序的稳定和安全.

一个相关的原则是：既不要把你程序的细节暴露给外界, 也尽量不要让外界的变动影响到你的程序.你可以想想这个原则在这里可以起到怎样的指导作用.


