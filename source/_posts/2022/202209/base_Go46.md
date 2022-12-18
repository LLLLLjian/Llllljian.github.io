---
title: Go_基础 (46)
date: 2022-09-09
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(状态模式)

<!-- more -->

#### 状态模式
- 概念

状态模式是一种行为设计模式, 让你能在一个对象的内部状态变化时改变其行为, 使其看上去就像改变了自身所属的类一样. 


该模式将与状态相关的行为抽取到独立的状态类中, 让原对象将工作委派给这些类的实例, 而不是自行进行处理. 


状态迁移有四个元素组成, 起始状态、触发迁移的事件, 终止状态以及要执行的动作, 每个具体的状态包含触发状态迁移的执行方法, 迁移方法的实现是执行持有状态对象的动作方法, 同时设置状态为下一个流转状态；持有状态的业务对象包含有触发状态迁移方法, 这些迁移方法将请求委托给当前具体状态对象的迁移方法. 

- 示例

IPhone手机充电就是一个手机电池状态的流转, 一开始手机处于有电状态, 插入充电插头后, 继续充电到满电状态, 并进入断电保护, 拔出充电插头后使用手机, 由满电逐渐变为没电, 最终关机；

状态迁移表：

<table style="margin-bottom: 0px;"><tbody><tr><td>起始状态</td><td>触发事件</td><td>终止状态</td><td>执行动作</td></tr><tr><td>有电</td><td>插入充电线</td><td>满电</td><td>充电</td></tr><tr><td>有电</td><td>拔出充电线</td><td>没电</td><td>耗电</td></tr><tr><td>满电</td><td>插入充电线</td><td>满电</td><td>停止充电</td></tr><tr><td>满电</td><td>拔出充电线</td><td>有电</td><td>耗电</td></tr><tr><td>没电</td><td>插入充电线</td><td>有电</td><td>充电</td></tr><tr><td>没电</td><td>拔出充电线</td><td>没电</td><td>关机</td></tr></tbody></table>

- 电池状态
    ```go
        package state

        import "fmt"

        // BatteryState 电池状态接口, 支持手机充电线插拔事件
        type BatteryState interface {
            ConnectPlug(iPhone *IPhone) string
            DisconnectPlug(iPhone *IPhone) string
        }

        // fullBatteryState 满电状态
        type fullBatteryState struct{}

        func (s *fullBatteryState) String() string {
            return "满电状态"
        }

        func (s *fullBatteryState) ConnectPlug(iPhone *IPhone) string {
            return iPhone.pauseCharge()
        }

        func (s *fullBatteryState) DisconnectPlug(iPhone *IPhone) string {
        iPhone.SetBatteryState(PartBatteryState)
            return fmt.Sprintf("%s,%s转为%s", iPhone.consume(), s, PartBatteryState)
        }

        // emptyBatteryState 空电状态
        type emptyBatteryState struct{}

        func (s *emptyBatteryState) String() string {
            return "没电状态"
        }

        func (s *emptyBatteryState) ConnectPlug(iPhone *IPhone) string {
        iPhone.SetBatteryState(PartBatteryState)
            return fmt.Sprintf("%s,%s转为%s", iPhone.charge(), s, PartBatteryState)
        }

        func (s *emptyBatteryState) DisconnectPlug(iPhone *IPhone) string {
            return iPhone.shutdown()
        }

        // partBatteryState 部分电状态
        type partBatteryState struct{}

        func (s *partBatteryState) String() string {
            return "有电状态"
        }

        func (s *partBatteryState) ConnectPlug(iPhone *IPhone) string {
        iPhone.SetBatteryState(FullBatteryState)
            return fmt.Sprintf("%s,%s转为%s", iPhone.charge(), s, FullBatteryState)
        }

        func (s *partBatteryState) DisconnectPlug(iPhone *IPhone) string {
        iPhone.SetBatteryState(EmptyBatteryState)
            return fmt.Sprintf("%s,%s转为%s", iPhone.consume(), s, EmptyBatteryState)
        }
    ```
- IPhone手机
    ```go
        package state

        import "fmt"

        // 电池状态单例, 全局统一使用三个状态的单例, 不需要重复创建
        var (
            FullBatteryState  = new(fullBatteryState)  // 满电
            EmptyBatteryState = new(emptyBatteryState) // 空电
            PartBatteryState  = new(partBatteryState)  // 部分电
        )

        // IPhone 已手机充电为例, 实现状态模式
        type IPhone struct {
            model        string       // 手机型号
            batteryState BatteryState // 电池状态
        }

        // NewIPhone 创建指定型号手机
        func NewIPhone(model string) *IPhone {
            return &IPhone{
                model:        model,
                batteryState: PartBatteryState,
            }
        }

        // BatteryState 输出电池当前状态
        func (i *IPhone) BatteryState() string {
            return fmt.Sprintf("iPhone %s 当前为%s", i.model, i.batteryState)
        }

        // ConnectPlug 连接充电线
        func (i *IPhone) ConnectPlug() string {
            return fmt.Sprintf("iPhone %s 连接电源线,%s", i.model, i.batteryState.ConnectPlug(i))
        }

        // DisconnectPlug 断开充电线
        func (i *IPhone) DisconnectPlug() string {
            return fmt.Sprintf("iPhone %s 断开电源线,%s", i.model, i.batteryState.DisconnectPlug(i))
        }

        // SetBatteryState 设置电池状态
        func (i *IPhone) SetBatteryState(state BatteryState) {
            i.batteryState = state
        }

        func (i *IPhone) charge() string {
            return "正在充电"
        }

        func (i *IPhone) pauseCharge() string {
            return "电已满,暂停充电"
        }

        func (i *IPhone) shutdown() string {
            return "手机关闭"
        }

        func (i *IPhone) consume() string {
            return "使用中,消耗电量"
        }
    ```
- 测试程序
    ```go
        package state

        import (
            "fmt"
            "testing"
        )

        func TestState(t *testing.T) {
            iPhone13Pro := NewIPhone("13 pro") // 刚创建的手机有部分电

            fmt.Println(iPhone13Pro.BatteryState()) // 打印部分电状态
            fmt.Println(iPhone13Pro.ConnectPlug())  // 插上电源插头, 继续充满电
            fmt.Println(iPhone13Pro.ConnectPlug())  // 满电后再充电, 会触发满电保护

            fmt.Println(iPhone13Pro.DisconnectPlug()) // 拔掉电源, 使用手机消耗电量, 变为有部分电
            fmt.Println(iPhone13Pro.DisconnectPlug()) // 一直使用手机, 直到没电
            fmt.Println(iPhone13Pro.DisconnectPlug()) // 没电后会关机

            fmt.Println(iPhone13Pro.ConnectPlug()) // 再次插上电源一会, 变为有电状态
        }
    ```
- 运行结果
    ```
        iPhone 13 pro 当前为有电状态
        iPhone 13 pro 连接电源线,正在充电,有电状态转为满电状态
        iPhone 13 pro 连接电源线,电已满,暂停充电
        iPhone 13 pro 断开电源线,使用中,消耗电量,满电状态转为有电状态
        iPhone 13 pro 断开电源线,使用中,消耗电量,有电状态转为没电状态
        iPhone 13 pro 断开电源线,手机关闭
        iPhone 13 pro 连接电源线,正在充电,没电状态转为有电状态
    ```


