<?php

use yii\helpers\Html;
use yii\widgets\DetailView;

/* @var $this yii\web\View */
/* @var $model app\models\SiteInfo */

$this->title = "Generate Report";
$this->params['breadcrumbs'][] = $this->title;
?>

<div class="row">
    <div class="col-md-12">
        <section class="panel panel-primary">
            <header class="panel-heading">
            	<?= Html::encode($this->title) ?>
            </header>
            <div class="panel-body">
				<form class="form-horizontal" role="form" method="post" id="gen-report-form" action="<?= Yii::$app->urlManager->createUrl('reports/generate-report') ?>" onSubmit="return genReport()">
                    <div class="form-group">
                        <label for="inputEmail1" class="col-md-2 col-sm-2 control-label">Account</label>
                        <div class="col-md-8">
                            <select class="form-control m-bot15" onChange="sel_account(this.value, '')" name="account" id="account">
                                <option value="">Select Account</option>
                                <option value="0" <?php if(isset($posted_data['account']) && $posted_data['account'] == 0) { echo ' selected="selected"'; } ?>>All</option>
                                <?php foreach($accounts_list as $account) {
									$selected = "";
									if(isset($posted_data['account']) && $posted_data['account'] == $account['id']) {
										$selected = ' selected="selected"';
									}
									echo '<option value="'.$account['id'].'" '.$selected.'>'.$account['account_name'].'</option>';
								} ?>
                            </select>
                        </div>
                    </div>
                    <?php if(empty($posted_data)) { ?>
                    <div class="form-group">
                        <label for="inputPassword1" class="col-md-2 col-sm-2 control-label">Stores</label>
                        <div class="col-md-8">
                            <select class="form-control m-bot15" id="store" name="store">
                            	<option value="">Select Store</option>
                            </select>
                        </div>
                    </div>
                    <?php } else { ?>
                    <div class="form-group">
                        <label for="inputPassword1" class="col-md-2 col-sm-2 control-label">Stores</label>
                        <div class="col-md-8">
                            <select class="form-control m-bot15" id="store" name="store">
                            	<?php if($posted_data['account'] == 0) { ?>
                                <option value="0">All</option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <?php } ?>
                    <div class="form-group">
                        <label for="inputPassword1" class="col-md-2 col-sm-2 control-label">Type of Order</label>
                        <div class="col-md-8">
                            <select class="form-control m-bot15" name="type" id="type">
                                <option value="0">Both</option>
                                <option value="1">Online</option>
                                <option value="2">Offine</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword1" class="col-md-2 col-sm-2 control-label">Date from</label>
                        <div class="col-md-8">
                            <input class="form-control default-date-picker m-bot15" size="16" type="text" value="<?php if(!empty($posted_data)) { echo $posted_data['start_date']; } ?>" id="start_date" name="start_date">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword1" class="col-md-2 col-sm-2 control-label">Date to</label>
                        <div class="col-md-8">
                            <?php /*?><input class="form-control default-date-picker m-bot15" size="16" type="text" value="" name="end_date" id="end_date"><?php */?>
                            <input class="form-control default-date-picker m-bot15" size="16" type="text" value="<?php if(!empty($posted_data)) { echo $posted_data['end_date']; } ?>" name="end_date" id="end_date">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-md-offset-2 col-md-10">
                        	<input type="hidden" name="_csrf" value="<?=Yii::$app->request->getCsrfToken()?>" />
                            <button type="submit" class="btn btn-primary" name="submit">Submit</button>
                            <span id="msg-lable"></span>
                        </div>
                    </div>
                </form>
			</div>
        </section>
        
        <?php if(!empty($report)) { ?>
        <section class="panel panel-primary">
            <header class="panel-heading">
            	Report
                <span class="pull-right">
                    <?php /*?><?= Html::a('Download as PDF', ['download-pdf'], ['class' => 'btn btn-primary btn-xs']) ?><?php */?>
                    <?php /*?><?= Html::a('Add User', ['create'], ['class' => 'btn btn-primary btn-xs']) ?><?php */?>
                    
                    <form method="post" target="_blank" action="<?= Yii::$app->urlManager->createUrl('reports/download-report') ?>">
                    	<input type="hidden" name="account" value="<?php echo $posted_data['account']; ?>">
                        <input type="hidden" name="store" value="<?php echo $posted_data['store']; ?>">
                        <input type="hidden" name="type" value="<?php echo $posted_data['type']; ?>">
                        <input type="hidden" name="start_date" value="<?php echo $posted_data['start_date']; ?>">
                        <input type="hidden" name="end_date" value="<?php echo $posted_data['end_date']; ?>">
                        <input type="hidden" name="_csrf" value="<?=Yii::$app->request->getCsrfToken()?>" />
                        <input type="submit" class="btn btn-primary btn-xs" value="Download as PDF" />
                    </form>
                </span>
            </header>
            <div class="panel-body" id="report_body">
            	<?php $a = 1; foreach($report as $account) { ?>
            	<div class="panel-group " id="accordion2">
                    <div class="panel">
                        <div class="panel-heading dark">
                            <h4 class="panel-title">
                                <a style="text-decoration:none" class="accordion-toggle" data-toggle="collapse" data-parent="#accordion<?= $a ?>" href="#collapseOne<?= $a ?>">
                                    <?= $a.'. '.$account['account_name'] ?>
                                </a>
                            </h4>
                        </div>
                        <div id="collapseOne<?= $a ?>" class="panel-collapse collapse <?php if($a == 1) { echo 'in'; } ?>">
                            <div class="panel-body" style="border:4px solid #353F4F">
                            	<?php $b = 1; foreach($account['stores'] as $store) { ?>
                                <div style="margin-bottom:50px;">
                                <h4 class="text-info"><strong><?php echo $b.". ".$store['store_name']; ?></strong></h4>
                                <br />
                                <?php if(empty($store['orders'])) { echo '<span class="text-warning"><strong>No Orders found...</strong></span>'; } else { ?>
                                <div style="<?php /*?>max-height:400px; overflow-y:scroll; border:2px solid #cccccc<?php */?>">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th style="width:60px;">#</th>
                                            <th>Description</th>
                                            <th style="width:160px;">Order Number</th>
                                            <th style="width:160px; text-align:center">Date</th>
                                            <th style="width:160px; text-align:right">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<?php $c= 1; $total_income = 0; foreach($store['orders'] as $order) { ?>
                                        <tr>
                                            <td><?= $c ?></td>
                                            <td>
                                            	<?php
												foreach($order['details'] as $item) {
                                            	echo $item['quantity']. " x <strong>".$item['item_name']."</strong><br />"; 
												} ?>
                                            </td>
                                            <td><?= $order['order_number'] ?></td>
                                            <td style="text-align:center"><?= date("d-m-Y", strtotime($order['n_datetime'])) ?></td>
                                            <td style="text-align:right">$ <?= $order['total_amount'] ?></td>
                                        </tr>
                                        <?php $c++; $total_income = $total_income + $order['total_amount']; } ?>
                                    </tbody>
                                </table>
                                </div>
                                
                                <div style="margin:20px 0">
                                    <strong >Total no. of orders:</strong> <?= ($c-1) ?>
                                    <span class="pull-right">
                                    <strong>Total Income:</strong> $ <?= $total_income ?>
                                    </span>
                                </div>
                                <?php } ?>
                                </div>
								<?php $b++; } ?>
                            </div>
                        </div>
                    </div>
                </div>
                <?php $a++; } ?>
            	<?php //echo "<pre>";print_r($report);echo "</pre>"; ?>
            </div>
        </section>
        <?php } ?>
    </div>
</div>
<script>
function sel_account(ac_id, sel_stor)
{
	if(ac_id == "") {
		$("#store").html('<option value="">Select Store</option>');
	} else if(ac_id == 0) {
		$("#store").html('<option value="0">All</option>');
	} else {
		var _csrf = yii.getCsrfToken();
		$.ajax({
			url: '<?= Yii::$app->urlManager->createUrl('reports/get-stores') ?>',
			method: 'POST',
			data: 'ac_id='+ac_id+'&sel_stor='+sel_stor+'&_csrf='+_csrf,
			cache: false,
			success: function(data){
				$("#store").html(data);
			},
			error: function(){
				alert("Something went wrong, Please try again");
			}		
		});
	}
}
<?php if(isset($posted_data['account']) && $posted_data['account'] != 0) { ?> 
document.onreadystatechange = function () {
	sel_account(<?= $posted_data['account'] ?>, <?= $posted_data['store'] ?>);
}

<?php } ?>
function genReport()
{
	var account = $("#account").val();
	var store = $("#store").val();
	var oType = $("#type").val();
	var start_date = $("#start_date").val();
	var end_date = $("#end_date").val();
	
	if(account == "") {
		//alert("Please select account name");
		$("#msg-lable").html('<lable style="color:#C0392B">Please select account name.</lable>');
	} else if(store == "") {
		//alert("Please select store name");
		$("#msg-lable").html('<lable style="color:#C0392B">Please select store name.</lable>');
	} else if(start_date == "") {
		//alert("Please select start date");
		$("#msg-lable").html('<lable style="color:#C0392B">Please select start date.</lable>');
	} else if(end_date == "") {
		//alert("Please select end date");
		$("#msg-lable").html('<lable style="color:#C0392B">Please select end date.</lable>');
	} else if(end_date < start_date) {
		//alert('Please select proper start date and end date');
		$("#msg-lable").html('<lable style="color:#C0392B">Please select proper start date and end date.</lable>');
	} else {
		$("#msg-lable").html('');
		return true;
	}
	return false;
}

function downloadReport()
{
	/*var account = $("#account").val();
	var store = $("#store").val();
	var oType = $("#type").val();
	var start_date = $("#start_date").val();
	var end_date = $("#end_date").val();
	var _csrf = yii.getCsrfToken();
	
	$.ajax({
		url: '<?= Yii::$app->urlManager->createUrl('site-info/download-report') ?>',
		method: 'POST',
		data: 'account='+account+'&store='+store+'&type='+oType+'&start_date='+start_date+'&end_date='+end_date+'&_csrf='+_csrf,
		cache: false,
		success: function(data){
			$("#msg-lable").html('<lable style="color:#2ECC71">Report has been generated below.</lable>');
			$("#report_body").html(data);
		},
		error: function(){
			//alert("Something went wrong, Please try again");
			$("#msg-lable").html('<lable style="color:#C0392B">Something went wrong, Please try again.</lable>');
		}		
	});*/
}
</script>