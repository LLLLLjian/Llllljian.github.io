---
title: Tencent_基础 (8)
date: 2019-07-09
tags: 
    - Tencent
    - Linux
    - ThinkPHP
toc: true
---

### 验证码的使用
    使用Composer快速安装think-captcha扩展包

<!-- more -->

#### 安装
- 安装前提
    * 进入tp根目录
    *  Composer可以正常使用
- 安装流程
    ```bash
        composer require topthink/think-captcha=2.0.*
    ```

#### 简单使用
- html
    ```html
        <div class="layui-form-item larry-verfiy-code" id="larry_code">
            <input type="text" name="code" required lay-verify="required" aautocomplete="off" class="layui-input larry-input" placeholder="输入验证码" autocomplete="off">
            <div class="code">
                <div style="width: 270px; height: 55px;">
                    <img src="{:captcha_src()}" onClick="this.src='{:captcha_src()}?'+Math.random();" alt="captcha" style="width: 178px; height: 36px; padding: 1px 0px 0px 2px;" />
                </div>
            </div>
        </div>
    ```
- php
    ```php
        if (! captcha_check(input('code'))) {
            $res['code'] = - 1.5;
            $res['msg'] = "验证码错误";
            echo json_encode($res);
            return;
        }
    ```

#### 个性化配置
- config
    ```bash
        # 在config文件中新建captcha.php
        [ubuntu@llllljian-cloud-tencent ~ 17:50:15 #26]$ cat /var/nginx/html/tp5/config/captcha.php
        <?php
        return [
            // 验证码字体大小
            'fontSize'    =>    30,    
            // 验证码位数
            'length'      =>    2,   
            // 关闭验证码杂点
            'useNoise'    =>    false,
            // 验证码字符集合
            'codeSet' => '23456789'
        ]; 
    ```
- 其他配置
    <table><thead><tr><th>参数</th><th>描述</th><th>默认</th></tr></thead><tbody><tr><td>codeSet</td><td>验证码字符集合</td><td>略</td></tr><tr><td>expire</td><td>验证码过期时间（s）</td><td>1800</td></tr><tr><td>useZh</td><td>使用中文验证码</td><td>false</td></tr><tr><td>zhSet</td><td>中文验证码字符串</td><td>略</td></tr><tr><td>useImgBg</td><td>使用背景图片</td><td>false</td></tr><tr><td>fontSize</td><td>验证码字体大小(px)</td><td>25</td></tr><tr><td>useCurve</td><td>是否画混淆曲线</td><td>true</td></tr><tr><td>useNoise</td><td>是否添加杂点</td><td>true</td></tr><tr><td>imageH</td><td>验证码图片高度,设置为0为自动计算</td><td>0</td></tr><tr><td>imageW</td><td>验证码图片宽度,设置为0为自动计算</td><td>0</td></tr><tr><td>length</td><td>验证码位数</td><td>5</td></tr><tr><td>fontttf</td><td>验证码字体,不设置是随机获取</td><td>空</td></tr><tr><td>bg</td><td>背景颜色</td><td>[243, 251, 254]</td></tr><tr><td>reset</td><td>验证成功后是否重置</td><td>true</td></tr></tbody></table>
