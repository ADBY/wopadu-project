<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Kitchens */

$this->title = 'Update Profile';
$this->params['breadcrumbs'][] = ['label' => 'Profile', 'url' => ['index']];
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="kitchens-update">
    <div class="row">
        <div class="col-md-12">
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
					
						<?php //echo $form->errorSummary($model_l); ?>
						
						<?= $form->field($model_e, 'emp_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter Cook name']) ?>
						
						<?php /*?><?= $form->field($model_l, 'email')->textInput(['maxlength' => true, 'placeholder' => 'Enter your email'])->label('Cook Email') ?><?php */?>
					
						<?= $form->field($model_l, 'password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please enter your password']) ?>
						
						<?php if(!$model_l->isNewRecord) { ?>
						<?= $form->field($model_l, 're_password')->passwordInput(['maxlength' => true, 'placeholder' => 'Please re-enter password']) ?>
						<?php } ?>
					
						<?php /*?><?= $form->field($model_k, 'kitchen_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter kitchen name. E.g. Veg Section']) ?><?php */?>
					
						<?php /*?><?= $form->field($model, 'added_date')->textInput() ?><?php */?>
						
						<?php /*?><?= $form->field($model_l, 'status')->dropDownList(
								['1' => 'Active', '0' => 'Deactive'],
								['id'=>'title']
							) ?><?php */?>
					
						<div class="form-group">
							<div class="col-md-offset-3 col-md-7">
								<?= Html::submitButton($model_l->isNewRecord ? 'Create' : 'Update', ['class' => $model_l->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
							</div>
						</div>
					
					<?php ActiveForm::end(); ?>
                </div>
            </section>
        </div>
    </div>
</div>