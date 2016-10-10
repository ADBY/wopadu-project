<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\SiteContent */
/* @var $form yii\widgets\ActiveForm */

$language = Yii::$app->db->createCommand("SELECT language_name, language_lc FROM languages WHERE status = 1")->queryAll();
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-12\">{input}{error}</div>",
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

    <?php /*?><?= $form->field($model, 'title')->textInput(['maxlength' => true]) ?><?php */?>
	<br />
    <?= $form->field($model, 'value')->textarea(['rows' => 15])->label(false) ?>

<?php if(!$model->isNewRecord) { ?>

    </div>
    
	<?php foreach($language as $lang) { ?>
    <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
    <br />
	<?php
        //echo $form->field($model, 'category_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter category name in '.$lang['language_name']])->label('Category Name');
		echo $form->field($model, 'value_'.$lang['language_lc'])->textarea(['rows' => 15])->label(false);
    ?>
    </div>
    <?php } ?>
</div>
        
<?php } ?>

    <div class="form-group">
    	<div class="col-md-12" style="margin-left:30px">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
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