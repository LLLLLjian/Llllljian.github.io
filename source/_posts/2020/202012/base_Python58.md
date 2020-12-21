---
title: Python_基础 (58)
date: 2020-12-07
tags: 
    - Python
    - Django
toc: true
---

### 快来跟我一起学Django
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之Paramiko模块

<!-- more -->

#### 先说说我想做的事
1. 使用Paramiko cd到指定目录再执行命令时发现还在原路径下
2. 需要得到shell命令执行之后的返回值, 需要根据返回值来判断是否正常执行shell脚本

#### 问题1
> 使用SSHClient对象的这个方法执行例如ls，pwd等命令的时候，都执行的还不错。但是cd /path这个命令就有点问题了，发现cd到其他路径下，但是使用pwd发现还是在登录的时候的默认路径，/home/&gt;user>
相当于没有执行cd命令，这个时候就要把后续的想要执行的命令和cd放在同一个字符串中传入exec_command方法中才会生效。
- eg
    ```python
        client = paramiko.SSHClient()

        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        client.connect('IP', username='username', password='password', timeout=5)

        client.exec_command('cd /home/<user>/xxx/yyy; ls -al')
    ```

#### 问题2
- eg
    ```python
        import paramiko

        hostname = 'ip'
        port = 22  
        username = 'root'  
        key_file = '/root/.ssh/id_rsa'  
        key = paramiko.RSAKey.from_private_key_file(key_file) 

        s = paramiko.SSHClient()  
        s.load_system_host_keys()  
        s.connect(hostname,port,username,pkey=key)  
        stdin,stdout,stderr = s.exec_command('/bin/bash /root/auto_run/publish81.sh') 
        channel = stdout.channel
        status = channel.recv_exit_status()
        print status
    ```
