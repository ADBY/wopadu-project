<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\OrderDetails */
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

    <?php /*?><?= $form->field($model, 'order_id')->textInput(['maxlength' => true]) ?><?php */?>

    <?php /*?><?= $form->field($model, 'item_id')->textInput(['maxlength' => true]) ?><?php */?>
    
    <div class="form-group">
    	<label class="col-md-3 col-sm-3 control-label" for="">Item Name</label>
    	<div class="col-md-7">
        	<input type="text" id="" class="form-control" name="" value="<?php echo $model->item->item_name; ?>" disabled>
            <div class="help-block"></div>
        </div>
    </div>

    <?php /*?><?= $form->field($model, 'item_options_id')->textInput(['maxlength' => true]) ?><?php */?>
    
    <?php /*?>
    <?php
	if($item_option) {
		$selected_options = explode(",", $model->item_options_id);
	?>
    <div class="form-group" style="margin-bottom:23px;">
        <label class="col-sm-3 control-label col-md-3" for="inputSuccess">Item Options</label>
        <div class="col-md-7">
        	<?php foreach($item_option as $opti) { ?>
        	<div class="col-md-3" style="text-align:right; font-weight:bold"><?php echo $opti['item_option_main_name']; ?></div>
            <div class="col-md-9">
            	<?php $none = true; foreach($opti['options'] as $sub_opti) { ?>
                <div class="radio" style="padding-top:0">
                    <label>
                    	
                        <input type="radio" name="item_sub_ids[<?php echo $opti['item_option_main_id']; ?>][]" value="<?php echo $sub_opti['item_option_sub_id']; ?>" <?php if(in_array($sub_opti['item_option_sub_id'], $selected_options)) { $none = false; echo ' checked'; } ?>>
                        <?php echo $sub_opti['sub_name']." x".$sub_opti['sub_amount']; ?>
                    </label>
                </div>
                <?php } ?>
                <div class="radio" style="padding-top:0">
                    <label>
                        <input type="radio" name="item_sub_ids[<?php echo $opti['item_option_main_id']; ?>][]" value="" <?php if($none == true){echo ' checked'; } ?>>
                        None
                    </label>
                </div>
            </div>
            <?php } ?>
        </div>
        
    </div>
    <?php } ?>
	<?php */?>
    <?= $form->field($model, 'quantity')->textInput(['disabled'=>'disabled']) ?>

    <?php /*?><?= $form->field($model, 'amount')->textInput(['maxlength' => true]) ?><?php */?>

    <?= $form->field($model, 'add_note')->textInput(['maxlength' => true]) ?>
    
    <?php /*?><?= $form->field($model, 'status')->dropDownList([ '1' => 'New', '2' => 'Processing', '3' => 'Ready to be collected', '4' => 'Completed', '5' => 'Cancelled' ], ['id'=> 'title']) ?><?php */?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
