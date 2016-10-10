<?php

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model app\models\LoginForm */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = 'Login';
$this->params['breadcrumbs'][] = $this->title;
?>

<?php $form = ActiveForm::begin([
	'id' => 'login-form',
	'options' => ['class' => 'form-signin'],
	'fieldConfig' => [
		//'template' => "{label}\n<div class=\"col-md-3\">{input}</div>\n<div class=\"col-md-8\">{error}</div>",
		//'labelOptions' => ['class' => 'col-md-1 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

    <div class="form-signin-heading text-center">
        <h1 class="sign-title">Sign In</h1>
        <img src="../images/login-logo.png" alt=""/>
    </div>
    <div class="login-wrap">
        <?= $form->field($model, 'username', ['inputOptions' => ['placeholder' => 'Email', 'autofocus'=>'']])->textInput()->label(false) ?>
        <?= $form->field($model, 'password', ['inputOptions' => ['placeholder' => 'Password']])->passwordInput()->label(false) ?>
        
        <?= Html::submitButton('<i class="fa fa-check"></i>', ['class' => 'btn btn-lg btn-login btn-block', 'name' => 'login-button']) ?>
        
        <label class="checkbox">
            <?= $form->field($model, 'rememberMe')->checkbox([
				'template' => "{input}",
			]) ?> Remember me
            <span class="pull-right">
                <a data-toggle="modal" href="#myModal"> Forgot Password?</a>
            </span>
        </label>
    </div>
    
    

    <!-- Modal -->
    <div aria-hidden="true" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" id="myModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Forgot Password ?</h4>
                </div>
                <div class="modal-body">
                    <p>Enter your e-mail address below to reset your password.</p>
                    <input type="text" name="email" id="email" placeholder="Email" autocomplete="off" class="form-control placeholder-no-fix">
                    <p id="err_label" style="margin:0"></p>
                </div>
                <div class="modal-footer">
                    <button data-dismiss="modal" class="btn btn-default" type="button">Cancel</button>
                    <button class="btn btn-primary" type="button" onClick="forgot_password()">Submit</button>
                </div>
            </div>
        </div>
    </div>
    <!-- modal -->

<?php ActiveForm::end(); ?>

<?php /*?><span style="float:right; color:#ffffff"> Powered by: <a href="http://bridgetechnocrats.com" target="_blank" style="color:#ffffff">Bridgetechnocrats</a></span><?php */?>

<script>
function forgot_password()
{
	var email = $("#email").val();
	var _csrf = yii.getCsrfToken();
	if(email == "")
	{
		$("#err_label").html('<span style="color:#C0392B">Please enter email address.</span>');
	}
	else
	{
		$.ajax({
			url: '<?= Yii::$app->urlManager->createUrl('site/forgot-password') ?>',
			method: 'POST',
			data: 'email='+email+'&_csrf='+_csrf,
			cache: false,
			success: function(data){
				if(data == 1) {
					$("#err_label").html('<span style="color:#2ECC71">Email is sent to your email address. Please click on the given link.</span>');
				} else if(data == 0) {
					$("#err_label").html('<span style="color:#C0392B">Email address not found in system. Please enter correct email address.</span>');
				} else {
					$("#err_label").html('<span style="color:#C0392B">Something went wrong, Please try again.</span>');
				}
			},
			error: function(){
				$("#err_label").html('<span style="color:#C0392B">Something went wrong, Please try again.</span>');
			}		
		});
	}
}
</script>