---
title: Lua_基础 (03)
date: 2020-12-03
tags: 
    - Lua
    - Nginx
toc: true
---

### 快来跟我一起学Lua
    快来学Lua

<!-- more -->

#### OpenResty 介绍
> OpenResty(又称：ngx_openresty) 是一个基于 NGINX 的可伸缩的 Web 平台,由中国人章亦春发起,提供了很多高质量的第三方模块.
OpenResty 是一个强大的 Web 应用服务器,Web 开发人员可以使用 Lua 脚本语言调动 Nginx 支持的各种 C 以及 Lua 模块,更主要的是在性能方面,OpenResty可以 快速构造出足以胜任 10K 以上并发连接响应的超高性能 Web 应用系统.
360,UPYUN,阿里云,新浪,腾讯网,去哪儿网,酷狗音乐等都是 OpenResty 的深度用户.

#### nginx如何结合lua
1. lua指令
    ```lua
        content_by_lua_file 直接加lua file的路径,接受请求,并处理响应.
        lua_package_path 设置用lua代码写的扩展库路径,lua文件里require要用到.
        set_by_lua_file $var <path-to-lua-script-file> [$arg1 $arg2 ...]; 设置一个Nginx变量,变量值从lua脚本里运算由return返回,可以实现复杂的赋值逻辑；此处是阻塞的,Lua代码要做到非常快.
        rewrite_by_lua_file lua文件的重定向操作
        access_by_lua_file lua文件的访问控制 
        header_filter_by_lua_file 设置header 和 cookie
        init_by_lua_file ginx Master进程加载配置时执行；通常用于初始化全局配置/预加载Lua模块
    ```
2. lua常用的方法和常量
    ```lua
        ngx.arg[index]  #ngx指令参数,当这个变量在set_by_lua或者set_by_lua_file内使用的时候是只读的,指的是在配置指令输入的参数
        ngx.var.varname #读写NGINX变量的值,最好在lua脚本里缓存变量值,避免在当前请求的生命周期内内存的泄漏
        ngx.config.ngx_lua_version  #当前ngx_lua模块版本号
        ngx.config.nginx_version    #nginx版本
        ngx.worker.pid              #当前worker进程的PID
        ...

        print()    #与 ngx.print()方法有区别,print() 相当于ngx.log()
        ngx.ctx    #这是一个lua的table,用于保存ngx上下文的变量,在整个请求的生命周期内都有效,详细参考官方
        ngx.location.capture()          #发出一个子请求
        ngx.location.capture_multi()    #发出多个子请求
        ngx.status                      #读或者写当前请求的相应状态. 必须在输出相应头之前被调用
        ngx.header.HEADER               #访问或设置http header头信息
        ngx.req.set_uri()               #设置当前请求的URI
        ngx.set_uri_args(args)          #根据args参数重新定义当前请求的URI参数
        ngx.req.get_uri_args()          #返回一个lua table,包含当前请求的全部的URL参数
        ngx.req.get_post_args()         #返回一个LUA TABLE,包括所有当前请求的POST参数
        ngx.req.get_headers()           #返回一个包含当前请求头信息的lua table
        ngx.req.set_header()            #设置当前请求头header某字段值.当前请求的子请求不会受到影响
        ngx.req.read_body()             #在不阻塞ngnix其他事件的情况下同步读取客户端的body信息
        ngx.time()                      #返回当前时间戳
        ngx.re.match(subject,regex,options,ctx)     #ngx正则表达式匹配
    ```
3. helloWorld又来了
    ```nginx
        location /test {
            default_type text/html;

            content_by_lua_block {
                ngx.say("HelloWorld")
            }
        }
    ```

#### nginx-upload-module
- 官方文档  http://www.grid.net.ru/nginx/upload.en.html
- 原理
    * Nginx upload module通过nginx服务来接受用户上传的文件,自动解析请求体中存储的所有文件上传到upload_store指定的目录下.这些文件信息从原始请求体中分离并根据nginx.conf中的配置重新组装好上传参数,交由upload_pass指定的段处理,从而允许处理任意上传文件.每个上传文件中的file字段值被一系列的upload_set_form_field指令值替换.每个上传文件的内容可以从$upload_tmp_path变量读取,或者可以将文件转移到目的目录下.上传的文件移除可以通过upload_cleanup指令控制.如果请求的方法不是POST,模块将返回405错误(405 Not Allowed),该错误提示可以通过error_page指令处理.
- 流程
    1. 用户访问能够选择上传文件的页面
    2. 用户提交表单
    3. 浏览器把文件和有关文件的信息作为请求的一部分发送给服务器
    4. 服务器把文件保存到临时存储目录下upload_store
    5. upload_pass指定的处理表单提交的php页面将文件从upload_store拷贝到持久存储位置
- 参数详情
    * upload_pass 指明后续处理的php地址.文件中的字段将被分离和取代,包含必要的信息处理上传文件.
    * upload_resumable 是否启动可恢复上传.
    * upload_store 指定上传文件存放地址(目录).目录可以散列,在这种情况下,在nginx启动前,所有的子目录必须存在.
    * upload_state_store 指定保存上传文件可恢复上传的文件状态信息目录.目录可以散列,在这种情况下,在nginx启动前,所有的子目录必须存在.
    * upload_store_access 上传文件的访问权限,user:r是指用户可读
    * upload_pass_form_field 从表单原样转到后端的参数,可以正则表达式表示
    * upload_pass_form_field “^submit$|^description$”; 意思是把submit,description这两个字段也原样通过upload_pass传递到后端php处理.如果希望把所有的表单字段都传给后端可以用upload_pass_form_field “^.*$”;

    * upload_set_form_field 名称和值都可能包含以下特殊变量：
    * $upload_field_name 表单的name值
    * $upload_content_type 上传文件的类型
    * $upload_file_name 客户端上传的原始文件名称
    * $upload_tmp_path 文件上传后保存在服务端的位置
    * upload_aggregate_form_field 可以多使用的几个变量,文件接收完毕后生成的并传递到后端
    * $upload_file_md5 文件的MD5校验值
    * $upload_file_md5_uc 大写字母表示的MD5校验值
    * $upload_file_sha1 文件的SHA1校验值
    * $upload_file_sha1_uc 大写字母表示的SHA1校验值
    * $upload_file_crc32 16进制表示的文件CRC32值
    * $upload_file_size 文件大小
    * $upload_file_number 请求体中的文件序号
    * 这些字段值是在文件成功上传后计算的.
    * upload_cleanup 如果出现400 404 499 500-505之类的错误,则删除上传的文件
    * upload_buffer_size 上传缓冲区大小
    * upload_max_part_header_len 指定头部分最大长度字节.
    * upload_max_file_size 指定上传文件最大大小,软限制.client_max_body_size硬限制.
    * upload_limit_rate 上传限速,如果设置为0则表示不限制.
    * upload_max_output_body_len 超过这个大小,将报403错(Request entity too large).
    * upload_tame_arrays 指定文件字段名的方括号是否删除
    * upload_pass_args 是否转发参数.
- nginx.conf
    ```bash
        server {
            ...
            # 上传大小限制(包括所有内容)
            client_max_body_size 32m;
            # 限制上传速度最大256k   
            upload_limit_rate 256k;

            location /upload {
                # 正确上传后、向后端发送请求
                upload_pass   @response_upload;

                # 存储上传文件的地方
                upload_store ./upload;
                
                # 设置文件权限
                upload_store_access user:rw;

                # 在body中设置上传文件信息
                upload_set_form_field $upload_field_name.name "$upload_file_name";
                upload_set_form_field $upload_field_name.content_type "$upload_content_type";
                upload_set_form_field $upload_field_name.path "$upload_tmp_path";

                # 告诉文件md5和大小
                upload_aggregate_form_field "$upload_field_name.md5" "$upload_file_md5";
                upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";

                # 接受表单中的其他参数
                upload_pass_form_field "^submit$|^description$";

                # 出错时、删除文件
                upload_cleanup 400 404 499 500-505;
            }

            # 传递修改后的body到后端
            location @response_upload {
                default_type 'text/html;charset=utf8';
                charset utf-8;

                content_by_lua_file 'lua/upload.lua';
            }
        }
    ```
- upload.html
    ```html
        <form id="upload" enctype="multipart/form-data" action="/upload" method="post" >
            <input name="code" type="file" />
            <input name="submit" type="submit" value="uploadFile" />
        </form>
    ```
- upload.lua
    ```lua
        -- 过滤参数
        local params = {}
        local k, v
        for k,v in string.gmatch(ngx.req.get_body_data(), 'name="([a-zA-Z0-9._-]+)"\r\n\r\n([a-zA-Z0-9._/-]+)') do
            params[k] = v
        end

        -- code对应的是html中的input框的name
        -- 原文件名
        print(params["code.name"])
        -- 文件类型
        print(params["code.content_type"])
        -- 路径
        print(params["code.path"])
        -- 大小
        print(params["code.size"])
        -- 大小
        print(params["submit$"])
    ```
- 缺陷
    * 因为nginx-upload-module未能及时拦下体积过大的文件上传,所以,尽管保障了用户的正常使用,可是依然不能防范恶意的流量攻击

