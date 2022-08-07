---
title: Go_基础 (26)
date: 2022-07-20
tags: Go
toc: true
---

### Go语言核心36讲
    sync.Mutex与sync.RWMutex

<!-- more -->

#### 前导内容

说起Go 大家首先想到的就是并发,那么需要先了解一些关于并发的关键词

**竞态条件**: 一旦数据被多个线程共享,那么就很可能会产生争用和冲突的情况

**临界区**: 多个并发运行的线程对这个共享资源的访问是完全串行的.只要一个代码片段需要实现对共享资源的串行化访问,就可以被视为一个临界区

**同步工具**: 临界区总是需要受到保护的,否则就会产生竞态条件.施加保护的重要手段之一,就是使用实现了某种同步机制的工具,也称为同步工具

**同步**: 同步的用途有两个,一个是避免多个线程在同一时刻操作同一个数据块,另一个是协调多个线程,以避免它们在同一时刻执行同一个代码块.

![竞态条件、临界区与同步工具](/img/20220720_1.PNG)

- demo58.go
    ```go
        package main

        import (
            "bytes"
            "flag"
            "fmt"
            "io"
            "io/ioutil"
            "log"
            "sync"
        )

        // protecting 用于指示是否使用互斥锁来保护数据写入.
        // 若值等于0则表示不使用,若值大于0则表示使用.
        // 改变该变量的值,然后多运行几次程序,并观察程序打印的内容.
        var protecting uint

        func init() {
            flag.UintVar(&protecting, "protecting", 1,
                "It indicates whether to use a mutex to protect data writing.")
        }

        func main() {
            flag.Parse()
            // buffer 代表缓冲区.
            var buffer bytes.Buffer

            const (
                max1 = 5  // 代表启用的goroutine的数量.
                max2 = 10 // 代表每个goroutine需要写入的数据块的数量.
                max3 = 10 // 代表每个数据块中需要有多少个重复的数字.
            )

            // mu 代表以下流程要使用的互斥锁.
            var mu sync.Mutex
            // sign 代表信号的通道.
            sign := make(chan struct{}, max1)

            for i := 1; i <= max1; i++ {
                go func(id int, writer io.Writer) {
                    defer func() {
                        sign <- struct{}{}
                    }()
                    for j := 1; j <= max2; j++ {
                        // 准备数据.
                        header := fmt.Sprintf("\n[id: %d, iteration: %d]",
                            id, j)
                        data := fmt.Sprintf(" %d", id*j)
                        // 写入数据.
                        if protecting > 0 {
                            mu.Lock()
                        }
                        _, err := writer.Write([]byte(header))
                        if err != nil {
                            log.Printf("error: %s [%d]", err, id)
                        }
                        for k := 0; k < max3; k++ {
                            _, err := writer.Write([]byte(data))
                            if err != nil {
                                log.Printf("error: %s [%d]", err, id)
                            }
                        }
                        if protecting > 0 {
                            mu.Unlock()
                        }
                    }
                }(i, &buffer)
            }

            for i := 0; i < max1; i++ {
                <-sign
            }
            data, err := ioutil.ReadAll(&buffer)
            if err != nil {
                log.Fatalf("fatal error: %s", err)
            }
            log.Printf("The contents:\n%s", data)
        }
    ```
- demo59.go
    ```go
        package main

        import (
            "bytes"
            "errors"
            "fmt"
            "io"
            "log"
            "sync"
            "time"
        )

        // singleHandler 代表单次处理函数的类型.
        type singleHandler func() (data string, n int, err error)

        // handlerConfig 代表处理流程配置的类型.
        type handlerConfig struct {
            handler   singleHandler // 单次处理函数.
            goNum     int           // 需要启用的goroutine的数量.
            number    int           // 单个goroutine中的处理次数.
            interval  time.Duration // 单个goroutine中的处理间隔时间.
            counter   int           // 数据量计数器,以字节为单位.
            counterMu sync.Mutex    // 数据量计数器专用的互斥锁.

        }

        // count 会增加计数器的值,并会返回增加后的计数.
        func (hc *handlerConfig) count(increment int) int {
            hc.counterMu.Lock()
            defer hc.counterMu.Unlock()
            hc.counter += increment
            return hc.counter
        }

        func main() {
            // mu 代表以下流程要使用的互斥锁.
            // 在下面的函数中直接使用即可,不要传递.
            var mu sync.Mutex

            // genWriter 代表的是用于生成写入函数的函数.
            genWriter := func(writer io.Writer) singleHandler {
                return func() (data string, n int, err error) {
                    // 准备数据.
                    data = fmt.Sprintf("%s\t",
                        time.Now().Format(time.StampNano))
                    // 写入数据.
                    mu.Lock()
                    defer mu.Unlock()
                    n, err = writer.Write([]byte(data))
                    return
                }
            }

            // genReader 代表的是用于生成读取函数的函数.
            genReader := func(reader io.Reader) singleHandler {
                return func() (data string, n int, err error) {
                    buffer, ok := reader.(*bytes.Buffer)
                    if !ok {
                        err = errors.New("unsupported reader")
                        return
                    }
                    // 读取数据.
                    mu.Lock()
                    defer mu.Unlock()
                    data, err = buffer.ReadString('\t')
                    n = len(data)
                    return
                }
            }

            // buffer 代表缓冲区.
            var buffer bytes.Buffer

            // 数据写入配置.
            writingConfig := handlerConfig{
                handler:  genWriter(&buffer),
                goNum:    5,
                number:   4,
                interval: time.Millisecond * 100,
            }
            // 数据读取配置.
            readingConfig := handlerConfig{
                handler:  genReader(&buffer),
                goNum:    10,
                number:   2,
                interval: time.Millisecond * 100,
            }

            // sign 代表信号的通道.
            sign := make(chan struct{}, writingConfig.goNum+readingConfig.goNum)

            // 启用多个goroutine对缓冲区进行多次数据写入.
            for i := 1; i <= writingConfig.goNum; i++ {
                go func(i int) {
                    defer func() {
                        sign <- struct{}{}
                    }()
                    for j := 1; j <= writingConfig.number; j++ {
                        time.Sleep(writingConfig.interval)
                        data, n, err := writingConfig.handler()
                        if err != nil {
                            log.Printf("writer [%d-%d]: error: %s",
                                i, j, err)
                            continue
                        }
                        total := writingConfig.count(n)
                        log.Printf("writer [%d-%d]: %s (total: %d)",
                            i, j, data, total)
                    }
                }(i)
            }

            // 启用多个goroutine对缓冲区进行多次数据读取.
            for i := 1; i <= readingConfig.goNum; i++ {
                go func(i int) {
                    defer func() {
                        sign <- struct{}{}
                    }()
                    for j := 1; j <= readingConfig.number; j++ {
                        time.Sleep(readingConfig.interval)
                        var data string
                        var n int
                        var err error
                        for {
                            data, n, err = readingConfig.handler()
                            if err == nil || err != io.EOF {
                                break
                            }
                            // 如果读比写快(读时会发生EOF错误),那就等一会儿再读.
                            time.Sleep(readingConfig.interval)
                        }
                        if err != nil {
                            log.Printf("reader [%d-%d]: error: %s",
                                i, j, err)
                            continue
                        }
                        total := readingConfig.count(n)
                        log.Printf("reader [%d-%d]: %s (total: %d)",
                            i, j, data, total)
                    }
                }(i)
            }

            // signNumber 代表需要接收的信号的数量.
            signNumber := writingConfig.goNum + readingConfig.goNum
            // 等待上面启用的所有goroutine的运行全部结束.
            for j := 0; j < signNumber; j++ {
                <-sign
            }
        }
    ```
