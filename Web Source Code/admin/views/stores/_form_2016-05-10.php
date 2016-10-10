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

<?php if(!$model->isNewRecord) { 
$language = Yii::$app->db->createCommand("SELECT id, language_name, language_lc FROM languages WHERE status = 1")->queryAll(); 
?>

<div class="col-md-12">
    <section class="panel">
    	<div class="col-md-3" style="float:right">
        	<select class="form-control m-bot15" onChange="dispLang(this.value)">
                <option value="0">Default Language</option>
                <?php
                foreach($language as $lang) {
					echo '<option value="'.$lang['id'].'">'.$lang['language_name'].'</option>';
				}
				?>
            </select>
        </div>
    </section>
</div>

<div class="col-md-12">
	<div class="" id="lang-0">
<?php } ?>

    <?php /*?><?= $form->field($model, 'account_id')->textInput(['maxlength' => true]) ?><?php */?>
        
    <?php /* if(!$model->isNewRecord) { ?>
    <?= $form->field($model, 'account_name')->textInput(['value' => Accounts::findOne($model->account_id)->account_name, 'disabled' => 'disabled']) ?>
    <?php } else { ?>
    <?= $form->field($model, 'account_id')->dropDownlist(ArrayHelper::map(Accounts::find(['id', 'account_name'])->all(), 'id', 'account_name'), 
	['id' => 'title']) ?>
    <?php } */ ?>

    <?= $form->field($model, 'store_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter store name. E.g. KFC Restaurant']) ?>

    <?= $form->field($model, 'store_branch')->textInput(['maxlength' => true, 'placeholder' => 'Please enter branch name. E.g. Kings Park Branch']) ?>

    <?= $form->field($model, 'address')->textArea(['rows' => 3, 'placeholder' => 'Please enter address. E.g. Shenton Park WA 6008, Australia']) ?>
        
    <?= $form->field($model, 'description')->textArea(['rows' => 3, 'placeholder' => 'Please enter description']) ?>

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
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Payment details:</strong>
        </div>
    </div>
    
    <?= $form->field($model, 'secret_key')->textInput(['maxlength' => true, 'placeholder' => '']) ?>

    <?= $form->field($model, 'publishable_key')->textInput(['maxlength' => true, 'placeholder' => '']) ?>
    
    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Map details:</strong>
        </div>
    </div>
    
    <?= $form->field($model, 'map_latitude')->textInput(['maxlength' => true, 'placeholder' => 'E.g. 27.1750199']) ?>

    <?= $form->field($model, 'map_longitude')->textInput(['maxlength' => true, 'placeholder' => 'E.g. 78.0399665']) ?>

<?php if(!$model->isNewRecord) { ?>

    </div>
    
	<?php foreach($language as $lang) { ?>
    <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
    <?php
		echo $form->field($model, 'store_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter store name in '.$lang['language_name']])->label('Store Name');
		echo $form->field($model, 'description_'.$lang['language_lc'])->textArea(['rows' => 3, 'placeholder' => 'Please enter description in '.$lang['language_name']])->label('Description');
    ?>
    </div>
    <?php } ?>
</div>
        
<?php } ?>

    <div class="form-group">
    	<div class="col-md-offset-3 col-md-7">
        	<?php if(!$model->isNewRecord) { ?>
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary', 'style' => 'margin-left:20px']) ?>
            <?php } else { ?>
            <?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
            <?php } ?>
            <?php if($gen_error != "" ){ echo '<span class="text-danger">'.$gen_error.'</span>'; } ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
<script>
function dispLang(x)
{
	$('div[id^="lang-"]').css('display', 'none');
	$('#lang-'+x).css('display', 'block');
}
</script>