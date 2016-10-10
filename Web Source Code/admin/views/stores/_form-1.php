<?php

use yii\helpers\Html;
use yii\helpers\ArrayHelper;
use yii\widgets\ActiveForm;
use app\models\Accounts;

/* @var $this yii\web\View */
/* @var $model app\models\stores */
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

    <?php /*?><?= $form->field($model, 'account_id')->textInput(['maxlength' => true]) ?><?php */?>
        
    <?php /* if(!$model->isNewRecord) { ?>
    <?= $form->field($model, 'account_name')->textInput(['value' => Accounts::findOne($model->account_id)->account_name, 'disabled' => 'disabled']) ?>
    <?php } else { ?>
    <?= $form->field($model, 'account_id')->dropDownlist(ArrayHelper::map(Accounts::find(['id', 'account_name'])->all(), 'id', 'account_name'), 
	['id' => 'title']) ?>
    <?php } */ ?>

    <?= $form->field($model, 'store_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter store name. E.g. KFC Restaurant']) ?>

    <?= $form->field($model, 'store_branch')->textInput(['maxlength' => true, 'placeholder' => 'Please enter branch name. E.g. Kings Park Branch']) ?>

    <?= $form->field($model, 'address')->textInput(['maxlength' => true, 'placeholder' => 'Please enter address. E.g. Shenton Park WA 6008, Australia']) ?>

    <?= $form->field($model, 'tax_invoice')->textInput(['maxlength' => true, 'placeholder' => 'Please enter invoice number. E.g. INV12345']) ?>

    <?= $form->field($model, 'abn_number')->textInput(['maxlength' => true, 'placeholder' => 'Please enter ABN number. E.g. A12345']) ?>

    <?= $form->field($model, 'image')->fileInput() ?>
    
    <?= $form->field($model, 'display_note')->dropDownList(['1' => 'Yes', '0' => 'No'], ['id'=> 'title']) ?>
	
	<?= $form->field($model, 'status')->dropDownList(['1' => 'Active', '0' => 'Inactive'], ['id'=> 'title']) ?>

    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Messages displayed to Customers on order actions:</strong>
        </div>
    </div>

	<?= $form->field($model, 'welcome_notif')->textInput(['maxlength' => true, 'placeholder' => 'Please enter message for welcome notification']) ?>

    <?= $form->field($model, 'received_notif')->textInput(['maxlength' => true, 'placeholder' => 'Please enter message for order received notification']) ?>

    <?= $form->field($model, 'ready_notif')->textInput(['maxlength' => true, 'placeholder' => 'Please enter message for order ready notification']) ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>

