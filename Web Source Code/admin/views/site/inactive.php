<?php

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model app\models\LoginForm */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = 'You are currently inactive';
$this->params['breadcrumbs'][] = $this->title;
?>
<form class="form-signin" action="<?= Yii::$app->urlManager->createUrl('site/security-question') ?>" method="post">

    <div class="form-signin-heading text-center">
        <img src="../images/login-logo.png" alt=""/>
    </div>
    
    <div class="login-wrap">
        <div class="alert alert-block alert-danger fade in">
        	<strong>Sorry!</strong> You can't login because this Account has been deactivated.
        </div>
        <label class="checkbox">
            <span class="pull-right">
                <a data-toggle="modal" href="<?= Yii::$app->urlManager->createUrl('site/login') ?>"> Back to LOGIN</a>
            </span>
        </label>
    </div>
</form>
