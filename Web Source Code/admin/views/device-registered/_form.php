<?php

use yii\helpers\Html;
use yii\helpers\ArrayHelper;
use yii\widgets\ActiveForm;
use app\models\Users;

/* @var $this yii\web\View */
/* @var $model app\models\DeviceRegistered */
/* @var $form yii\widgets\ActiveForm */
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

    <?php /*?><?= $form->field($model, 'user_id')->textInput(['maxlength' => true]) ?><?php */?>
    
    <?= $form->field($model, 'user_id')->dropDownlist(ArrayHelper::map(Users::find(['id', 'email'])->all(), 'id', 'email'), ['id' => 'title']) ?>

    <?= $form->field($model, 'device_id')->textInput(['maxlength' => true]) ?>
    
    <?= $form->field($model, 'notif_id')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'type')->dropDownList(['1' => 'iOs', '2' => 'Android'], ['id'=> 'title']) ?>

    <?php /*?><?= $form->field($model, 'reg_datetime')->textInput() ?><?php */?>

    <?= $form->field($model, 'status')->dropDownList(['1' => 'Active', '0' => 'Inactive'], ['id'=> 'title']) ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>