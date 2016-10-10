<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;
use app\models\Kitchens;
use app\models\Stores;
/* @var $this yii\web\View */
/* @var $model app\models\Employee */
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
    
    <?php if(isset($_GET['id'])) { $store_id = $model_e->store_id; } else if(isset($_GET['s'])) { $store_id = $_GET['s'];  ?>
    <?= Html::activeHiddenInput($model_e, 'store_id', ['value' => $store_id]) ?>
    <?php } else { ?>
    
    <?= $form->field($model_e, 'store_id')->dropDownlist(ArrayHelper::map(Stores::find(['id', 'store_name'])->where(['account_id' => $session['account_id']])->all(), 'id', 'store_name'), ['id' => 'title', 'prompt' => 'Select Store', 'onChange' => 'changeStore(this)'])->label('Store Name') ?>
    <?php } ?>
    
    <?= $form->field($model_e, 'emp_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter employee name'])->label("Employee Name") ?>
    
    <?= $form->field($model_l, 'email')->textInput(['maxlength' => true, 'placeholder' => 'Enter your email']) ?>

    <?= $form->field($model_l, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter your password']) ?>
    
    <?php if(!$model_l->isNewRecord) { ?>
    <?= $form->field($model_l, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
    <?php } ?>
    
    <div class="form-group" style="margin-bottom:30px">
        <label class="col-sm-3 control-label col-md-3" for="inputSuccess">Role</label>
        <div class="col-md-7">
            <div class="radio" style="padding-left:0">
                <label class="checkbox-inline">
                    <input type="radio" name="emp_role" id="kitchen_role" value="3" <?php if(isset($_GET['id']) && $model_l->role == 3) { echo "checked"; } else { echo 'checked'; } ?> onClick="emp_role_func(this.value)" />
                    Cook / Bar-tender
                </label>
                <label class="checkbox-inline">
                    <input type="radio" name="emp_role" id="waiter_role" value="4" <?php if(isset($_GET['id']) && $model_l->role == 4) { echo "checked"; } ?> onClick="emp_role_func(this.value)" />
                    Waiter
                </label>
            </div>
        </div>
    </div>
    
    
	
	<?php /*?><?= $form->field($model_l, 'role')->radioList(['3'=>'Kitchen / Bar-tender', '4' => 'Waiter'] , ['style' => 'margin-top:6px;', 'separator'=>" &nbsp;&nbsp;&nbsp;" ]) ?><?php */?>
    
    <div class="form-group" id="kitchen_display" <?php if(isset($_GET['id']) && $model_l->role == 4) { echo 'style="display: none;"'; } ?>>
        <label class="col-sm-3 control-label col-md-3" for="inputSuccess">Area</label>
        <div class="col-md-7">
            <select class="form-control m-bot15" name="kitchen_id">
            	<?php 
				
				$kitchens = Kitchens::find(['id', 'kitchen_name'])->where(['store_id' => $store_id])->all();
				foreach($kitchens as $kitchen)
				{
					$selected = "";
					if(isset($_GET['id']) && $model_e->kitchen_id == $kitchen['id'])
					{
						$selected .= ' selected="selected"';
					}
                	echo '<option value="'.$kitchen['id'].'" '.$selected.'>'.$kitchen['kitchen_name'].'</option>';
				}
				?>
            </select>
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
function emp_role_func(x)
{
	//alert(x);
	if(x == 3)
	{
		$("#kitchen_display").css("display", "block");
	} else if(x == 4)
	{
		$("#kitchen_display").css("display", "none");
	}
	
}
</script>