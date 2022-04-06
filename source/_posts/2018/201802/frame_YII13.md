---
title: PHP_Yii框架 (13)
date: 2018-02-09
tags: Yii
toc: true
---

### 行为
    具体的可以看文档,简单记录一下自己使用的三个和两个典型的例子

<!-- more -->

#### TimestampBehavior
    ```php
        namespace app\models\User;

        use yii\db\ActiveRecord;
        use yii\behaviors\TimestampBehavior;

        class User extends ActiveRecord
        {
            // ...

            public function behaviors()
            {
                return [
                    // 当记录插入时,行为将当前时间戳赋值给 created_at 和 updated_at 属性；
                    // 当记录更新时,行为将当前时间戳赋值给 updated_at 属性.
                    [
                        // 匿名的行为,仅直接给出行为的类名称 
                        'class' => TimestampBehavior::className(),
                        // 写明表中需要插入的时间字段[可根据自己表的实际情况修改]
                        'createdAtAttribute' => 'created_at',    
                        // 写明表中需要更新的时间字段[可根据自己表的实际情况修改]
                        'updatedAtAttribute' => 'updated_at', 
                        // 不需要当前属性可以设置为false 
                        //'updatedAtAttribute' => false, 
                        'attributes' => [
                            ActiveRecord::EVENT_BEFORE_INSERT => ['created_at', 'updated_at'],
                            ActiveRecord::EVENT_BEFORE_UPDATE => ['updated_at'],
                        ],
                        // 默认值为时间戳,修改的话可以通过value属性
                        //'value' => time(),
                    ],
                ];
            }
        }
    ```

#### BlameableBehavior
    ```php
        namespace app\models\User;

        use yii\db\ActiveRecord;
        use yii\behaviors\BlameableBehavior;

        class User extends ActiveRecord
        {
            public function behaviors()
            {
                return [
                    // 当记录插入时,行为将当前用户id赋值给 author_id 和 updater_id 属性；
                    // 当记录更新时,行为将当前用户id赋值给 updater_id 属性.
                    [
                        // 匿名的行为,仅直接给出行为的类名称 
                        'class' => BlameableBehavior::className(),
                        // 写明表中需要插入的操作者字段[可根据自己表的实际情况修改]
                        'createdByAttribute' => 'author_id',    
                        // 写明表中需要更新的操作者字段[可根据自己表的实际情况修改]
                        'updatedByAttribute' => 'updater_id',  
                        'attributes' => [
                            ActiveRecord::EVENT_BEFORE_INSERT => ['author_id', 'updater_id'],
                            ActiveRecord::EVENT_BEFORE_UPDATE => ['updater_id'],
                        ],
                        // 默认值为当前用户id,修改的话可以通过value属性
                        //'value' => ,
                    ],
                ];
            }
        }
    ```

#### AttributeBehavior
    ```php
        namespace app\models\User;

        use yii\db\ActiveRecord;
        use yii\behaviors\TimestampBehavior;

        class User extends ActiveRecord
        {
            // ...
            public function behaviors()
            {
                return [
                    // 当记录插入时,行为将value的返回值给 attribute1 属性；
                    // 当记录更新时,行为将value的返回值给 attribute2 属性；
                    [
                        'class' => AttributeBehavior::className(),
                        'attributes' => [
                            ActiveRecord::EVENT_BEFORE_INSERT => 'attribute1',
                            ActiveRecord::EVENT_BEFORE_UPDATE => 'attribute2',
                        ],
                        'value' => function ($event) {
                            return 'some value';
                        },
                    ],
                ];
            }
        }
    ```

#### 针对1,2优化
    优化情况为 : 所有表中涉及的创建时间 更新时间 创建人 更新人字段名都相同
    ```php
        namespace common\models\activeRecord;

        use yii;
        use yii\db\ActiveRecord;
        use common\lib\db\TimestampBehavior;
        use common\lib\db\CreatorOrUpdaterBehavior;

        class Aaaa extends ActiveRecord
        {
            public function behaviors()
            {
                return [
                    TimestampBehavior::className(),
                    CreatorOrUpdaterBehavior::className(),
                ];
            }
        }

        namespace common\lib\db;

        class TimestampBehavior extends \yii\behaviors\TimestampBehavior
        {
            // 数据库中创建时间对应字段ctime,在这里继承\yii\behaviors\TimestampBehavior统一修改
            public $createdAtAttribute = "ctime";

            // 数据库中更新时间对应字段mtime,在这里继承\yii\behaviors\TimestampBehavior统一修改
            public $upfateAtAttribute = "mtime";
        }

        namespace common\lib\db;

        class CreatorOrUpdaterBehavior extends \yii\behaviors\BlameableBehavior
        {
            // 数据库中创建者对应字段creator,在这里继承\yii\behaviors\BlameableBehavior
            public $createdByAttribute = "creator";

            // 数据库中更新者对应字段updater,在这里继承\yii\behaviors\BlameableBehavior
            public $upfateByAttribute = "updater";
        }
    ```

#### 实例[关于1,3]
    前提: 表goods和表news都要能上传附件[利用行为快速实现]
    ```php
        class News extends \yii\db\ActiveRecord
        {
            public function behaviors() 
            {
                return [
                    TimestampBehavior::className(),
                    [
                        'class' => AttachmentsBehavior::className(),
                        'uploadFiles' => 'attachmentsToBe',
                        'uploadedFiles' => 'attachments',
                    ]
                ];
            }
        }

        class Goods extends \yii\db\ActiveRecord
        {
            public function behaviors() 
            {
                return [
                    TimestampBehavior::className(),
                    [
                        'class' => AttachmentsBehavior::className(),
                        'uploadFiles' => 'attachmentsToBe',
                        'uploadedFiles' => 'attachments',
                    ]
                ];
            }
        }

        class AttachmentsBehavior extends Behavior 
        {

            private $_files;
            // 需要上传的文件属性
            public $uploadFiles = 'uploadfiles';
            // 已经上传了的文件属性
            public $uploadedFiles = 'uploadedfiles';
            // 保存路径
            public $savePath = '@common/upload';
            // 访问路径
            public $saveUrl = '@commonurl/upload';

            public function events() 
            {
                return [
                    BaseActiveRecord::EVENT_BEFORE_VALIDATE => 'beforeValidate',
                    BaseActiveRecord::EVENT_AFTER_INSERT => 'afterSave',
                    BaseActiveRecord::EVENT_AFTER_UPDATE => 'afterSave',
                    BaseActiveRecord::EVENT_BEFORE_DELETE => 'beforeDelete',
                ];
            }

            // 在验证开始之前调用此方法
            public function beforeValidate()
            {
            $this->_files = UploadedFile::getInstances($this->owner, $this->uploadFiles);
            }

            // 返回拥有者的唯一Id
            public function getIdentityId()
            {
                return  $this->owner->className().'.'.$this->owner->id;
            }

            // 明确拥有者与附件的关系-连表查询
            public function getAttachments()
            {
                return $this->owner->hasMany(Attachments::className(),['ownerId' => 'identityId']);
            }

            // 在主模型保存后挨个保存附件
            public function afterSave()
            {

                foreach ($this->_files as $file) {
                    $model = new Attachments();
                    $model->fileName = $file->name;
                    $model->url = date('Ymd') . Yii::$app->getSecurity()->generateRandomString(8) .'.'. $file->extension;
                    $model->ownerId = $this->owner->identityId;
                    $model->savePath = Yii::getAlias($this->savePath);
                    $file->saveAs(Yii::getAlias($this->savePath) . DIRECTORY_SEPARATOR .$model->url);
                    $model->save();
                }

            }

            // 在主模型删除之前删除所有附件
            public function beforeDelete()
            {

                foreach ($this->owner->{$this->uploadedFiles} as $file){
                    $file->delete();
                }
                return true;
            }


            public function getFilesUrl($url)
            {
                return Yii::getAlias($this->saveUrl) . DIRECTORY_SEPARATOR. $url;
            }

        }
    ```