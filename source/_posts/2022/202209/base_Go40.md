---
title: Go_基础 (40)
date: 2022-09-01
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-设计模式(责任链模式)

<!-- more -->

#### 责任链模式
- 概念

责任链模式是一种行为设计模式,  允许你将请求沿着处理者链进行发送. 收到请求后, 每个处理者均可对请求进行处理, 或将其传递给链上的下个处理者. 


该模式允许多个对象来对请求进行处理, 而无需让发送者类与具体接收者类相耦合. 链可在运行时由遵循标准处理者接口的任意处理者动态生成. 

一般意义上的责任链模式是说, 请求在链上流转时任何一个满足条件的节点处理完请求后就会停止流转并返回, 不过还可以根据不同的业务情况做一些改进

* 请求可以流经处理链的所有节点, 不同节点会对请求做不同职责的处理；
* 可以通过上下文参数保存请求对象及上游节点的处理结果, 供下游节点依赖, 并进一步处理；
* 处理链可支持节点的异步处理, 通过实现特定接口判断, 是否需要异步处理；
* 责任链对于请求处理节点可以设置停止标志位, 不是异常, 是一种满足业务流转的中断；
* 责任链的拼接方式存在两种, 一种是节点遍历, 一个节点一个节点顺序执行；另一种是节点嵌套, 内层节点嵌入在外层节点执行逻辑中, 类似递归, 或者“回”行结构；
* 责任链的节点嵌套拼接方式多被称为拦截器链或者过滤器链, 更易于实现业务流程的切面, 比如监控业务执行时长, 日志输出, 权限校验等；

- 示例
1. 办理登机牌
2. 如果有行李, 就办理托运
3. 核实身份
4. 安全检查
5. 完成登机

- 登机过程
    ```go
        package chainofresponsibility

        import "fmt"

        // BoardingProcessor 登机过程中, 各节点统一处理接口
        type BoardingProcessor interface {
            SetNextProcessor(processor BoardingProcessor)
            ProcessFor(passenger *Passenger)
        }

        // Passenger 旅客
        type Passenger struct {
            name                  string // 姓名
            hasBoardingPass       bool   // 是否办理登机牌
            hasLuggage            bool   // 是否有行李需要托运
            isPassIdentityCheck   bool   // 是否通过身份校验
            isPassSecurityCheck   bool   // 是否通过安检
            isCompleteForBoarding bool   // 是否完成登机
        }

        // baseBoardingProcessor 登机流程处理器基类
        type baseBoardingProcessor struct {
            // nextProcessor 下一个登机处理流程
            nextProcessor BoardingProcessor
        }

        // SetNextProcessor 基类中统一实现设置下一个处理器方法
        func (b *baseBoardingProcessor) SetNextProcessor(processor BoardingProcessor) {
            b.nextProcessor = processor
        }

        // ProcessFor 基类中统一实现下一个处理器流转
        func (b *baseBoardingProcessor) ProcessFor(passenger *Passenger) {
            if b.nextProcessor != nil {
                b.nextProcessor.ProcessFor(passenger)
            }
        }

        // boardingPassProcessor 办理登机牌处理器
        type boardingPassProcessor struct {
            baseBoardingProcessor // 引用基类
        }

        func (b *boardingPassProcessor) ProcessFor(passenger *Passenger) {
            if !passenger.hasBoardingPass {
                fmt.Printf("为旅客%s办理登机牌;\n", passenger.name)
                passenger.hasBoardingPass = true
            }
            // 成功办理登机牌后, 进入下一个流程处理
            b.baseBoardingProcessor.ProcessFor(passenger)
        }

        // luggageCheckInProcessor 托运行李处理器
        type luggageCheckInProcessor struct {
            baseBoardingProcessor
        }

        func (l *luggageCheckInProcessor) ProcessFor(passenger *Passenger) {
            if !passenger.hasBoardingPass {
                fmt.Printf("旅客%s未办理登机牌, 不能托运行李;\n", passenger.name)
                return
            }
            if passenger.hasLuggage {
                fmt.Printf("为旅客%s办理行李托运;\n", passenger.name)
            }
            l.baseBoardingProcessor.ProcessFor(passenger)
        }

        // identityCheckProcessor 校验身份处理器
        type identityCheckProcessor struct {
            baseBoardingProcessor
        }

        func (i *identityCheckProcessor) ProcessFor(passenger *Passenger) {
            if !passenger.hasBoardingPass {
                fmt.Printf("旅客%s未办理登机牌, 不能办理身份校验;\n", passenger.name)
                return
            }
            if !passenger.isPassIdentityCheck {
                fmt.Printf("为旅客%s核实身份信息;\n", passenger.name)
                passenger.isPassIdentityCheck = true
            }
            i.baseBoardingProcessor.ProcessFor(passenger)
        }

        // securityCheckProcessor 安检处理器
        type securityCheckProcessor struct {
            baseBoardingProcessor
        }

        func (s *securityCheckProcessor) ProcessFor(passenger *Passenger) {
            if !passenger.hasBoardingPass {
                fmt.Printf("旅客%s未办理登机牌, 不能进行安检;\n", passenger.name)
                return
            }
            if !passenger.isPassSecurityCheck {
                fmt.Printf("为旅客%s进行安检;\n", passenger.name)
                passenger.isPassSecurityCheck = true
            }
            s.baseBoardingProcessor.ProcessFor(passenger)
        }

        // completeBoardingProcessor 完成登机处理器
        type completeBoardingProcessor struct {
            baseBoardingProcessor
        }

        func (c *completeBoardingProcessor) ProcessFor(passenger *Passenger) {
            if !passenger.hasBoardingPass ||
                !passenger.isPassIdentityCheck ||
                !passenger.isPassSecurityCheck {
                fmt.Printf("旅客%s登机检查过程未完成, 不能登机;\n", passenger.name)
                return
            }
            passenger.isCompleteForBoarding = true
            fmt.Printf("旅客%s成功登机;\n", passenger.name)
        }
    ```

- 测试程序
    ```go
        package chainofresponsibility

        import "testing"

        func TestChainOfResponsibility(t *testing.T) {
            boardingProcessor := BuildBoardingProcessorChain()
            passenger := &Passenger{
                name:                  "李四",
                hasBoardingPass:       false,
                hasLuggage:            true,
                isPassIdentityCheck:   false,
                isPassSecurityCheck:   false,
                isCompleteForBoarding: false,
            }
            boardingProcessor.ProcessFor(passenger)
        }

        // BuildBoardingProcessorChain 构建登机流程处理链
        func BuildBoardingProcessorChain() BoardingProcessor {
            completeBoardingNode := &completeBoardingProcessor{}

            securityCheckNode := &securityCheckProcessor{}
            securityCheckNode.SetNextProcessor(completeBoardingNode)

            identityCheckNode := &identityCheckProcessor{}
            identityCheckNode.SetNextProcessor(securityCheckNode)

            luggageCheckInNode := &luggageCheckInProcessor{}
            luggageCheckInNode.SetNextProcessor(identityCheckNode)

            boardingPassNode := &boardingPassProcessor{}
            boardingPassNode.SetNextProcessor(luggageCheckInNode)
            return boardingPassNode
        }
    ```
- 运行结果
    ```
        为旅客李四办理登机牌;
        为旅客李四办理行李托运;
        为旅客李四核实身份信息;
        为旅客李四进行安检;
        旅客李四成功登机;
    ```
