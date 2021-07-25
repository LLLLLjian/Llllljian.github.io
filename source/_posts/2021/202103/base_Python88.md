---
title: Python_基础 (88)
date: 2021-03-16
tags: Python
toc: true
---

### 快来跟我一起学Python
    哈哈哈 之前学的栗子都是水过地皮湿 还是学项目吧！！
    python之日常积累

<!-- more -->

#### python执行shell命令
> 需要在python脚本中执行一些shell命令, 并且要能得到shell命令的返回值
- code
    ```python
        import subprocess

        def getstatusoutput(cmd):
            """
            执行shell命令
            """
            p = subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
            stdoutdata, stderrdata = p.communicate()
            status = p.returncode
            if status == 0:
                out = stdoutdata
            else:
                out = stderrdata

            try:
                output = out.decode()
            except UnicodeDecodeError:
                output = out

            return status, output

        cmd = "cd /home/work"
        status, output = getstatusoutput(cmd)
        if status != 0:
            logging.error("cmd <%s> failed: %s" % (cmd, output))
        else:
            logging.debug("cmd <%s> succ" % (cmd))
    ```

#### 封装的HTTP请求
> 封装的一个简单的http请求
- code
    ```python
        def talk_with_master(operation, data, method="POST", token=None):
            """
            以http的post方式与master
            """
            try:
                if sys.version_info < (3,):
                    conn = httplib.HTTPConnection('%s:%s' % (conf["master_ip"], conf["master_port"]))
                else:
                    conn = http.client.HTTPConnection('%s:%s' % (conf["master_ip"], conf["master_port"]))

                headers = {"Content-type": "application/json", "Connection": "close"}
                if token is not None:
                    headers["token"] = token
                conn.request(method, operation, json.dumps(data), headers)
                response = conn.getresponse()
            except Exception as ex:
                # conn.close()
                logging.error("talk to master failed: %s" % ex)
                return None, None, None

            status, header, body = response.status, response.getheaders(), response.read()
            conn.close()
            try:
                body = json.loads(body)
            except Exception as ex:
                logging.error("body to json failed: %s" % ex)
                pass
            return status, header, body
        
        status, header, body = utils.talk_with_master(
            "http://localhost:4001",
            "aaaa",
            "post",
            "xxdxxxxxxx"
        )
    ```

