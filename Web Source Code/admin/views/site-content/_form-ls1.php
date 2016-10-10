<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\SiteContent */
/* @var $form yii\widgets\ActiveForm */

$language = Yii::$app->db->createCommand("SELECT language_name, language_lc FROM languages WHERE status = 1")->queryAll();

?>
<style>
.nav-tabs li a{
	font-size:10px;
}
.custom-tab ul > li > a{
	padding: 22px 15px !important;
}
</style>
<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-12\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

<?php if(!$model->isNewRecord) { ?>
<div class="col-md-12">
    <section class="panel">
        <header class="panel-heading custom-tab tab-right">
            <ul class="nav nav-tabs pull-right">
                <li class="active">
                    <a href="#default-lang" data-toggle="tab">
                        English
                    </a>
                </li>
                <?php foreach($language as $lang) { ?>
                <li class="">
                    <a href="#lang-<?php echo $lang['language_lc']; ?>" data-toggle="tab">
                        <?php echo $lang['language_lc']; ?>
                    </a>
                </li>
                <?php } ?>
            </ul>
        </header>
        
        <div class="panel-body">
            <div class="tab-content">
                <div class="tab-pane active" id="default-lang">
                <br /><h4><strong>Default (English)</strong></h4><br />
<?php } ?>


    <?php /*?><?= $form->field($model, 'title')->textInput(['maxlength' => true]) ?><?php */?>

    <?= $form->field($model, 'value')->textarea(['rows' => 15])->label(false) ?>


<?php if(!$model->isNewRecord) { ?>

                </div>
                <?php foreach($language as $lang) { ?>
                <div class="tab-pane" id="lang-<?php echo $lang['language_lc']; ?>">
                
                <br /><h4><strong><?php echo $lang['language_name']; ?></strong></h4><br />
				<?php echo $form->field($model, 'value_'.$lang['language_lc'])->textarea(['rows' => 15])->label(false); ?>
                
                </div>
                <?php } ?>
            </div>
        </div>
    </section>
</div>
<?php } ?>
    <div class="form-group">
    	<div class="col-md-12" style="margin-left:30px">
        	<?= Html::submitButton($model->isNewRecord ? 'Create' : 'Update', ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
        </div>
    </div>

<?php ActiveForm::end(); ?>
