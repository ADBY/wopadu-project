<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Kitchens */
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
<?php
/*echo "<pre>";
print_r($model_k->getErrors());
print_r($model_l->getErrors());
echo "</pre>";
exit;*/
?>
<?php //echo $form->errorSummary($model_l); ?>

    <?php /*?><?= $form->field($model, 'store_id')->textInput(['maxlength' => true]) ?><?php */?>
    
    <?php if(isset($_GET['id'])) { } else if(isset($_GET['s'])) { ?>
    <?= Html::activeHiddenInput($model_k, 'store_id', ['value' => $_GET['s']]) ?>
    <?php } else { ?>
    
    <?= $form->field($model_k, 'store_id')->dropDownlist(ArrayHelper::map(Stores::find(['id', 'store_name'])->where(['account_id' => $session['account_id']])->all(), 'id', 'store_name'), ['id' => 'title', 'prompt' => 'Select Store', 'onChange' => 'changeStore(this)'])->label('Store Name') ?>
    <?php } ?>
    
    <?php /*?><?= $form->field($model_k, 'cook_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter Cook name']) ?>
    
    <?= $form->field($model_l, 'email')->textInput(['maxlength' => true, 'placeholder' => 'Enter your email'])->label('Cook Email') ?>

    <?= $form->field($model_l, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter your password']) ?>
    
    <?php if(!$model_l->isNewRecord) { ?>
    <?= $form->field($model_l, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
    <?php } ?><?php */?>

    <?= $form->field($model_k, 'kitchen_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter area name. E.g. Veg Section']) ?>

    <?= $form->field($model_k, 'kitchen_description')->textarea(['rows' => 6, 'placeholder' => 'Please enter area description']) ?>

    <?php /*?><?= $form->field($model, 'added_date')->textInput() ?><?php */?>
    
    <?php /*?><?= $form->field($model_l, 'status')->dropDownList(
			['1' => 'Active', '0' => 'Deactive'],
            ['id'=>'title']
        ) ?><?php */?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model_k->isNewRecord ? 'Create' : 'Update', ['class' => $model_k->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>