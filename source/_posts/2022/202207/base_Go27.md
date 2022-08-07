---
title: Go_基础 (27)
date: 2022-07-21
tags: Go
toc: true
---

### Go语言核心36讲
    条件变量sync.Cond 

<!-- more -->

#### 条件变量sync.Cond

条件变量是基于互斥锁的,它必须有互斥锁的支撑才能发挥作用

条件变量并不是呗用来保护临界区和共享资源的,它是用于协调想要访问共享资源的那些线程的.当共享资源的状态发生变化是,它可以被用来通知被互斥锁阻塞的线程

- demo61.go
    ```go
        package main

        import (
            "log"
            "sync"
            "time"
        )

        func main() {
            // mailbox 代表信箱.
            // 0代表信箱是空的,1代表信箱是满的.
            var mailbox uint8
            // lock 代表信箱上的锁.
            var lock sync.RWMutex
            // sendCond 代表专用于发信的条件变量.
            sendCond := sync.NewCond(&lock)
            // recvCond 代表专用于收信的条件变量.
            recvCond := sync.NewCond(lock.RLocker())

            // sign 用于传递演示完成的信号.
            sign := make(chan struct{}, 3)
            max := 5
            go func(max int) { // 用于发信.
                defer func() {
                    sign <- struct{}{}
                }()
                for i := 1; i <= max; i++ {
                    time.Sleep(time.Millisecond * 500)
                    lock.Lock()
                    for mailbox == 1 {
                        sendCond.Wait()
                    }
                    log.Printf("sender [%d]: the mailbox is empty.", i)
                    mailbox = 1
                    log.Printf("sender [%d]: the letter has been sent.", i)
                    lock.Unlock()
                    recvCond.Signal()
                }
            }(max)
            go func(max int) { // 用于收信.
                defer func() {
                    sign <- struct{}{}
                }()
                for j := 1; j <= max; j++ {
                    time.Sleep(time.Millisecond * 500)
                    lock.RLock()
                    for mailbox == 0 {
                        recvCond.Wait()
                    }
                    log.Printf("receiver [%d]: the mailbox is full.", j)
                    mailbox = 0
                    log.Printf("receiver [%d]: the letter has been received.", j)
                    lock.RUnlock()
                    sendCond.Signal()
                }
            }(max)

            <-sign
            <-sign
        }
    ```
- demo62.go
    ```go
        package main

        import (
            "log"
            "sync"
            "time"
        )

        func main() {
            // mailbox 代表信箱.
            // 0代表信箱是空的,1代表信箱是满的.
            var mailbox uint8
            // lock 代表信箱上的锁.
            var lock sync.Mutex
            // sendCond 代表专用于发信的条件变量.
            sendCond := sync.NewCond(&lock)
            // recvCond 代表专用于收信的条件变量.
            recvCond := sync.NewCond(&lock)

            // send 代表用于发信的函数.
            send := func(id, index int) {
                lock.Lock()
                for mailbox == 1 {
                    sendCond.Wait()
                }
                log.Printf("sender [%d-%d]: the mailbox is empty.",
                    id, index)
                mailbox = 1
                log.Printf("sender [%d-%d]: the letter has been sent.",
                    id, index)
                lock.Unlock()
                recvCond.Broadcast()
            }

            // recv 代表用于收信的函数.
            recv := func(id, index int) {
                lock.Lock()
                for mailbox == 0 {
                    recvCond.Wait()
                }
                log.Printf("receiver [%d-%d]: the mailbox is full.",
                    id, index)
                mailbox = 0
                log.Printf("receiver [%d-%d]: the letter has been received.",
                    id, index)
                lock.Unlock()
                sendCond.Signal() // 确定只会有一个发信的goroutine.
            }

            // sign 用于传递演示完成的信号.
            sign := make(chan struct{}, 3)
            max := 6
            go func(id, max int) { // 用于发信.
                defer func() {
                    sign <- struct{}{}
                }()
                for i := 1; i <= max; i++ {
                    time.Sleep(time.Millisecond * 500)
                    send(id, i)
                }
            }(0, max)
            go func(id, max int) { // 用于收信.
                defer func() {
                    sign <- struct{}{}
                }()
                for j := 1; j <= max; j++ {
                    time.Sleep(time.Millisecond * 200)
                    recv(id, j)
                }
            }(1, max/2)
            go func(id, max int) { // 用于收信.
                defer func() {
                    sign <- struct{}{}
                }()
                for k := 1; k <= max; k++ {
                    time.Sleep(time.Millisecond * 200)
                    recv(id, k)
                }
            }(2, max/2)

            <-sign
            <-sign
            <-sign
        }
    ```

带着两个问题来比较demo61和demo62的差异之处
- 条件变量的Wait方法做了什么
    * 把调用它的 goroutine(也就是当前的 goroutine)加入到当前条件变量的通知队列中.
    * 解锁当前的条件变量基于的那个互斥锁.
    * 让当前的 goroutine 处于等待状态,等到通知到来时再决定是否唤醒它.此时,这个 goroutine 就会阻塞在调用这个Wait方法的那行代码上.
    * 如果通知到来并且决定唤醒这个 goroutine,那么就在唤醒它之后重新锁定当前条件变量基于的互斥锁.自此之后,当前的 goroutine 就会继续执行后面的代码了.
    * 因为条件变量的Wait方法在阻塞当前的 goroutine 之前,会解锁它基于的互斥锁,所以在调用该Wait方法之前,我们必须先锁定那个互斥锁,否则在调用这个Wait方法时,就会引发一个不可恢复的 panic.
    * 为什么条件变量的Wait方法要这么做呢？你可以想象一下,如果Wait方法在互斥锁已经锁定的情况下,阻塞了当前的 goroutine,那么又由谁来解锁呢？别的 goroutine 吗？
    * 先不说这违背了互斥锁的重要使用原则,即：成对的锁定和解锁,就算别的 goroutine 可以来解锁,那万一解锁重复了怎么办？由此引发的 panic 可是无法恢复的.
    * 如果当前的 goroutine 无法解锁,别的 goroutine 也都不来解锁,那么又由谁来进入临界区,并改变共享资源的状态呢？只要共享资源的状态不变,即使当前的 goroutine 因收到通知而被唤醒,也依然会再次执行这个Wait方法,并再次被阻塞.
    * 所以说,如果条件变量的Wait方法不先解锁互斥锁的话,那么就只会造成两种后果：不是当前的程序因 panic 而崩溃,就是相关的 goroutine 全面阻塞.
    * 为什么用for而不是if
        * 这主要是为了保险起见.如果一个 goroutine 因收到通知而被唤醒,但却发现共享资源的状态,依然不符合它的要求,那么就应该再次调用条件变量的Wait方法,并继续等待下次通知的到来.
- 条件变量的Signal方法和Broadcast方法有哪些异同
    * 条件变量的Signal方法和Broadcast方法都是被用来发送通知的,不同的是,前者的通知只会唤醒一个因此而等待的 goroutine,而后者的通知却会唤醒所有为此等待的 goroutine.
    * 条件变量的Wait方法总会把当前的 goroutine 添加到通知队列的队尾,而它的Signal方法总会从通知队列的队首开始,查找可被唤醒的 goroutine.所以,因Signal方法的通知,而被唤醒的 goroutine 一般都是最早等待的那一个.
    * 这两个方法的行为决定了它们的适用场景.如果你确定只有一个 goroutine 在等待通知,或者只需唤醒任意一个 goroutine 就可以满足要求,那么使用条件变量的Signal方法就好了.
    * 否则,使用Broadcast方法总没错,只要你设置好各个 goroutine 所期望的共享资源状态就可以了.

