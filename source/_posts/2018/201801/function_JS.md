---
title: javascript_功能
date: 2018-01-23
tags: JS
toc: true
---

### 禁用退格键
```javascript
    document.onkeydown = function(e) {
        e = e||event; 
        if(e.keyCode == 8) {
            // 如果是在textarea内不执行任何操作
            var obj = e.srcElement || e.target;
            var tag=obj.tagName.toLowerCase();
                if(tag != "input"  && tag != "textarea" && tag != "password")
                    return false;         
        } 
    }
```

<!-- more -->

### 禁止input框事件
    ondragstart="return false" 禁止鼠标在网页上拖动
    ondragenter 当用户拖曳对象到一个合法拖曳目标时在目标元素上触发
    onpaste="return false" 禁止粘贴
```javascript
    <input class="xinput" 
            maxlength=4 
            size="5" 
            onkeydown="fnKeyDown(event);" 
            onfocus="this.select()" 
            onclick="this.select()" 
            onpaste="return false" 
            ondrop="return false" 
            ondragenter="return false;" 
            ondragstart="return false" 
            onkeypress="return keyDigt(event)" value="" />
```

### 文本域快捷键
    enter和ctrl+enter操作
    alt+enter为换行
```javascript
    $("textarea").keydown(function(event) {
        if (event.altKey && event.keyCode == 13) {
            var e = $(this).val();
            $(this).val(e + '\n');
        } else if (event.ctrlKey && event.keyCode == 13) {
            event.returnValue = false;
            sendText();// 提交内容
            return false;
        } else if (event.keyCode == 13) {
            event.returnValue = false;
            sendText();// 提交内容
            return false;
        }
    });
```

### 只输入数字
```javascript
    <script type="text/javascript">
		function onlyNumber (obj) {
	        //得到第一个字符是否为负号
	        var t = obj.value.charAt(0);
	        //先把非数字的都替换掉,除了数字和.
	        obj.value = obj.value.replace(/[^\d\.]/g,'');
	        //必须保证第一个为数字而不是.
	        obj.value = obj.value.replace(/^\./g,'');
	        //保证只有一个.而没有多个.
	        obj.value = obj.value.replace(/\.{2,}/g,'.');
	        //保证.只出现一次,而不能出现两次以上
	        obj.value = obj.value.replace('.','$#$').replace(/\./g,'').replace('$#$','.');
	        //如果第一个位是负号,则允许添加
	        if(t == '-'){
	            obj.value = '-'+obj.value;
	        }
	    }	  
	</script>

    <input type="text" name="number" onkeyup="onlyNumber(this)">
```

### 实时获取文本框内容
```javascript
    <script type="text/javascript">
	var formBind = {
		initialize:function(){
            this.a1 = $('#a1');
            this.a2 = $('#a2');
            this.a3 = $('#a3');
            this.textarea = $('#textarea');
            this.sub = $('#sub');
            this.form = $('#form');
            this.post_url = "demo.php";
            this.initEvent();
        },
        initEvent:function(){
            this.a1.on('input propertychange',this.setData.bind(this));
            this.a2.on('input propertychange',this.setData.bind(this));
            this.a3.on('input propertychange',this.setData.bind(this));
            this.sub.on('click',this.postData.bind(this));
        },
        setData:function(){
            var reg = /^[0-9\.]*$/;
            if(!reg.test(this.a1.val()) || !reg.test(this.a2.val())){
                //return false;
            }

            var text = "";
            if (this.a1.val() != "") {
            	text = text + 'a1的值为'+this.a1.val()+',';
            }
            if (this.a2.val() != "") {
            	text = text + 'a2的值为'+this.a2.val()+',';
            }
            if (this.a3.val() != "") {
            	text = text + 'a3的值为'+this.a3.val()+',';
            }
            
            this.textarea.html(text);
        },
        postData:function(){
            if(this.a1.val() == ''){
                alert('a1的值不能为空！');
                return false;
            }

            this.commit_button.attr('disabled',true);//隐藏点击按钮
            var that = this;
            $.ajax({
                url : this.post_url,
                data : this.form.serialize(),
                type : "POST",
                dataType : "json",
                success:function(result){
                    alert(result.msg);
                },
                complete:function(req,text){
                    if(text!='success'){
                        alert(text+" "+req.responseText);
                    }
                }
            });
            return false;
        }
    };

    $(document).ready(function() {
    	formBind.initialize();
    })	  
	</script>

    <form id="form">
		a1 : <input type="text" name="a1" id="a1"><br />
		a2 : <input type="text" name="a2" id="a2"><br />
		a3 : <input type="text" name="a3" id="a3"><br />
		textarea : <textarea id="textarea" name="textarea"></textarea>
		<input type="button" name="sub" id="sub" value="提交">
	</form>
```