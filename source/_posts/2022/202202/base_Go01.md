---
title: Go_基础 (1)
date: 2022-02-14
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-包、变量和函数

<!-- more -->

#### 包

每个 Go 程序都是由包构成的.

程序从 main 包开始运行.

本程序通过导入路径 "fmt" 和 "math/rand" 来使用这两个包.

按照约定, 包名与导入路径的最后一个元素一致.例如, "math/rand" 包中的源码均以 package rand 语句开始.

*注意：* 此程序的运行环境是固定的, 因此 rand.Intn 总是会返回相同的数字. (要得到不同的数字, 需为生成器提供不同的种子数, 参见 rand.Seed. 练习场中的时间为常量, 因此你需要用其它的值作为种子数.)

- code
    ```go
        package main

        import (
            "fmt"
            "math/rand"
        )

        func main() {
            fmt.Println("My favorite number is", rand.Intn(10))
        }
    ```

#### 导入
此代码用圆括号组合了导入, 这是“分组”形式的导入语句.

当然你也可以编写多个导入语句, 例如：
    ```
        import "fmt"
        import "math"
    ```
不过使用分组导入语句是更好的形式.

- code
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        func main() {
            fmt.Printf("Now you have %g problems.\n", math.Sqrt(7))
        }
    ```

#### 导出名
在 Go 中, 如果一个名字以大写字母开头, 那么它就是已导出的.例如, Pizza 就是个已导出名, Pi 也同样, 它导出自 math 包.

pizza 和 pi 并未以大写字母开头, 所以它们是未导出的.

在导入一个包时, 你只能引用其中已导出的名字.任何“未导出”的名字在该包外均无法访问.

执行代码, 观察错误输出.

然后将 math.pi 改名为 math.Pi 再试着执行一次.

- code
    ```go
        package main

        import (
            "fmt"
            "math"
        )

        func main() {
            // fmt.Println(math.pi)
            fmt.Println(math.Pi)
        }
    ```

#### 函数
函数可以没有参数或接受多个参数.

在本例中, add 接受两个 int 类型的参数.

注意类型在变量名 之后.

函数可以返回任意数量的返回值.

Go 的返回值可被命名, 它们会被视作定义在函数顶部的变量.

返回值的名称应当具有一定的意义, 它可以作为文档使用.

没有参数的 return 语句返回已命名的返回值.也就是 直接 返回.

直接返回语句应当仅用在下面这样的短函数中.在长的函数中它们会影响代码的可读性.

- code
    ```go
        package main

        import "fmt"

        func add(x int, y int) int {
            return x + y
        }

        // 当连续两个或多个函数的已命名形参类型相同时, 除最后一个类型以外, 其它都可以省略
        func add1(x, y int) int {
            return x + y
        }

        func swap(x, y string) (string, string) {
            return y, x
        }

        func split(sum int) (x, y int) {
            x = sum * 4 / 9
            y = sum - x
            return
        }

        func main() {
            fmt.Println(add(42, 13))
            fmt.Println(add1(42, 13))
            a, b := swap("hello", "world")
	        fmt.Println(a, b)
            fmt.Println(split(17))
        }
    ```

#### 变量
var 语句用于声明一个变量列表, 跟函数的参数列表一样, 类型在最后.

就像在这个例子中看到的一样, var 语句可以出现在包或函数级别.

- code
    ```go
        package main

        import "fmt"

        var c, python, java bool

        func main() {
            var i int
            fmt.Println(i, c, python, java)
        }
    ```

#### 变量的初始化
变量声明可以包含初始值, 每个变量对应一个.

如果初始化值已存在, 则可以省略类型；变量会从初始值中获得类型.

- code
    ```go
        package main

        import fmt

        var i, j int = 1, 2

        func main() {
            var c, python, java = true, false, "no!"
            fmt.Println(i, j, c, python, java)
        }
    ```


