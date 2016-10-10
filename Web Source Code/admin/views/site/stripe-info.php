<?php

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model app\models\LoginForm */

use yii\helpers\Html;
use yii\bootstrap\ActiveForm;

$this->title = 'Stripe Info';
$this->params['breadcrumbs'][] = $this->title;
?>

<style>
.dont-break-out {

  /* These are technically the same, but use both */
  overflow-wrap: break-word;
  word-wrap: break-word;

  -ms-word-break: break-all;
  /* This is the dangerous one in WebKit, as it breaks things wherever */
  word-break: break-all;
  /* Instead use this non-standard one: */
  word-break: break-word;

  /* Adds a hyphen where the word breaks, if supported (No Blink) */
  -ms-hyphens: auto;
  -moz-hyphens: auto;
  -webkit-hyphens: auto;
  hyphens: auto;

}
</style>
<form class="form-signin" action="<?= Yii::$app->urlManager->createUrl('site/security-question') ?>" method="post">

    <div class="form-signin-heading text-center">
        <img src="../images/login-logo.png" alt=""/>
    </div>
    
    <div class="login-wrap">
    	<?php
			//define('CLIENT_ID', 'ca_8PxIswbDFyxfSjgXBbTiB249EhljJ3Vr');
			//define('API_KEY', 'sk_test_Dp4tLXNNZbFLm33peWc3abs5');	// 	Test Secret Key
			//define('TOKEN_URI', 'https://connect.stripe.com/oauth/token');
			//define('AUTHORIZE_URI', 'https://connect.stripe.com/oauth/authorize');
			
			$CLIENT_ID 		= Yii::$app->params['CLIENT_ID'];
			$API_KEY 		= Yii::$app->params['API_KEY'];
			$TOKEN_URI 		= Yii::$app->params['TOKEN_URI'];
			$AUTHORIZE_URI 	= Yii::$app->params['AUTHORIZE_URI'];
			
			if (isset($_GET['code']))
			{
				// Redirect w/ code
				$code = $_GET['code'];
				$token_request_body = array(
					'client_secret' => $API_KEY,
					'grant_type' => 'authorization_code',
					'client_id' => $CLIENT_ID,
					'code' => $code,
				);
				
				//echo 'https://connect.stripe.com/oauth/token?client_secret='.$token_request_body['client_secret'].'&grant_type=authorization_code&client_id='.$token_request_body['client_id'].'&code='.$code;
				
				
				$req = curl_init($TOKEN_URI);
				curl_setopt($req, CURLOPT_RETURNTRANSFER, true);
				curl_setopt($req, CURLOPT_POST, true );
				curl_setopt($req, CURLOPT_POSTFIELDS, http_build_query($token_request_body));
				// TODO: Additional error handling
				$respCode = curl_getinfo($req, CURLINFO_HTTP_CODE);
				$resp = json_decode(curl_exec($req), true);
				curl_close($req);
				//echo $resp['access_token'];
				/*echo "<pre>";
				print_r($resp);
				echo "</pre>";*/
				
				if(isset($resp['error']))
				{
					echo '<div class="alert alert-block alert-danger fade in">
				<span class="dont-break-out">'.$resp['error_description'].'</span><br />
				</div>';
				}
				else
				{
				
				echo '<div class="alert alert-block alert-success fade in">
				<strong>Stripe Publishable Key</strong>: <span class="dont-break-out">'.$resp['stripe_publishable_key'].'</span><br /><br />
				<strong>Stripe User Id</strong>: <span class="dont-break-out">'.$resp['stripe_user_id'].'</span><br /><br />
				<strong>Refresh Token</strong>: <span class="dont-break-out">'.$resp['refresh_token'].'</span><br /><br />
				<strong>Access Token</strong>: <span class="dont-break-out">'.$resp['access_token'].'</span><br />
				
				</div>';
				}
			}
			else if (isset($_GET['error']))
			{
				// Error
				echo '<div class="alert alert-block alert-danger fade in">'.$_GET['error_description'].'</div>';
			}
			else
			{
				echo '<div class="alert alert-block alert-danger fade in" style="margin-top:20px;">Something went wrong, <br />Please try again</div>';
			}
		?>
        
    </div>
</form>
