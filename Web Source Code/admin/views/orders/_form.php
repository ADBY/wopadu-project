<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Orders */
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


	<?php if($model->isNewRecord) { ?>
    <?= $form->field($model, 'user_id')->textInput(['maxlength' => true ]) ?>
    <?php } else { ?>
    <div class="form-group">
    	<label class="col-md-3 col-sm-3 control-label" for="">User Name</label>
    	<div class="col-md-7">
        	<input type="text" id="" class="form-control" name="" value="<?php echo $model->user->first_name." ".$model->user->last_name; ?>" disabled>
            <div class="help-block"></div>
        </div>
    </div>
    <?php } ?>
    <?php /*?><?= $form->field($model, 'store_id')->textInput(['maxlength' => true]) ?><?php */?>

    <?php /*?><?= $form->field($model, 'order_number')->textInput(['maxlength' => true]) ?><?php */?>
    
    <div class="form-group required has-success">
    	<label class="col-md-3 col-sm-3 control-label" for="">Order Number</label>
    	<div class="col-md-7">
        	<input type="text" id="" class="form-control" name="" value="<?php echo $model->order_number; ?>" disabled>
            <div class="help-block"></div>
        </div>
    </div>

    <?= $form->field($model, 'invoice_number')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'order_type')->dropDownList(['1' => 'Online', '2' => 'Offline'], ['id'=> 'title']) ?>


    <?= $form->field($model, 'table_location')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'total_amount')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'add_note')->textArea(['rows' => '6']) ?>

    <?php /*?><?= $form->field($model, 'added_datetime')->textInput() ?><?php */?>

    <?= $form->field($model, 'status')->dropDownList([ '1' => 'New', '2' => 'Processing', '3' => 'Ready to be collected', '4' => 'Completed', '5' => 'Cancelled' ], ['id'=> 'title']) ?>


    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
