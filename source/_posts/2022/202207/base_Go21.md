---
title: Go_基础 (21)
date: 2022-07-01
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-错误处理

<!-- more -->

#### 错误处理
> 卫述语句： 被用来检查后续操作的前置条件并进行相应处理的语句.

error类型其实是一个接口类型, 也是一个 Go 语言的内建类型.在这个接口类型的声明中只包含了一个方法Error.

Error方法不接受任何参数, 但是会返回一个string类型的结果.它的作用是返回错误信息的字符串表示形式.

我们使用error类型的方式通常是, 在函数声明的结果列表的最后, 声明一个该类型的结果, 同时在调用这个函数之后, 先判断它返回的最后一个结果值是否“不为nil”.

如果这个值“不为nil”, 那么就进入错误处理流程, 否则就继续进行正常的流程.

- 代码分析
    ```go
        package main

        import (
            "errors"
            "fmt"
        )

        func echo(request string) (response string, err error) {
            if request == "" {
                err = errors.New("empty request")
                return
            }
            response = fmt.Sprintf("echo: %s", request)
            return
        }

        func main() {
            for _, req := range []string{"", "hello!"} {
                fmt.Printf("request: %s\n", req)
                resp, err := echo(req)
                if err != nil {
                fmt.Printf("error: %s\n", err)
                continue
                }
                fmt.Printf("response: %s\n", resp)
            }
        }
    ```

- Q: 怎样判断一个错误值具体代表的是哪一类错误
    * 对于类型在已知范围内的一系列错误值, 一般使用类型断言表达式或类型switch语句来判断；
    * 对于已有相应变量且类型相同的一系列错误值, 一般直接使用判等操作来判断；
    * 对于没有相应变量且类型未知的一系列错误值, 只能使用其错误信息的字符串表示形式来做判断.

- demo45.go
    ```go
        package main

        import (
            "fmt"
            "os"
            "os/exec"
            "runtime"
        )

        // underlyingError 会返回已知的操作系统相关错误的潜在错误值.
        func underlyingError(err error) error {
            switch err := err.(type) {
            case *os.PathError:
                return err.Err
            case *os.LinkError:
                return err.Err
            case *os.SyscallError:
                return err.Err
            case *exec.Error:
                return err.Err
            }
            return err
        }

        func main() {
            // 示例1.
            r, w, err := os.Pipe()
            if err != nil {
                fmt.Printf("unexpected error: %s\n", err)
                return
            }
            // 人为制造 *os.PathError 类型的错误.
            r.Close()
            _, err = w.Write([]byte("hi"))
            uError := underlyingError(err)
            fmt.Printf("underlying error: %s (type: %T)\n",
                uError, uError)
            fmt.Println()

            // 示例2.
            paths := []string{
                os.Args[0],           // 当前的源码文件或可执行文件.
                "/it/must/not/exist", // 肯定不存在的目录.
                os.DevNull,           // 肯定存在的目录.
            }
            printError := func(i int, err error) {
                if err == nil {
                    fmt.Println("nil error")
                    return
                }
                err = underlyingError(err)
                switch err {
                case os.ErrClosed:
                    fmt.Printf("error(closed)[%d]: %s\n", i, err)
                case os.ErrInvalid:
                    fmt.Printf("error(invalid)[%d]: %s\n", i, err)
                case os.ErrPermission:
                    fmt.Printf("error(permission)[%d]: %s\n", i, err)
                }
            }
            var f *os.File
            var index int
            {
                index = 0
                f, err = os.Open(paths[index])
                if err != nil {
                    fmt.Printf("unexpected error: %s\n", err)
                    return
                }
                // 人为制造潜在错误为 os.ErrClosed 的错误.
                f.Close()
                _, err = f.Read([]byte{})
                printError(index, err)
            }
            {
                index = 1
                // 人为制造 os.ErrInvalid 错误.
                f, _ = os.Open(paths[index])
                _, err = f.Stat()
                printError(index, err)
            }
            {
                index = 2
                // 人为制造潜在错误为 os.ErrPermission 的错误.
                _, err = exec.LookPath(paths[index])
                printError(index, err)
            }
            if f != nil {
                f.Close()
            }
            fmt.Println()

            // 示例3.
            paths2 := []string{
                runtime.GOROOT(),     // 当前环境下的Go语言根目录.
                "/it/must/not/exist", // 肯定不存在的目录.
                os.DevNull,           // 肯定存在的目录.
            }
            printError2 := func(i int, err error) {
                if err == nil {
                    fmt.Println("nil error")
                    return
                }
                err = underlyingError(err)
                if os.IsExist(err) {
                    fmt.Printf("error(exist)[%d]: %s\n", i, err)
                } else if os.IsNotExist(err) {
                    fmt.Printf("error(not exist)[%d]: %s\n", i, err)
                } else if os.IsPermission(err) {
                    fmt.Printf("error(permission)[%d]: %s\n", i, err)
                } else {
                    fmt.Printf("error(other)[%d]: %s\n", i, err)
                }
            }
            {
                index = 0
                err = os.Mkdir(paths2[index], 0700)
                printError2(index, err)
            }
            {
                index = 1
                f, err = os.Open(paths[index])
                printError2(index, err)
            }
            {
                index = 2
                _, err = exec.LookPath(paths[index])
                printError2(index, err)
            }
            if f != nil {
                f.Close()
            }
        }
    ```

