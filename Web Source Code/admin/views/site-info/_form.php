<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\SiteInfo */
/* @var $form yii\widgets\ActiveForm */
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-8\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-2 col-sm-4 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

 
    <?= $form->field($model, 'value')-> textInput(['maxlength' => true])?>

    <div class="form-group">
    	<div class="col-md-offset-2 col-md-10">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
