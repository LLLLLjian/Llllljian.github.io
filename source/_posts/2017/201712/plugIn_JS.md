---
title: JS_插件(1)
date: 2017-12-13
tags: JS
toc: true
---

## 使用过的前端插件
    下边写的都是一些自己使用过的插件,只是简单的写了一个例子,具体的还是要再看文档.

<!-- more -->

### 图片类
- 图片上传插件zyupload
    * HTML
        ``` javascript  
            <input type="hidden" name="file" id="file">
            <div id="zyupload" class="zyupload"></div>
        ```
    * JS
        ``` javascript     
            $(function() {
                var fileSet = [];
                $("#zyupload").zyUpload({
                    url: //服务器端接收数据的地址,
                    asset: //加载的资源,
                    fileType: [//允许上传的类型
                        "jpg",
                        "png",
                        "bmp",
                        "gif"
                    ],
                    width: "100%",//宽
                    height: "auto",//高
                    fileSize: 1024000,//文件大小
                    itemWidth: "90px",//缩略图宽
                    itemHeight: "70px",//缩略图高
                    del: true,//是否允许删除
                    tailor: true,//是否能裁剪图片
                    multiple: true,//是否可以上传多个文件
                    dragDrop: false,//是否允许拖拽上传
                    finishDel: false,//是否在上传文件完成后删除预览

                    onSelect: function() {

                    },
                    onFailure: function() {

                    },
                    onDelete: function(file, files) {删除一个文件的回调方法 file:当前删除的文件  files:删除之后的文件 
                        var filter = function(s) {
                            return s === undefined ? false : s.trim();
                        }
                        fileSet[file.index] = undefined;
                        $('#mri_file').val(fileSet.filter(filter).join('|'));
                    },
                    onSuccess: function(file, response) {// 文件上传成功的回调方法 
                        var data = JSON.parse(response);
                        var filter = function(s) {
                            return s === undefined ? false : s.trim();
                        }
                        if (data.err) {
                            alert(data.msg)
                        } else {
                            fileSet[file.index] = data.arr.filename;
                            //将回调地址放到表单中,多个文件用 |  隔开
                            $('#file').val(fileSet.filter(filter).join('|'));
                        }
                    }
                });
            });
        ```
    * 服务器端
        ``` javascript
            $_FILES接收文件内容,调用文件上传类,储存文件,成功或失败都返回json数据给前端
        ```

- 点击查看大图imgbox.pack
    * HTML
        ``` javascript  
            <a class="fjImage" href="图片地址">
                <img src="图片地址">
            </a>
        ```
    * JS
        ``` javascript     
            $('.fjImage').imgbox({
                'speedIn'       : 0,
                'speedOut'      : 0,
                'alignment'     : 'center',
                'overlayShow'   : true,
                'allowMultiple' : false
            });
        ```

- 点击查看大图imgbox简易版
    * HTML
        ``` javascript  
            <a class="zoom-1" href="图片地址"><img src="图片地址"/></a>
        ```
    * jQuery
        ``` javascript     
            $("a.zoom-1").imgbox();
        ```

### 文字类
- 代码高亮SyntaxHighlighter
    * HTML
        ``` javascript  
            <div class="syntaxhighlighter">

            </div>
        ```
    * 插件注释
        ``` javascript 
            useScriptTags   true      是否支持解析 <script type=”syntaxhighlighter” /> 标签.
            
            bloggerMode     false     博客模式.如果在博客网上使用该插件,因为通常博主习惯用 <br /> 替换所有的新行(’\n’),这会造成SyntaxHighlighter 插件无法拆开每一行.
                                    开启此选项内部会将 <br /> 替换为新行’\n’

            stringBrs       false     如果您的软件会在每行末尾添加 < br / > 标记,此选项允许您忽略这些标记.

            <div class="syntaxhighlighter  php">
                <table border="0" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td class="gutter">
                                <div class="line number1 index0 alt2" style="height: 14px;">1</div>
                            </td>
                            <td class="code">
                                <div class="container">
                                    <div class="line number1 index0 alt2" style="height: 14px;">
                                        <code class="php plain">&lt;?php</code>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        ```

### 时间类
- 时间插件WdatePicker
    * HTML
        ```javascript  
            
        ```
    * jQuery
        ``` javascript     
            
        ```