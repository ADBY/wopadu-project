<?php

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model app\models\LoginForm */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = 'Change Password';
$this->params['breadcrumbs'][] = $this->title;
?>

<form class="form-signin" action="<?= Yii::$app->urlManager->createUrl(['site/change-password', 'email' => $_GET['email'], 'token' => $_GET['token']]) ?>" method="post">

    <div class="form-signin-heading text-center">
        <h1 class="sign-title">Change Password</h1>
        <img src="../images/login-logo.png" alt=""/>
    </div>
    
    <div class="login-wrap">
    	<?php if(isset($error['error_1'])) { ?>
        <p style="color:#C0392B; text-align:center"><?php echo $error['error_1']; ?></p>
		<?php } else { ?>
         <input type="password" class="form-control" name="password" placeholder="New password" autofocus>
         <input type="password" class="form-control" name="re_password" placeholder="Re-enter password">
         <input type="hidden" name="_csrf" value="<?=Yii::$app->request->getCsrfToken()?>" />
        <?= Html::submitButton('<i class="fa fa-check"></i>', ['class' => 'btn btn-lg btn-login btn-block', 'name' => 'login-button']) ?>
        <?php if(isset($error['error_2'])) { echo '<p style="color:#C0392B;">'.$error['error_2'].'</p>'; } ?>
        <?php if(isset($error['error_3'])) { echo '<p style="color:#2ECC71;">'.$error['error_3'].'</p>'; } ?>
        
        <?php } ?>
        <label class="checkbox">
            <span class="pull-right">
                <a data-toggle="modal" href="<?= Yii::$app->urlManager->createUrl('site/login') ?>"> Back to LOGIN</a>
            </span>
        </label>
    </div>
</form>
