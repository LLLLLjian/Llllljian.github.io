---
title: Go_基础 (13)
date: 2022-03-18
tags: Go
toc: true
---

### Go基础学习
    Go基础学习-Cobra

<!-- more -->

#### 前情提要
> Cobra既是用于创建强大的现代CLI应用程序的库,也是用于生成应用程序和命令文件的程序.
有多强呢,我列举一下优秀的开源项目中用到Cobra的

    ```
        Kubernetes
        Hugo
        rkt
        etcd
        Moby (former Docker)
        Docker (distribution)
        OpenShift
        Delve
        GopherJS
        CockroachDB
        Bleve
        ProjectAtomic (enterprise)
        GiantSwarm's swarm
        Nanobox/Nanopack
        rclone
        nehm
        Pouch
    ```

#### Cobra的安装
> 首先,通过go get下载cobra

```
    go get -v github.com/spf13/cobra/cobra
    go install
```

#### 初始化项目
- 在命令行下运行下cobra命令
    ```bash
        $ cobra
        Cobra is a CLI library for Go that empowers applications.
        This application is a tool to generate the needed files
        to quickly create a Cobra application.

        Usage:
        cobra [command]

        Available Commands:
        add         Add a command to a Cobra Application
        completion  generate the autocompletion script for the specified shell
        help        Help about any command
        init        Initialize a Cobra Application

        Flags:
        -a, --author string    author name for copyright attribution (default "YOUR NAME")
            --config string    config file (default is $HOME/.cobra.yaml)
        -h, --help             help for cobra
        -l, --license string   name of license for the project
            --viper            use Viper for configuration (default true)

        Use "cobra [command] --help" for more information about a command.
    ```
- 创建命令程序
    ```bash
        $ cobra init testcobra --pkg-name=testcobra
        Your Cobra application is ready at
        /Users/llllljian/Desktop/code/test/go/testcobra
    ```
- 当前目录结构
    ```bash
        $ pwd
        /Users/llllljian/Desktop/code/test/go/testcobra
        $ tree
        .
        |____cmd
        | |____root.go
        |____LICENSE
        |____main.go
    ```

#### 代码分析
- main.go
    ```go
        package main

        import "testcobra/cmd"

        func main() {
            cmd.Execute()
        }
    ```
- root.go
    ```go
        ...
        var rootCmd = &cobra.Command{
            // 命令名
            Use:   "testcobra",
            // 帮助信息的文字内容
            Short: "A brief description of your application",
            // 帮助信息的文字内容
            Long: `A longer description that spans multiple lines and likely contains
        examples and usage of using your application. For example:

        Cobra is a CLI library for Go that empowers applications.
        This application is a tool to generate the needed files
        to quickly create a Cobra application.`,
            // Uncomment the following line if your bare application
            // has an action associated with it:
            // Run: func(cmd *cobra.Command, args []string) { },
        }
        ...
    ```
- 运行测试
    ```bash
        $ go run main.go
        A longer description that spans multiple lines and likely contains
        examples and usage of using your application. For example:

        Cobra is a CLI library for Go that empowers applications.
        This application is a tool to generate the needed files
        to quickly create a Cobra application.
    ```
    * 如果运行的结果和我的一致,那我们就可以进入到实践环节了

#### 实践
- 添加命令
    ```bash
        $ cobra add create
        create created at /Users/llllljian/Desktop/code/test/go/testcobra

        $ tree
        .
        |____cmd
        | |____create.go
        | |____root.go
        |____go.mod
        |____LICENSE
        |____go.sum
        |____main.go

        $ cat cmd/create.go
        ...
        func init() {
            rootCmd.AddCommand(createCmd)        
        }   
    ```
- 运行测试
    ```bash
        $ go run main.go create
        create called

        # 未知命令
        $ go run main.go creat
        Error: unknown command "creat" for "testcobra"

        Did you mean this?
                create

        Run 'testcobra --help' for usage.
        Error: unknown command "creat" for "testcobra"

        Did you mean this?
                create

        exit status 1s
    ```
- 添加子命令
    ```bash
        $ cobra add rule
        Your Cobra application is ready at
        /Users/llllljian/Desktop/code/test/go/testcobra
        
        $ tree
        .
        |____cmd
        | |____create.go
        | |____rule.go
        | |____root.go
        |____go.mod
        |____LICENSE
        |____go.sum
        |____main.go

        $ vim cmd/rule.go
        ...

        func init() {
                // 修改子命令的层级关系
                //rootCmd.AddCommand(ruleCmd)
                createCmd.AddCommand(ruleCmd)
        }

        $ go run main.go create -h
        A longer description that spans multiple lines and likely contains examples
        and usage of using your command. For example:

        Cobra is a CLI library for Go that empowers applications.
        This application is a tool to generate the needed files
        to quickly create a Cobra application.

        Usage:
        testcobra create [flags]
        testcobra create [command]

        Available Commands:
        rule        A brief description of your command

        Flags:
        -h, --help   help for create

        Global Flags:
            --config string   config file (default is $HOME/.testcobra.yaml)

        Use "testcobra create [command] --help" for more information about a command.
    ```
- 参数
    * 内置验证方式
        * NoArgs：如果有任何参数,命令行将会报错
        * ArbitraryArgs： 命令行将会接收任何参数
        * OnlyValidArgs： 如果有如何参数不属于 Command 的 ValidArgs 字段,命令行将会报错
        * MinimumNArgs(int)： 如果参数个数少于 N 个,命令行将会报错
        * MaximumNArgs(int)： 如果参数个数多于 N 个,命令行将会报错
        * ExactArgs(int)： 如果参数个数不等于 N 个,命令行将会报错
        * RangeArgs(min, max)： 如果参数个数不在 min 和 max 之间, 命令行将会报错
    * 使用
        ```go
            // rule.go
            ...

            var ruleCmd = &cobra.Command{
                    Use:   "rule",
                    Short: "rule",
                    Long: "Rule Command.",
                    
                    Args: cobra.ExactArgs(1),
                    Run: func(cmd *cobra.Command, args []string) {           
                    fmt.Printf("Create rule %s success.\n", args[0])
                    },
            }

            ...
        ```
    * 运行
        ```bash
            $ go run main.go create rule
            Error: accepts 1 arg(s), received 0

            $ go run main.go create rule llllljian
            Create rule llllljian success.

            $ go run main.go create rule llllljian llllljian1
            Error: accepts 1 arg(s), received 2
        ```
    * 自定义
        ```go
            ...
            Args: func(cmd *cobra.Command, args []string) error {
                if len(args) < 1 {
                    return fmt.Errorf("项目名称必填")
                }
                return nil
            },
            ...
        ```
    * 验证
        ```bash
            $ go run main.go create rule
            Error: 项目名称必填
        ```
- 标志
    * 持久标志 ( Persistent Flags )
        * 指所有的 commands 都可以使用该标志.比如：–verbose ,–namespace
    * 本地标志 ( Local Flags ) 
        * 指特定的 commands 才可以使用该标志
    * 本地标志demo
        ```bash
            $ cat cmd/rule.go
            package cmd

            import (
                    "fmt"
                    "github.com/spf13/cobra"
            )

            // 添加变量 name
            var name string

            var ruleCmd = &cobra.Command{
                    Use:   "rule",
                    Short: "rule",
                    Long:  "Rule Command.",
                    Run: func(cmd *cobra.Command, args []string) {
                            // 如果没有输入 name
                            if len(name) == 0 {
                                    cmd.Help()
                                    return
                            }
                            fmt.Printf("Create rule %s success.\n", name)
                    },
            }

            func init() {
                    createCmd.AddCommand(ruleCmd)
                    // 添加本地标志
                    ruleCmd.Flags().StringVarP(&name, "name", "n", "", "rule name")
            }
        ```
    * 验证
        ```bash
            $ go run main.go create --name llllljian rule
            Create rule llllljian success.

            $ go run main.go create -n llllljian rule
            Create rule llllljian success.

            $ go run main.go create rule --name llllljian
            Create rule llllljian success.

            $ go run main.go create rule -n llllljian
            Create rule llllljian success.
        ```
- 读取配置
    * 直接从配置文件中读到自己想要的标志
    * 查看默认的配置文件为 $HOME/.testcobra.yaml(查看方式为 go run main.go -h)
    * 配置库我们可以使用 Viper.Viper 是 Cobra 集成的配置文件读取库,支持 YAML,JSON, TOML, HCL 等格式的配置
    * cmd/rule.go
        ```go
            package cmd

            import (
                "fmt"
                // 导入 viper 包
                "github.com/spf13/cobra"
                "github.com/spf13/viper"
            )

            var name string

            var ruleCmd = &cobra.Command{
                Use:   "rule",
                Short: "rule",
                Long:  "Rule Command.",
                Run: func(cmd *cobra.Command, args []string) {
                    // 不输入 --name 从配置文件中读取 name
                    if len(name) == 0 {
                        name = viper.GetString("name")
                        // 配置文件中未读取到 name,打印帮助提示
                        if len(name) == 0 {
                            cmd.Help()
                            return
                        }
                    }
                    fmt.Printf("Create rule %s success.\n", name)
                },
            }

            func init() {
                createCmd.AddCommand(ruleCmd)
                ruleCmd.Flags().StringVarP(&name, "name", "n", "", "rule name")
            }
        ```
    * $HOME/.testcobra.yaml 
        ```bash
            $ cat $HOME/.testcobra.yaml 
            name: llllljian_yaml
        ```
    * 运行
        ```bash
            $ go run main.go create rule
            Using config file: /Users/llllljian/.testcobra.yaml
            Create rule llllljian_yaml success.
        ```
- 编译运行
    * ​编译生成命令行工具
        ```bash
            $ go build -o testcobra

            $ ./testcobra create rule
            Using config file: /Users/llllljian/.testcobra.yaml
            Create rule llllljian_yaml success.
        ```
    * 编译后的结果可能要跨平台运行, 所以需要build的时候额外添加部分参数
        * GOOS：目标平台的操作系统(darwin、freebsd、linux、windows)
        * GOARCH：目标平台的体系架构(386、amd64、arm)
        * Mac 下编译 Linux 和 Windows 64位可执行程序
            ```bash
                CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build main.go
                CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build main.go
            ```
        * Linux 下编译 Mac 和 Windows 64位可执行程序
            ```bash
                CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build main.go
                CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build main.go
            ```
        * Windows 下编译 Mac 和 Linux 64位可执行程序
            ```bash
                SET CGO_ENABLED=0
                SET GOOS=darwin
                SET GOARCH=amd64
                go build main.go

                SET CGO_ENABLED=0
                SET GOOS=linux
                SET GOARCH=amd64
                go build main.go
            ```



