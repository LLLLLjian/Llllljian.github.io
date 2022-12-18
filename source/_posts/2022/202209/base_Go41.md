---
title: Go_基础 (41)
date: 2022-09-02
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(命令模式)

<!-- more -->

#### 命令模式
- 概念

命令模式是一种行为设计模式, 它可将请求转换为一个包含与请求相关的所有信息的独立对象. 该转换让你能根据不同的请求将方法参数化、延迟请求执行或将其放入队列中, 且能实现可撤销操作. 


方法参数化是指将每个请求参数传入具体命令的工厂方法(go语言没有构造函数）创建命令, 同时具体命令会默认设置好接受对象, 这样做的好处是不管请求参数个数及类型, 还是接受对象有几个, 都会被封装到具体命令对象的成员字段上, 并通过统一的Execute接口方法进行调用, 屏蔽各个请求的差异, 便于命令扩展, 多命令组装, 回滚等；

- 示例

控制电饭煲做饭是一个典型的命令模式的场景, 电饭煲的控制面板会提供设置煮粥、蒸饭模式, 及开始和停止按钮, 电饭煲控制系统会根据模式的不同设置相应的火力, 压强及时间等参数；煮粥, 蒸饭就相当于不同的命令, 开始按钮就相当命令触发器, 设置好做饭模式, 点击开始按钮电饭煲就开始运行, 同时还支持停止命令；

- 电饭煲接收器
    ```go
        package command

        import "fmt"

        // ElectricCooker 电饭煲
        type ElectricCooker struct {
            fire     string // 火力
            pressure string // 压力
        }

        // SetFire 设置火力
        func (e *ElectricCooker) SetFire(fire string) {
            e.fire = fire
        }

        // SetPressure 设置压力
        func (e *ElectricCooker) SetPressure(pressure string) {
            e.pressure = pressure
        }

        // Run 持续运行指定时间
        func (e *ElectricCooker) Run(duration string) string {
            return fmt.Sprintf("电饭煲设置火力为%s,压力为%s,持续运行%s;", e.fire, e.pressure, duration)
        }

        // Shutdown 停止
        func (e *ElectricCooker) Shutdown() string {
            return "电饭煲停止运行. "
        }
    ```
- 电饭煲命令
    ```go
        package command

        // CookCommand 做饭指令接口
        type CookCommand interface {
            Execute() string // 指令执行方法
        }

        // steamRiceCommand 蒸饭指令
        type steamRiceCommand struct {
            electricCooker *ElectricCooker // 电饭煲
        }

        func NewSteamRiceCommand(electricCooker *ElectricCooker) *steamRiceCommand {
            return &steamRiceCommand{
                electricCooker: electricCooker,
            }
        }

        func (s *steamRiceCommand) Execute() string {
            s.electricCooker.SetFire("中")
            s.electricCooker.SetPressure("正常")
            return "蒸饭:" + s.electricCooker.Run("30分钟")
        }

        // cookCongeeCommand 煮粥指令
        type cookCongeeCommand struct {
            electricCooker *ElectricCooker
        }

        func NewCookCongeeCommand(electricCooker *ElectricCooker) *cookCongeeCommand {
            return &cookCongeeCommand{
                electricCooker: electricCooker,
            }
        }

        func (c *cookCongeeCommand) Execute() string {
            c.electricCooker.SetFire("大")
            c.electricCooker.SetPressure("强")
            return "煮粥:" + c.electricCooker.Run("45分钟")
        }

        // shutdownCommand 停止指令
        type shutdownCommand struct {
            electricCooker *ElectricCooker
        }

        func NewShutdownCommand(electricCooker *ElectricCooker) *shutdownCommand {
            return &shutdownCommand{
                electricCooker: electricCooker,
            }
        }

        func (s *shutdownCommand) Execute() string {
            return s.electricCooker.Shutdown()
        }

        // ElectricCookerInvoker 电饭煲指令触发器
        type ElectricCookerInvoker struct {
            cookCommand CookCommand
        }

        // SetCookCommand 设置指令
        func (e *ElectricCookerInvoker) SetCookCommand(cookCommand CookCommand) {
            e.cookCommand = cookCommand
        }

        // ExecuteCookCommand 执行指令
        func (e *ElectricCookerInvoker) ExecuteCookCommand() string {
            return e.cookCommand.Execute()
        }
    ```
- 测试程序
    ```go
        package command

        import (
            "fmt"
            "testing"
        )

        func TestCommand(t *testing.T) {
            // 创建电饭煲, 命令接受者
            electricCooker := new(ElectricCooker)
            // 创建电饭煲指令触发器
            electricCookerInvoker := new(ElectricCookerInvoker)

            // 蒸饭
            steamRiceCommand := NewSteamRiceCommand(electricCooker)
            electricCookerInvoker.SetCookCommand(steamRiceCommand)
            fmt.Println(electricCookerInvoker.ExecuteCookCommand())

            // 煮粥
            cookCongeeCommand := NewCookCongeeCommand(electricCooker)
            electricCookerInvoker.SetCookCommand(cookCongeeCommand)
            fmt.Println(electricCookerInvoker.ExecuteCookCommand())

            // 停止
            shutdownCommand := NewShutdownCommand(electricCooker)
            electricCookerInvoker.SetCookCommand(shutdownCommand)
            fmt.Println(electricCookerInvoker.ExecuteCookCommand())
        }
    ```
- 运行结果
    ```
        蒸饭:电饭煲设置火力为中,压力为正常,持续运行30分钟;
        煮粥:电饭煲设置火力为大,压力为强,持续运行45分钟;
        电饭煲停止运行. 
    ```


