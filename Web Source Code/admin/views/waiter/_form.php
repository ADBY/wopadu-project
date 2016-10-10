<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Waiter */
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

    <?php /*?><?= $form->field($model, 'store_id')->textInput(['maxlength' => true]) ?><?php */?>
    
    <?php if(isset($_GET['id'])) { } else if(isset($_GET['s'])) { ?>
    <?= Html::activeHiddenInput($model, 'store_id', ['value' => $_GET['s']]) ?>
    <?php } else { ?>
    
    <?= $form->field($model, 'store_id')->dropDownlist(ArrayHelper::map(Stores::find(['id', 'store_name'])->where(['account_id' => $session['account_id']])->all(), 'id', 'store_name'), ['id' => 'title', 'prompt' => 'Select Store', 'onChange' => 'changeStore(this)'])->label('Store Name') ?>
    <?php } ?>

    <?= $form->field($model, 'name')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'email')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'password')->passwordInput(['maxlength' => true]) ?>
    
    <?php if(!$model->isNewRecord) { ?>
    <?= $form->field($model, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
    <?php } ?>

    <?php /*?><?= $form->field($model, 'added_date')->textInput() ?><?php */?>

    <?= $form->field($model, 'status')->dropDownList(
			['1' => 'Active', '0' => 'Deactive'],
            ['id'=>'title']
        ) ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
