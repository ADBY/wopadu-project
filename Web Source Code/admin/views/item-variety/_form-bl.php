<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\ItemVariety */
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

    <?= $form->field($model, 'item_id')->hiddenInput(['maxlength' => true, 'value' => $_GET['i']])->label(false) ?>

    <?= $form->field($model, 'variety_name')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'variety_price')->textInput() ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
