<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Accounts */
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

	<?php if($model_l->isNewRecord) {
		echo $form->field($model_a, 'account_type')->dropDownList(['1' => 'Single Store Account', '2' => 'Multiple Store Account'], ['id' => 'title', 'onChange' => 'selAcountType(this)']);
	} ?>
	
	<?= $form->field($model_a, 'account_name')->textInput(['maxlength' => true, 'placeholder' => 'Account Name. E.g. KFC\'s ']) ?>

    <?= $form->field($model_l, 'email')->textInput(['maxlength' => true, 'placeholder' => 'Enter your email']) ?>

    <?= $form->field($model_l, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter your password']) ?>
    
    <?php if(!$model_l->isNewRecord) { ?>
    <?= $form->field($model_l, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
    <?php } ?>
    
    <div class="form-group" id="num_of_accounts" style="display:none">
        <label class="control-label col-md-3">Allowed Stores</label>
        <div class="col-md-7">
            <div id="spinner5">
                <div class="input-group">
                    <div class="spinner-buttons input-group-btn">
                        <button type="button" class="btn spinner-up btn-primary">
	                        <i class="fa fa-plus"></i>
                        </button>
                    </div>
                    <input type="text" class="spinner-input form-control" id="accounts-allowed_stores" name="Accounts[allowed_stores]" maxlength="3" readonly>
                    <div class="spinner-buttons input-group-btn">
                        <button type="button" class="btn spinner-down btn-warning">
    	                    <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
            </div>
            <span class="help-block">
            	How many store are allowed for this account (Max value: 10).
	        </span>
        </div>
    </div>

    <?= $form->field($model_l, 'status')->dropDownList(
			['1' => 'Active', '0' => 'Deactive'],
            ['id'=>'title']
        ) ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?= Html::submitButton($model_l->isNewRecord ? 'Create' : 'Update', ['class' => $model_l->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>            
    </div>
    
<?php ActiveForm::end(); ?>

<script>
function selAcountType(x)
{
	if(x.value == 1)
	{
		$("#num_of_accounts").css('display', 'none');
	}
	else
	{
		$("#num_of_accounts").css('display', 'block');
	}
}
</script>
