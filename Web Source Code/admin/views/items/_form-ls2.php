<?php

use yii\helpers\Html;
use yii\helpers\ArrayHelper;
use yii\widgets\ActiveForm;
use app\models\Categories;
use app\models\Kitchens;
use app\models\Tax;

/* @var $this yii\web\View */
/* @var $model app\models\Items */
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

	<?php if(isset($_GET['c'])) { ?>
    <?= $form->field($model, 'category_id')->hiddenInput(['value'=> $_GET['c']])->label(false) ?>
    <?php } ?>
    <?= $form->field($model, 'item_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter product name. E.g. The Bleu Burger']) ?>
    
    <?= $form->field($model, 'item_description')->textArea(['rows' => 10, 'placeholder' => 'Please enter product description']) ?>
    
    <?php /*?><?= $form->field($model, 'item_size')->textInput(['maxlength' => true, 'placeholder' => 'Please enter product size. E.g. Small, Medium, Large']) ?><?php */?>

    <?= $form->field($model, 'price')->textInput(['maxlength' => true, 'placeholder' => 'Please enter product price']) ?>
    
    <?= $form->field($model, 'tax_percentage')->dropDownlist(ArrayHelper::map(Tax::find(['tax_percentage'])->orderBy('tax_percentage')->all(), 'tax_percentage', 'tax_percentage'), ['id' => 'title']) ?>

    <?= $form->field($model, 'images')->fileInput(['style' => 'margin-top:5px']) ?>

    <?php /*?><?= $form->field($model, 'no_of_option')->textInput() ?><?php */?>
    
    <?php /*?><?= $form->field($model, 'is_new')->dropDownList(['0' => 'No', '1' => 'Yes']) ?><?php */?>
    
    <?= $form->field($model, 'kitchen_id')->dropDownlist(ArrayHelper::map(Kitchens::find(['id', 'kitchen_name'])->where(['store_id' => $category->store_id])->all(), 'id', 'kitchen_name'), ['id' => 'title'])->label('Area') ?>

    <?php /*?><?= $form->field($model, 'added_datetime')->textInput() ?><?php */?>

    <?= $form->field($model, 'status')->dropDownList(['1'=>'Active', '0' => 'Inactive']) ?>

<?php if(!$model->isNewRecord) { ?>

    </div>
    
	<?php foreach($language as $lang) { ?>
	<div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
    <br />
	<?php
        echo $form->field($model, 'item_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter product name in '.$lang['language_name']])->label('Product Name');
		echo $form->field($model, 'item_description_'.$lang['language_lc'])->textArea(['rows' => 6, 'placeholder' => 'Please enter product description in '.$lang['language_name']])->label('Description');
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