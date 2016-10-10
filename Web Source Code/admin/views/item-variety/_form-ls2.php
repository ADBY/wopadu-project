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

    <?= $form->field($model, 'item_id')->hiddenInput(['maxlength' => true, 'value' => $_GET['i']])->label(false) ?>

    <?= $form->field($model, 'variety_name')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'variety_price')->textInput() ?>

<?php if(!$model->isNewRecord) { ?>

    </div>
    
	<?php foreach($language as $lang) { ?>
    <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
    <br />
	<?php
        echo $form->field($model, 'variety_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter variety name in '.$lang['language_name']])->label('Variety Name');
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
	$('div[id^="lang-'+x+'"]').css('display', 'block');
}
</script>