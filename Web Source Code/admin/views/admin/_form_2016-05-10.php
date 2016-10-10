<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Admin */
/* @var $form yii\widgets\ActiveForm */

$session = Yii::$app->session;

?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>
	
    <?php if($session['login_role'] == 1) { ?>
	<?= $form->field($model_l, 'email')->textInput(['maxlength' => true]) ?>
	<?php } ?> 
    
    <?= $form->field($model_a, 'mobile')->textInput(['maxlength' => true]) ?>

    <?php /*?><?= $form->field($model, 'auth_key')->textInput(['maxlength' => true]) ?><?php */?>

    <?php /*?><?= $form->field($model, 'password_reset_token')->textInput(['maxlength' => true]) ?><?php */?>

    <?= $form->field($model_a, 'security_question')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model_a, 'security_answer')->textInput(['maxlength' => true]) ?>
    
    <?= $form->field($model_l, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter your password']) ?>

    <?= $form->field($model_l, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
    <?php /*?><?= $form->field($model, 'verif_link')->textInput(['maxlength' => true]) ?><?php */?>

    <?php /*?><?= $form->field($model, 'last_login_date')->textInput() ?><?php */?>

    <?php /*?><?= $form->field($model, 'last_login_ip')->textInput(['maxlength' => true]) ?><?php */?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model_a->isNewRecord ? 'Create' : 'Update', ['class' => $model_a->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>