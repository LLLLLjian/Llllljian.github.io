---
title: 读T代码 (06)
date: 2021-06-07
tags: Code
toc: true
---

### 读T代码
    不能一直自己低着头造轮子呀, 看看别人写的代码吧

<!-- more -->

#### 故事背景
> 这是一个神奇的agent, dududu

#### test_client.py
- code
    ```python
        # !/usr/bin/env python
        # coding: utf-8
        import socket
        import sys
        import os
        import logging

        from flask import Flask
        from flask import request
        from flask import Response, abort, jsonify

        from client import Client
        from werkzeug.utils import secure_filename

        sys.path.append("./")
        logger = logging.getLogger("root")
        ALLOW_FOLDER = os.path.abspath("../")
        ALLOWED_EXTENSIONS = {'py', 'pyc', 'sh', 'txt'}
        pwd = os.path.dirname(os.path.realpath(__file__))  # src
        WORK_DIR = os.path.dirname(pwd)  # test_agent
        NEW_VERSiON_FILE = os.path.join(WORK_DIR, ".new_version")


        def allowed_file(filename):
            """
            判断文件是否允许更新
            文件名中有. 并且 文件名后缀在被允许的dict里
            """
            return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


        def port_occupied(port):
            """
            判断端口是否被占用
            True是被使用了 False是没用
            """
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            try:
                s.connect(("127.0.0.1", int(port)))
                s.shutdown(2)
                # 利用shutdown()函数使socket双向数据传输变为单向数据传输.shutdown()需要一个单独的参数, 
                # 该参数表示了如何关闭socket.具体为: 0表示禁止将来读；1表示禁止将来写；2表示禁止将来读和写.
                return True
            except Exception:
                return False


        def _get_address():
            """
            获取当前机器信息
            """
            hostname = socket.gethostname()
            net_ip = socket.gethostbyname(hostname)
            net_port = DEFAULT_PORT
            return hostname, net_ip, net_port


        @app.before_request
        def check_auth():
            """
            检查权限
            before_request()函数被修饰以后, 每一次请求到来后, 都会先执行它, 如果没问题即没有执行到abort(400), 那么就会进入到正常的被app.route修饰的函数中进行响应, 如果有多个函数被app.before_request修饰了, 那么这些函数会被依次执行
            """
            if client.check_auth(request):
                return None
            else:
                abort(400)


        # 地址是根路径, methods : 默认为("GET",) 
        @app.route('/')
        def index():
            """
            索引页,一般用来测试agent活跃
            """
            msg = "this is a test client\nstart-up port is %s\nstart-up path is %s\n" % (DEFAULT_PORT, ALLOW_FOLDER)
            return msg


        # post请求, 请求的url是/v2/auth
        @app.route("/v2/auth", methods=["POST"])
        def set_auth():
            """
            管理员授权接口
            """
            return client.api_set_auth(request)


        # get请求, 请求的url是/v2/heartbeat
        @app.route('/v2/heartbeat', methods=["GET"])
        def heartbeat():
            """
            心跳
            """
            data = {
                # agent版本
                "version": client.version,
                # 部署路径
                "path": ALLOW_FOLDER,
                # 启动用户
                "user": client.current_user
            }
            return jsonify(data)


        # post请求, 请求的url是/v2/update
        @app.route('/v2/update', methods=['POST'])
        def upload_file():
            """
            upload file interface
            """
            # 请求里没有文件内容就直接返回500
            if not request.files:
                return Response('No file uploaded', status=500)
            files = request.files
            # 更新多个文件
            for file in files.values():
                # 没有指定文件名也返回500
                if file and file.filename == '':
                    return Response('No filename uploaded', status=500)
                # 如果是允许更新的文件
                if allowed_file(file.filename):
                    # 获得安全文件名, 防止客户端伪造文件
                    filename = secure_filename(file.filename)
                    # 获取更新文件在当前系统的路径
                    file_save_path = os.path.join(app.config['ALLOW_FOLDER'], "src", filename)
                    logger.info("save update file:%s" % file_save_path)
                    # 将文件内容写入路径
                    file.save(file_save_path)
                else:
                    return Response("failed", 400)
                # touch version file
                logger.info("update version file")
                try:
                    with open(NEW_VERSiON_FILE, "w") as f:
                        f.write("\n")
                except Exception as e:
                    logger.exception(e)
                    return Response("update version file failed:%s" % e, status=500)

            return "success"

        # 引入了Flask包, 并创建一个Web应用的实例”app”
        app = Flask(__name__)
        try:
            client = Client()
            client.run()
        except Exception:
            logger.exception("init client failed")
            client = None
        app.config['ALLOW_FOLDER'] = ALLOW_FOLDER
        app.debug = False

        if len(sys.argv) > 1:
            DEFAULT_PORT = sys.argv[1]
        else:
            DEFAULT_PORT = 52705  # 52705,填写强制使用
            port_list = list(range(52705, 52755))
            for port in port_list:
                if (port_occupied(port)):
                    pass
                else:
                    DEFAULT_PORT = port
                    break


        if __name__ == '__main__':
            hostname, ip, port = _get_address()
            client.set_port(port)
            print('hostname: %s ip: %s port: %s' % (hostname, ip, port))
            try:
                # 启动前先注册
                client.register_to_master(port)
                # 如果你需要外网访问, ip需要设置为0.0.0.0, 此时, 在本机上访问需要使用默认的127.0.0.1(也就是你不设置ip时默认的ip),在外网上访问则需要使用你本机的ip, 不要使用0.0.0.0
                # use_reloader 出现异常后是否重载或者派生进程
                app.run(host="0.0.0.0", port=port, use_reloader=False)
            except socket.error:
                print('the port has been used:(%s:%s)' % (ip, port))
                sys.exit(1)
            except Exception as e:
                print('exit(%s)' % e)
                sys.exit(1)
    ```




