---
title: Python_基础 (136)
date: 2021-10-18
tags: Python
toc: true
---

### python小积累
    python基础知识

<!-- more -->

#### 前言
> 既然开始学python了 那基本的一些python知识要知道 只会写代码还是不行鸭

#### pexpect
> Expect 程序主要用于人机对话的模拟, 就是那种系统提问, 人来回答 yes/no , 或者账号登录输入用户名和密码等等的情况. 因为这种情况特别多而且繁琐, 所以很多语言都有各种自己的实现
- spawn()
    * 执行程序
    * spawn() 方法用来执行一个程序, 它返回这个程序的操作句柄, 以后可以通过操作这个句柄来对这个程序进行操作
- expect()
    * 关键字匹配
    * 当 spawn() 启动了一个程序并返回程序控制句柄后, 就可以用 expect() 方法来等待指定的关键字了. 它最后会返回 0 表示匹配到了所需的关键字, 如果后面的匹配关键字是一个列表的话, 就会返回一个数字表示匹配到了列表中第几个关键字, 从 0 开始计算
- sendline()
    * 发送带回车符的字符串
    * 在发送的字符串后面加上了回车换行符
- close()
    * 停止应用程序
    * 如果想中途关闭子程序, 那么可以用 close 来完成, 调用这个方法后会返回这个程序的返回值
- demo
    ```python
        def do_one_ssh(cmd, hostname, username, password):
            """
            单个地执行命令
            """
            prompt = r"\[.*\][#|$]"
            try:
                # 忽略UserKnownHostsFile
                sshcmd = ('ssh  -oUserKnownHostsFile=/dev/null '
                        '-oStrictHostKeyChecking=no %s@%s' % (username:hostname))
                s = pexpect.spawn(command=sshcmd, timeout=60)
                s.setecho(True)
                i = -1
                while (i != 0):
                    # 捕捉list中的信息
                    i = s.expect([prompt,
                                "Are you sure you want to continue connecting (yes/no)?",
                                ".*password:"])
                    if i == 1:
                        # 如果对应的是 Are you sure you want to continue connecting (yes/no)? 输入yes
                        s.sendline("yes")
                    elif i == 2:
                        # 捕捉到输入密码的话 就输入密码
                        s.sendline(password)
                # 执行cmd
                s.sendline(cmd)
                s.expect(prompt)
                # 退出
                s.sendline("exit")
                s.close()
                logger.info("%s ssh cmd %s succ", hostname, cmd)
                return True
            except pexpect.ExceptionPexpect as e:
                logger.warn("%s ssh cmd %s failed, %s", hostname, cmd, e)
                return False
            except Exception as ex:
                logger.warn("%s ssh cmd %s failed, %s", hostname, cmd, ex)
                return False
    ```



