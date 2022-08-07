---
title: Go_基础 (23)
date: 2022-07-13
tags: Go
toc: true
---

### Go语言核心36讲
    Go语言基础-测试的基本规则和流程 

<!-- more -->

#### 测试的基本规则和流程
- Go 语言对测试函数的名称和签名都有哪些规定
    * 对于功能测试函数来说,其名称必须以Test为前缀,并且参数列表中只应有一个*testing.T类型的参数声明.
    * 对于性能测试函数来说,其名称必须以Benchmark为前缀,并且唯一参数的类型必须是*testing.B类型的.
    * 对于示例测试函数来说,其名称必须以Example为前缀,但对函数的参数列表没有强制规定.
- go test命令执行的主要测试流程是什么
    ```go
        // demo52.go
        package main

        import (
            "errors"
            "flag"
            "fmt"
        )

        var name string

        func init() {
            flag.StringVar(&name, "name", "everyone", "The greeting object.")
        }

        func main() {
            flag.Parse()
            greeting, err := hello(name)
            if err != nil {
                fmt.Printf("error: %s\n", err)
                return
            }
            fmt.Println(greeting, introduce())
        }

        // hello 用于生成问候内容.
        func hello(name string) (string, error) {
            if name == "" {
                return "", errors.New("empty name")
            }
            return fmt.Sprintf("Hello, %s!", name), nil
        }

        // introduce 用于生成介绍内容.
        func introduce() string {
            return "Welcome to my Golang column."
        }

        // demo52_test.go
        package main

        import (
            "fmt"
            "testing"
        )

        func TestHello(t *testing.T) {
            var name string
            greeting, err := hello(name)
            if err == nil {
                t.Errorf("The error is nil, but it should not be. (name=%q)",
                    name)
            }
            if greeting != "" {
                t.Errorf("Nonempty greeting, but it should not be. (name=%q)",
                    name)
            }
            name = "Robert"
            greeting, err = hello(name)
            if err != nil {
                t.Errorf("The error is not nil, but it should be. (name=%q)",
                    name)
            }
            if greeting == "" {
                t.Errorf("Empty greeting, but it should not be. (name=%q)",
                    name)
            }
            expected := fmt.Sprintf("Hello, %s!", name)
            if greeting != expected {
                t.Errorf("The actual greeting %q is not the expected. (name=%q)",
                    greeting, name)
            }
            t.Logf("The expected greeting is %q.\n", expected)
        }

        func testIntroduce(t *testing.T) { // 请注意这个测试函数的名称.
            intro := introduce()
            expected := "Welcome to my Golang column."
            if intro != expected {
                t.Errorf("The actual introduce %q is not the expected.",
                    intro)
            }
            t.Logf("The expected introduce is %q.\n", expected)
        }
    ```
    * 执行结果
        ```
            go test
            PASS
            ok      mani/test           0.023s
        ```
    * 执行结果分析
        * 只有测试源码文件的名称对了,测试函数的名称和签名也对了,当我们运行go test命令的时候,其中的测试代码才有可能被运行.所以testIntroduce不会被执行
        * go test命令在开始运行时,会先做一些准备工作,比如,确定内部需要用到的命令,检查我们指定的代码包或源码文件的有效性,以及判断我们给予的标记是否合法,等等.
        * 在准备工作顺利完成之后,go test命令就会针对每个被测代码包,依次地进行构建、执行包中符合要求的测试函数,清理临时文件,打印测试结果.这就是通常情况下的主要测试流程.
        * 请注意上述的“依次”二字.对于每个被测代码包,go test命令会串行地执行测试流程中的每个步骤.
        * 但是,为了加快测试速度,它通常会并发地对多个被测代码包进行功能测试,只不过,在最后打印测试结果的时候,它会依照我们给定的顺序逐个进行,这会让我们感觉到它是在完全串行地执行测试流程.
        * 另一方面,由于并发的测试会让性能测试的结果存在偏差,所以性能测试一般都是串行进行的.更具体地说,只有在所有构建步骤都做完之后,go test命令才会真正地开始进行性能测试.
        * 并且,下一个代码包性能测试的进行,总会等到上一个代码包性能测试的结果打印完成才会开始,而且性能测试函数的执行也都会是串行的.






