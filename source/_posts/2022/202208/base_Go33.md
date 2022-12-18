---
title: Go_基础 (33)
date: 2022-08-23
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-泛型

<!-- more -->

#### 泛型是什么
1. 泛型生命周期只在编译期, 旨在为程序员生成代码, 减少重复代码的编写
2. 在比较两个数的大小时, 没有泛型的时候, 仅仅只是传入类型不一样, 我们就要再写一份一模一样的函数, 如果有了泛型就可以减少这类代码

```go
    // int
    func GetMaxNumInt(a, b int) int {
        if a > b {
            return a
        }

        return b
    }

    // int8
    func GetMaxNumInt8(a, b int8) int8 {
        if a > b {
            return a
        }

        return b
    }
```

#### 泛型简单实用
1. 修改一下上面的例子
    ```go
        // 使用泛型
        func GetMaxNum[T int | int8](a, b T) T {
            if a > b {
                return a
            }
            return b
        }
    ```
2. 使用自定义泛型
    ```go
        // 像声明接口一样声明
        type MyInt interface {
            int | int8 | int16 | int32 | int64
        }

        // T的类型为声明的MyInt
        func GetMaxNum[T MyInt](a, b T) T {
            if a > b {
                return a
            }

            return b
        }
    ```
3. 调用带泛型的函数
    ```go
        var a int = 10
        var b int = 20

        // 方法1, 正常调用, 编译器会自动推断出传入类型是int
        GetMaxNum(a, b)

        // 方法2, 显式告诉函数传入的类型是int
        GetMaxNum[int](a, b)
    ```

#### 泛型和结构体联合使用
> 创建一个带有泛型的结构体User, 提供两个获取age和name的方法
> 注意：只有在结构体上声明了泛型, 结构体方法中才可以使用泛型

- demo1
    ```go
        type AgeT interface {
            int8 | int16
        }

        type NameE interface {
            string
        }

        type User[T AgeT, E NameE] struct {
            age  T
            name E
        }

        // 获取age
        func (u *User[T, E]) GetAge() T {
            return u.age
        }


        // 获取name
        func (u *User[T, E]) GetName() E {
            return u.name
        }

        // 声明要使用的泛型的类型
        var u User[int8, string]

        // 赋值
        u.age = 18
        u.name = "weiwei"

        // 调用方法
        age := u.GetAge()
        name := u.GetName()

        // 输出结果 18 weiwei
        fmt.Println(age, name) 
    ```
- demo2
    ```go
        func SumInts(m map[string]int) int {
            var s int
            for _, v := range m {
                s += v
            }
            return s
        }

        func SumFloats(m map[string]float64) float64 {
            var s float64
            for _, v := range m {
                s += v
            }
            return s
        }

        func SumIntsOrFloats[K comparable, V int | float64](m map[K]V) V {
            var s V
            for _, v := range m {
                s += v
            }
            return s
        }

        type Number interface{
            int | float64
        }

        func SumNumbers[K comparable, V Number](m map[K]V) V {
            var s V
            for _, v := range m {
                s += v
            }
            return s
        }

        func main() {
            ints := map[string]int{
                "first":  34,
                "second": 12,
            }

            floats := map[string]float64{
                "first":  35.98,
                "second": 26.99,
            }

            fmt.Printf("非泛型计算结果, SumInts: %v, SumFloats: %v\n", SumInts(ints), SumFloats(floats))

            fmt.Printf("泛型计算结果, Ints 结果: Floats 结果: %v\n", SumIntsOrFloats[string, int](ints), SumIntsOrFloats[string, float64](floats))

            fmt.Printf("泛型计算结果, Ints 结果: Floats 结果: %v\n", SumIntsOrFloats(ints), SumIntsOrFloats(floats))

            fmt.Printf(
                "泛型计算结果(带 Constraint), Ints 结果: %v, Floats 结果: %v\n",
                SumNumbers(ints),
                SumNumbers(floats),
            )
        }
    ```

