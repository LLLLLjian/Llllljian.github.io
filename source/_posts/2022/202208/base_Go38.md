---
title: Go_基础 (38)
date: 2022-08-30
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-go单元测试

<!-- more -->

#### 测试框架
- go test
    ```go
        // sample_test.go

        package sample_test

        import ( "testing" )

        func TestDownload(t *testing.T) {}
        func TestUpload(t *testing.T) {}

        // t.Fatal：会让测试函数立刻返回错误
        // t.Error：会输出错误并记录失败, 但任然会继续运行
        // t.Log：输出 debug 信息, go test -v参数下有效
    ```

#### 表格驱动测试
> 表格驱动测试通过定义一组不同的输入, 可以让代码得到充分的测试, 同时也能有效地测试负路径
- demo
    ```go
        func twice(i interface{}) (int, error) {
            switch v := i.(type) {
            case int:
                return v * 2, nil
            case string:
                value, err := strconv.Atoi(v)
                if err != nil {
                    return 0, errors.Wrapf(err, "invalid string num %s", v)
                }
                return value * 2, nil
            default:
                return 0, errors.New("unknown type")
            }
        }

        func Test_twice(t *testing.T) {
            type args struct {
                i interface{}
            }
            tests := []struct {
                name    string
                args    args
                want    int
                wantErr bool
            }{
                {
                    name: "int",
                    args: args{i: 10},
                    want: 20,
                },
                {
                    name: "string success",
                    args: args{i: "11"},
                    want: 22,
                },
                {
                    name:    "string failed",
                    args:    args{i: "aaa"},
                    wantErr: true,
                },
                {
                    name:    "unknown type",
                    args:    args{i: []byte("1")},
                    wantErr: true,
                },
            }
            for _, tt := range tests {
                t.Run(tt.name, func(t *testing.T) {
                    got, err := twice(tt.args.i)
                    if (err != nil) != tt.wantErr {
                        t.Errorf("twice() error = %v, wantErr %v", err, tt.wantErr)
                        return
                    }
                    if got != tt.want {
                        t.Errorf("twice() got = %v, want %v", got, tt.want)
                    }
                })
            }
        }
    ```

#### 访问 http 接口

代码里经常会遇到要访问http接口的情况, 这时如果在测试代码里不做处理直接访问, 可能遇到环境不同访问不通等问题. 为此go标准库内置了专门用于测试http服务的包net/http/httptest, 不过我们这里并不用它来测试http服务, 而是用来模拟要请求的http服务. 

```go
    mux := http.NewServeMux()
    mux.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
        writer.Write([]byte(`{"code":0,"msg":"ok"}`))
    })

    server := httptest.NewServer(mux)
    defer server.Close()
    url := server.URL
```





