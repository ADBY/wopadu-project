<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Beacons */
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

    <?php /*?><?= $form->field($model, 'beacon_major')->textInput() ?><?php */?>

    <?php /*?><?= $form->field($model, 'beacon_minor')->textInput() ?><?php */?>
    
    <?= $form->field($model, 'table_id')->textInput() ?>

    <?php /*?><?= $form->field($model, 'added_datetime')->textInput() ?><?php */?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
