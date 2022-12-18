---
title: Go_基础 (43)
date: 2022-09-06
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(中介者模式)

<!-- more -->

#### 中介者模式
- 概念

中介者模式是一种行为设计模式, 能让你减少对象之间混乱无序的依赖关系. 该模式会限制对象之间的直接交互, 迫使它们通过一个中介者对象进行合作, 将网状依赖变为星状依赖. 


中介者能使得程序更易于修改和扩展, 而且能更方便地对独立的组件进行复用, 因为它们不再依赖于很多其他的类. 


中介者模式与观察者模式之间的区别是, 中介者模式解决的是同类或者不同类的多个对象之间多对多的依赖关系, 观察者模式解决的是多个对象与一个对象之间的多对一的依赖关系. 

- 示例

机场塔台调度系统是一个体现中介者模式的典型示例, 假设是一个小机场, 每次只能同时允许一架飞机起降, 每架靠近机场的飞机需要先与塔台沟通是否可以降落, 如果没有空闲的跑道, 需要在天空盘旋等待, 如果有飞机离港, 等待的飞机会收到塔台的通知, 按先后顺序降落；这种方式, 免去多架飞机同时到达机场需要相互沟通降落顺序的复杂性, 减少多个飞机间的依赖关系, 简化业务逻辑, 从而降低系统出问题的风险. 

- 飞机对象
    ```go
        package mediator

        import "fmt"

        // Aircraft 飞机接口
        type Aircraft interface {
            ApproachAirport() // 抵达机场空域
            DepartAirport()   // 飞离机场
        }

        // airliner 客机
        type airliner struct {
            name            string          // 客机型号
            airportMediator AirportMediator // 机场调度
        }

        // NewAirliner 根据指定型号及机场调度创建客机
        func NewAirliner(name string, mediator AirportMediator) *airliner {
            return &airliner{
                name:            name,
                airportMediator: mediator,
            }
        }

        func (a *airliner) ApproachAirport() {
            if !a.airportMediator.CanLandAirport(a) { // 请求塔台是否可以降落
                fmt.Printf("机场繁忙, 客机%s继续等待降落;\n", a.name)
                return
            }
            fmt.Printf("客机%s成功滑翔降落机场;\n", a.name)
        }

        func (a *airliner) DepartAirport() {
            fmt.Printf("客机%s成功滑翔起飞, 离开机场;\n", a.name)
            a.airportMediator.NotifyWaitingAircraft() // 通知等待的其他飞机
        }

        // helicopter 直升机
        type helicopter struct {
            name            string
            airportMediator AirportMediator
        }

        // NewHelicopter 根据指定型号及机场调度创建直升机
        func NewHelicopter(name string, mediator AirportMediator) *helicopter {
            return &helicopter{
                name:            name,
                airportMediator: mediator,
            }
        }

        func (h *helicopter) ApproachAirport() {
            if !h.airportMediator.CanLandAirport(h) { // 请求塔台是否可以降落
                fmt.Printf("机场繁忙, 直升机%s继续等待降落;\n", h.name)
                return
            }
            fmt.Printf("直升机%s成功垂直降落机场;\n", h.name)
        }

        func (h *helicopter) DepartAirport() {
            fmt.Printf("直升机%s成功垂直起飞, 离开机场;\n", h.name)
            h.airportMediator.NotifyWaitingAircraft() // 通知其他等待降落的飞机
        }
    ```
- 机场塔台
    ```go
        package mediator

        // AirportMediator 机场调度中介者
        type AirportMediator interface {
            CanLandAirport(aircraft Aircraft) bool // 确认是否可以降落
            NotifyWaitingAircraft()                // 通知等待降落的其他飞机
        }

        // ApproachTower 机场塔台
        type ApproachTower struct {
            hasFreeAirstrip bool
            waitingQueue    []Aircraft // 等待降落的飞机队列
        }

        func (a *ApproachTower) CanLandAirport(aircraft Aircraft) bool {
            if a.hasFreeAirstrip {
                a.hasFreeAirstrip = false
                return true
            }
            // 没有空余的跑道, 加入等待队列
            a.waitingQueue = append(a.waitingQueue, aircraft)
            return false
        }

        func (a *ApproachTower) NotifyWaitingAircraft() {
            if !a.hasFreeAirstrip {
                a.hasFreeAirstrip = true
            }
            if len(a.waitingQueue) > 0 {
                // 如果存在等待降落的飞机, 通知第一个降落
                first := a.waitingQueue[0]
                a.waitingQueue = a.waitingQueue[1:]
                first.ApproachAirport()
            }
        }
    ```
- 测试程序
    ```go
        package mediator

        import "testing"

        func TestMediator(t *testing.T) {
            // 创建机场调度塔台
            airportMediator := &ApproachTower{hasFreeAirstrip: true}
            // 创建C919客机
            c919Airliner := NewAirliner("C919", airportMediator)
            // 创建米-26重型运输直升机
            m26Helicopter := NewHelicopter("米-26", airportMediator)

            c919Airliner.ApproachAirport()  // c919进港降落
            m26Helicopter.ApproachAirport() // 米-26进港等待

            c919Airliner.DepartAirport()  // c919飞离, 等待的米-26进港降落
            m26Helicopter.DepartAirport() // 最后米-26飞离
        }
    ```
- 运行结果
    ```
        客机C919成功滑翔降落机场;
        机场繁忙, 直升机米-26继续等待降落;
        客机C919成功滑翔起飞, 离开机场;
        直升机米-26成功垂直降落机场;
        直升机米-26成功垂直起飞, 离开机场;
    ```


