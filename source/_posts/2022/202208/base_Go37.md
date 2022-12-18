---
title: Go_基础 (37)
date: 2022-08-29
tags: Go
toc: true
---

### Go语言中文网
    公众号阅读笔记-10个通用函数

<!-- more -->

#### 检查 slice 中某元素是否存在
- code
    ```go
        func Contains(slice []string, element string) bool {
            for _, i := range slice {
                if i == element {
                return true
                }
            }
            return false
        }
    ```

#### 检查给定的时间是否处于某一时间区间内
- code
    ```go
        func main() {
            currentTime := time.Now()
            // Time after 18 hours of currentTime
            futureTime := time.Now().Add(time.Hour * 18)
            // Time after 10 hours of currentTime
            intermediateTime := time.Now().Add(time.Hour * 10)
            if intermediateTime.After(currentTime) &&    intermediateTime.Before(futureTime) {
                fmt.Println("intermediateTime is between currentTime and  futureTime")
            } else {
                fmt.Println("intermediateTime is not inbetween currentTime and futureTime")
            }
        }
    ```


#### 将较小的数除以较大的数
- code
    ```go
        import "fmt"

        func main() {
            smallerNo := 5
            largerNo := 25
            result := float32(smallerNo) / float32(largerNo)
            fmt.Println("result : ", result)
        }


        output:
        result : 0.2
    ```

#### 计算特定时区的当前时间戳
- code
    ```go
        import (
            "time"
            "fmt"
        )

        func main() {
            timeZone := "Asia/Kolkata" // timezone value
            loc, _ := time.LoadLocation(timeZone)
            currentTime = time.Now().In(loc)
            fmt.Println("currentTime : ", currentTime)
        }


        output:
        // for timezone = "Asia/Kolkata"
        currentTime :  2022-02-09 10:42:39.164079505 +0530 IST
        // for timezone = "Asia/Shanghai"
        currentTime :  2022-02-09 13:14:33.986953939 +0800 CST
    ```

#### 去重
- code
    ```go
        func RemoveDuplicatesFromSlice(intSlice []string) []string {
            keys := make(map[string]bool)
            list := []string{}
            for _, entry := range intSlice {
                if _, value := keys[entry]; !value {
                keys[entry] = true
                list = append(list, entry)
                }
            }
            return list
        }
    ```

#### 随机打乱
- code
    ```go
        func Shuffle(array []string) {
            // seed random for changing order of elements
            random := rand.New(rand.NewSource(time.Now().UnixNano()))
            for i := len(array) - 1; i > 0; i-- {
                j := random.Intn(i + 1)
                array[i], array[j] = array[j], array[i]
            }
            fmt.Println("Shuffled array : ", array)
        }
    ```

#### 反转
- code
    ```go
        func ReverseSlice(a []int) []int {
            for i := len(a)/2 - 1; i >= 0; i-- {
                pos := len(a) - 1 - i
                a[i], a[pos] = a[pos], a[i]
            }
            return a
        }
    ```

#### 元素求和
- code
    ```go
        func sumSlice(array []int) int {
            sum := 0
            for _, item := range array {
                sum += item
            }
            return sum
        }
    ```


#### 将 slice 转换为逗号分隔的字符串
- code
    ```go
        func ConvertSliceToString(input []int) string {
            var output []string
            for _, i := range input {
                output = append(output, strconv.Itoa(i))
            }
            return strings.Join(output, ",")
        }
    ```

#### 将字符串以下划线分割
- code
    ```go
        func ConvertToSnakeCase(input string) string {
            var matchChars = regexp.MustCompile("(.)([A-Z][a-z]+)")
            var matchAlpha = regexp.MustCompile("([a-z0-9])([A-Z])")

            snake := matchChars.ReplaceAllString(input, "${1}_${2}")
            snake = matchAlpha.ReplaceAllString(snake, "${1}_${2}")
            return strings.ToLower(snake)
        }

    ```
