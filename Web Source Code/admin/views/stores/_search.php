<?php

use yii\helpers\Html;
use yii\widgets\ActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\StoresSearch */
/* @var $form yii\widgets\ActiveForm */
?>

<div class="stores-search">

    <?php $form = ActiveForm::begin([
        'action' => ['index'],
        'method' => 'get',
    ]); ?>

    <?= $form->field($model, 'id') ?>

    <?= $form->field($model, 'account_id') ?>

    <?= $form->field($model, 'store_name') ?>

    <?= $form->field($model, 'store_branch') ?>

    <?= $form->field($model, 'address') ?>

    <?php // echo $form->field($model, 'tax_invoice') ?>

    <?php // echo $form->field($model, 'abn_number') ?>

    <?php // echo $form->field($model, 'image') ?>

    <?php // echo $form->field($model, 'welcome_notif') ?>

    <?php // echo $form->field($model, 'received_notif') ?>

    <?php // echo $form->field($model, 'ready_notif') ?>

    <?php // echo $form->field($model, 'status') ?>

    <div class="form-group">
        <?= Html::submitButton('Search', ['class' => 'btn btn-primary']) ?>
        <?= Html::resetButton('Reset', ['class' => 'btn btn-default']) ?>
    </div>

    <?php ActiveForm::end(); ?>

</div>
