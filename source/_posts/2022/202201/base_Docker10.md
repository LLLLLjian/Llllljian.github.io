---
title: Docker_基础 (10)
date: 2022-01-12
tags: Docker
toc: true
---

### 运行中的DOCKER配置端口映射(添加／删除)

<!-- more -->

1. 添加端口映射
    ```bash
        # a, 获取容器ip  
        docker inspect $container_name | grep IPAddress
        # b. 添加转发规则  
        iptables -t nat -A DOCKER -p tcp --dport $host_port -j DNAT --to-destination $docker_ip:$docker_port  
    ```
2. 删除端口映射规则
    ```bash
        # a. 获取规则编号  
        iptables -t nat -nL --line-number
        # b. 根据编号删除规则  
        iptables -t nat -D DOCKER $num
    ```





