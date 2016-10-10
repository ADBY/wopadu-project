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

<?php if(!$model->isNewRecord) { ?>
<div class="col-md-12">
    <section class="panel">
        <header class="panel-heading custom-tab tab-right ">
            <ul class="nav nav-tabs pull-right">
                <li class="active">
                    <a href="#home-3" data-toggle="tab">
                        1. 
                        Default Language
                    </a>
                </li>
                <li class="">
                    <a href="#about-3" data-toggle="tab">
                        2. 
                        Other Languages
                    </a>
                </li>
            </ul>
        </header>
        <div class="panel-body">
            <div class="tab-content">
                <div class="tab-pane active" id="home-3">

<?php } ?>

    <?= $form->field($model, 'item_id')->hiddenInput(['maxlength' => true, 'value' => $_GET['i']])->label(false) ?>

    <?= $form->field($model, 'variety_name')->textInput(['maxlength' => true]) ?>

    <?= $form->field($model, 'variety_price')->textInput() ?>

<?php if(!$model->isNewRecord) { ?>

                </div>
                <div class="tab-pane" id="about-3">
                	<h4><strong>Variety Name</strong></h4>
					<?php
                        $language = Yii::$app->db->createCommand("SELECT language_name, language_lc FROM languages WHERE status = 1")->queryAll();
                        foreach($language as $lang) {
                            echo $form->field($model, 'variety_name_'.$lang['language_lc'])->textInput(['maxlength' => true])->label('in '.$lang['language_name']);
                        }
                    ?>
                
                </div>
            </div>
        </div>
    </section>
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
