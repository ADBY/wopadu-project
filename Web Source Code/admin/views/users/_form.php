<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Users */
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

	<?php /*?><?= $form->errorSummary($model); ?><?php */?>

    <?= $form->field($model, 'first_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter first name. E.g. Shirish'])->label('First Name') ?>

    <?= $form->field($model, 'last_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter last name. E.g. Makwana']) ?>

    <?= $form->field($model, 'email')->textInput(['maxlength' => true, 'placeholder' => 'Please enter user email. E.g. abc@xyz.com']) ?>

    <?= $form->field($model, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter password']) ?>
    
    <?= $form->field($model, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>

    <?= $form->field($model, 'pin_number')->textInput(['maxlength' => 4, 'placeholder' => 'Please enter pin number. E.g. 1234']) ?>

    <?= $form->field($model, 'mobile')->textInput(['maxlength' => true, 'placeholder' => 'Please enter mobile number']) ?>
    
    <?= $form->field($model, 'allergies')->textarea(['rows' => 3]) ?>

    <?php /*?><?= $form->field($model, 'image')->fileInput() ?><?php */?>

    <?php /*?><?= $form->field($model, 'reg_datetime')->textInput() ?><?php */?>

    <?= $form->field($model, 'verif_account')->dropDownList(['1' => 'Yes', '0' => 'No'], ['id' => 'title']) ?>

    <?php /*?><?= $form->field($model, 'verif_code')->textInput(['maxlength' => true]) ?><?php */?>

    <?php /*?><?= $form->field($model, 'verif_code_exp_datetime')->textInput() ?><?php */?>

    <?php /*?><?= $form->field($model, 'verif_datetime')->textInput() ?><?php */?>

    <?= $form->field($model, 'status')->dropDownList(['1'=> 'Active', '0' => 'Inactive'], ['id' => 'title']) ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>