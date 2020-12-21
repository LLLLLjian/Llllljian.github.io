---
title: Python_基础 (57)
date: 2020-12-04
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
1. 现在有ip, username, password, port, 需要我登陆到该服务器上执行一些命令, 这里就会用到Paramiko模块
    1. 学习Paramiko模块
    2. 实现功能

#### Paramiko简介
> ssh是一个协议，OpenSSH是其中一个开源实现，paramiko是Python的一个库，实现了SSHv2协议(底层使用cryptography)。
有了Paramiko以后，我们就可以在Python代码中直接使用SSH协议对远程服务器执行操作，而不是通过ssh命令对远程服务器进行操作。
- 安装
    ```bash
        # 由于paramiko属于第三方库，所以需要使用如下命令先行安装
        pip3 install paramiko
    ```

#### Paramiko介绍
> paramiko包含两个核心组件：SSHClient和SFTPClient。
1. SSHClient
    * SSHClient的作用类似于Linux的ssh命令，是对SSH会话的封装，该类封装了传输(Transport)，通道(Channel)及SFTPClient建立的方法(open_sftp)，通常用于执行远程命令。
2. SFTPClient
    * SFTPClient的作用类似与Linux的sftp命令，是对SFTP客户端的封装，用以实现远程文件操作，如文件上传、下载、修改文件权限等操作。
3. 基础名词
    1. Channel: 是一种类Socket，一种安全的SSH传输通道；
    2. Transport: 是一种加密的会话，使用时会同步创建了一个加密的Tunnels(通道)，这个Tunnels叫做Channel；
    3. Session: 是client与Server保持连接的对象，用connect()/start_client()/start_server()开始会话。

#### Paramiko的基本使用

##### SSHClient常用的方法介绍
1. connect()
    * 实现远程服务器的连接与认证，对于该方法只有hostname是必传参数
    * 常用参数
        * hostname 连接的目标主机
        * port=SSH_PORT 指定端口
        * username=None 验证的用户名
        * password=None 验证的用户密码
        * pkey=None 私钥方式用于身份验证
        * key_filename=None 一个文件名或文件列表，指定私钥文件
        * timeout=None 可选的tcp连接超时时间
        * allow_agent=True, 是否允许连接到ssh代理，默认为True 允许
        * look_for_keys=True 是否在~/.ssh中搜索私钥文件，默认为True 允许
        * compress=False, 是否打开压缩
2. set_missing_host_key_policy()
    * 设置远程服务器没有在know_hosts文件中记录时的应对策略
    * 目前支持的三种策略
        * AutoAddPolicy 自动添加主机名及主机密钥到本地HostKeys对象，不依赖load_system_host_key的配置。即新建立ssh连接时不需要再输入yes或no进行确认
        * WarningPolicy 用于记录一个未知的主机密钥的python警告。并接受，功能上和AutoAddPolicy类似，但是会提示是新连接
        * RejectPolicy 自动拒绝未知的主机名和密钥，依赖load_system_host_key的配置。此为默认选项
3. exec_command()
    * 在远程服务器执行Linux命令的方法。
4. open_sftp()
    * 在当前ssh会话的基础上创建一个sftp会话。该方法会返回一个SFTPClient对象, 可以进行文件的上传等操作

##### SSHClient常用的方法举例
1. 账号密码登陆
    ```python
        import paramiko
 
        # 实例化SSHClient
        client = paramiko.SSHClient()
        
        # 自动添加策略，保存服务器的主机名和密钥信息，如果不添加，那么不再本地know_hosts文件中记录的主机将无法连接
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # 连接SSH服务端，以用户名和密码进行认证
        client.connect(hostname='192.168.1.105', port=22, username='root', password='123456')
        
        # 打开一个Channel并执行命令
        stdin, stdout, stderr = client.exec_command('df -h ')  # stdout 为正确输出，stderr为错误输出，同时是有1个变量有值
        
        # 打印执行结果
        print(stdout.read().decode('utf-8'))
        
        # 关闭SSHClient
        client.close()
    ```
2. 密钥连接方式
    ```python
        import paramiko

        # 配置私人密钥文件位置
        private = paramiko.RSAKey.from_private_key_file('/Users/ch/.ssh/id_rsa')
        
        #实例化SSHClient
        client = paramiko.SSHClient()
        
        #自动添加策略，保存服务器的主机名和密钥信息，如果不添加，那么不再本地know_hosts文件中记录的主机将无法连接
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        #连接SSH服务端，以用户名和密码进行认证
        client.connect(hostname='10.0.0.1',port=22,username='root',pkey=private)
    ```
3. SSHClient封装Transport
    ```python
        import paramiko
 
        # 创建一个通道
        transport = paramiko.Transport(('hostname', 22))
        transport.connect(username='root', password='123')
        
        ssh = paramiko.SSHClient()
        ssh._transport = transport
        
        stdin, stdout, stderr = ssh.exec_command('df -h')
        print(stdout.read().decode('utf-8'))
        
        transport.close()
    ```

##### SFTPClient常用方法介绍
> SFTPCLient作为一个sftp的客户端对象，根据ssh传输协议的sftp会话，实现远程文件操作，如上传、下载、权限、状态
1. from_transport(cls,t)
    * 创建一个已连通的SFTP客户端通道
2. put(localpath, remotepath, callback=None, confirm=True)
    * 将本地文件上传到服务器
    * 参数confirm：是否调用stat()方法检查文件状态，返回ls -l的结果
3. get(remotepath, localpath, callback=None)
    * 从服务器下载文件到本地
4. mkdir()
    * 在服务器上创建目录
5. remove()
    * 在服务器上删除目录
6. rename()
    * 在服务器上重命名目录
7. stat()
    * 查看服务器文件状态
8. listdir()
    * 列出服务器目录下的文件

##### SFTPClient常用方法举例
    ```python
        import paramiko
 
        # 获取Transport实例
        tran = paramiko.Transport(('10.0.0.3', 22))
        
        # 连接SSH服务端，使用password
        tran.connect(username="root", password='123456')
        # 或使用
        # 配置私人密钥文件位置
        private = paramiko.RSAKey.from_private_key_file('/Users/root/.ssh/id_rsa')
        # 连接SSH服务端，使用pkey指定私钥
        tran.connect(username="root", pkey=private)
        
        # 获取SFTP实例
        sftp = paramiko.SFTPClient.from_transport(tran)
        
        # 设置上传的本地/远程文件路径
        localpath = "/Users/root/Downloads/1.txt"
        remotepath = "/tmp/1.txt"
        
        # 执行上传动作
        sftp.put(localpath, remotepath)
        # 执行下载动作
        sftp.get(remotepath, localpath)
        
        tran.close()
    ```

#### Paramiko的综合使用例子
    ```python
        class SSHConnection(object):
            """
            SSH连接类
            """
            def __init__(self, host_dict):
                """
                初始化账号密码信息
                """
                self.host = host_dict['host']
                self.port = host_dict['port']
                self.username = host_dict['username']
                self.pwd = host_dict['pwd']
                self.__k = None
 
            def connect(self):
                """
                连接
                """
                transport = paramiko.Transport((self.host,self.port))
                transport.connect(username=self.username,password=self.pwd)
                self.__transport = transport
 
            def close(self):
                """
                关闭连接
                """
                self.__transport.close()
 
            def run_cmd(self, command):
                """
                执行shell命令,返回字典
                return {'color': 'red','res':error}或
                return {'color': 'green', 'res':res}
                :param command:
                :return:
                """
                ssh = paramiko.SSHClient()
                ssh._transport = self.__transport
                # 执行命令
                stdin, stdout, stderr = ssh.exec_command(command)
                # 获取命令结果
                res = self.to_str(stdout.read())
                # 获取错误信息
                error = self.to_str(stderr.read())
                # 如果有错误信息，返回error
                # 否则返回res
                if error.strip():
                    return {'color':'red','res':error}
                else:
                    return {'color': 'green', 'res':res}
 
            def upload(self,local_path, target_path):
                """
                文件上传
                """
                # 连接，上传
                sftp = paramiko.SFTPClient.from_transport(self.__transport)
                # 将location.py 上传至服务器 /tmp/test.py
                sftp.put(local_path, target_path, confirm=True)
                # print(os.stat(local_path).st_mode)
                # 增加权限
                # sftp.chmod(target_path, os.stat(local_path).st_mode)
                sftp.chmod(target_path, 0o755)  # 注意这里的权限是八进制的，八进制需要使用0o作为前缀
 
            def download(self,target_path, local_path):
                """
                文件下载
                """
                # 连接，下载
                sftp = paramiko.SFTPClient.from_transport(self.__transport)
                # 将location.py 下载至服务器 /tmp/test.py
                sftp.get(target_path, local_path)
 
            def __del__(self):
                """
                销毁
                """
                self.close()
 
            def to_str(bytes_or_str):
                """
                把byte类型转换为str
                :param bytes_or_str:
                :return:
                """
                if isinstance(bytes_or_str, bytes):
                    value = bytes_or_str.decode('utf-8')
                else:
                    value = bytes_or_str
                return value
    ```


