<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\TableBeacon */
/* @var $form yii\widgets\ActiveForm */
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

    <?php /*?><?= $form->field($model, 'store_id')->textInput(['maxlength' => true]) ?><?php */?>

    <?= $form->field($model, 'table_id')->textInput(['maxlength' => true]) ?>
    
    <div class="form-group">
        <label class="col-md-3 col-sm-3 control-label">Distance: </label>
    </div>
    
    <?php $i = 0; foreach($beacons as $beacon) { ?>
    <div class="form-group">
        <div class="col-md-offset-3 col-md-4">
        	<input type="text" name="beacon[<?= $beacon['beacon_minor'] ?>]" class="form-control" value="<?php if(isset($beacons_distance[$beacon['beacon_minor']])) { echo $beacons_distance[$beacon['beacon_minor']]; } ?>">
        </div>
        <label class="col-md-5 col-sm-5 control-label" style="text-align:left">from Beacon Major - <strong><?= $beacon['beacon_major'] ?></strong> and Minor - <strong><?= $beacon['beacon_minor'] ?></strong> </label>
    </div>
    <?php } ?>

    <?php /*?><?= $form->field($model, 'beacon_major')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'beacon_minor')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'distance')->textInput(['maxlength' => true]) ?><?php */?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Add Table' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
            <span class="text-danger"><?= $error ?></span>
        </div>
    </div>

<?php ActiveForm::end(); ?>
