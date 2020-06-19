---
title: Interview_总结 (72)
date: 2020-03-11
tags: Interview
toc: true
---

### 面试题
    今日被问傻系列

<!-- more -->

#### Shell脚本检查统计nginx访问日志access.log
>  统计nginx的访问日志, 统计访问总数, http状态码信息等
```bash
    #!/bin/bash
    nginx_log_path='/var/log/nginx/access.log'

    #the log of nginx after filter
    nginx_log_awkpath='./mynginx.log'

    #filter log only with http code
    cat ${nginx_log_path} | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}"| awk '{print $2}' > ${nginx_log_awkpath}

    echoFun(){
        echo $1 $2
    }

    check_http_status(){
        http_code_100=$(grep -o '1[0-9][0-9]' ${nginx_log_awkpath} | wc -l)
        http_code_200=$(grep -o '2[0-9][0-9]' ${nginx_log_awkpath} | wc -l)
        http_code_300=$(grep -o '3[0-9][0-9]' ${nginx_log_awkpath} | wc -l)
        http_code_400=$(grep -o '4[0-9][0-9]' ${nginx_log_awkpath} | wc -l)
        http_code_500=$(grep -o '5[0-9][0-9]' ${nginx_log_awkpath} | wc -l)
        http_code_total=$(grep -o '[1-5][0-9][0-9]' ${nginx_log_awkpath} | wc -l)

        echoFun "http status[100+]" "${http_code_100}"
        echoFun "http status[200+]" "${http_code_200}"
        echoFun "http status[300+]" "${http_code_300}"
        echoFun "http status[400+]" "${http_code_400}"
        echoFun "http status[500+]" "${http_code_500}"
        echoFun "http status total" "${http_code_total}"
    }

    check_http_code(){
        http_code_403=$(grep -o '403' ${nginx_log_awkpath} | wc -l)
        http_code_404=$(grep -o '404' ${nginx_log_awkpath} | wc -l)
        echoFun "http status[403]" "${http_code_403}"
        echoFun "http status[404]" "${http_code_404}"
    }

    check_http_status
    check_http_code
```

#### Shell脚本求两个文件交集和差集的办法
- comm
    ```bash
        cat a.txt
        a
        b
        c
        e
        d
        a

        cat b.txt
        c
        d
        a
        c

        comm a.txt b.txt
        a
        b
                        c
                d
                a
                c
        e
        d
        a

        $ comm -12 <(sort a.txt|uniq ) <(sort b.txt|uniq )
        a
        c
        d
    ```
- sort
    ```bash
        # 并
        sort -m <(sort file1 | uniq) <(sort file2 | uniq) | uniq

        # 交
        sort -m <(sort file1 | uniq) <(sort file2 | uniq) | uniq -d

        # 差
        sort -m <(sort file1 | uniq) <(sort file2 | uniq) <(sort file2 | uniq) | uniq -u
    ```
- grep
    ```bash
        grep -F -f a.txt b.txt | sort | uniq
        a
        c
        d

        # a-b
        grep -F -v -f a.txt b.txt | sort | uniq
        # b-a
        grep -F -v -f b.txt a.txt | sort | uniq
        b
        e
    ```
