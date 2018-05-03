---
title: PHP_Yii框架 (19)
date: 2018-03-01
tags: Yii
toc: true
---

### 文件上传
    在Yii里上传文件通常使用yii\web\UploadedFile类， 它把每个上传的文件封装成 UploadedFile 对象

<!-- more -->

#### 单文件上传
- 创建模型
    ```bash
        namespace app\models;

        use yii\base\Model;
        use yii\web\UploadedFile;

        class UploadForm extends Model
        {
            public $imageFile;

            public function rules()
            {
                return [
                    [['imageFile'], 'file', 'skipOnEmpty' => false, 'extensions' => 'png, jpg'],
                ];
            }
            
            public function upload()
            {
                if ($this->validate()) {
                    // 确保文件夹有写的权限
                    $this->imageFile->saveAs('uploads/' . $this->imageFile->baseName . '.' . $this->imageFile->extension);
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```
- 视图文件
    ```bash
        <?php
        use yii\widgets\ActiveForm;
        ?>

        <?php $form = ActiveForm::begin(['options' => ['enctype' => 'multipart/form-data']]) ?>

            <?= $form->field($model, 'imageFile')->fileInput() ?>

            <button>Submit</button>

        <?php ActiveForm::end() ?>
    ```
- 控制器文件
    ```bash
        namespace app\controllers;

        use Yii;
        use yii\web\Controller;
        use app\models\UploadForm;
        use yii\web\UploadedFile;

        class SiteController extends Controller
        {
            public function actionUpload()
            {
                $model = new UploadForm();

                if (Yii::$app->request->isPost) {
                    $model->imageFile = UploadedFile::getInstance($model, 'imageFile');
                    if ($model->upload()) {
                        // 文件上传成功
                        return;
                    }
                }

                return $this->render('upload', ['model' => $model]);
            }
        }
    ```

#### 多文件上传
- 创建模型
    ```bash
        namespace app\models;

        use yii\base\Model;
        use yii\web\UploadedFile;

        class UploadForm extends Model
        {
            /**
            * @var UploadedFile[]
            */
            public $imageFiles;

            public function rules()
            {
                return [
                    // 重点 maxFiles 设置允许上传的最大文件数
                    [['imageFiles'], 'file', 'skipOnEmpty' => false, 'extensions' => 'png, jpg', 'maxFiles' => 4],
                ];
            }
            
            public function upload()
            {
                if ($this->validate()) { 
                    foreach ($this->imageFiles as $file) {
                        $file->saveAs('uploads/' . $file->baseName . '.' . $file->extension);
                    }
                    return true;
                } else {
                    return false;
                }
            }
        }
    ```
- 视图文件
    ```bash
        <?php
        use yii\widgets\ActiveForm;
        ?>

        <?php $form = ActiveForm::begin(['options' => ['enctype' => 'multipart/form-data']]) ?>

            <?= $form->field($model, 'imageFiles[]')->fileInput(['multiple' => true, 'accept' => 'image/*']) ?>

            <button>Submit</button>

        <?php ActiveForm::end() ?>
    ```
- 控制器文件
    ```bash
        namespace app\controllers;

        use Yii;
        use yii\web\Controller;
        use app\models\UploadForm;
        use yii\web\UploadedFile;

        class SiteController extends Controller
        {
            public function actionUpload()
            {
                $model = new UploadForm();

                if (Yii::$app->request->isPost) {
                    $model->imageFiles = UploadedFile::getInstances($model, 'imageFiles');
                    if ($model->upload()) {
                        // 文件上传成功
                        return;
                    }
                }

                return $this->render('upload', ['model' => $model]);
            }
        }
    ```