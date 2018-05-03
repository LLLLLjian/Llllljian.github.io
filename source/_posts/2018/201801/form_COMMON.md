---
title: 公用_表单
date: 2018-01-24
tags: COMMON
toc: true
---

## 用户注册表单
    基于jQuery的一些表单验证判断(需要添加部分css样式)

<!-- more -->

```bash
<form method="post" onsubmit="return checkForm(this)">
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="username" class="ant-form-item-required" title="用户名">用户名</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper">
                    <input type="text" placeholder="只能使用字母+数字，且字母开头" maxlength="11" id="username" name="username" class="ant-input ant-input-lg">
                </span>
            </div>
        </div>
    </div>
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="phone" class="ant-form-item-required" title="手机号">手机号</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper">
                    <input type="text" placeholder="请输入手机号" maxlength="11" id="phone" name="phone" class="ant-input ant-input-lg">
                </span>
            </div>
        </div>
    </div>
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="sms_code" class="ant-form-item-required" title="手机验证码">手机验证码</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper" style="width: 50%;">
                    <input type="text" maxlength="6" placeholder="手机验证码" name="sms_code" id="sms_code" class="ant-input ant-input-lg">
                </span>
                <button type="button" class="ant-btn ant-btn-primary ant-btn-lg" style="width: 48%;position: relative;top: -1px;" id="getcode" onclick="send()">
                    <span>获取验证码</span>
                </button>
            </div>
        </div>
    </div>
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="email" class="ant-form-item-required" title="邮箱">邮箱</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper">
                    <input type="email" name="email" placeholder="请输入邮箱" id="email" class="ant-input ant-input-lg">
                </span>
            </div>
        </div>
    </div>
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="qq" class="ant-form-item-required" title="QQ">QQ</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper">
                    <input type="qq" name="qq" placeholder="请输入QQ" id="qq" class="ant-input ant-input-lg">
                </span>
            </div>
        </div>
    </div>
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="password" class="ant-form-item-required" title="设置密码">设置密码</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper">
                    <input type="password" maxlength="128" placeholder="请输入密码" name="password" id="password" class="ant-input ant-input-lg">
                </span>
            </div>
        </div>
    </div>
    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="repassword" class="ant-form-item-required" title="确认密码">确认密码</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
            <div class="ant-form-item-control ">
                <span class="ant-input-affix-wrapper">
                    <input type="password" maxlength="128" placeholder="请重新输入密码" name="repassword" id="repassword" class="ant-input ant-input-lg">
                </span>
            </div>
        </div>
    </div>

    <div class="ant-row ant-form-item">
        <div class="ant-col-6 ant-form-item-label">
            <label for="company" class="ant-form-item-required" title="公司名称">公司名称</label>
        </div>
        <div class="ant-col-18 ant-form-item-control-wrapper">
        <div class="ant-form-item-control ">
            <span class="ant-input-affix-wrapper">
                <input type="text" placeholder="请输入公司名称" value="" id="company" class="ant-input ant-input-lg">
            </span>
        </div>
      </div>
    </div>
    <div class="ant-row ant-form-item" style="margin-bottom: 5px;">
        <div class="ant-form-item-control-wrapper">
            <div class="ant-form-item-control has-success">
                <label class="ant-checkbox-wrapper" style="float: left;">
                    <span class="ant-checkbox" id="checkbox"><!--ant-checkbox-checked-->
                        <input type="checkbox" class="ant-checkbox-input" value="1">
                        <span class="ant-checkbox-inner"></span>
                    </span>
                    <span>同意</span> 
                </label>
                <a href="">《服务条款》</a>
            </div>
        </div>
    </div>
    <div class="ant-row" style="display: flex; flex-direction: row;">
        <input type="submit" id="submit" class="submit ant-btn ant-btn-primary ant-btn-lg" value="注 册" disabled="disabled">
        <button type="button" class="ant-btn ant-btn-primary ant-btn-lg" style="margin-left: 5px;" onclick="window.location.href='/index.php/public/login'">
            <span>已有账号，去登录</span>
        </button>
    </div>
</form>

<script>
    $(function() {
        //同意协议
        $('#checkbox').click(function(){
            $(this).toggleClass('ant-checkbox-checked');
            if($(this).hasClass('ant-checkbox-checked')){
                $('#submit').removeAttr("disabled");
            }else{
                $('#submit').attr("disabled",true);
            }
        });
        //手机号输入状态检测
        $('#phone').on("input propertychange,blur",function(){
            var val=$(this).val();
            if(checkPhone(val)==true){
                $('#getcode').removeAttr("disabled");
            }else{
                $('#getcode').attr("disabled",true);
            }
        });
    };

    //验证手机号
    function checkPhone(phone) {
        if(!(/^1[34578]\d{9}$/.test(phone))){
            return false;
        }
        return true;
    }
    
    //验证邮箱
    function checkEmail(mail) {
        if(!(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/.test(mail))){
            return false;
        }
        return true;
    }

    //获取验证码
    function send() {
        var phone=$('#phone').val();
        if(checkPhone(phone)==false){
            alert('手机号码有误，请重填');
            return false;
        }
        $.get(
            '/send_sms',
            {phone:phone},
            function(res){
                if(res.code==1){
                    var secend=60;
                    var intval=window.setInterval(function(){
                        secend--;
                        $('#getcode span').html(""+secend+"秒后重新获取");
                        if(secend<=0){
                            window.clearInterval(intval);
                            $('#getcode').attr("disabled",false);
                            $('#getcode span').html("获取验证码");
                        }
                    },1000);

                    $('#getcode').attr("disabled",true);
                }else{
                    alert(res.info);
                }
        });
    }

    //提交表单、检测表单
    function checkForm(obj) {
        var flag=true;
        var username=$('#username');
        var phone=$('#phone');
        var sms_code=$('#sms_code');
        var password=$('#password');
        var repassword=$('#repassword');
        var email=$('#email');
        var vcode=$('#vcode');
        var qq=$('#qq');

        var re = /^[a-zA-Z][a-zA-Z0-9]*$/;
        if(!re.test(username.val())){
            alert('用户名只能使用字母或数字，且第一位为字母');
            return false;
        }
        if(username.val().length<4){
            alert('用户名过短');
            return false;
        }
        if(checkPhone(phone.val())==false){
            alert('手机号码有误，请重填');
            return false;
        }
        if(!sms_code.val()){
            alert('请输入短信验证码');
            return false;
        }
        if(password.val().length<6){
            alert('密码不能小于6位');
            return false;
        }
        if(password.val()!=repassword.val()){
            alert('两次密码不一致');
            return false;
        }
        if(!checkEmail(email.val())){
            alert('邮箱格式不正确');
            return false;
        }
        if(!vcode.val()){
            alert('请输入验证码');
            return false;
        }
        if($('#checkbox').hasClass('ant-checkbox-checked')){
            return true;
        }else{
            alert('请先阅读《服务条款》');
            return false;
        }
    }
</script>
```