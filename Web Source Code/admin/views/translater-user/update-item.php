<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\TranslaterUser */
/* @var $form yii\widgets\ActiveForm */

if($model_t->type == 1) {
	$menu_var = 'Stores';
} else if($model_t->type == 2) {
	$menu_var = 'Categories';
} else if($model_t->type == 3) {
	$menu_var = 'Products';
} else if($model_t->type == 4) {
	$menu_var = 'Product Varieties';
} else if($model_t->type == 5) {
	$menu_var = 'Product Option Main';
} else if($model_t->type == 6) {
	$menu_var = 'Product Option Sub';
} else {
	$this->menu_vartitle = 'Translate';
}

$this->title = 'Update Translation';
//$this->params['breadcrumbs'][] = ['label' => 'Translater Users', 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $menu_var, 'url' => ['translate-item', 'type' => $model_t->type]];
$this->params['breadcrumbs'][] = 'Update';

$session = Yii::$app->session;

$language = Yii::$app->db->createCommand("SELECT id, language_name, language_lc FROM languages WHERE status = 1")->queryAll(); 
?>

<div class="Translater-user-update">
    <div class="row">
        <div class="col-lg-12">
            <section class="panel panel-primary">
                <header class="panel-heading">
                    <?= Html::encode($this->title) ?>
                </header>
                <div class="panel-body">
                    <?php $form = ActiveForm::begin([
						'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
						'fieldConfig' => [
							'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
							'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
							'inputOptions' => ['class' => 'form-control'],
						],
					]); ?>
					
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
                    <?php if($_GET['type'] == 1) { ?>
                        <div class="" id="lang-0">
							<?= $form->field($model_i, 'store_name')->textInput(['maxlength' => true]) ?>
                            <?= $form->field($model_i, 'description')->textArea(['rows' => 3, 'maxlength' => true]) ?>
                        </div>
                        <?php foreach($language as $lang) { ?>
                        <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
                        <?php
                            echo $form->field($model_i, 'store_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter store name in '.$lang['language_name']])->label('Store Name');
                            echo $form->field($model_i, 'description_'.$lang['language_lc'])->textArea(['rows' => 3, 'placeholder' => 'Please enter description in '.$lang['language_name']])->label('Description');
                        ?>
                        </div>
                        <?php } ?>
                    <?php } else if($_GET['type'] == 2) { ?>
                        <div class="" id="lang-0">
							<?= $form->field($model_i, 'category_name')->textInput(['maxlength' => true]) ?>
                        </div>
                        <?php foreach($language as $lang) { ?>
                        <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
                        <?php
                            echo $form->field($model_i, 'category_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter category name in '.$lang['language_name']])->label('Category Name');
                        ?>
                        </div>
                        <?php } ?>
                    <?php } else if($_GET['type'] == 3) { ?>
                        <div class="" id="lang-0">
							<?= $form->field($model_i, 'item_name')->textInput(['maxlength' => true]) ?>
                            <?= $form->field($model_i, 'item_description')->textArea(['rows' => 3, 'maxlength' => true]) ?>
                        </div>
                        <?php foreach($language as $lang) { ?>
                        <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
                        <?php
                            echo $form->field($model_i, 'item_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter product name in '.$lang['language_name']])->label('Product Name');
                            echo $form->field($model_i, 'item_description_'.$lang['language_lc'])->textArea(['rows' => 3, 'placeholder' => 'Please enter description in '.$lang['language_name']])->label('Description');
                        ?>
                        </div>
                        <?php } ?>
                    <?php } else if($_GET['type'] == 4) { ?>
                        <div class="" id="lang-0">
							<?= $form->field($model_i, 'variety_name')->textInput(['maxlength' => true]) ?>
                        </div>
                        <?php foreach($language as $lang) { ?>
                        <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
                        <?php
                            echo $form->field($model_i, 'variety_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter variety name in '.$lang['language_name']])->label('Variety Name');
                        ?>
                        </div>
                        <?php } ?>
                    <?php } else if($_GET['type'] == 5) { ?>
                        <div class="" id="lang-0">
							<?= $form->field($model_i, 'option_name')->textInput(['maxlength' => true]) ?>
                        </div>
                        <?php foreach($language as $lang) { ?>
                        <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
                        <?php
                            echo $form->field($model_i, 'option_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter option name in '.$lang['language_name']])->label('Option Name');
                        ?>
                        </div>
                        <?php } ?>
                    <?php } else if($_GET['type'] == 6) { ?>
                        <div class="" id="lang-0">
							<?= $form->field($model_i, 'sub_name')->textInput(['maxlength' => true]) ?>
                        </div>
                        <?php foreach($language as $lang) { ?>
                        <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
                        <?php
                            echo $form->field($model_i, 'sub_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter sub option name in '.$lang['language_name']])->label('Option Sub Name');
                        ?>
                        </div>
                        <?php } ?>
                    <?php }?>
                    </div>
                    
                    <?= $form->field($model_t, 'added_date')->textInput(['maxlength' => true, 'type' => 'hidden'])->label(false) ?>                    
                    <div class="form-group">
                        <div class="col-md-offset-3 col-md-7">
                            <?= Html::submitButton('Update', ['class' => 'btn btn-primary', 'style'=>'margin-left:10px']) ?>
                        </div>
                    </div>
					
					<?php ActiveForm::end(); ?>
                </div>
            </section>
        </div>
    </div>
</div>

<script>
function dispLang(x)
{
	$('div[id^="lang-"]').css('display', 'none');
	$('#lang-'+x).css('display', 'block');
}

</script>