---
title: JS_插件(2)
date: 2017-12-14
tags: JS
toc: true
---

## 使用过的前端插件
    下边写的都是一些自己使用过的插件,只是简单的写了一个例子,具体的还是要再看文档.

<!-- more -->

### 页面类
- 分享选中内容插件
    * HTML
        ``` javascript  
            <div id="share">  
                <div class="bdsharebuttonbox" data-tag="share_1">  
                    <a class="bds_mshare" data-cmd="mshare">mshare</a>  
                    <a class="bds_qzone" data-cmd="qzone">qzone</a>  
                    <a class="bds_tsina" data-cmd="tsina">tsina</a>  
                    <a class="bds_baidu" data-cmd="baidu">baidu</a>  
                    <a class="bds_renren" data-cmd="renren">renren</a>  
                    <a class="bds_tqq" data-cmd="tqq">tqq</a>  
                </div>  
            </div>  
        ```
    * JS
        ``` javascript     
            window._bd_share_config = {  
                "common": {  
                    "bdSnsKey": {},  
                    "bdMini": "2",  
                    "bdMiniList": false,  
                    "bdText": '自定义分享内容',   
                    "bdDesc": '自定义分享摘要',   
                    "bdUrl": '自定义分享url地址',     
                    "bdPic": '自定义分享图片',  
                    "bdStyle": "1",  
                    "bdSize": "16"  
                },  
                "share": {  
                    "bdSize": 16,  
                    "bdCustomStyle":"./css/demo.css"  
                }  
            }  
        
            //以下为js加载部分  
            with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?cdnversion='+~(-new Date()/36e5)];
        ```
    * CSS
        ``` javascript  
            /*
            .bdsharebuttonbox a
            {
                display:inline-block;
                height:100px;
                background:url(http://42.121.106.37//images/logo.png);
                width:100px;
                float:left;
            }  

            .bds_qzone
            {
                background:#999;
            }  

            .bds_tsina
            {
                background:#333;
            }
            */   
        ```

- 页面消息提示toastr
    * AJAX响应部分
        ``` javascript  
            success : function (data) {
                data.err? toastr.error(data.msg) : toastr.success(data.msg);
            }

            其它颜色响应：

            //常规消息提示,默认背景为浅蓝色  
            toastr.info("你有新消息了!");  
            //成功消息提示,默认背景为浅绿色 
            toastr.success("你有新消息了!"); 
            //警告消息提示,默认背景为橘黄色 
            toastr.warning("你有新消息了!"); 
            //错误消息提示,默认背景为浅红色 
            toastr.error("你有新消息了!");  
            //带标题的消息框
            toastr.success("你有新消息了!","消息提示");
            //另一种调用方法
            toastr["info"]("你有新消息了!","消息提示");
        ```
    * JS自定义配置
        ``` javascript     
            toastr.options = {  
                closeButton: false, //是否显示关闭按钮(提示框右上角关闭按钮）；
                debug: false,  //是否为调试； 
                progressBar: true,  //是否显示进度条(设置关闭的超时时间进度条）； 
                positionClass: "toast-bottom-center",  //消息框在页面显示的位置
                onclick: null,  
                showDuration: "300",  
                hideDuration: "1000",  
                timeOut: "2000",  
                extendedTimeOut: "1000",  
                showEasing: "swing",  
                hideEasing: "linear",  
                showMethod: "fadeIn",  
                hideMethod: "fadeOut"  
            };

            positionClass :

            toast-top-left  顶端左边
            toast-top-right    顶端右边
            toast-top-center  顶端中间
            toast-top-full-width 顶端,宽度铺满整个屏幕
            toast-botton-right  
            toast-bottom-left
            toast-bottom-center
            toast-bottom-full-width
        ```

### 表格类
- 表格头固定fixedtableheader
    * HTML
        ``` javascript  
            <table id="tdata-1">

            </table>
        ```
    * jQuery
        ``` javascript     
            $(document).ready(function() { 
                $('#tdata-1').fixedtableheader({ 
                　　highlightrow: true,
                    //头固定几行   
                    headerrowsize: 4
                }); 
            }); 
        ```

- 导出表格数据tableexcel
    * HTML
        ``` javascript  
            <table>
                <thead>
                    <tr class="noExl">
                    <td>带<code>noExl</code>class的行不会被输出到excel中</td>
                    <td>带<code>noExl</code>class的行不会被输出到excel中</td>
                    </tr>
                    <tr>
                    <td>这一行会被导出到excel中</td>
                    <td>这一行会被导出到excel中</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                    <td>单元格1-1</td>
                    <td>单元格1-2</td>
                    </tr>
                    <tr>
                    <td>单元格2-1</td>
                    <td>单元格2-2</td>
                    </tr>
                    <tr>
                    <td>单元格3-1</td>
                    <td>单元格3-2</td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                    <td colspan="2">合并2个单元格</td>
                    </tr>
                </tfoot>
                </table> 
        ```
    * jQuery
        ``` javascript     
            $("#table2excel").table2excel({
                // 不被导出的表格行的CSS class类
                exclude: ".noExl",
                // 导出的Excel文档的名称
                name: "Excel Document Name",
                // Excel文件的名称
                filename: "myExcelTable"
            });
        ```
    * 配置参数
        ``` javascript
            exclude：不被导出的表格行的CSS class类.
            name：导出的Excel文档的名称.
            filename：Excel文件的名称.
            exclude_img：是否导出图片.
            exclude_links：是否导出超链接
            exclude_inputs：是否导出输入框中的内容.
        ```

###   树插件类
- 树插件zTree
    * HTML
    * jQuery
