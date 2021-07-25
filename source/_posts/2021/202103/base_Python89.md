---
title: Python_基础 (89)
date: 2021-03-17
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之日常积累

<!-- more -->

#### python方法ssh机器并执行cmd
> 给定账号密码, 需要ssh到机器上执行cmd命令
- code
    ```python
        import pexpect
        import logging

        def do_ssh(cmd, hosts, username, password):
            """
            批量执行命令
            """
            hosts = set(hosts)
            good_hosts, bad_hosts = [], []
            for hostname in hosts:
                ret = do_one_ssh(cmd, hostname, username, password)
                if ret:
                    good_hosts.append(hostname)
                else:
                    bad_hosts.append(hostname)

            return good_hosts, bad_hosts


        def do_one_ssh(cmd, hostname, username, password):
            """
            单个地执行命令
            """
            prompt = "\[.*\][#|$]"
            try:
                sshcmd = ('ssh  -oUserKnownHostsFile=/dev/null '
                        '-oStrictHostKeyChecking=no %s' % hostname)

                sshcmd = sshcmd + " -l " + username if username else sshcmd
                s = pexpect.spawn(command=sshcmd, timeout=60)
                s.setecho(True)
                i = -1
                while (i != 0):
                    i = s.expect([prompt,
                                "Are you sure you want to continue connecting (yes/no)?",
                                ".*password:"])
                    if i == 1:
                        s.sendline("yes")
                    elif i == 2:
                        s.sendline(password)
                s.sendline(cmd)
                s.expect(prompt)
                s.sendline("exit")
                s.close()
                logging.info("%s ssh cmd %s succ", hostname, cmd)
                return True
            except pexpect.ExceptionPexpect as e:
                logging.warn("%s ssh cmd %s failed, %s", hostname, cmd, e)
                return False
            except Exception as ex:
                logging.warn("%s ssh cmd %s failed, %s", hostname, cmd, ex)
                return False


        if __name__ == '__main__':
            print(do_one_ssh("df -h", "ip", "username", "password"))
            print(do_ssh("df -h", ["ip1", "ip2"], "username", "password"))
    ```



