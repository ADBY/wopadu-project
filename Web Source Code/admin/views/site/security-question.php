<?php

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model app\models\LoginForm */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = 'Security Question';
$this->params['breadcrumbs'][] = $this->title;
?>
<form class="form-signin" action="<?= Yii::$app->urlManager->createUrl('site/security-question') ?>" method="post">

    <div class="form-signin-heading text-center">
        <h1 class="sign-title">Security Question</h1>
        <img src="../images/login-logo.png" alt=""/>
    </div>
    
    <div class="login-wrap">
         <h5><?= $security_question ?></h5>
         <input type="text" class="form-control" name="answer" placeholder="Enter your answer here" autofocus>
         <input type="hidden" name="_csrf" value="<?=Yii::$app->request->getCsrfToken()?>" />
        <?= Html::submitButton('<i class="fa fa-check"></i>', ['class' => 'btn btn-lg btn-login btn-block', 'name' => 'login-button']) ?>
        <?php if(isset($error['error_1'])) { echo '<p style="color:#C0392B;">'.$error['error_1'].'</p>'; } ?>
        <label class="checkbox">
            <span class="pull-right">
                <a data-toggle="modal" href="<?= Yii::$app->urlManager->createUrl('site/login') ?>"> Back to LOGIN</a>
            </span>
        </label>
    </div>
</form>
