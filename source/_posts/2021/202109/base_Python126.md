---
title: Python_基础 (126)
date: 2021-09-06
tags: 
    - Python
    - Flask
toc: true
---

### 初识flask
    嘻嘻嘻嘻嘻, 新项目用的是flask, 所以得学一学鸭

<!-- more -->

#### Flask之request
> 在Flask的官方文档中是这样介绍request的: 对于 Web 应用,与客户端发送给服务器的数据交互至关重要.在 Flask 中由全局的 request 对象来提供这些信息.
- 使用
    ```python
        from flask import request
    ```
- 属性
    <table border="1" cellpadding="1" cellspacing="1"><caption><strong>Request属相</strong></caption><tbody><tr><td style="text-align:center;width:191px;">属性名</td><td style="text-align:center;width:657px;">解释</td></tr><tr><td style="text-align:center;width:191px;">form&nbsp;</td><td style="width:657px;">一个从POST和PUT请求解析的 MultiDict(一键多值字典).</td></tr><tr><td style="text-align:center;width:191px;">args</td><td style="width:657px;"><p>MultiDict,要操作 URL (如 ?key=value )中提交的参数可以使用 args 属性:</p><p>searchword = request.args.get('key', '')</p></td></tr><tr><td style="text-align:center;width:191px;"><strong>values</strong>&nbsp;</td><td style="width:657px;">CombinedMultiDict,内容是<code>form</code>和<code>args</code>.&nbsp;<br> 可以使用values替代form和args.</td></tr><tr><td style="text-align:center;width:191px;">cookies</td><td style="width:657px;">请求的cookies,类型是dict.</td></tr><tr><td style="text-align:center;width:191px;">stream</td><td style="width:657px;">在可知的mimetype下,如果进来的表单数据无法解码,会没有任何改动的保存到这个 stream 以供使用.很多时候,当请求的数据转换为string时,使用<code>data</code>是最好的方式.这个stream只返回数据一次.</td></tr><tr><td style="text-align:center;width:191px;"><strong>headers</strong>&nbsp;</td><td style="width:657px;">请求头,字典类型.</td></tr><tr><td style="text-align:center;width:191px;"><strong>data</strong>&nbsp;</td><td style="width:657px;">包含了请求的数据,并转换为字符串,除非是一个Flask无法处理的mimetype.</td></tr><tr><td style="text-align:center;width:191px;">files&nbsp;</td><td style="width:657px;">MultiDict,带有通过POST或PUT请求上传的文件.</td></tr><tr><td style="text-align:center;width:191px;">environ&nbsp;</td><td style="width:657px;">WSGI隐含的环境配置.</td></tr><tr><td style="text-align:center;width:191px;"><strong>method</strong></td><td style="width:657px;">请求方法,比如POST、GET.</td></tr><tr><td style="text-align:center;width:191px;">path</td><td style="width:657px;">获取请求文件路径: /myapplication/page.html</td></tr><tr><td style="text-align:center;width:191px;">script_root</td><td style="width:657px;">&nbsp;</td></tr><tr><td style="text-align:center;width:191px;">base_url</td><td style="width:657px;">获取域名与请求文件路径: http://www.baidu.com/myapplication/page.html</td></tr><tr><td style="text-align:center;width:191px;">url</td><td style="width:657px;">获取全部url: http://www.baidu.com/myapplication/page.html?id=1&amp;edit=edit</td></tr><tr><td style="text-align:center;width:191px;">url_root</td><td style="width:657px;">获取域名: http://www.baidu.com/</td></tr><tr><td style="text-align:center;width:191px;">is_xhr</td><td style="width:657px;">如果请求是一个来自<code>JavaScript XMLHttpRequest</code>的触发,则返回<code>True</code>,这个只工作在支持<code>X-Requested-With</code>头的库并且设置了<code>XMLHttpRequest</code>.</td></tr><tr><td style="text-align:center;width:191px;">blueprint&nbsp;</td><td style="width:657px;">蓝图名字.</td></tr><tr><td style="text-align:center;width:191px;">endpoint&nbsp;</td><td style="width:657px;">endpoint匹配请求,这个与<code>view_args</code>相结合,可是用于重构相同或修改URL.当匹配的时候发生异常,会返回None.</td></tr><tr><td style="text-align:center;width:191px;">json</td><td style="width:657px;">如果<code>mimetype</code>是<code>application/json</code>,这个参数将会解析JSON数据,如果不是则返回None.&nbsp;<br> 可以使用这个替代get_json()方法.</td></tr><tr><td style="text-align:center;width:191px;">max_content_length</td><td style="width:657px;">只读,返回<code>MAX_CONTENT_LENGTH</code>的配置键.</td></tr><tr><td style="text-align:center;width:191px;">module&nbsp;</td><td style="width:657px;">如果请求是发送到一个实际的模块,则该参数返回当前模块的名称.这是弃用的功能,使用<code>blueprints</code>替代.</td></tr><tr><td style="text-align:center;width:191px;">routing_exception = None</td><td style="width:657px;">如果匹配URL失败,这个异常将会/已经抛出作为请求处理的一部分.这通常用于<code>NotFound</code>异常或类似的情况.</td></tr><tr><td style="text-align:center;width:191px;">url_rule = None</td><td style="width:657px;">内部规则匹配请求的URL.这可用于在URL之前/之后检查方法是否允许(request.url_rule.methods) 等等.&nbsp;<br> 默认情况下,在处理请求函数中写下&nbsp;<br> print('request.url_rule.methods', request.url_rule.methods)&nbsp;<br> 会打印: <br> request.url_rule.methods {‘GET’, ‘OPTIONS’, ‘HEAD’}</td></tr><tr><td style="text-align:center;width:191px;">view_args = None</td><td style="width:657px;">一个匹配请求的view参数的字典,当匹配的时候发生异常,会返回None.</td></tr><tr><td style="text-align:center;width:191px;">其他方法</td><td style="width:657px;"><p>get_json(force=False, silent=False, cache=True)</p><p>on_json_loading_failed(e)</p></td></tr></tbody></table>
- 常用方法
    ```python
        return request.method        #POST

        return json.dumps(request.form)        #{"username": "123", "password": "1234"}

        return json.dumps(request.args)       
        #url: http://192.168.1.183:5000/login?a=1&b=2、返回值: {"a": "1", "b": "2"}
        print(request.args['a'])
        #输出: 1
        return str(request.values)        
        #CombinedMultiDict([ImmutableMultiDict([('a', '1'), ('b', '2')]), ImmutableMultiDict([('username', '123'), ('password', '1234')])])

        return json.dumps(request.cookies)        #cookies信息

        return str(request.headers)        #headers信息
        request.headers.get('User-Agent')        #获取User-Agent信息

        return 'url: %s , script_root: %s , path: %s , base_url: %s , url_root : %s' % (request.url,request.script_root, request.path,request.base_url,request.url_root)
        '''
        url: http://192.168.1.183:5000/testrequest?a&b , 
        script_root: , 
        path: /testrequest , 
        base_url: http://192.168.1.183:5000/testrequest , 
        url_root : http://192.168.1.183:5000/
        '''

        @app.route('/upload',methods=['GET','POST'])
        def upload():
            if request.method == 'POST':
                f = request.files['file']
                filename = secure_filename(f.filename)
                #f.save(os.path.join('app/static',filename))
                f.save('app/static/'+str(filename))
                return 'ok'
            else:
                return render_template('upload.html')
        
        #html
        <!DOCTYPE html>
        <html>
            <body>
                <form action="upload" method="post" enctype="multipart/form-data">
                    <input type="file" name="file" /><br />
                    <input type="submit" value="Upload" />
                </form>
            </body>
        </html>
    ```




