---
title: Go_基础 (6)
date: 2022-02-21
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-更多类型：struct、slice 和映射

<!-- more -->

#### 指针
Go 拥有指针.指针保存了值的内存地址.

类型 *T 是指向 T 类型值的指针.其零值为 nil.
```
var p *int
```
& 操作符会生成一个指向其操作数的指针.
```
i := 42
p = &i
```
\* 操作符表示指针指向的底层值.
```
fmt.Println(*p) // 通过指针 p 读取 i
*p = 21         // 通过指针 p 设置 i
```
这也就是通常所说的“间接引用”或“重定向”.

与 C 不同, Go 没有指针运算.

- code
    ```go
        package main

        import "fmt"

        func main() {
            i, j := 42, 2701

            p := &i         // 指向 i
            fmt.Println(*p) // 通过指针读取 i 的值
            fmt.Println(p)  // 指针指向的底层值
            *p = 21         // 通过指针设置 i 的值
            fmt.Println(i)  // 查看 i 的值

            p = &j         // 指向 j
            *p = *p / 37   // 通过指针对 j 进行除法运算
            fmt.Println(j) // 查看 j 的值
        }
    ```

#### 结构体

一个结构体(struct)就是一组字段(field)

结构体字段使用点号来访问

- code
    ```go
        package main

        import "fmt"

        type Vertex struct {
            X int
            Y int
        }

        func main() {
            v := Vertex{1, 2}
            fmt.Println(v)
            v.X = 4
            fmt.Println(v.X)
            p := &v
            p.X = 1e9
            fmt.Println(v)
        }
    ```

#### 数组

类型 [n]T 表示拥有 n 个 T 类型的值的数组.

表达式
```
var a [10]int
```
会将变量 a 声明为拥有 10 个整数的数组.

数组的长度是其类型的一部分, 因此数组不能改变大小.这看起来是个限制, 不过没关系, Go 提供了更加便利的方式来使用数组.

- code
    ```go
        package main

        import "fmt"

        func main() {
            var a [2]string
            a[0] = "Hello"
            a[1] = "World"
            fmt.Println(a[0], a[1])
            fmt.Println(a)

            primes := [6]int{2, 3, 5, 7, 11, 13}
            fmt.Println(primes)
        }
    ```

#### 切片
每个数组的大小都是固定的.而切片则为数组元素提供动态大小的、灵活的视角.在实践中, 切片比数组更常用.

类型 []T 表示一个元素类型为 T 的切片.

切片通过两个下标来界定, 即一个上界和一个下界, 二者以冒号分隔：
```
a[low : high]
```
它会选择一个半开区间, 包括第一个元素, 但排除最后一个元素.

以下表达式创建了一个切片, 它包含 a 中下标从 1 到 3 的元素：
```
a[1:4]
```

- code
    ```go
        package main

        import "fmt"

        func main() {
            primes := [6]int{2, 3, 5, 7, 11, 13}
            // 左开右闭 [3 5 7]
            var s []int = primes[1:4]
            fmt.Println(s)
        }
    ```

切片并不存储任何数据, 它只是描述了底层数组中的一段.

更改切片的元素会修改其底层数组中对应的元素.

与它共享底层数组的切片都会观测到这些修改.

- code1
    ```go
        package main

        import "fmt"

        func main() {
            names := [4]string{
                "John",
                "Paul",
                "George",
                "Ringo",
            }2
            fmt.Println(names)

            a := names[0:2]
            b := names[1:3]
            fmt.Println(a, b)

            b[0] = "XXX"
            fmt.Println(a, b)
            fmt.Println(names)
        }
    ```

切片拥有 长度 和 容量.

切片的长度就是它所包含的元素个数.

切片的容量是从它的第一个元素开始数, 到其底层数组元素末尾的个数.

切片 s 的长度和容量可通过表达式 len(s) 和 cap(s) 来获取.

你可以通过重新切片来扩展一个切片, 给它提供足够的容量.试着修改示例程序中的切片操作, 向外扩展它的容量, 看看会发生什么.

- code2
    ```go
        package main

        import "fmt"

        func main() {
            s := []int{2, 3, 5, 7, 11, 13}
            printSlice(s)

            // 截取切片使其长度为 0
            s = s[:0]
            printSlice(s)

            // 拓展其长度
            s = s[:4]
            printSlice(s)

            // 舍弃前两个值
            s = s[2:]
            printSlice(s)
        }

        func printSlice(s []int) {
            fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
        }
    ```

#### 用 make 创建切片

切片可以用内建函数 make 来创建, 这也是你创建动态数组的方式.

make 函数会分配一个元素为零值的数组并返回一个引用了它的切片：
```
a := make([]int, 5)  // len(a)=5
```
要指定它的容量, 需向 make 传入第三个参数：
```
b := make([]int, 0, 5) // len(b)=0, cap(b)=5

b = b[:cap(b)] // len(b)=5, cap(b)=5
b = b[1:]      // len(b)=4, cap(b)=4
```

- code
    ```go
        package main

        import "fmt"

        func main() {
            a := make([]int, 5)
            printSlice("a", a)

            b := make([]int, 0, 5)
            printSlice("b", b)

            c := b[:2]
            printSlice("c", c)

            d := c[2:5]
            printSlice("d", d)
        }

        func printSlice(s string, x []int) {
            fmt.Printf("%s len=%d cap=%d %v\n",
                s, len(x), cap(x), x)
        }
    ```

#### 向切片追加元素
为切片追加新的元素是种常用的操作, 为此 Go 提供了内建的 append 函数.内建函数的文档对此函数有详细的介绍.
```
func append(s []T, vs ...T) []T
```
append 的第一个参数 s 是一个元素类型为 T 的切片, 其余类型为 T 的值将会追加到该切片的末尾.

append 的结果是一个包含原切片所有元素加上新添加元素的切片.

当 s 的底层数组太小, 不足以容纳所有给定的值时, 它就会分配一个更大的数组.返回的切片会指向这个新分配的数组.

- code
    ```go
        package main

        import "fmt"

        func main() {
            var s []int
            printSlice(s)

            // 添加一个空切片
            s = append(s, 0)
            printSlice(s)

            // 这个切片会按需增长
            s = append(s, 1)
            printSlice(s)

            // 可以一次性添加多个元素
            s = append(s, 2, 3, 4)
            printSlice(s)
        }

        func printSlice(s []int) {
            fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
        }
    ```

