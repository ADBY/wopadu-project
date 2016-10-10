<?php

use yii\helpers\Html;
use yii\helpers\ArrayHelper;
use yii\widgets\ActiveForm;
use app\models\Accounts;

$session = Yii::$app->session;

/* @var $this yii\web\View */
/* @var $model app\models\stores */
/* @var $form yii\widgets\ActiveForm */

/*echo "<pre>";
print_r($_SESSION);
echo "</pre>";*/
//exit;
?>

<?php $form = ActiveForm::begin([
	'options' => ['class'=>'form-horizontal', 'enctype'=>'multipart/form-data'],
	'fieldConfig' => [
		'template' => "{label}\n<div class=\"col-md-7\">{input}{error}</div>",
		'labelOptions' => ['class' => 'col-md-3 col-sm-3 control-label'],
		'inputOptions' => ['class' => 'form-control'],
	],
]); ?>

<?php if(!$model->isNewRecord) { 
$language = Yii::$app->db->createCommand("SELECT id, language_name, language_lc FROM languages WHERE status = 1")->queryAll(); 
?>

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
	<div class="" id="lang-0">
<?php } ?>

    <?= $form->field($model, 'store_name')->textInput(['maxlength' => true, 'placeholder' => 'Please enter store name. E.g. KFC Restaurant']) ?>

    <?= $form->field($model, 'store_branch')->textInput(['maxlength' => true, 'placeholder' => 'Please enter branch name. E.g. Kings Park Branch']) ?>

    <?= $form->field($model, 'address')->textArea(['rows' => 3, 'placeholder' => 'Please enter address. E.g. Shenton Park WA 6008, Australia']) ?>
        
    <?= $form->field($model, 'description')->textArea(['rows' => 3, 'placeholder' => 'Please enter description']) ?>

    <?= $form->field($model, 'tax_invoice')->textInput(['maxlength' => true, 'placeholder' => 'Please enter invoice number. E.g. INV12345']) ?>

    <?= $form->field($model, 'abn_number')->textInput(['maxlength' => true, 'placeholder' => 'Please enter ABN number. E.g. A12345']) ?>

    <?= $form->field($model, 'image')->fileInput() ?>
    
    <?= $form->field($model, 'display_note')->dropDownList(['1' => 'Yes', '0' => 'No'], ['id'=> 'title']) ?>
	
    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Messages displayed to Customers on order actions:</strong>
        </div>
    </div>

	<?= $form->field($model, 'welcome_notif')->textInput(['maxlength' => true, 'placeholder' => 'Please enter message for welcome notification']) ?>

    <?= $form->field($model, 'received_notif')->textInput(['maxlength' => true, 'placeholder' => 'Please enter message for order received notification']) ?>

    <?= $form->field($model, 'ready_notif')->textInput(['maxlength' => true, 'placeholder' => 'Please enter message for order ready notification']) ?>
    
    <?php /*?><div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Payment details:</strong>
        </div>
    </div>
    
    <?= $form->field($model, 'secret_key')->textInput(['maxlength' => true, 'placeholder' => '']) ?>

    <?= $form->field($model, 'publishable_key')->textInput(['maxlength' => true, 'placeholder' => '']) ?><?php */?>
    
    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Map details:</strong>
        </div>
    </div>
    
    <?= $form->field($model, 'map_latitude')->textInput(['maxlength' => true, 'placeholder' => 'E.g. 27.1750199']) ?>

    <?= $form->field($model, 'map_longitude')->textInput(['maxlength' => true, 'placeholder' => 'E.g. 78.0399665']) ?>
    
    <?php if($session['super_admin'] == "YES") { ?>
    
    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Stripe Payment details:</strong>
        </div>
    </div>
    
	<?php if($model->stripe_details_flag == 0) { ?>
    
    <div class="form-group">
        <div class="col-lg-offset-3 col-lg-9">
        	<p class="form-control-static text-info"><strong>Add new stripe account</strong></p>
            <p class="form-control-static text-info">To register the account on stripe, please click below button <br />and enter the required details from that page and active <br />the Store status. Store can't be activated without entering stripe details.</p>
            <?php 
			//define('CLIENT_ID', 'ca_8PxIswbDFyxfSjgXBbTiB249EhljJ3Vr');
			//define('AUTHORIZE_URI', 'https://connect.stripe.com/oauth/authorize');
			$CLIENT_ID 		= Yii::$app->params['CLIENT_ID'];
			$AUTHORIZE_URI 	= Yii::$app->params['AUTHORIZE_URI'];
			
			// Show OAuth link
			$authorize_request_body = array(
				'response_type' => 'code',
				'scope' => 'read_write',
				'client_id' => $CLIENT_ID
			);
			$url = $AUTHORIZE_URI . '?' . http_build_query($authorize_request_body);
			echo '<a href="'.$url.'" target="_blank" class="btn btn-sm btn-info">Connect with Stripe</a>';
			?>
            <?php 
				$account_id = $session['account_id'];
				if($model->id)
				{
				$stripe_stores = Yii::$app->db->createCommand("SELECT id, store_name, stripe_publishable_key, stripe_user_id, refresh_token, access_token, stripe_discount_percentage FROM stores WHERE account_id = ".$account_id." AND id != ".$model->id." AND stripe_details_flag = 1")->queryAll();
				}
				else
				{
				$stripe_stores = Yii::$app->db->createCommand("SELECT id, store_name, stripe_publishable_key, stripe_user_id, refresh_token, access_token, stripe_discount_percentage FROM stores WHERE account_id = ".$account_id." AND stripe_details_flag = 1")->queryAll();	
				}
				if($stripe_stores)
				{
					echo '<br /><br /><p class="form-control-static text-info"><strong><u>Or</u> select stripe details from existing Store</strong></p>';
					
					foreach($stripe_stores as $ss)
					{
						echo '<h4>'.$ss['store_name'].' <a onClick="setStripeDetails('.$ss['id'].')"><span style="font-size:13px; cursor:pointer">click here to select this</span></a></h4>';
						echo '<div class="col-md-4">';
						echo 'Publishable Key <br />User id <br />Refresh Token <br />Access Token <br />Discount Percentage';
						echo '</div>';
						echo '<div class="col-md-8">';
						echo ': <code id="spk_'.$ss['id'].'">'.$ss['stripe_publishable_key'].'</code><br />: <code id="sui_'.$ss['id'].'">'.$ss['stripe_user_id'].'</code><br />: <code id="rt_'.$ss['id'].'">'.$ss['refresh_token'].'</code><br />: <code id="at_'.$ss['id'].'">'.$ss['access_token'].'</code><br />: <code id="sdp_'.$ss['id'].'">'.$ss['stripe_discount_percentage'].'</code>';
						echo '</div>';
						echo '<div class="clearfix"></div>';
						/*echo '<p>';
						echo 'Stripe publishable key: <code>'.$ss['stripe_publishable_key'].'</code><br />';
						echo 'Stripe user id: <code>'.$ss['stripe_user_id'].'</code><br />';
						echo 'Refresh token: <code>'.$ss['refresh_token'].'</code><br />';
						echo 'Access token: <code>'.$ss['access_token'].'</code><br />';
						echo '</p>';*/
					}
				}
				
				//print_r($stripe_stores);
			
			?>
        </div>
    </div>
    
	<?php } ?>
    
    <?= $form->field($model, 'stripe_publishable_key')->textInput(['maxlength' => true, 'placeholder' => 'Please Enter Stripe Publishable Key']) ?>

    <?= $form->field($model, 'stripe_user_id')->textInput(['maxlength' => true, 'placeholder' => 'Please Enter Stripe User Id']) ?>
    
    <?= $form->field($model, 'refresh_token')->textInput(['maxlength' => true, 'placeholder' => 'Please Enter Stripe Refresh Token']) ?>
    
    <?= $form->field($model, 'access_token')->textInput(['maxlength' => true, 'placeholder' => 'Please Enter Stripe Access Token']) ?>
    
    <?= $form->field($model, 'stripe_discount_percentage')->textInput(['maxlength' => true, 'placeholder' => 'Please Enter Stripe Discount Percentage']) ?>
    
    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Store Status:</strong>
        </div>
    </div>
    
    <?= $form->field($model, 'status')->dropDownList(['1' => 'Active', '0' => 'Inactive'], ['id'=> 'title']) ?>
    
    <?php } else { ?>
    <?php if(!$model->isNewRecord && $model->stripe_details_flag == 1) { ?>

    <div class="form-group">
    	<div class="col-md-offset-1 col-md-7">
        	<strong>Store Status:</strong>
        </div>
    </div>
    
    <?= $form->field($model, 'status')->dropDownList(['1' => 'Active', '0' => 'Inactive'], ['id'=> 'title', ]) ?>
    
    <?php } else { ?>
    
    <div class="form-group">
        <div class="col-lg-offset-3 col-lg-9">
        	<input type="hidden" id="stores-status" class="form-control" name="Stores[status]" value="0">
            <input type="hidden" id="stores-stripe_details_flag" class="form-control" name="Stores[stripe_details_flag]" value="0">
            <p class="form-control-static text-info">Your store will be activated when super admin approves</p>
        </div>
    </div>
    
    <?php } ?>
    
    <?php } ?>
    
<?php if(!$model->isNewRecord) { ?>

    </div>
    
	<?php foreach($language as $lang) { ?>
    <div class="" id="lang-<?php echo $lang['id']; ?>" style="display:none">
    <?php
		echo $form->field($model, 'store_name_'.$lang['language_lc'])->textInput(['maxlength' => true, 'placeholder' => 'Please enter store name in '.$lang['language_name']])->label('Store Name');
		echo $form->field($model, 'description_'.$lang['language_lc'])->textArea(['rows' => 3, 'placeholder' => 'Please enter description in '.$lang['language_name']])->label('Description');
    ?>
    </div>
    <?php } ?>
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
<script>
function dispLang(x)
{
	$('div[id^="lang-"]').css('display', 'none');
	$('#lang-'+x).css('display', 'block');
}

function setStripeDetails(x)
{
	$("#stores-stripe_publishable_key").val($("#spk_"+x).html());
	$("#stores-stripe_user_id").val($("#sui_"+x).html());
	$("#stores-refresh_token").val($("#rt_"+x).html());
	$("#stores-access_token").val($("#at_"+x).html());
	$("#stores-stripe_discount_percentage").val($("#sdp_"+x).html());	
}

</script>