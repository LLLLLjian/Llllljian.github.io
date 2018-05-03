---
title: PHP_Yii框架 (17)
date: 2018-02-27
tags: Yii
toc: true
---

#### 创建表单
    在 Yii 中使用表单的主要方式是通过 yii\widgets\ActiveForm。如果是基于 模型的表单应首选这种方式。此外，在 yii\helpers\Html中也有一些实用的 方法用于添加按钮和帮助文本

<!-- more -->

#### ActiveForm
    ```bash
        <?php  
        use yii\helpers\Html;  
        use yii\widgets\ActiveForm;  
        
        ?>  
        
        <?php $form = ActiveForm::begin([  
                            'action' => ['log/login'], //提交地址(*可省略*)  
                            'method'=>'post',    //提交方法(*可省略默认POST*)  
                            'id' => 'login-form', //设置ID属性  
                            'options' => [  
                                    'class' => 'form-horizontal', //设置class属性  
                                    'enctype' => 'multipart/form-data' //文件上传时添加该编码  
                            ],  
                            'fieldConfig' => [  
                                    'template' => '<div class="form-group"><center><label class="col-md-2 control-label" for="type-name-field">{label}</label></center><div class="col-md-8 controls">{input}{error}</div></div>'  
                            ],  //设置模板的样式  
        ]); ?>  
        
        <!--文本框-->  
        <?= $form->field($model, 'username', ['inputOptions' => ['placeholder'=>'请输入用户名','class' => 'ipt'],'template'=>'<div class="form-group"><div class="col-md-8 controls">{label}{input}{error}</div></div>'])
                 ->textInput(['maxlength' => 20,"style"=>"width:200px; height:30px;"]) ?>  

        <!--文本框 默认值-->  
        <?= $form->field($model, 'name')
                 ->textInput(['value' => '需要的值'])?>
            
        <!--密码框-->  
        <h4>密码</h4><?= $form->field($model, 'pwd')
                              ->label(false)
                              ->passwordInput(['maxlength' => 20,"style"=>"width:200px; height:30px;","placeholder"=>"请输入您的密码"]) ?>  
    
        <?= $form->field($model, 're_pwd')
                 ->passwordInput(['maxlength' => 20,"style"=>"width:200px; height:30px;","placeholder"=>"请输入您的密码"]) ?>  
        
        <!--单选按钮-->  
        <?= $form->field($model, 'sex')->radioList(['1'=>'男','0'=>'女']) ?>

        <!--单选按钮 默认选中-->
        <?php $model->is_use = '需要的值'?>
        <?= $form->field($model, 'is_use ')->radioList(['1' => '是', '0' => '否'])->label('是否需要')?>
    
        <!--验证邮箱-->  
        <?= $form->field($model, 'email')
                 ->textInput() ?>  
        
        <!--下拉框的默认选中使用 prompt 设置 -->  
        <?= $form->field($model, 'school')
                 ->dropDownList(['1'=>'大学','2'=>'高中','3'=>'初中'], ['prompt'=>'请选择','style'=>'width:120px']) ?>  

        <!--下拉框的默认选中 --> 
        <?php $model->id = $data['id']?>
        <?= $form->field($model, 'id')->dropDownList(['1'=>'大学','2'=>'高中','3'=>'初中'])?>
        
        <!--文件上传-->  
        <?= $form->field($model, 'photo')
                 ->fileInput() ?>  
        
        <!--复选框 -->  
        <?= $form->field($model, 'hobby')
                 ->checkboxList(['0'=>'篮球','1'=>'足球','2'=>'羽毛球','3'=>'乒乓球']) ?>  
        
        <!--复选框 默认选中 --> 
        <?php $model->country= $array?>
        <?= $form->field($model, 'country')->checkboxList(['0'=>'篮球','1'=>'足球','2'=>'羽毛球','3'=>'乒乓球'])?>
        
        <!--文本域-->  
        <?= $form->field($model, 'remark')
                 ->textarea(['rows'=>3]) ?>  
        
        <!--隐藏域-->  
        <?= $form->field($model, 'userid')
                 ->hiddenInput(['value'=>3])
                 ->label(false); ?>  

        <!--增加一个提示标签 hint-->  
        <?= $form->field($model, 'username')->textInput()->hint('Please enter your name')->label('Name') ?>

        <!-- 创建一个 HTML5 邮箱输入框 --> 
        <?= $form->field($model, 'email')->input('email') ?>
    
        <?= Html::submitButton('提交', ['class'=>'btn btn-primary','name' =>'submit-button']) ?>  
            
        <?= Html::resetButton('重置', ['class'=>'btn btn-primary','name' =>'submit-button']) ?>  
        
        <?php ActiveForm::end(); ?>  
    ```