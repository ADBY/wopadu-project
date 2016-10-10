<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\TranslaterUser */
/* @var $form yii\widgets\ActiveForm */

$session = Yii::$app->session;
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

    <?= $form->field($model_t, 'first_name')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model_t, 'last_name')->textInput(['maxlength' => true]) ?>
    
    <?php if($session['login_role'] != 6) { ?>
    
    <?= $form->field($model_l, 'email')->textInput(['maxlength' => true, 'placeholder' => 'Enter your email']) ?>

    <?= $form->field($model_l, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter your password']) ?>
    
    <?php if(!$model_l->isNewRecord) { ?>
    <?= $form->field($model_l, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
    <?php } ?>
    
    <?php } ?>

    <?= $form->field($model_l, 'status')->dropDownList(
		['1' => 'Active', '0' => 'Deactive'],
		['id'=>'title']
	) ?>   
    
    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model_l->isNewRecord ? 'Create' : 'Update', ['class' => $model_l->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
