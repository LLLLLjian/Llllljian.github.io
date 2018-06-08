---
title: PHP_Yii框架 (7)
date: 2018-02-02
tags: Yii
toc: true
---

### 小部件

#### 说明
- 小部件是面向对象方式来重用视图代码.
- 创建小部件时仍需要遵循MVC模式,通常逻辑代码在小部件类, 展示内容在视图中.
- 小部件设计时应是独立的,也就是说使用一个小部件时候, 可以直接丢弃它而不需要额外的处理. 
- 但是当小部件需要外部资源如CSS, JavaScript, 图片等会比较棘手, 幸运的时候Yii提供 资源包 来解决这个问题.
- 当一个小部件只包含视图代码,它和视图很相似, 实际上,在这种情况下,唯一的区别是小部件是可以重用类, 视图只是应用中使用的普通PHP脚本.

<!-- more -->

#### 使用小部件
- 日期
    ```php
        <?php
        use yii\jui\DatePicker;
        ?>
        <?= DatePicker::widget([
            'model' => $model,
            'attribute' => 'from_date',
            'language' => 'ru',
            'dateFormat' => 'php:Y-m-d',
        ]) ?>
    ```
- 表单
    ```php
        <?php  
        use yii\helpers\Html;  
        use yii\bootstrap\ActiveForm;  
        ?>  
        
        <?php 
            $form=  ActiveForm::begin([  
                'id'=>'register',  
                'layout'=>'horizontal',  
                'action'=>'req.php',  
                'method'=>'get',  
                'fieldConfig' => [  
                        'template' => "{label}\n<div class=\"col-lg-3\">{input}</div>\n<div class=\"col-lg-8\">{error}</div>",  
                        'labelOptions' => ['class' => 'col-lg-1 control-label'],  
                ]  
            ]) 
        ?>  
        
        <!--文本框-->  
        <?= $form->field($model, 'name')->textInput(['placeholder'=>'请输入用户名']) ?>  


        <!--密码框-->  
        <?= $form->field($model, 'password')->passwordInput()?>  


        <!--多选框(单个)-->  
        <?= /*$form->field($model, 'hobby')->checkbox(['label'=>'爱好','uncheck'=>null,'value'=>1])*/ ?>  


        <!--多选框（多个）默认多选框是纵向排列  使用->inline()横向排列-->  
        <?php echo $form->field($model, 'hobby')->inline()->checkboxList(['1'=>'篮球','2'=>'排球'])?>  


        <!--多选框（多个）template设置模板,separator设置分割符 -->  
        <?php echo $form->field($model,'hobby')->inline()->checkboxList(['1'=>'篮球','2'=>'排球'])?>  


        <!--下拉框-->  
        <?php echo $form->field($model, 'city')->dropDownList(['1'=>'北京','2'=>'上海'],['prompt'=>'请选择','width'=>'120'])?>  


        <!--文件上传-->  
        <?php echo $form->field($model,'file')->fileInput()?>  


        <!--隐藏域-->  
        <?php echo $form->field($model,'token')->hiddenInput(['value'=>'1234567890'])->label(false);?>  


        <!--listbox-->  
        <?php echo $form->field($model,'city')->listBox(['1'=>'北京','2'=>'上海'],['prompt'=>'请选择'])?>  


        <!--单选按钮 多个-->  
        <?php echo $form->field($model,'gender')->inline()->radioList([1=>'男','2'=>'女'])?>  


        <!--单选按钮 一个-->  
        <?php echo $form->field($model,'gender')->radioList(['2'=>'选中'])?>  


        <!--提交按钮-->  
        <?php echo Html::submitButton('注册',['class' => 'btn btn-primary', 'name' => 'login-button'])?>  
        
        <?php ActiveForm::end();?>  
    ```